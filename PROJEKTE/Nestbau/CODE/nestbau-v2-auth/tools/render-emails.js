#!/usr/bin/env node
'use strict';

/**
 * Rendert alle Email-Templates mit Beispieldaten nach emails/preview/.
 * Aufruf aus dem Projekt-Root:  node tools/render-emails.js
 */

const fs = require('fs');
const path = require('path');
const { render, toPlainText } = require('../functions/lib/render');

const OUT = path.join(__dirname, '..', 'emails', 'preview');
fs.mkdirSync(OUT, { recursive: true });

const LINK = 'https://nestbau-app.web.app/auth.html?invite=demo123&token=Xk9-demo-token';

const samples = [
  {
    file: 'verification',
    template: 'verification',
    meta: {
      subject: 'Bestaetige deine Nestbau-Email',
      headline: 'Willkommen bei Nestbau',
      preheader: 'Ein Klick, dann ist dein Konto aktiv.',
      recipient: 'indra@example.com'
    },
    values: { name: 'Indra', link: LINK }
  },
  {
    file: 'household-invite',
    template: 'household-invite',
    meta: {
      subject: 'Indra laedt dich zu "Haushalt Zuerich" ein',
      headline: 'Einladung in einen Haushalt',
      preheader: 'Indra moechte Nestbau mit dir teilen.',
      footerNote: 'Du bekommst diese Email, weil deine Adresse eingeladen wurde. Es wurde kein Konto fuer dich angelegt.',
      recipient: 'partnerin@example.com'
    },
    values: {
      inviterName: 'Indra',
      householdName: 'Haushalt Zuerich',
      householdDescription: '<div style="margin-top:6px;color:#7a746a;">Zusammenleben, Wocheneinkauf, Menueplan</div>',
      roleLabel: 'Mitglied',
      link: LINK,
      expiresAt: '10. September 2026'
    }
  },
  {
    file: 'invite-accepted',
    template: 'invite-accepted',
    meta: {
      subject: 'Mia ist "Haushalt Zuerich" beigetreten',
      headline: 'Neues Haushalts-Mitglied',
      preheader: 'Mia macht jetzt mit.',
      recipient: 'indra@example.com'
    },
    values: { inviterName: 'Indra', memberName: 'Mia', householdName: 'Haushalt Zuerich' }
  }
];

const index = [];
for (const sample of samples) {
  const html = render(sample.template, sample.meta, sample.values);
  fs.writeFileSync(path.join(OUT, `${sample.file}.html`), html, 'utf8');
  fs.writeFileSync(path.join(OUT, `${sample.file}.txt`), toPlainText(html), 'utf8');
  index.push({ file: sample.file, subject: sample.meta.subject, bytes: Buffer.byteLength(html) });
  console.log(`  ${sample.file}.html  (${Buffer.byteLength(html)} B)  ${sample.meta.subject}`);
}

// Kleine Uebersicht zum Durchklicken
fs.writeFileSync(path.join(OUT, 'index.html'), `<!doctype html>
<html lang="de"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Nestbau – Email-Vorschau</title>
<style>
 body{margin:0;font:15px -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;
      background:#f4f1ea;color:#2b2b28;padding:24px}
 h1{font-size:20px;margin:0 0 4px} p.sub{color:#6d675d;margin:0 0 20px;font-size:14px}
 ul{list-style:none;padding:0;max-width:520px;margin:0}
 li{background:#fff;border:1px solid #e4ded2;border-radius:12px;margin-bottom:10px}
 a{display:block;padding:14px 16px;color:#1c7d70;text-decoration:none;font-weight:600}
 a span{display:block;color:#6d675d;font-weight:400;font-size:13px;margin-top:2px}
</style></head><body>
<h1>Nestbau – Email-Vorschau</h1>
<p class="sub">Generiert aus functions/templates/ – nicht von Hand bearbeiten.</p>
<ul>${index.map((i) =>
  `<li><a href="./${i.file}.html">${i.file}<span>${i.subject}</span></a></li>`).join('')}</ul>
</body></html>`, 'utf8');

console.log(`\nFertig: ${samples.length} Templates -> emails/preview/`);
