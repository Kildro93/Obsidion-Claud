# Final-Checkliste: was noch von Hand zu tun ist

Stand 2026-09-06. Alles darunter braucht dich (Token, Passwoerter, Konsolen-Klicks) — kein Bot kann es uebernehmen.

## 1. GitHub-Repo anlegen und Erst-Push (10 Min)

- [ ] github.com → New repository → Name `obsidian-vault`, **Private**, ohne README/gitignore
- [ ] Token erstellen und in Windows hinterlegen: [[SETUP-GITHUB-TOKEN]]
- [ ] In PowerShell im Vault-Ordner:
  ```powershell
  cd "C:\KI Programme\Obsidion für Claud"
  git push -u origin main
  ```
- [ ] Auf github.com pruefen: SYSTEM/, PROJEKTE/, scripts/ sind da — `Nestbau/` und `nestbau-firebase/` nicht

## 2. Auto-Sync aktivieren (2 Min)

- [ ] `powershell -ExecutionPolicy Bypass -File ".\scripts\install-autosync-task.ps1"`
- [ ] Test: `Start-ScheduledTask -TaskName "Obsidian Vault Auto-Sync"`
- [ ] Log pruefen: `Get-Content ".\scripts\logs\vault-sync.log" -Tail 10`

## 3. Backups aktivieren (2 Min)

- [ ] `powershell -ExecutionPolicy Bypass -File ".\scripts\install-backup-task.ps1"`
- [ ] Einmal sofort testen: `powershell -ExecutionPolicy Bypass -File ".\scripts\weekly-backup.ps1"`
- [ ] Ergebnis liegt in `backups/`

## 4. Sicherheit abschliessen (15 Min)

- [ ] Firebase-API-Key in der Google Cloud Console auf eigene Domains einschraenken ([[SETUP-FIREBASE]], Abschnitt 4)
- [ ] Keystore `nestbau-release.jks` + `keystore.properties` ausser Haus sichern ([[BACKUP-STRATEGY]], Ebene 3)
- [ ] Kalendereintrag: Token laeuft in 90 Tagen ab

## 5. Nestbau-Altlasten (offen aus PROJEKT-UPDATE)

- [ ] 21 uncommittete Aenderungen im `Nestbau/`-Repo sichten und committen
- [ ] Branch-Entscheidung: welche Fassung geht in den Play Store
- [ ] Client-IDs in `nb-config.local.js` vervollstaendigen, dann `firebase deploy --only firestore:rules,storage`

## Danach

Der Loop laeuft: Vault ist auf GitHub, wird alle 30 Minuten gesichert, woechentlich gezippt. Neue Chats starten mit [[QUICK-START]].
