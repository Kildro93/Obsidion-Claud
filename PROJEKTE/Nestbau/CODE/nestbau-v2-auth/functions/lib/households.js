'use strict';

const crypto = require('crypto');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineString } = require('firebase-functions/params');
const logger = require('firebase-functions/logger');

const {
  db, admin, FieldValue,
  requireVerifiedAuth, assertEmail, assertString
} = require('./common');
const mail = require('./mail');

const APP_BASE_URL = defineString('APP_BASE_URL', {
  default: 'https://nestbau-app.web.app',
  description: 'Basis-URL der Nestbau-PWA (fuer Links in Emails)'
});

const MAX_MEMBERS = 8;
const MAX_HOUSEHOLDS_PER_USER = 5;
const INVITE_TTL_DAYS = 7;
const INVITE_RATE_LIMIT = 10;       // pro Haushalt und Stunde
const INVITE_RATE_WINDOW_MS = 60 * 60 * 1000;

const ROLE_LABEL = { admin: 'Administrator', member: 'Mitglied' };

function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

function formatDate(date) {
  return new Intl.DateTimeFormat('de-CH', {
    day: '2-digit', month: 'long', year: 'numeric', timeZone: 'Europe/Zurich'
  }).format(date);
}

/**
 * Baut die Member-Card: das, was Haushalts-Mitglieder voneinander sehen.
 * Gewicht, Groesse und Alter bleiben im privaten Profil. Allergien werden
 * nur kopiert, wenn der User sie ausdruecklich freigibt - fuer den Menueplan
 * ist das relevant, fuer alles andere nicht.
 */
function buildMemberCard(profile, role, email) {
  const p = profile || {};
  return {
    displayName: p.displayName || (email ? email.split('@')[0] : 'Mitglied'),
    color: p.color || '#1c7d70',
    photoURL: p.photoURL || null,
    role,
    allergies: p.shareAllergiesWithHousehold === true ? (p.allergies || []) : [],
    allergiesShared: p.shareAllergiesWithHousehold === true,
    updatedAt: FieldValue.serverTimestamp()
  };
}

// ---------------------------------------------------------------- create
const createHousehold = onCall(async (request) => {
  const { uid, email } = requireVerifiedAuth(request);
  const name = assertString(request.data && request.data.name, 'name', { min: 2, max: 60 });
  const description = request.data && request.data.description
    ? assertString(request.data.description, 'description', { min: 1, max: 240 })
    : '';

  const userRef = db.collection('users').doc(uid);
  const userSnap = await userRef.get();
  const existing = userSnap.exists ? (userSnap.data().householdIds || []) : [];
  if (existing.length >= MAX_HOUSEHOLDS_PER_USER) {
    throw new HttpsError('resource-exhausted',
      `Maximal ${MAX_HOUSEHOLDS_PER_USER} Haushalte pro Konto.`);
  }

  const profileSnap = await db.collection('profiles').doc(uid).get();
  const householdRef = db.collection('households').doc();

  const batch = db.batch();
  batch.set(householdRef, {
    name,
    description,
    adminUid: uid,
    members: { [uid]: { role: 'admin', joinedAt: new Date() } },
    memberUids: [uid],
    memberCount: 1,
    status: 'active',
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp()
  });
  batch.set(householdRef.collection('members').doc(uid),
    Object.assign(buildMemberCard(profileSnap.data(), 'admin', email), {
      email,
      joinedAt: FieldValue.serverTimestamp()
    }));
  batch.set(userRef, {
    householdIds: FieldValue.arrayUnion(householdRef.id),
    activeHouseholdId: householdRef.id,
    status: 'active',
    updatedAt: FieldValue.serverTimestamp()
  }, { merge: true });
  await batch.commit();

  logger.info('household.created', { uid, householdId: householdRef.id });
  return { householdId: householdRef.id, name };
});

// ---------------------------------------------------------------- invite
const inviteToHousehold = onCall(async (request) => {
  const { uid } = requireVerifiedAuth(request);
  const householdId = assertString(request.data && request.data.householdId, 'householdId', { max: 40 });
  const email = assertEmail(request.data && request.data.email);
  const role = (request.data && request.data.role) === 'admin' ? 'admin' : 'member';

  const householdRef = db.collection('households').doc(householdId);
  const householdSnap = await householdRef.get();
  if (!householdSnap.exists) throw new HttpsError('not-found', 'Haushalt existiert nicht.');

  const household = householdSnap.data();
  const members = household.members || {};
  if (!members[uid] || members[uid].role !== 'admin') {
    throw new HttpsError('permission-denied', 'Nur Admins duerfen einladen.');
  }
  if (Object.keys(members).length >= MAX_MEMBERS) {
    throw new HttpsError('resource-exhausted', `Der Haushalt ist voll (max. ${MAX_MEMBERS}).`);
  }

  const memberDocs = await householdRef.collection('members').get();
  if (memberDocs.docs.some((d) => (d.data().email || '') === email)) {
    throw new HttpsError('already-exists', 'Diese Person ist bereits im Haushalt.');
  }

  // Rate-Limit: schuetzt das Mail-Kontingent vor Einladungs-Spam.
  const since = new Date(Date.now() - INVITE_RATE_WINDOW_MS);
  const recent = await db.collection('invites')
    .where('householdId', '==', householdId)
    .where('createdAt', '>=', since)
    .count().get();
  if (recent.data().count >= INVITE_RATE_LIMIT) {
    throw new HttpsError('resource-exhausted',
      'Zu viele Einladungen in kurzer Zeit. Versuch es in einer Stunde nochmal.');
  }

  // Offene Einladung an dieselbe Adresse ersetzen statt duplizieren.
  const open = await db.collection('invites')
    .where('householdId', '==', householdId)
    .where('email', '==', email)
    .where('status', '==', 'pending')
    .get();

  const token = crypto.randomBytes(24).toString('base64url');
  const expiresAt = new Date(Date.now() + INVITE_TTL_DAYS * 24 * 60 * 60 * 1000);
  const inviteRef = db.collection('invites').doc();

  const batch = db.batch();
  open.forEach((doc) => batch.update(doc.ref, { status: 'superseded' }));
  batch.set(inviteRef, {
    householdId,
    householdName: household.name,
    email,
    role,
    status: 'pending',
    invitedByUid: uid,
    tokenHash: hashToken(token),      // Klartext-Token existiert nur in der Email
    createdAt: FieldValue.serverTimestamp(),
    expiresAt
  });
  await batch.commit();

  const inviterProfile = await db.collection('profiles').doc(uid).get();
  const inviterName = (inviterProfile.data() && inviterProfile.data().displayName) || 'Jemand';
  const link = `${APP_BASE_URL.value()}/auth.html?invite=${inviteRef.id}&token=${encodeURIComponent(token)}`;

  await mail.sendHouseholdInvite({
    to: email,
    inviterName,
    householdName: household.name,
    householdDescription: household.description,
    roleLabel: ROLE_LABEL[role],
    link,
    expiresAt: formatDate(expiresAt)
  });

  logger.info('invite.sent', { householdId, inviteId: inviteRef.id, role });
  return { inviteId: inviteRef.id, expiresAt: expiresAt.toISOString() };
});

// ---------------------------------------------------------------- accept
const acceptHouseholdInvite = onCall(async (request) => {
  const { uid, email } = requireVerifiedAuth(request);
  const inviteId = assertString(request.data && request.data.inviteId, 'inviteId', { max: 40 });
  const token = assertString(request.data && request.data.token, 'token', { max: 200 });

  const inviteRef = db.collection('invites').doc(inviteId);
  const profileSnap = await db.collection('profiles').doc(uid).get();

  const result = await db.runTransaction(async (tx) => {
    const inviteSnap = await tx.get(inviteRef);
    if (!inviteSnap.exists) throw new HttpsError('not-found', 'Einladung nicht gefunden.');
    const invite = inviteSnap.data();

    if (invite.status !== 'pending') {
      throw new HttpsError('failed-precondition', 'Diese Einladung wurde bereits verwendet.');
    }

    // Timing-sicherer Vergleich, damit sich Token nicht ueber Laufzeiten raten lassen.
    const given = Buffer.from(hashToken(token), 'utf8');
    const stored = Buffer.from(String(invite.tokenHash || ''), 'utf8');
    if (given.length !== stored.length || !crypto.timingSafeEqual(given, stored)) {
      throw new HttpsError('permission-denied', 'Einladungslink ist ungueltig.');
    }
    if (invite.expiresAt.toDate() < new Date()) {
      tx.update(inviteRef, { status: 'expired' });
      throw new HttpsError('deadline-exceeded', 'Die Einladung ist abgelaufen.');
    }
    if (invite.email !== email) {
      throw new HttpsError('permission-denied',
        'Diese Einladung gilt fuer eine andere Email-Adresse.');
    }

    const householdRef = db.collection('households').doc(invite.householdId);
    const householdSnap = await tx.get(householdRef);
    if (!householdSnap.exists) throw new HttpsError('not-found', 'Haushalt existiert nicht mehr.');
    const household = householdSnap.data();
    const members = household.members || {};

    if (members[uid]) {
      tx.update(inviteRef, { status: 'accepted', acceptedAt: FieldValue.serverTimestamp() });
      return { householdId: invite.householdId, householdName: household.name, alreadyMember: true };
    }
    if (Object.keys(members).length >= MAX_MEMBERS) {
      throw new HttpsError('resource-exhausted', 'Der Haushalt ist voll.');
    }

    tx.update(householdRef, {
      [`members.${uid}`]: { role: invite.role, joinedAt: new Date() },
      memberUids: FieldValue.arrayUnion(uid),
      memberCount: FieldValue.increment(1),
      updatedAt: FieldValue.serverTimestamp()
    });
    tx.set(householdRef.collection('members').doc(uid),
      Object.assign(buildMemberCard(profileSnap.data(), invite.role, email), {
        email,
        joinedAt: FieldValue.serverTimestamp()
      }));
    tx.set(db.collection('users').doc(uid), {
      householdIds: FieldValue.arrayUnion(invite.householdId),
      activeHouseholdId: invite.householdId,
      status: 'active',
      updatedAt: FieldValue.serverTimestamp()
    }, { merge: true });
    tx.update(inviteRef, {
      status: 'accepted',
      acceptedByUid: uid,
      acceptedAt: FieldValue.serverTimestamp()
    });

    return {
      householdId: invite.householdId,
      householdName: household.name,
      invitedByUid: invite.invitedByUid,
      alreadyMember: false
    };
  });

  if (!result.alreadyMember && result.invitedByUid) {
    try {
      const inviter = await admin.auth().getUser(result.invitedByUid);
      const inviterProfile = await db.collection('profiles').doc(result.invitedByUid).get();
      if (inviter.email) {
        await mail.sendInviteAccepted({
          to: inviter.email,
          inviterName: (inviterProfile.data() && inviterProfile.data().displayName) || 'du',
          memberName: (profileSnap.data() && profileSnap.data().displayName) || email,
          householdName: result.householdName
        });
      }
    } catch (err) {
      // Benachrichtigung ist Nice-to-have, der Beitritt bleibt gueltig.
      logger.warn('invite.acceptedMailFailed', { error: err.message });
    }
  }

  logger.info('invite.accepted', { uid, householdId: result.householdId });
  return { householdId: result.householdId, householdName: result.householdName };
});

// ------------------------------------------------------- decline / revoke
const declineHouseholdInvite = onCall(async (request) => {
  const { email } = requireVerifiedAuth(request);
  const inviteId = assertString(request.data && request.data.inviteId, 'inviteId', { max: 40 });
  const ref = db.collection('invites').doc(inviteId);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError('not-found', 'Einladung nicht gefunden.');
  if (snap.data().email !== email) throw new HttpsError('permission-denied', 'Nicht deine Einladung.');
  await ref.update({ status: 'declined', declinedAt: FieldValue.serverTimestamp() });
  return { ok: true };
});

const revokeHouseholdInvite = onCall(async (request) => {
  const { uid } = requireVerifiedAuth(request);
  const inviteId = assertString(request.data && request.data.inviteId, 'inviteId', { max: 40 });
  const ref = db.collection('invites').doc(inviteId);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError('not-found', 'Einladung nicht gefunden.');

  const household = await db.collection('households').doc(snap.data().householdId).get();
  const members = (household.data() && household.data().members) || {};
  if (!members[uid] || members[uid].role !== 'admin') {
    throw new HttpsError('permission-denied', 'Nur Admins duerfen Einladungen zuruecknehmen.');
  }
  await ref.update({ status: 'revoked', revokedAt: FieldValue.serverTimestamp() });
  return { ok: true };
});

// ------------------------------------------------------ Mitglieder pflegen
async function detachMember(householdId, memberUid) {
  const householdRef = db.collection('households').doc(householdId);
  const batch = db.batch();
  batch.update(householdRef, {
    [`members.${memberUid}`]: FieldValue.delete(),
    memberUids: FieldValue.arrayRemove(memberUid),
    memberCount: FieldValue.increment(-1),
    updatedAt: FieldValue.serverTimestamp()
  });
  batch.delete(householdRef.collection('members').doc(memberUid));
  batch.set(db.collection('users').doc(memberUid), {
    householdIds: FieldValue.arrayRemove(householdId),
    updatedAt: FieldValue.serverTimestamp()
  }, { merge: true });
  await batch.commit();

  // activeHouseholdId darf nicht auf einen verlassenen Haushalt zeigen.
  const userSnap = await db.collection('users').doc(memberUid).get();
  if (userSnap.exists && userSnap.data().activeHouseholdId === householdId) {
    const rest = userSnap.data().householdIds || [];
    await userSnap.ref.update({ activeHouseholdId: rest[0] || null });
  }
}

const removeHouseholdMember = onCall(async (request) => {
  const { uid } = requireVerifiedAuth(request);
  const householdId = assertString(request.data && request.data.householdId, 'householdId', { max: 40 });
  const memberUid = assertString(request.data && request.data.uid, 'uid', { max: 40 });

  const snap = await db.collection('households').doc(householdId).get();
  if (!snap.exists) throw new HttpsError('not-found', 'Haushalt existiert nicht.');
  const members = snap.data().members || {};
  if (!members[uid] || members[uid].role !== 'admin') {
    throw new HttpsError('permission-denied', 'Nur Admins duerfen Mitglieder entfernen.');
  }
  if (memberUid === uid) {
    throw new HttpsError('failed-precondition', 'Nutze "Haushalt verlassen", um selbst auszutreten.');
  }
  if (!members[memberUid]) throw new HttpsError('not-found', 'Person ist kein Mitglied.');

  await detachMember(householdId, memberUid);
  logger.info('household.memberRemoved', { householdId, memberUid, by: uid });
  return { ok: true };
});

const leaveHousehold = onCall(async (request) => {
  const { uid } = requireVerifiedAuth(request);
  const householdId = assertString(request.data && request.data.householdId, 'householdId', { max: 40 });

  const ref = db.collection('households').doc(householdId);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError('not-found', 'Haushalt existiert nicht.');
  const members = snap.data().members || {};
  if (!members[uid]) throw new HttpsError('failed-precondition', 'Du bist kein Mitglied.');

  const admins = Object.keys(members).filter((k) => members[k].role === 'admin');
  const others = Object.keys(members).filter((k) => k !== uid);
  const isLastAdmin = admins.length === 1 && admins[0] === uid;

  if (isLastAdmin && others.length > 0) {
    // Admin-Rolle weitergeben, statt den Haushalt fuehrungslos zu lassen.
    const heir = others[0];
    await ref.update({
      [`members.${heir}.role`]: 'admin',
      adminUid: heir,
      updatedAt: FieldValue.serverTimestamp()
    });
    await ref.collection('members').doc(heir).update({ role: 'admin' });
    logger.info('household.adminTransferred', { householdId, from: uid, to: heir });
  }

  await detachMember(householdId, uid);

  if (others.length === 0) {
    await ref.update({ status: 'empty', updatedAt: FieldValue.serverTimestamp() });
  }
  return { ok: true, transferredAdmin: isLastAdmin && others.length > 0 };
});

const updateMemberRole = onCall(async (request) => {
  const { uid } = requireVerifiedAuth(request);
  const householdId = assertString(request.data && request.data.householdId, 'householdId', { max: 40 });
  const memberUid = assertString(request.data && request.data.uid, 'uid', { max: 40 });
  const role = request.data && request.data.role;
  if (role !== 'admin' && role !== 'member') {
    throw new HttpsError('invalid-argument', 'Rolle muss "admin" oder "member" sein.');
  }

  const ref = db.collection('households').doc(householdId);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError('not-found', 'Haushalt existiert nicht.');
  const members = snap.data().members || {};
  if (!members[uid] || members[uid].role !== 'admin') {
    throw new HttpsError('permission-denied', 'Nur Admins duerfen Rollen aendern.');
  }
  if (!members[memberUid]) throw new HttpsError('not-found', 'Person ist kein Mitglied.');

  const admins = Object.keys(members).filter((k) => members[k].role === 'admin');
  if (role === 'member' && admins.length === 1 && admins[0] === memberUid) {
    throw new HttpsError('failed-precondition', 'Es muss mindestens einen Admin geben.');
  }

  const update = {
    [`members.${memberUid}.role`]: role,
    updatedAt: FieldValue.serverTimestamp()
  };
  if (role === 'admin') update.adminUid = memberUid;

  await ref.update(update);
  await ref.collection('members').doc(memberUid).update({ role });
  return { ok: true };
});

module.exports = {
  createHousehold,
  inviteToHousehold,
  acceptHouseholdInvite,
  declineHouseholdInvite,
  revokeHouseholdInvite,
  removeHouseholdMember,
  leaveHousehold,
  updateMemberRole,
  buildMemberCard,
  hashToken,
  MAX_MEMBERS,
  INVITE_TTL_DAYS
};
