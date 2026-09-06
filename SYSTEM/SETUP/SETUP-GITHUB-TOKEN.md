# SETUP: GitHub Token

Ziel: Der Auto-Sync pusht ohne Passwort-Abfrage.

## 1. Personal Access Token erstellen

1. github.com → Profilbild → Settings → Developer settings
2. Personal access tokens → Fine-grained tokens → Generate new token
3. Name: `vault-autosync`
4. Expiration: 90 Tage (Kalendereintrag zum Erneuern setzen)
5. Repository access: Only select repositories → `obsidian-vault` (und `Nestbau`, wenn der gleiche Token dafuer gelten soll)
6. Permissions → Repository permissions → **Contents: Read and write**
7. Generate → Token sofort kopieren (wird nur einmal angezeigt)

## 2. Token in Windows hinterlegen

Einmalig in PowerShell im Vault-Ordner:

```powershell
git config --global credential.helper manager
git push origin main
```

Beim ersten Push fragt Windows nach Zugangsdaten:
- Benutzername: `Kildro93`
- Passwort: der Token (nicht das GitHub-Passwort)

Danach liegt der Token im Windows Credential Manager und der Auto-Sync laeuft ohne Nachfrage.

## 3. Pruefen

```powershell
git ls-remote https://github.com/Kildro93/obsidian-vault
```

Gibt Refs aus → Token funktioniert. Fehler 403 → Permissions pruefen (Contents: Read and write).

## Token erneuern

Bei Ablauf: neuen Token erzeugen, dann alten Eintrag ersetzen:

```powershell
cmdkey /list | findstr github
git credential-manager erase
```
Danach naechster Push fragt erneut → neuen Token eingeben.

## No-Gos

- Token nie in eine Vault-Datei schreiben
- Token nie in `.git/config` als URL (`https://TOKEN@github.com/...`)
- Bei Verdacht auf Leak: Settings → Tokens → Revoke, neuen erzeugen
