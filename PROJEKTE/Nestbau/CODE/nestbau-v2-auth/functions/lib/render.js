'use strict';

/**
 * Reines Email-Rendering – bewusst OHNE firebase-admin, damit sich die
 * Templates lokal per `node tools/render-emails.js` vorschauen lassen.
 */

const fs = require('fs');
const path = require('path');

const TEMPLATE_DIR = path.join(__dirname, '..', 'templates');
const cache = new Map();

function escapeHtml(value) {
  return String(value == null ? '' : value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function loadTemplate(name) {
  if (!cache.has(name)) {
    cache.set(name, fs.readFileSync(path.join(TEMPLATE_DIR, `${name}.html`), 'utf8'));
  }
  return cache.get(name);
}

/**
 * Ersetzt {{key}}-Platzhalter. Werte werden HTML-escaped, ausser sie stehen
 * in `raw` – das gilt nur fuer serverseitig erzeugte Links und Markup.
 */
function fill(template, values, raw = []) {
  return template.replace(/\{\{(\w+)\}\}/g, (_, key) => {
    const value = values[key];
    if (value == null) return '';
    return raw.includes(key) ? String(value) : escapeHtml(value);
  });
}

/** Baut eine vollstaendige HTML-Mail aus Basis-Layout + Inhalts-Template. */
function render(templateName, meta, values) {
  const body = fill(loadTemplate(templateName), values, ['link', 'householdDescription']);
  return fill(loadTemplate('_base'), {
    subject: meta.subject,
    headline: meta.headline,
    preheader: meta.preheader,
    recipient: meta.recipient,
    footerNote: meta.footerNote
      || 'Du erhaeltst diese Email, weil dein Konto mit dieser Adresse verknuepft ist.',
    body
  }, ['body']);
}

/** Plaintext-Fallback – ohne den landen Mails schneller im Spam. */
function toPlainText(html) {
  return html
    .replace(/<style[\s\S]*?<\/style>/gi, '')
    .replace(/<br\s*\/?>/gi, '\n')
    .replace(/<\/(p|div|tr|h\d)>/gi, '\n')
    .replace(/<[^>]+>/g, '')
    .replace(/&nbsp;/g, ' ')
    .replace(/&amp;/g, '&')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}

module.exports = { render, fill, toPlainText, escapeHtml, loadTemplate };
