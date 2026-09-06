# PROJEKT-ACCESS: Nestbau

**WICHTIG:** Echte Tokens/Keys NICHT hier speichern. Diese Datei ist nur Orientierung. Echte Keys lokal in einer `.env.local` (Git-ignored) oder als GitHub/CI-Secret halten.

## Zugang-Vorlagen

### GitHub
```
GITHUB_USER:  Kildro93
GITHUB_TOKEN: [NICHT HIER – lokal halten, siehe GitHub-Automation/PAT-Setup.md]
REPO_NAME:    Nestbau
REPO_URL:     https://github.com/Kildro93/Nestbau
BRANCHES:     main (Firebase) | release/play-store (Tests/CI/Store) | master (nestbau-firebase)
```

### Firebase
```
FIREBASE_PROJECT: [Projekt-ID eintragen]
FIREBASE_CONFIG:  js/nb-config.local.js   (NICHT im Repo – Client-IDs)
CONSOLE:          https://console.firebase.google.com
BENÖTIGT:         Firestore, Auth (Google Sign-In), Storage, Extension "Trigger Email from Firestore"
```

### OAuth (Kalender-Sync)
```
GOOGLE_OAUTH_CLIENT_ID:    [nb-config.local.js]   – Google Cloud Console, PKCE, kein Secret im Frontend
MICROSOFT_OAUTH_CLIENT_ID: [nb-config.local.js]   – Entra ID, PKCE
```

### Anthropic API (Rezept-Import, Bot 4)
```
ANTHROPIC_API_KEY: [Firebase Functions Secret: anthropic.api_key]
MODELL:            claude-opus-5 (KI-Fallback wenn JSON-LD < 50% Felder)
```

### Play Store
```
RELEASE_KEYSTORE:  C:/Users/indra/.nestbau-keys/nestbau-release.jks   (ausserhalb Vault)
KEYSTORE_PROPS:    Nestbau/android/keystore.properties   (im Vault, per .gitignore ausgeschlossen)
KEY_ALIAS:         nestbau-release
STORE/KEY_PASSWORD: [Klartext in keystore.properties – siehe Warnung unten]
PLAY_CONSOLE:      App-Integrität → App-Signaturschlüssel (Fingerprint für assetlinks.json)
```

**Warnung – Klartext-Passwörter:** `Nestbau/android/keystore.properties` enthält `storePassword`/`keyPassword` im Klartext. Abgesichert durch:
- `Nestbau/.gitignore` (schliesst `keystore.properties`, `*.jks` aus)
- Vault-Root-`.gitignore` (angelegt 2026-09-06, greift beim geplanten Push der Vault-Wurzel)

Offen (Mensch): Keystore-Backup an sicheren Ort. Bei Verdacht auf Leak → Play App Signing macht Rotation des Upload-Keys möglich (Details `Nestbau/BUILD-GUIDE.md`). Eine Kopie lag bis 2026-09-06 zusätzlich in `C:\nestbau-build` (gelöscht).

## Wie echte Keys verwalten

- Lokale `.env.local` bzw. `js/nb-config.local.js` – steht in `.gitignore`
- Firebase Functions: `firebase functions:secrets:set`
- GitHub Actions: Repo → Settings → Secrets
- Keystore-Erzeugung ist KEIN Bot-Task (Passwörter). Geht der Keystore verloren, ist die Store-App nie wieder aktualisierbar.

## Wichtige Links

- Repo: https://github.com/Kildro93/Nestbau
- Issues: https://github.com/Kildro93/Nestbau/issues
- PAT-Setup: [[PAT-Setup]]
