/**
 * Nestbau v2.0 – Firebase Bootstrap
 *
 * Die Config-Werte sind KEINE Geheimnisse: der apiKey identifiziert nur das
 * Projekt. Was schuetzt, sind Security Rules + der Domain-Allowlist unter
 * Authentication > Settings > Authorized domains. Trotzdem liegt die Config
 * in einer eigenen Datei, damit sie pro Umgebung getauscht werden kann.
 */

import { initializeApp } from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-app.js';
import {
  getAuth, connectAuthEmulator, setPersistence,
  browserLocalPersistence, browserSessionPersistence
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-auth.js';
import {
  getFirestore, connectFirestoreEmulator
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-firestore.js';
import {
  getStorage, connectStorageEmulator
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-storage.js';
import {
  getFunctions, connectFunctionsEmulator
} from 'https://www.gstatic.com/firebasejs/11.0.2/firebase-functions.js';

// TODO: Mit den Werten aus Firebase Console > Projekteinstellungen > Web-App ersetzen.
export const firebaseConfig = window.__NESTBAU_FIREBASE_CONFIG__ || {
  apiKey: 'AIzaSyDEMO-REPLACE-ME',
  authDomain: 'nestbau-app.firebaseapp.com',
  projectId: 'nestbau-app',
  storageBucket: 'nestbau-app.firebasestorage.app',
  messagingSenderId: '000000000000',
  appId: '1:000000000000:web:0000000000000000000000'
};

export const REGION = 'europe-west1';

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
export const functions = getFunctions(app, REGION);

/** Emulator-Modus: `?emu=1` an die URL haengen oder auf localhost entwickeln. */
const useEmulator =
  new URLSearchParams(location.search).has('emu') ||
  ['localhost', '127.0.0.1'].includes(location.hostname);

if (useEmulator) {
  connectAuthEmulator(auth, 'http://127.0.0.1:9099', { disableWarnings: true });
  connectFirestoreEmulator(db, '127.0.0.1', 8080);
  connectStorageEmulator(storage, '127.0.0.1', 9199);
  connectFunctionsEmulator(functions, '127.0.0.1', 5001);
  console.info('[Nestbau] Firebase-Emulatoren aktiv');
}

/**
 * "Angemeldet bleiben" steuert die Persistenz.
 *
 * local   = IndexedDB, ueberlebt Neustarts (Default fuer die installierte PWA –
 *           sonst muesste man sich bei jedem App-Start neu anmelden)
 * session = nur der aktuelle Tab, z. B. auf einem geteilten Geraet
 *
 * In beiden Faellen verwaltet das Firebase SDK die Tokens selbst; es landet
 * nie ein Token per Hand in localStorage.
 */
export async function applyPersistence(remember = true) {
  await setPersistence(auth, remember ? browserLocalPersistence : browserSessionPersistence);
}
