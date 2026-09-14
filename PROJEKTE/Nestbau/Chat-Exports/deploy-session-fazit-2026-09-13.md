---
tags: [projekt/nestbau, typ/fazit, status/aktuell]
erstellt: 2026-09-13
session: CEO-Nestbau (Cowork) — Deploy + Manueller Test
---

# Fazit: Deploy + Test Token-Refresh — 2026-09-13

## Abgeschlossene Aufgaben

- **package-lock.json regeneriert** — Cloud Build schlug fehl weil die Lockdatei (Node 22 lokal) nicht zu Cloud Build (Node 20) passte. Neue Lockdatei in Cloud-Umgebung generiert, `npm ci` bestanden, auf PC committet.
- **Deploy erfolgreich** — Alle 3 Kalender-Functions live (Gen 2, europe-west1):
  - `connectCalendar` → `https://connectcalendar-bb2xjs6cha-ew.a.run.app`
  - `getCalendarAccessToken`
  - `disconnectCalendar`
- **origin_mismatch behoben** — `http://localhost:5000` fehlte in den autorisierten JavaScript-Ursprüngen des OAuth-Clients "Nestbau Web (lokal)" (`831902446330-na1t66dupoie1lj2g0sgvjjvnjo4dh9b`). Hinzugefügt, Google-Consent-Popup erscheint jetzt.
- **CORS/Cloud Run Auth behoben** — Gen-2-Functions blockierten CORS-Preflight weil Cloud Run standardmässig Auth verlangt. Alle 3 Dienste auf "Öffentlichen Zugriff erlauben" umgestellt (sicher, weil `onCall` Firebase Auth intern prüft).
- **Secrets verifiziert** — `GOOGLE_CLIENT_ID` und `GOOGLE_CLIENT_SECRET` stimmen mit dem OAuth-Client in der Google Console überein.

## Status

**Aktuell blockiert:** `connectCalendar` antwortet mit **400 (Bad Request)**. Die Function-Logs zeigen "Callable request verification passed, auth: VALID" — der Request kommt durch, aber die Function selbst gibt einen Fehler zurück. Vermutlich scheitert der OAuth-Token-Tausch (`authorization_code` → Tokens) bei Google.

## Wichtigste Erkenntnisse

1. **Cloud Build braucht Node-20-kompatible Lockdatei** — Lokal generierte Lockdateien (Node 22) funktionieren nicht. Lösung: In einer Node-20-Umgebung generieren oder zumindest mit `npm ci` in Cloud Build testen.
2. **Gen-2-Functions (Cloud Run) brauchen "Öffentlichen Zugriff"** — Callable Functions prüfen Auth intern via `onCall`. Cloud-Run-Level-Auth ist redundant und blockt CORS-Preflight (OPTIONS hat keinen Auth-Header).
3. **Zwei OAuth-Clients im Projekt** — Nicht verwechseln:
   - Firebase Auth (auto): `...du7e7n8fa8hvt95a8spm0dqr69g8bjtb` (für Login)
   - Kalender ("Nestbau Web lokal"): `...na1t66dupoie1lj2g0sgvjjvnjo4dh9b` (für Calendar API)
4. **`gcloud` ist nicht installiert** — Alles über Firebase CLI oder Google Cloud Console machen.

## Nächste Schritte

1. **400-Fehler debuggen** — Browser-DevTools → Netzwerk-Tab → `connectCalendar`-Request → Antwort-Body lesen. Dort steht die genaue Fehlermeldung (z.B. `OAuth-Fehler (invalid_grant)` oder eine `assert`-Meldung).
2. **Je nach Fehler:**
   - `invalid_grant` → Code abgelaufen oder bereits verwendet → nochmal verbinden
   - `redirect_uri_mismatch` → `postmessage` vs. tatsächliche Redirect-URI prüfen
   - `assert`-Fehler → Frontend sendet falsche/fehlende Daten → `nb-google-calendar.js` prüfen
3. **Nach erfolgreichem Test:** Branches mergen, PROJEKT-UPDATE.md aktualisieren
4. **Danach:** Phase-2-Tests 6–9, Repo-Merge

## Offene Probleme

| Problem | Schweregrad | Nächster Schritt |
|---------|-------------|------------------|
| `connectCalendar` gibt 400 zurück | **blockiert** | DevTools Response-Body prüfen |
| Branches nicht gemergt (fix/google-token-refresh + fix/token-refresh-function) | wartend | Nach erfolgreichem Test mergen |
| Phase-2-Tests 6–9 ausstehend | mittel | Nach Token-Refresh-Fix |

## Dateipfade

| Datei | Pfad |
|-------|------|
| Function-Code (tokens.js) | `nestbau-firebase/functions/src/tokens.js` |
| Function-Index | `nestbau-firebase/functions/index.js` |
| Frontend Kalender | `Nestbau/js/nb-google-calendar.js` |
| Frontend Firebase | `Nestbau/js/nb-firebase.js` |
| OAuth-Config | `Nestbau/js/nb-config.local.js` |
| Crypto-Helfer | `nestbau-firebase/functions/lib/crypto.js` |
| Common-Helfer | `nestbau-firebase/functions/lib/common.js` |

## Tipps für nächsten Chat

- **Erster Schritt:** Browser-DevTools öffnen (F12), Netzwerk-Tab, "Verbinden" klicken, `connectCalendar`-Response-Body lesen — dort steht die exakte Fehlermeldung.
- Die 3 Cloud-Run-Dienste sind bereits auf "Öffentlichen Zugriff" gestellt — nicht nochmal ändern.
- Secrets sind korrekt gesetzt (GOOGLE_CLIENT_ID + GOOGLE_CLIENT_SECRET verifiziert).
- App läuft auf `http://localhost:5000`.
- `gcloud` ist nicht installiert, alles über `firebase` CLI oder Cloud Console.
