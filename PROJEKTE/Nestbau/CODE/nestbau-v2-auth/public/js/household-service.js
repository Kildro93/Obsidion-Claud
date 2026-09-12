/**
 * Nestbau v2.0 – Haushalts-Service
 *
 * Alle schreibenden Operationen laufen ueber Cloud Functions. Der Client
 * kann Mitgliedschaften nicht selbst setzen – sonst koennte sich jeder per
 * Konsole in einen fremden Haushalt schreiben.
 */

import {
  doc, collection, query, where, orderBy, limit,
  getDoc, getDocs, onSnapshot
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-firestore.js';
import { httpsCallable } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-functions.js';

import { db, functions, auth } from './firebase-config.js';

const call = (name) => httpsCallable(functions, name);

// ------------------------------------------------------------- schreiben
export async function createHousehold({ name, description = '' }) {
  const res = await call('createHousehold')({ name, description });
  return res.data;
}

export async function inviteMember({ householdId, email, role = 'member' }) {
  const res = await call('inviteToHousehold')({ householdId, email, role });
  return res.data;
}

export async function acceptInvite({ inviteId, token }) {
  const res = await call('acceptHouseholdInvite')({ inviteId, token });
  return res.data;
}

export async function declineInvite(inviteId) {
  return (await call('declineHouseholdInvite')({ inviteId })).data;
}

export async function revokeInvite(inviteId) {
  return (await call('revokeHouseholdInvite')({ inviteId })).data;
}

export async function removeMember({ householdId, uid }) {
  return (await call('removeHouseholdMember')({ householdId, uid })).data;
}

export async function leaveHousehold(householdId) {
  return (await call('leaveHousehold')({ householdId })).data;
}

export async function setMemberRole({ householdId, uid, role }) {
  return (await call('updateMemberRole')({ householdId, uid, role })).data;
}

// ---------------------------------------------------------------- lesen
export async function getHousehold(householdId) {
  const snap = await getDoc(doc(db, 'households', householdId));
  return snap.exists() ? { id: snap.id, ...snap.data() } : null;
}

export async function listMyHouseholds() {
  const uid = auth.currentUser?.uid;
  if (!uid) return [];
  const q = query(
    collection(db, 'households'),
    where('memberUids', 'array-contains', uid),
    orderBy('createdAt', 'desc'),
    limit(20)
  );
  const snap = await getDocs(q);
  return snap.docs.map((d) => ({ id: d.id, ...d.data() }));
}

export function watchMembers(householdId, callback) {
  return onSnapshot(
    collection(db, 'households', householdId, 'members'),
    (snap) => callback(snap.docs.map((d) => ({ uid: d.id, ...d.data() }))),
    (err) => console.error('[Nestbau] Mitglieder-Listener:', err)
  );
}

/** Offene Einladungen an die eigene Email-Adresse. */
export async function listMyInvites() {
  const email = auth.currentUser?.email?.toLowerCase();
  if (!email) return [];
  const q = query(
    collection(db, 'invites'),
    where('email', '==', email),
    where('status', '==', 'pending'),
    orderBy('createdAt', 'desc'),
    limit(20)
  );
  const snap = await getDocs(q);
  return snap.docs.map((d) => ({ id: d.id, ...d.data() }));
}

/** Offene Einladungen, die dieser Haushalt verschickt hat (Admin-Ansicht). */
export function watchHouseholdInvites(householdId, callback) {
  const q = query(
    collection(db, 'invites'),
    where('householdId', '==', householdId),
    where('status', '==', 'pending'),
    orderBy('createdAt', 'desc'),
    limit(20)
  );
  return onSnapshot(q,
    (snap) => callback(snap.docs.map((d) => ({ id: d.id, ...d.data() }))),
    (err) => console.error('[Nestbau] Einladungs-Listener:', err));
}

/** Deep-Link `?invite=<id>&token=<token>` auslesen und aus der URL entfernen. */
export function readInviteFromUrl() {
  const params = new URLSearchParams(location.search);
  const inviteId = params.get('invite');
  const token = params.get('token');
  if (!inviteId || !token) return null;

  // Token nicht in der Adressleiste stehen lassen (History, Screenshots, Referrer)
  params.delete('invite');
  params.delete('token');
  const rest = params.toString();
  history.replaceState({}, '', location.pathname + (rest ? `?${rest}` : ''));

  return { inviteId, token };
}
