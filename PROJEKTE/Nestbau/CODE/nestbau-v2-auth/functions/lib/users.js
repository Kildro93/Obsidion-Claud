'use strict';

const functionsV1 = require('firebase-functions/v1');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { onDocumentWritten } = require('firebase-functions/v2/firestore');
const { defineString } = require('firebase-functions/params');
const logger = require('firebase-functions/logger');

const { db, auth, FieldValue, REGION, requireVerifiedAuth } = require('./common');
const mail = require('./mail');

const APP_BASE_URL = defineString('APP_BASE_URL', {
  default: 'https://nestbau-app.web.app'
});

/**
 * Auth-Trigger gibt es (Stand firebase-functions v6) nur im v1-Namespace.
 * Deshalb hier bewusst functionsV1 - der Rest der Codebase ist v2.
 */
const onUserCreated = functionsV1
  .region(REGION)
  .auth.user()
  .onCreate(async (user) => {
    const email = (user.email || '').toLowerCase();

    await db.collection('users').doc(user.uid).set({
      uid: user.uid,
      email,
      emailVerified: user.emailVerified === true,
      status: 'pending_profile',
      householdIds: [],
      activeHouseholdId: null,
      locale: 'de-CH',
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp()
    }, { merge: true });

    // Profil-Skelett, damit die App direkt einen Listener anhaengen kann.
    await db.collection('profiles').doc(user.uid).set({
      uid: user.uid,
      displayName: email ? email.split('@')[0] : 'Ich',
      color: '#1c7d70',
      age: null,
      heightCm: null,
      weightKg: null,
      fitnessLevel: 'medium',
      allergies: [],
      dietary: [],
      shareAllergiesWithHousehold: false,
      photoURL: null,
      profileComplete: false,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp()
    }, { merge: true });

    logger.info('user.created', { uid: user.uid });
  });

/**
 * Kontolöschung: Profil, Mitgliedschaften und offene Einladungen mitnehmen.
 * Ohne das bleiben verwaiste Member-Cards in fremden Haushalten stehen.
 */
const onUserDeleted = functionsV1
  .region(REGION)
  .auth.user()
  .onDelete(async (user) => {
    const uid = user.uid;
    const userSnap = await db.collection('users').doc(uid).get();
    const householdIds = userSnap.exists ? (userSnap.data().householdIds || []) : [];

    for (const hid of householdIds) {
      const ref = db.collection('households').doc(hid);
      try {
        await db.runTransaction(async (tx) => {
          const snap = await tx.get(ref);
          if (!snap.exists) return;
          const members = snap.data().members || {};
          const others = Object.keys(members).filter((k) => k !== uid);
          const admins = Object.keys(members).filter((k) => members[k].role === 'admin');

          const update = {
            [`members.${uid}`]: FieldValue.delete(),
            memberUids: FieldValue.arrayRemove(uid),
            memberCount: FieldValue.increment(-1),
            updatedAt: FieldValue.serverTimestamp()
          };
          // Letzter Admin weg: Rolle weitergeben, sonst ist der Haushalt tot.
          if (admins.length === 1 && admins[0] === uid && others.length > 0) {
            update[`members.${others[0]}.role`] = 'admin';
            update.adminUid = others[0];
          }
          if (others.length === 0) update.status = 'empty';

          tx.update(ref, update);
          tx.delete(ref.collection('members').doc(uid));
        });
      } catch (err) {
        logger.error('user.deleteCleanupFailed', { uid, householdId: hid, error: err.message });
      }
    }

    const pending = await db.collection('invites')
      .where('email', '==', (user.email || '').toLowerCase())
      .where('status', '==', 'pending')
      .get();
    const batch = db.batch();
    pending.forEach((doc) => batch.update(doc.ref, { status: 'revoked' }));
    batch.delete(db.collection('profiles').doc(uid));
    batch.delete(db.collection('users').doc(uid));
    await batch.commit();

    logger.info('user.deleted', { uid, households: householdIds.length });
  });

/**
 * Branded Verifikations-Email. Optional: der Client kann stattdessen
 * `sendEmailVerification()` nutzen (Firebase-Standardtemplate, kein Deploy
 * noetig). Diese Variante nutzt das Nestbau-HTML-Template.
 */
const sendVerificationEmail = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Bitte melde dich an.');
  const uid = request.auth.uid;
  const user = await auth.getUser(uid);
  if (!user.email) throw new HttpsError('failed-precondition', 'Kein Email-Konto hinterlegt.');
  if (user.emailVerified) return { ok: true, alreadyVerified: true };

  // Einfaches Cooldown gegen Mail-Bombing per Wiederhol-Klick.
  const ref = db.collection('users').doc(uid);
  const snap = await ref.get();
  const last = snap.exists && snap.data().lastVerificationSentAt
    ? snap.data().lastVerificationSentAt.toDate()
    : null;
  if (last && Date.now() - last.getTime() < 60 * 1000) {
    throw new HttpsError('resource-exhausted', 'Bitte warte eine Minute, bevor du erneut sendest.');
  }

  const link = await auth.generateEmailVerificationLink(user.email, {
    url: `${APP_BASE_URL.value()}/auth.html?verified=1`,
    handleCodeInApp: false
  });

  const profile = await db.collection('profiles').doc(uid).get();
  await mail.sendVerification({
    to: user.email,
    name: (profile.data() && profile.data().displayName) || null,
    link
  });
  await ref.set({ lastVerificationSentAt: FieldValue.serverTimestamp() }, { merge: true });

  logger.info('verification.sent', { uid });
  return { ok: true };
});

/**
 * Der Client darf `emailVerified` und `status` nicht selbst schreiben
 * (Rules verbieten es). Nach der Bestaetigung ruft die App diese Function,
 * die den Zustand aus dem Auth-Token uebernimmt.
 */
const syncAuthState = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Bitte melde dich an.');
  const uid = request.auth.uid;
  const user = await auth.getUser(uid);

  const ref = db.collection('users').doc(uid);
  const snap = await ref.get();
  const data = snap.exists ? snap.data() : {};
  const hasHousehold = (data.householdIds || []).length > 0;
  const profile = await db.collection('profiles').doc(uid).get();
  const profileComplete = profile.exists && profile.data().profileComplete === true;

  let status = 'pending_verification';
  if (user.emailVerified && profileComplete && hasHousehold) status = 'active';
  else if (user.emailVerified && profileComplete) status = 'pending_household';
  else if (user.emailVerified) status = 'pending_profile';

  await ref.set({
    email: (user.email || '').toLowerCase(),
    emailVerified: user.emailVerified === true,
    status,
    lastLoginAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp()
  }, { merge: true });

  return {
    status,
    emailVerified: user.emailVerified === true,
    profileComplete,
    householdIds: data.householdIds || [],
    activeHouseholdId: data.activeHouseholdId || null
  };
});

/**
 * Profil geaendert -> Member-Cards in allen Haushalten nachziehen.
 * Nur die freigegebenen Felder werden kopiert; Gewicht/Groesse/Alter nie.
 */
const onProfileWritten = onDocumentWritten('profiles/{uid}', async (event) => {
  const after = event.data && event.data.after.exists ? event.data.after.data() : null;
  const before = event.data && event.data.before.exists ? event.data.before.data() : null;
  if (!after) return;

  const relevant = ['displayName', 'color', 'photoURL', 'allergies', 'shareAllergiesWithHousehold'];
  const changed = !before || relevant.some((k) => JSON.stringify(before[k]) !== JSON.stringify(after[k]));
  if (!changed) return;

  const uid = event.params.uid;
  const userSnap = await db.collection('users').doc(uid).get();
  const householdIds = userSnap.exists ? (userSnap.data().householdIds || []) : [];
  if (householdIds.length === 0) return;

  const shared = after.shareAllergiesWithHousehold === true;
  const patch = {
    displayName: after.displayName || 'Mitglied',
    color: after.color || '#1c7d70',
    photoURL: after.photoURL || null,
    allergies: shared ? (after.allergies || []) : [],
    allergiesShared: shared,
    updatedAt: FieldValue.serverTimestamp()
  };

  const batch = db.batch();
  householdIds.forEach((hid) => {
    batch.set(db.collection('households').doc(hid).collection('members').doc(uid),
      patch, { merge: true });
  });
  await batch.commit();

  logger.info('profile.synced', { uid, households: householdIds.length });
});

module.exports = {
  onUserCreated,
  onUserDeleted,
  sendVerificationEmail,
  syncAuthState,
  onProfileWritten
};
