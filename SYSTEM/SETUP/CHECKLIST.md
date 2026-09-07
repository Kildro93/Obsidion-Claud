# Final-Checkliste: was noch von Hand zu tun ist

Stand 2026-09-06. Alles darunter braucht dich (Token, Passwoerter, Konsolen-Klicks) — kein Bot kann es uebernehmen.

## 1. GitHub-Repo anlegen und Erst-Push (10 Min) — ERLEDIGT

Repo: `Kildro93/Obsidion-Claud`. Vault und Nestbau sind gepusht, Push laeuft ueber den Token im Windows Credential Manager.


- [x] ~~github.com → New repository~~ → Repo heisst `Obsidion-Claud` (bereits angelegt)
- [ ] Token erstellen und in Windows hinterlegen: [[SETUP-GITHUB-TOKEN]]
- [ ] In PowerShell im Vault-Ordner:
  ```powershell
  cd "C:\KI Programme\Obsidion für Claud"
  git push -u origin main
  ```
- [ ] Auf github.com pruefen: SYSTEM/, PROJEKTE/, scripts/ sind da — `Nestbau/` und `nestbau-firebase/` nicht

## 2. Auto-Sync aktivieren (2 Min) — ERLEDIGT 07.09.2026

- [x] Aufgabe "Obsidian Vault Auto-Sync" registriert, laeuft alle 30 Minuten
- [x] Verifiziert: Aenderung erkannt, committet, gepusht, im Log protokolliert

## 3. Backups aktivieren (2 Min)

- [x] Aufgabe "Obsidian Vault Weekly Backup" registriert (07.09.2026, sonntags 02:00)
- [ ] Einmal sofort testen: `powershell -ExecutionPolicy Bypass -File ".\scripts\weekly-backup.ps1"`
- [ ] Ergebnis liegt in `backups/`

## 4. Sicherheit abschliessen (15 Min)

- [x] Firebase-API-Key auf eigene Domains eingeschraenkt (localhost, nestbau-app.web.app, nestbau-app.firebaseapp.com)
- [ ] Keystore `nestbau-release.jks` + `keystore.properties` ausser Haus sichern ([[BACKUP-STRATEGY]], Ebene 3)
- [ ] Kalendereintrag: Token laeuft in 90 Tagen ab

## 5. Nestbau-Altlasten (offen aus PROJEKT-UPDATE)

- [x] ~~Uncommittete Aenderungen im `Nestbau/`-Repo~~ – 07.09.2026 in 6 Commits aufgeteilt und gepusht
- [x] ~~Branch-Entscheidung~~ – `main` geht in den Play Store, siehe [[Branch-Entscheidung]]
- [ ] Client-IDs in `nb-config.local.js` vervollstaendigen, dann `firebase deploy --only firestore:rules,storage`

## Danach

Der Loop laeuft: Vault ist auf GitHub, wird alle 30 Minuten gesichert, woechentlich gezippt. Neue Chats starten mit [[QUICK-START]].
