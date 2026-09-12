---
title: checklist
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/setup, status/aktuell]
autor: indra
---

# Final-Checkliste: was noch von Hand zu tun ist

Stand 2026-09-06. Alles darunter braucht dich (Token, Passwoerter, Konsolen-Klicks) — kein Bot kann es uebernehmen.

## 1. GitHub-Repo anlegen und Erst-Push (10 Min) — ERLEDIGT

Repo: `Kildro93/Obsidion-Claud`. Vault und Nestbau sind gepusht, Push laeuft ueber den Token im Windows Credential Manager.


- [x] ~~github.com → New repository~~ → Repo heisst `Obsidion-Claud` (bereits angelegt)
- [x] Token erstellt und im Windows Credential Manager hinterlegt
- [x] Vault gepusht, Auto-Sync pusht seither selbstständig
- [x] Auf github.com geprüft: SYSTEM/, PROJEKTE/, scripts/ sind da, die Code-Repos nicht

## 2. Auto-Sync aktivieren (2 Min) — ERLEDIGT 07.09.2026

- [x] Aufgabe "Obsidian Vault Auto-Sync" registriert, laeuft alle 30 Minuten
- [x] Verifiziert: Aenderung erkannt, committet, gepusht, im Log protokolliert

## 3. Backups aktivieren (2 Min)

- [x] Aufgabe "Obsidian Vault Weekly Backup" registriert (07.09.2026, sonntags 02:00)
- [x] Getestet 07.09.2026: 411 Dateien, 3,5 MB, ohne node_modules und Build-Müll

## 4. Sicherheit abschliessen (15 Min)

- [x] Firebase-API-Key auf eigene Domains eingeschraenkt (localhost, nestbau-app.web.app, nestbau-app.firebaseapp.com)
- [ ] Keystore `nestbau-release.jks` + `keystore.properties` ausser Haus sichern ([[MEMORY/setup/backup-strategy]], Ebene 3)
- [ ] Kalendereintrag: Token laeuft in 90 Tagen ab

## 5. Nestbau-Altlasten (offen aus PROJEKT-UPDATE)

- [x] ~~Uncommittete Aenderungen im `Nestbau/`-Repo~~ – 07.09.2026 in 6 Commits aufgeteilt und gepusht
- [x] ~~Branch-Entscheidung~~ – `main` geht in den Play Store, siehe [[Branch-Entscheidung]]
- [x] Client-IDs eingetragen und Regeln ausgerollt (10.09.2026)

## Danach

Der Loop laeuft: Vault ist auf GitHub, wird alle 30 Minuten gesichert, woechentlich gezippt. Neue Chats starten mit [[MEMORY/quick-start]].
