'use strict';

const { db, FieldValue, escapeHtml } = require('./common');
const { render, toPlainText } = require('./render');

/**
 * Legt die Mail in der Collection `mail` ab. Den Versand uebernimmt die
 * Firebase-Extension "Trigger Email from Firestore" (SendGrid/SMTP wird dort
 * einmalig konfiguriert – so liegt KEIN API-Key im Function-Code).
 * Alternative ohne Extension: siehe docs/INTEGRATION.md.
 */
async function enqueue({ to, subject, html, replyTo }) {
  await db.collection('mail').add({
    to: [to],
    ...(replyTo ? { replyTo } : {}),
    message: { subject, html, text: toPlainText(html) },
    createdAt: FieldValue.serverTimestamp()
  });
}

async function sendVerification({ to, name, link }) {
  const subject = 'Bestaetige deine Nestbau-Email';
  const html = render('verification', {
    subject,
    headline: 'Willkommen bei Nestbau',
    preheader: 'Ein Klick, dann ist dein Konto aktiv.',
    recipient: to
  }, { name: name || 'du', link });
  await enqueue({ to, subject, html });
}

async function sendHouseholdInvite({
  to, inviterName, householdName, householdDescription, roleLabel, link, expiresAt
}) {
  const subject = `${inviterName} laedt dich zu "${householdName}" ein`;
  const html = render('household-invite', {
    subject,
    headline: 'Einladung in einen Haushalt',
    preheader: `${inviterName} moechte Nestbau mit dir teilen.`,
    footerNote: 'Du bekommst diese Email, weil deine Adresse eingeladen wurde. Es wurde kein Konto fuer dich angelegt.',
    recipient: to
  }, {
    inviterName,
    householdName,
    householdDescription: householdDescription
      ? `<div style="margin-top:6px;color:#7a746a;">${escapeHtml(householdDescription)}</div>`
      : '',
    roleLabel,
    link,
    expiresAt
  });
  await enqueue({ to, subject, html });
}

async function sendInviteAccepted({ to, inviterName, memberName, householdName }) {
  const subject = `${memberName} ist "${householdName}" beigetreten`;
  const html = render('invite-accepted', {
    subject,
    headline: 'Neues Haushalts-Mitglied',
    preheader: `${memberName} macht jetzt mit.`,
    recipient: to
  }, { inviterName, memberName, householdName });
  await enqueue({ to, subject, html });
}

module.exports = {
  enqueue, render, toPlainText,
  sendVerification, sendHouseholdInvite, sendInviteAccepted
};
