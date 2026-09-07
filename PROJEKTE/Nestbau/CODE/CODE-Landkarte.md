# Nestbau – CODE-Landkarte

Der Code wird **nicht** in dieser Vault-Notizschicht gepflegt. Er liegt in eigenen Git-Repos / Bundles im Vault-Root. Diese Datei ist der Wegweiser. Lose Snippets aus Chats/Notizen: [[#Snippets]].

## Code-Standorte

| Ort (Vault-Root) | Git | Inhalt | Maßgebliche Doku |
|------------------|-----|--------|------------------|
| `Nestbau/` | ✅ eigenes Repo | Haupt-App (`index.html`, `js/`), Android (`android/`, Capacitor), Play-Store, Test-Suite | `Nestbau/README.md`, `BUILD-GUIDE.md`, `DEPLOYMENT.md`, `FIREBASE-ARCHITECTURE.md`, `DESIGN-GUIDE.md`, `IMPLEMENTATION-STATUS.md` |
| `nestbau-firebase/` | ✅ eigenes Repo | Firebase-Backend-Ansatz: Functions (`functions/src/`, `functions/lib/`), Rules, Schema, Migration, Rules-Tests | `nestbau-firebase/README.md`, `ARCHITEKTUR.md`, `migration/README.md` |
| `Claude outputs/nestbau-v2-auth/` | ❌ Bundle | Bot-1-Drop-in: Auth-Flow (`public/`), Cloud Functions (`functions/`), Email-Templates | `.../README.md`, `docs/INTEGRATION.md`, `docs/SECURITY.md` |
| `Claude outputs/nestbau-v2-recipe-import/` | ❌ Bundle | Bot-4-Drop-in: Browser-Extension (`clipper/`), Rezept-Parser-Functions, Import-Web-UI | `.../README.md` |
| `Claude outputs/design-modernization.patch` | ❌ Patch | Design-System-Umstellung (Bot 3), 60 KB Diff | — |
| `Claude outputs/nb-config.local.js` | ❌ | lokale Client-ID-Config (Beispiel/Platzhalter) | — |

Remote: https://github.com/Kildro93/Nestbau — Branches `main` / `release/play-store` / `master`, siehe [[Tech-Stack]].

## Weitere Repo-Klone auf der Platte (Stand 2026-09-06)

Von `Kildro93/Nestbau` existieren mehrere lokale Klone. Der maßgebliche ist der im Vault.

| Pfad | Branch / HEAD | Status |
|------|---------------|--------|
| `Obsidion für Claud/Nestbau/` (Vault) | main, `6465a9c` (1 hinter origin) | **Maßgeblich.** ~20 uncommittete Änderungen (Build-Optimizer + Play-Store) – existieren nur hier |
| `C:\Users\indra\Nestbau` | main, `4bbd515` = origin/main | redundant → **2026-09-06 gelöscht** |
| `C:\KI Programme\Nestbau Boter` | release/play-store, `7b01fe1` = origin | 0 uncommitted/unpushed → **2026-09-06 gelöscht** (Branch via `git fetch origin release/play-store` wieder da) |
| `C:\KI Programme\nestbau-app` | main, `738eebd` (alt) | 0 uncommitted/unpushed → **2026-09-06 gelöscht**. `.claude/launch.json` „nestbau" zeigt jetzt auf den Vault-Klon |

**Offen:** Vault-Klon ist 1 Commit hinter `origin/main` (fehlt `4bbd515` Phase-3-OAuth-Docs). Beim nächsten lokalen Arbeiten `git fetch && git merge origin/main` – die uncommitteten Änderungen bleiben dabei erhalten (nur untracked/modified, kein Konflikt mit dem einen Commit).

## Ehemals: `C:\nestbau-build` (2026-09-06 gelöscht)

Wegwerf-Build-Ordner vom 04.09.2026, ~152 MB. Enthielt **nichts Eigenes**:
- Android-Scaffold identisch mit `Nestbau/android/`
- Die 3 Artefakte (`app-debug.apk`, `app-release.apk`, `app-release.aab`) byte-identisch mit `Nestbau/dist/nestbau-2.0.0-*` (04.09. 21:19–21:20)
- Rest reiner Cache: `node_modules/` (@capacitor), `android/.gradle/`, `android/app/build/`

Neu bauen bei Bedarf im `Nestbau/`-Repo: `npm install && npm run sync && node tools/android-build.js release`. Die Release-Artefakte landen in `Nestbau/dist/`.

Test-Emulator (2026-09-06 gelöscht, 4,5 GB) 1:1 wiederherstellen: [[Emulator-Setup]].

Der Ordner enthielt zusätzlich `keystore.properties` mit Klartext-Signing-Passwörtern (dieselbe Datei liegt weiterhin in `Nestbau/android/keystore.properties`) — siehe [[PROJEKT-ACCESS]] und die Vault-Root-`.gitignore`.

## Frontend

- Alles in `Nestbau/index.html`. `js/`-Module nur auf `main` (Liste: [[Tech-Stack]]).
- Kein Build für die Web-App. Bearbeiten → speichern → Strg+F5.
- Android-Build: `npm run sync` → `www/` → `android/`; `node tools/android-build.js debug|release`.

## Backend / Functions

- Zwei parallele Function-Sets: `nestbau-firebase/functions/` und `Claude outputs/nestbau-v2-auth/functions/`. Vor Deploy klären, welches der Stand ist.
- Deploy-Reihenfolge (kritisch): Rules → Indexes → Functions → Hosting.
- Region `europe-west1`. Email über Extension „Trigger Email from Firestore".

## Datenbank

- Firestore-Schema: [[Datenbank-Schema]] (Zusammenfassung), Details [[Firebase-Architektur]] und `Nestbau/FIREBASE-ARCHITECTURE.md`.

## Snippets

Lose Code-Fragmente, die nur in Chats/Notizen existieren (nicht im Repo als solche):

- [[kochbuch-naehrwert-berechnung]] – Nährwert-Formeln (Zutaten → Rezept → Tag)
- [[menuplan-migration]] – String→Objekt-Migration der Menüplan-Slots
- [[css-spezifitaet-dark-mode-fix]] – eigene Klasse statt `.chip-btn.active`

Vollständiges Datenmodell mit JS: [[Kochbuch-Datenmodell]].

## Lokal starten (Stand 07.09.2026)

```powershell
cd Nestbau
node scripts/server.mjs --port 8000
```

Port 8000 ist Pflicht, nicht der Standard 3000: die Google-OAuth-Client-ID ist auf
`http://localhost:8000/oauth-callback.html` registriert, und Google vergleicht die
Redirect-URI zeichengenau.
