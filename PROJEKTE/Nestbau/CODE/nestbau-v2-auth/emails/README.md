# Email-Templates

Quelle der Wahrheit sind die Dateien in `functions/templates/`.
`preview/` wird generiert und sollte nicht von Hand bearbeitet werden:

```bash
node tools/render-emails.js
```

Danach `emails/preview/index.html` im Browser oeffnen.

## Aufbau

| Datei | Zweck | Ausgeloest durch |
|---|---|---|
| `_base.html` | Rahmen: Header, Footer, Preheader | alle |
| `verification.html` | Email-Bestaetigung | `sendVerificationEmail` |
| `household-invite.html` | Einladung in einen Haushalt | `inviteToHousehold` |
| `invite-accepted.html` | Info an den Einladenden | `acceptHouseholdInvite` |

## Platzhalter

`{{key}}` wird beim Rendern ersetzt und dabei **HTML-escaped**.
Ausgenommen sind nur `link` und `householdDescription` – beide werden
serverseitig erzeugt bzw. vorher selbst escaped (`lib/render.js`).

| Template | Platzhalter |
|---|---|
| `_base` | `subject`, `headline`, `preheader`, `body`, `footerNote`, `recipient` |
| `verification` | `name`, `link` |
| `household-invite` | `inviterName`, `householdName`, `householdDescription`, `roleLabel`, `link`, `expiresAt` |
| `invite-accepted` | `inviterName`, `memberName`, `householdName` |

## Warum Tabellen-Layout und Inline-Styles

Outlook rendert mit der Word-Engine: kein Flexbox, kein Grid, keine
`<style>`-Bloecke in mancher Konfiguration. Alles, was hier steht, ist
absichtlich altmodisch. Der Preheader (unsichtbarer Text ganz oben) steuert
die Vorschauzeile in der Inbox.

Ein Plaintext-Teil wird automatisch aus dem HTML erzeugt (`toPlainText`) und
mitgeschickt – reine HTML-Mails landen deutlich haeufiger im Spam.

## Nicht hier: Passwort-Reset

Die Reset-Mail verschickt Firebase selbst. Sie laesst sich nur in der Console
anpassen (Authentication > Templates). Text-Vorschlag steht in
`docs/INTEGRATION.md`.
