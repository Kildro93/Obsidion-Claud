'use strict';

const admin = require('firebase-admin');
const { HttpsError } = require('firebase-functions/v2/https');

if (!admin.apps.length) admin.initializeApp();

const db = admin.firestore();
const auth = admin.auth();
const FieldValue = admin.firestore.FieldValue;

const REGION = 'europe-west1';

/** Nestbau-Markenfarben – auch in den Email-Templates verwendet. */
const BRAND = {
  primary: '#1c7d70',
  green: '#4a6741',
  ochre: '#8a5f22',
  red: '#b5342a'
};

/**
 * Verlangt einen angemeldeten UND email-verifizierten Aufrufer.
 * Ohne Verifikation kann sonst jeder mit einer fremden Adresse ein Konto
 * anlegen und darueber Einladungen abgreifen.
 */
function requireVerifiedAuth(request) {
  const a = request.auth;
  if (!a) throw new HttpsError('unauthenticated', 'Bitte melde dich an.');
  if (!a.token.email_verified) {
    throw new HttpsError('failed-precondition', 'Bitte bestaetige zuerst deine Email-Adresse.');
  }
  return { uid: a.uid, email: String(a.token.email || '').toLowerCase() };
}

function normalizeEmail(value) {
  return String(value || '').trim().toLowerCase();
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/;

function assertEmail(value, field = 'email') {
  const email = normalizeEmail(value);
  if (!EMAIL_RE.test(email) || email.length > 254) {
    throw new HttpsError('invalid-argument', `Ungueltige Email-Adresse (${field}).`);
  }
  return email;
}

function assertString(value, field, { min = 1, max = 200 } = {}) {
  const s = typeof value === 'string' ? value.trim() : '';
  if (s.length < min || s.length > max) {
    throw new HttpsError('invalid-argument', `Feld "${field}" muss ${min}–${max} Zeichen haben.`);
  }
  return s;
}

/** HTML-Escaping fuer alles, was aus User-Input in eine Email wandert. */
function escapeHtml(value) {
  return String(value == null ? '' : value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

module.exports = {
  admin, db, auth, FieldValue, REGION, BRAND,
  requireVerifiedAuth, normalizeEmail, assertEmail, assertString, escapeHtml
};
