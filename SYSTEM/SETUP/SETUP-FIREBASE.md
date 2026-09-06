# SETUP: Firebase (Projekt nestbau-app)

Konsole: https://console.firebase.google.com/project/nestbau-app

## Benoetigte Dienste

| Dienst | Zweck | Status pruefen |
|---|---|---|
| Firestore | Haushalt, Aufgaben, Kalender, Kochbuch | Console → Firestore Database |
| Authentication | Google Sign-In + E-Mail | Console → Authentication → Sign-in method |
| Storage | Rezeptbilder | Console → Storage |
| Extension "Trigger Email from Firestore" | Einladungs-Mails | Console → Extensions |

## 1. CLI vorbereiten

```bash
npm install -g firebase-tools
firebase login
cd "C:\KI Programme\Obsidion für Claud\Nestbau"
firebase use nestbau-app
```

Fehlt `.firebaserc`, anlegen:

```json
{ "projects": { "default": "nestbau-app" } }
```

## 2. Client-IDs holen

Console → Projekteinstellungen → Allgemein → Meine Apps → Web-App → SDK-Konfiguration.
Werte nach `Nestbau/js/nb-config.local.js` uebertragen, siehe [[SETUP-ENV-LOCAL]].

## 3. Rules und Indexes deployen

```bash
firebase deploy --only firestore:rules,firestore:indexes,storage
```

Nach jedem Regel-Deploy kurz gegen den Emulator testen:

```bash
firebase emulators:start --only firestore,auth
```

Emulator-Details: [[Emulator-Setup]]

## 4. Absicherung (wichtig)

Der Web-API-Key ist oeffentlich sichtbar — er identifiziert nur das Projekt. Die eigentliche Absicherung:

- Firestore Rules: Zugriff nur fuer Mitglieder des eigenen Haushalts
- Storage Rules: gleiches Prinzip
- Google Cloud Console → APIs & Dienste → Anmeldedaten → API-Key → Anwendungseinschraenkung auf die eigenen Domains (localhost, GitHub-Pages-Domain, Firebase-Hosting-Domain)
- Authorized Domains in Authentication → Settings sauber halten

## 5. Funktions-Secrets

```bash
firebase functions:secrets:set ANTHROPIC_API_KEY
firebase deploy --only functions
```

## Offene Punkte (Stand 2026-09-06)

- [ ] Client-IDs in `nb-config.local.js` vollstaendig eintragen
- [ ] `firebase deploy --only firestore:rules,storage`
- [ ] API-Key-Einschraenkung in der Cloud Console setzen
- [ ] Phase 2 Testing: Emulator, Two-Device-Sync, Offline
