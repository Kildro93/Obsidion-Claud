/**
 * Nestbau v2.0 – Profil-Service
 * Profil lesen/schreiben und Profilbild hochladen.
 */

import {
  doc, getDoc, setDoc, onSnapshot, serverTimestamp
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-firestore.js';
import {
  ref as storageRef, uploadBytes, getDownloadURL, deleteObject
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-storage.js';

import { db, storage, auth } from './firebase-config.js';
import { normalizeProfileInput } from './validation.js';

const MAX_UPLOAD_BYTES = 5 * 1024 * 1024;
const AVATAR_SIZE = 512;

function profileRef(uid) {
  return doc(db, 'profiles', uid);
}

export async function getProfile(uid = auth.currentUser?.uid) {
  if (!uid) throw new Error('Nicht angemeldet.');
  const snap = await getDoc(profileRef(uid));
  return snap.exists() ? { id: snap.id, ...snap.data() } : null;
}

export function watchProfile(callback, uid = auth.currentUser?.uid) {
  if (!uid) return () => {};
  return onSnapshot(profileRef(uid),
    (snap) => callback(snap.exists() ? { id: snap.id, ...snap.data() } : null),
    (err) => console.error('[Nestbau] Profil-Listener:', err));
}

/**
 * Speichert das Profil. `profileComplete` markiert, dass der Wizard einmal
 * vollstaendig durchlaufen wurde – daran haengt der Onboarding-Status.
 */
export async function saveProfile(input, { markComplete = false } = {}) {
  const uid = auth.currentUser?.uid;
  if (!uid) throw new Error('Nicht angemeldet.');

  const data = normalizeProfileInput(input);
  await setDoc(profileRef(uid), {
    ...data,
    uid,
    ...(markComplete ? { profileComplete: true } : {}),
    updatedAt: serverTimestamp()
  }, { merge: true });

  return data;
}

/**
 * Verkleinert das Bild im Browser auf 512×512 (Center-Crop) und komprimiert
 * als WebP. Ein 4-MB-Handyfoto wird so zu ~40 KB – das spart Upload-Zeit,
 * Storage-Kosten und laedt in der Mitglieder-Liste sofort.
 */
async function prepareAvatar(file) {
  if (!file.type.startsWith('image/')) {
    throw new Error('Bitte waehle ein Bild (JPG, PNG oder WebP).');
  }
  if (file.size > MAX_UPLOAD_BYTES * 4) {
    throw new Error('Das Bild ist zu gross (max. 20 MB Ausgangsdatei).');
  }

  const bitmap = await createImageBitmap(file);
  const side = Math.min(bitmap.width, bitmap.height);
  const sx = (bitmap.width - side) / 2;
  const sy = (bitmap.height - side) / 2;

  const canvas = document.createElement('canvas');
  canvas.width = canvas.height = AVATAR_SIZE;
  const ctx = canvas.getContext('2d');
  ctx.imageSmoothingQuality = 'high';
  ctx.drawImage(bitmap, sx, sy, side, side, 0, 0, AVATAR_SIZE, AVATAR_SIZE);
  bitmap.close?.();

  const blob = await new Promise((resolve) =>
    canvas.toBlob(resolve, 'image/webp', 0.85));
  if (!blob) throw new Error('Bild konnte nicht verarbeitet werden.');
  if (blob.size > MAX_UPLOAD_BYTES) throw new Error('Bild ist nach der Komprimierung noch zu gross.');
  return blob;
}

export async function uploadAvatar(file) {
  const uid = auth.currentUser?.uid;
  if (!uid) throw new Error('Nicht angemeldet.');

  // Die Rules validieren das GESAMTE Dokument nach dem Merge. Faellt der
  // Upload vor den ersten Profil-Speichern (oder bevor die Cloud Function
  // das Skelett angelegt hat), fehlen displayName und color – der Write
  // wuerde abgelehnt. Deshalb hier Mindestwerte mitschicken.
  const existing = await getProfile(uid).catch(() => null);
  const fallback = {
    displayName: existing?.displayName || auth.currentUser.email?.split('@')[0] || 'Ich',
    color: existing?.color || '#1c7d70'
  };

  const blob = await prepareAvatar(file);
  // Fester Dateiname: ein Upload ersetzt den vorherigen, es sammelt sich
  // kein Muell im Bucket an.
  const path = `profiles/${uid}/avatar.webp`;
  const fileRef = storageRef(storage, path);

  await uploadBytes(fileRef, blob, {
    contentType: 'image/webp',
    cacheControl: 'public,max-age=3600'
  });
  const url = await getDownloadURL(fileRef);

  await setDoc(profileRef(uid), {
    ...fallback,
    uid,
    photoURL: url,
    photoPath: path,
    updatedAt: serverTimestamp()
  }, { merge: true });

  return url;
}

export async function removeAvatar() {
  const uid = auth.currentUser?.uid;
  if (!uid) throw new Error('Nicht angemeldet.');
  try {
    await deleteObject(storageRef(storage, `profiles/${uid}/avatar.webp`));
  } catch (err) {
    if (err.code !== 'storage/object-not-found') throw err;
  }
  await setDoc(profileRef(uid), {
    photoURL: null, photoPath: null, updatedAt: serverTimestamp()
  }, { merge: true });
  // Kein Rules-Problem: das Dokument existiert an dieser Stelle bereits
  // vollstaendig, sonst gaebe es kein Bild zum Loeschen.
}

/** Initialen fuer den Avatar-Platzhalter: "Anna Muster" -> "AM" */
export function initials(name) {
  return String(name || '?')
    .trim().split(/\s+/).slice(0, 2)
    .map((part) => part[0] || '')
    .join('').toUpperCase() || '?';
}
