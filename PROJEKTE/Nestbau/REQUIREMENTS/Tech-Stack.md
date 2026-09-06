# Nestbau – Tech-Stack

Maßgeblich ist der Repo-Stand (`Nestbau/`), nicht ältere Notizen.

## Widerspruch aufgelöst

`Claude outputs/GitHub-Automation`-Projektnotiz (jetzt [[nestbau]]) nennt „React 18 + TypeScript". **Das stimmt nicht.** Der tatsächliche Code ist Vanilla JS. Die React-Angabe stammt aus einer früheren, verworfenen Planung.

## Frontend

- **Vanilla JavaScript**, kein Build-Schritt, kein Framework
- Gesamte App in `index.html` (~3000 Zeilen HTML+CSS+JS), plus `js/`-Module auf `main`
- Styling: eigenes CSS mit CSS-Variablen (`nestbau-design.css`), Light/Dark über `prefers-color-scheme` + `data-theme`
- PWA: Service Worker (`sw.js`), `manifest.json`
- Offline: `localStorage` (`nestbau-state-v1`)

## JS-Module (`js/`, nur auf `main`)

| Modul | Zweck |
|-------|-------|
| nb-core.js | 14 Error-Codes, Retry mit Backoff + Jitter, HTTP-Wrapper |
| nb-oauth.js | PKCE-Flow für Google & Microsoft |
| nb-google-calendar.js / nb-outlook-calendar.js | Kalender-APIs |
| nb-calendar-sync.js | inkrementeller Abgleich, Konflikt-Handling |
| nb-firebase.js | Firestore-Collections, Listeners, Change-Detection (~850 Zeilen) |
| nb-migrate.js | Migration localStorage → Firestore (Backup, Batch, Verify) |
| nb-integrations-ui.js | Karten im Zahnrad-Menü |
| nb-config.js / nb-config.local.js | Config (local nicht im Repo: Client-IDs) |

`src/`, `firebase-*.js` = älterer ES-Modul-Ansatz, ignorierbar.

## Backend (optional)

- **Firebase**: Firestore, Auth (Google Sign-In; Email/Password im Auth-Bundle), Storage
- **Cloud Functions** (Node, Region `europe-west1`): Templates für Household-Lifecycle, Email-Versand über Extension „Trigger Email from Firestore", Rezept-Import
- Firebase SDK: compat-Builds via CDN
- **Anthropic API** (Claude Opus 5): KI-Fallback im Rezept-Parser, Secret `anthropic.api_key`

## Android

- **Capacitor 7** (`@capacitor/android`, app, splash-screen, status-bar)
- Web-Code wird nach `www/` gebaut (`tools/build-web.js`) und via `npx cap sync android` gepackt
- `targetSdkVersion 35`, `minSdkVersion 23`
- Build: `node tools/android-build.js debug|release`
- Auslieferung als TWA/AAB für Play Store; Cloud-Funktionen im Store-Build noch nicht aktiv

## Tooling / Tests (Branch `release/play-store`)

- Test-Runner: `node --test` (eingebaut), DOM via jsdom, echter Browser via Playwright/Chromium
- 43 Tests (Unit + Integration), Health-Check, Security-/Perf-Audit
- CI: `.github/workflows/ci.yml`, `pages.yml`
- Asset-Generierung: `@resvg/resvg-js` (nicht `sharp` – scheitert auf Windows), auch `puppeteer`/`sharp` in devDeps des Haupt-Repos

## Branch-Lage (github.com/Kildro93/Nestbau)

| Branch | Inhalt |
|--------|--------|
| `main` | Firebase, OAuth, Kalender-Sync (Vanilla JS + js/-Module) |
| `release/play-store` | Test-Suite, CI/CD, Play-Store-Assets – **ohne** Firebase |
| `master` | `nestbau-firebase`-Struktur |

Merge steht aus. Siehe [[haushalts-app]] → Branch-Divergenz.

## Umgebung (Rechner Indra)

JDK 21.0.7, Android SDK, Platform `android-35`, Build-Tools 35.0.0 / 35.0.1 / 36.0.0, Python (lokaler Server), Node.
