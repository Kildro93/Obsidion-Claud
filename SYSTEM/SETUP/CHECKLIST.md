# Final-Checkliste: was noch von Hand zu tun ist

Stand 2026-09-06.

## 1. GitHub-Repo + Erst-Push (ERLEDIGT)

- [x] Repo angelegt: Kildro93/Obsidion-Claud (privat)
- [x] Token erstellt (unbegrenzt) und im Credential Store hinterlegt
- [x] git push -u origin main erfolgreich (8 Commits)
- [x] Auf github.com geprueft: SYSTEM/, PROJEKTE/, scripts/ sind da

## 2. Auto-Sync aktivieren (ERLEDIGT)

- [x] install-autosync-task.ps1 ausgefuehrt (Fix: TimeSpan MaxValue -> 9999 Tage)
- [x] Task "Obsidian Vault Auto-Sync" registriert (alle 30 Min)
- [x] Erster Auto-Sync erfolgreich gelaufen (3 Dateien committed + gepusht)

## 3. Backups aktivieren (ERLEDIGT)

- [x] install-backup-task.ps1 ausgefuehrt
- [x] Task "Obsidian Vault Weekly Backup" registriert (Sonntag 02:00)
- [ ] Einmal sofort testen: `powershell -ExecutionPolicy Bypass -File ".\scripts\weekly-backup.ps1"`

## 4. Sicherheit (ERLEDIGT)

- [x] Firebase-API-Key auf eigene Domains eingeschraenkt (localhost, nestbau-app.web.app, nestbau-app.firebaseapp.com)
- [x] Keystore + keystore.properties in OneDrive gesichert
- [x] Token laeuft nicht ab (unbegrenzt)

## 5. CEO-Chat (ERLEDIGT)

- [x] CEO-Prompt auf Loop-System aktualisiert (Claude outputs/nestbau-ceo-master-prompt.md)

## 6. Nestbau-Altlasten (offen, fuer CEO-Chat)

- [ ] 21 uncommittete Aenderungen im Nestbau/-Repo sichten und committen
- [ ] Branch-Entscheidung: welche Fassung geht in den Play Store
- [ ] Client-IDs in nb-config.local.js vervollstaendigen, dann firebase deploy --only firestore:rules,storage

## Danach

Der Loop laeuft: Vault ist auf GitHub, wird alle 30 Minuten gesichert, woechentlich gezippt. Neue Chats starten mit [[QUICK-START]].
