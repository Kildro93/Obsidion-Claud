---
title: debugging
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/guide, status/aktuell]
projekt: nestbau
autor: indra
---

# Debugging-Guide

## Git und Sync

| Symptom | Ursache | Fix |
|---|---|---|
| `fatal: not a git repository` | im falschen Ordner oder `.git` fehlt | in den Vault-Root wechseln, sonst `git init` |
| Push 403 | Token fehlt, abgelaufen oder ohne Contents-Write | [[MEMORY/setup/setup-github-token]] |
| `! [rejected] non-fast-forward` | GitHub hat Commits, die lokal fehlen | `git pull --rebase origin main` |
| Auto-Sync commitet nichts | Dateien stehen in `.gitignore` | `git check-ignore -v <pfad>` |
| Datei sollte ignoriert sein, ist aber drin | war schon getrackt, bevor die Regel kam | `git rm --cached <pfad>` |
| Sync-Log leer | Aufgabe läuft nicht | Taskplaner → Verlauf, ExecutionPolicy prüfen |

## Nestbau App

| Symptom | Erster Blick |
|---|---|
| Weisse Seite | Browser-Konsole: fehlendes Script oder Syntaxfehler; `node --check js/<datei>.js` |
| Firebase "permission denied" | Firestore Rules, Nutzer im richtigen Haushalt? |
| Login geht nicht | Authorized Domains in Firebase Auth, Redirect-URI in Cloud Console |
| Google-Login: `redirect_uri_mismatch` | Dev-Server auf Port 8000 starten: `node scripts/server.mjs --port 8000` |
| Kalender-Sync leer | OAuth-Scopes, Token abgelaufen, `nb-config.local.js` gesetzt? |
| Dark Mode kaputt | CSS-Spezifität prüfen |
| Emulator startet nicht | Firebase Emulator-Setup prüfen |

## Vorgehen bei unklarem Fehler

1. Bereich per `grep` lokalisieren, nicht raten
2. Kleinste reproduzierbare Aktion in der UI finden
3. Konsole und Netzwerk-Tab lesen, bevor Code geändert wird
4. Eine Änderung pro Batch, danach `node --check`
5. Fehler mit Lösung in Fazit dokumentieren

## Wenn ein Bot sich verrennt

Abbrechen, Summary schreiben lassen mit dem, was bekannt ist, und im README als Blocker vermerken. Kein Bot arbeitet länger als eine Sitzung an derselben Sackgasse.
