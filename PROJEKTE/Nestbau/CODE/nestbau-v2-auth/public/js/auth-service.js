/**
 * Nestbau v2.0 – Auth-Service
 * Registrierung, Login, Email-Verifikation, Passwort-Reset.
 */

import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut,
  sendEmailVerification,
  sendPasswordResetEmail,
  onAuthStateChanged,
  reload,
  updatePassword,
  reauthenticateWithCredential,
  EmailAuthProvider
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js';
import { httpsCallable } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-functions.js';

import { auth, functions, applyPersistence } from './firebase-config.js';

/**
 * Fehler-Mapping.
 *
 * Wichtig: falsches Passwort und unbekannte Email liefern DIESELBE Meldung.
 * Alles andere waere ein Konto-Orakel ("diese Adresse existiert") und laesst
 * sich zum Abgleich von Email-Listen missbrauchen. Firebase-Projekte mit
 * aktivierter Email-Enumeration-Protection liefern dafuer ohnehin nur noch
 * `auth/invalid-credential`.
 */
const GENERIC_CREDENTIALS = 'Email oder Passwort stimmt nicht.';

const ERROR_MESSAGES = {
  'auth/invalid-credential': GENERIC_CREDENTIALS,
  'auth/wrong-password': GENERIC_CREDENTIALS,
  'auth/user-not-found': GENERIC_CREDENTIALS,
  'auth/invalid-email': 'Diese Email-Adresse sieht nicht gueltig aus.',
  'auth/user-disabled': 'Dieses Konto wurde deaktiviert.',
  'auth/email-already-in-use': 'Fuer diese Adresse existiert bereits ein Konto. Melde dich an oder setze dein Passwort zurueck.',
  'auth/weak-password': 'Das Passwort ist zu schwach.',
  'auth/too-many-requests': 'Zu viele Versuche. Bitte warte einen Moment.',
  'auth/network-request-failed': 'Keine Verbindung. Pruef dein Netz und versuch es nochmal.',
  'auth/requires-recent-login': 'Aus Sicherheitsgruenden bitte neu anmelden.',
  'auth/operation-not-allowed': 'Email/Passwort-Anmeldung ist im Projekt nicht aktiviert.',
  'functions/unauthenticated': 'Bitte melde dich an.',
  'functions/permission-denied': 'Dafuer fehlt dir die Berechtigung.',
  'functions/resource-exhausted': 'Limit erreicht. Bitte spaeter nochmal.',
  'functions/deadline-exceeded': 'Der Vorgang ist abgelaufen.',
  'functions/already-exists': 'Das existiert bereits.',
  'functions/not-found': 'Nicht gefunden.'
};

export function toMessage(error) {
  if (!error) return 'Unbekannter Fehler.';
  const code = error.code || '';
  if (ERROR_MESSAGES[code]) return ERROR_MESSAGES[code];
  // HttpsError aus eigenen Functions traegt eine eigene, bereits deutsche Message
  if (code.startsWith('functions/') && error.message) return error.message;
  return 'Etwas ist schiefgelaufen. Versuch es bitte nochmal.';
}

/**
 * Client-seitige Bremse gegen Passwort-Raten im selben Tab.
 * Ersetzt KEINEN Server-Schutz – dafuer sind Firebase App Check und die
 * automatische Sperre nach zu vielen Versuchen zustaendig. Das hier
 * verhindert nur, dass ein Formular in Millisekunden durchgehaemmert wird.
 */
const THROTTLE_KEY = 'nb_login_attempts';
const THROTTLE_MAX = 5;
const THROTTLE_BASE_MS = 15000;

function readAttempts() {
  try { return JSON.parse(sessionStorage.getItem(THROTTLE_KEY)) || { count: 0, until: 0 }; }
  catch { return { count: 0, until: 0 }; }
}
function writeAttempts(state) {
  try { sessionStorage.setItem(THROTTLE_KEY, JSON.stringify(state)); } catch { /* Private Mode */ }
}

export function throttleStatus() {
  const { until } = readAttempts();
  const remaining = until - Date.now();
  return remaining > 0 ? { blocked: true, seconds: Math.ceil(remaining / 1000) } : { blocked: false };
}

function noteFailure() {
  const state = readAttempts();
  state.count += 1;
  if (state.count >= THROTTLE_MAX) {
    const over = state.count - THROTTLE_MAX;
    state.until = Date.now() + THROTTLE_BASE_MS * Math.pow(2, Math.min(over, 4));
  }
  writeAttempts(state);
}

function clearFailures() {
  writeAttempts({ count: 0, until: 0 });
}

// ---------------------------------------------------------------- Registrierung
export async function register({ email, password, remember = true }) {
  await applyPersistence(remember);
  const cred = await createUserWithEmailAndPassword(auth, email.trim().toLowerCase(), password);
  clearFailures();
  await requestVerificationEmail();
  return cred.user;
}

/**
 * Verschickt die Bestaetigungs-Email. Bevorzugt die Cloud Function mit dem
 * Nestbau-Template; faellt auf das Firebase-Standardtemplate zurueck, wenn
 * die Function (noch) nicht deployed ist.
 */
export async function requestVerificationEmail() {
  const user = auth.currentUser;
  if (!user) throw new Error('Nicht angemeldet.');
  if (user.emailVerified) return { alreadyVerified: true };

  try {
    const call = httpsCallable(functions, 'sendVerificationEmail');
    const res = await call({});
    return res.data;
  } catch (err) {
    console.warn('[Nestbau] Branded Verification-Mail nicht verfuegbar, nutze Firebase-Default:', err.code);
    await sendEmailVerification(user, {
      url: `${location.origin}/auth.html?verified=1`,
      handleCodeInApp: false
    });
    return { ok: true, fallback: true };
  }
}

/** Prueft beim Server nach, ob die Email inzwischen bestaetigt wurde. */
export async function refreshVerification() {
  const user = auth.currentUser;
  if (!user) return false;
  await reload(user);
  await user.getIdToken(true);          // Token neu ziehen: email_verified-Claim
  if (user.emailVerified) await syncAuthState();
  return user.emailVerified;
}

// ---------------------------------------------------------------- Login
export async function login({ email, password, remember = true }) {
  const status = throttleStatus();
  if (status.blocked) {
    throw Object.assign(new Error(`Zu viele Versuche. Warte noch ${status.seconds} Sekunden.`),
      { code: 'nestbau/throttled' });
  }
  try {
    await applyPersistence(remember);
    const cred = await signInWithEmailAndPassword(auth, email.trim().toLowerCase(), password);
    clearFailures();
    await syncAuthState().catch(() => {});
    return cred.user;
  } catch (err) {
    noteFailure();
    throw err;
  }
}

export async function logout() {
  await signOut(auth);
  clearFailures();
}

/**
 * Passwort-Reset. Meldet bewusst immer Erfolg – ob die Adresse existiert,
 * ist aus derselben Enumeration-Ueberlegung heraus keine Information,
 * die wir preisgeben.
 */
export async function requestPasswordReset(email) {
  try {
    await sendPasswordResetEmail(auth, email.trim().toLowerCase(), {
      url: `${location.origin}/auth.html`
    });
  } catch (err) {
    if (err.code !== 'auth/user-not-found' && err.code !== 'auth/invalid-email') throw err;
  }
  return { ok: true };
}

export async function changePassword({ currentPassword, newPassword }) {
  const user = auth.currentUser;
  if (!user || !user.email) throw new Error('Nicht angemeldet.');
  const credential = EmailAuthProvider.credential(user.email, currentPassword);
  await reauthenticateWithCredential(user, credential);
  await updatePassword(user, newPassword);
  return { ok: true };
}

/** Serverseitiger Statusabgleich (users/{uid}: emailVerified, status, lastLoginAt). */
export async function syncAuthState() {
  const call = httpsCallable(functions, 'syncAuthState');
  const res = await call({});
  return res.data;
}

export function watchAuth(callback) {
  return onAuthStateChanged(auth, callback);
}

export function currentUser() {
  return auth.currentUser;
}
