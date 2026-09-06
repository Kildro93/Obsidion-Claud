# SETUP: Lokale Konfiguration (.env / nb-config.local.js)

Alle echten Werte liegen ausserhalb der Repos oder in git-ignorierten Dateien.

## Nestbau Frontend

Datei: `Nestbau/js/nb-config.local.js` (existiert bereits, per `.gitignore` ausgeschlossen)

```javascript
NB.configure({
  google:  { clientId: "<google-oauth-client-id>.apps.googleusercontent.com" },
  outlook: { clientId: "<entra-application-client-id>", tenant: "common" },
  firebase: {
    apiKey: "<web-api-key>",
    authDomain: "nestbau-app.firebaseapp.com",
    projectId: "nestbau-app",
    storageBucket: "nestbau-app.appspot.com",
    messagingSenderId: "<sender-id>",
    appId: "<app-id>"
  }
});
```

Diese Client-IDs sind oeffentlich (PKCE/SPA) — Schutz kommt aus Firestore Rules und den erlaubten Redirect-URIs, nicht aus Geheimhaltung.

## Firebase Functions

Serverseitige Geheimnisse nie in Dateien, sondern:

```bash
firebase functions:secrets:set GOOGLE_CLIENT_SECRET
firebase functions:secrets:set MS_CLIENT_SECRET
firebase functions:secrets:set TOKEN_ENC_KEY
firebase functions:secrets:set ANTHROPIC_API_KEY
firebase functions:secrets:access GOOGLE_CLIENT_SECRET   # pruefen
```

## Android Build

Datei: `Nestbau/android/keystore.properties` (git-ignoriert, Klartext-Passwoerter)

```
storeFile=C:/Users/indra/.nestbau-keys/nestbau-release.jks
storePassword=<...>
keyAlias=nestbau-release
keyPassword=<...>
```

Vorlage: `keystore.properties.example` (bleibt im Repo).

## Pruefen, dass nichts geleakt wird

Im Vault-Ordner:

```powershell
git check-ignore -v "Nestbau/js/nb-config.local.js"
git status --porcelain | findstr /i "local .env jks keystore"
```

Zweiter Befehl darf nichts ausgeben.
