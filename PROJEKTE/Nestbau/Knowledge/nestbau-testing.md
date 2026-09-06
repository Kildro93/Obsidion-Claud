# Nestbau v2.0 – Test-Erkenntnisse & Validierung [stated]

**Sicherheit, Performance & Bugs aus allen 4 Bot-Implementierungen**

---

## ✅ Security Rules – 17 Test Cases [stated]

### Haushaltsdaten-Zugriff

| Test | Ergebnis | Zweck |
|------|----------|-------|
| Mitglied darf Rezepte lesen | ✅ Pass | Basis-Lesezugriff funktioniert |
| Fremde kommen nicht an Rezepte | ✅ Pass | Cross-Household Data Leak verhindert |
| Ohne Email-Verifikation kein Zugriff | ✅ Pass | Unverifiziete Konten sperren |
| Rollen-Claim wirkt ohne Dokument-Lookup | ✅ Pass | Claims-Optimierung spart Reads |
| Base64-Foto im Dokument blockiert | ✅ Pass | Data URLs in Firestore verhindert |
| Mitglied ändert nicht Mitgliederliste | ✅ Pass | Privilege Escalation verhindert |
| Admin ändert Haushaltsnamen | ✅ Pass | Rollen-basierte Schreibrechte |
| Systemliste kann nicht gelöscht werden | ✅ Pass | "Aufgaben"-Liste ist unverletzbar |

### Private Daten

| Test | Ergebnis | Zweck |
|------|----------|-------|
| Gesundheitsdaten für Mitbewohner gesperrt | ✅ Pass | Allergen-Privacy isoliert |
| Admin kommt nicht an fremde Allergien | ✅ Pass | Keine Hintertür durch Admin-Rolle |
| Eigene Gesundheitsdaten les-/schreibbar | ✅ Pass | Owner kann seine Daten verwalten |
| OAuth-Tokens für Clients gesperrt | ✅ Pass | Tokens niemals zum Client |
| Benachrichtigungen: niemand für andere anlegen | ✅ Pass | Notifications privat |
| householdIds kann sich niemand selbst setzen | ✅ Pass | Haushalt-Zuordnung nur über Functions |

---

## 🐛 Bugs gefunden & gefixt [stated]

### Bot 1 (Auth & Profiles) [stated]

| Bug | Impact | Fix |
|-----|--------|-----|
| Email-Verifikation wird nicht versendet | CRITICAL | Expliziter `mail`-Collection-Eintrag statt "magic" SDK |
| Catch-all-Rule macht alle Rules wirkungslos | CRITICAL | Entfernt – spezifische Matches definieren Zugriff |
| Profil-Wizard speichert nicht bei Abbruch | HIGH | Screen-by-Screen speichern statt one-shot |
| Doppelte Haushalt-Einladungen möglich | MEDIUM | Rate-Limit: 10 pro Stunde |

### Bot 2 (Firebase & Data) [stated]

| Bug | Impact | Fix |
|-----|--------|-----|
| Firestore Docs > 900 KB nicht speicherbar | CRITICAL | Bilder externalisieren zu Storage |
| Index-Fehler bei `arrayContains` + `orderBy` | HIGH | Alle Composite-Indexes in `firestore.indexes.json` |
| Rules-Deploy nach Functions schließt Sicherheitslücke | HIGH | Deploy-Reihenfolge: Rules → Indexes → Functions |
| localStorage-Migration überschreibt neue Daten | HIGH | Backup-Markierung + Verify-Step |

### Bot 3 (Kalender-Sync) [stated]

| Bug | Impact | Fix |
|-----|--------|-----|
| Multi-Day-Events falsch abgegrenzt | MEDIUM | Enddatum inclusive vs. exclusive prüfen |
| Offline-Edits + Sync erzeugt Konflikte | HIGH | Conflict-Markierung statt blind überschreiben |
| Service Worker cachet `.json` (API-Antworten) | MEDIUM | Cache-Liste: nur `/`, CSS, JS, Icons |

### Bot 4 (Rezept-Import) [stated]

| Bug | Impact | Fix |
|-----|--------|-----|
| SSRF-Attacks auf Private-IP-Ranges | CRITICAL | Blocklist: 10.0.0.0/8, 169.254.0.0/16, etc. |
| JSON-LD Parser scheitert bei Markup-Varianten | MEDIUM | Fallback auf Mikrodata + KI |
| Allergie-Aggregation doppelt | MEDIUM | Set-Deduplication in `recipeNutrition.js` |
| Token-Speicherung im Klartext | CRITICAL | SHA-256-Hash vor DB-Speicherung |

---

## 📊 Integration-Tests [stated]

### OAuth & Anmeldung

| Szenario | Status | Notiz |
|----------|--------|-------|
| Google OAuth Popup + PKCE | ✅ Pass | State-Validation, Challenge-Verifier korrekt |
| Microsoft Entra ID Refresh | ✅ Pass | Refresh-Token-Flow konsistent |
| Token-Speicher (nb2:... prefix) | ✅ Pass | Nicht in Sicherungs-JSON |
| Passwort-Score-Validierung | ✅ Pass | Min 10 Zeichen + Score ≥ 2 |
| Email-Enumeration-Protection | ✅ Pass | Beide Fehler-Cases gleiche Msg |

### Firestore-Sync

| Szenario | Status | Notiz |
|----------|--------|-------|
| Batch-Write < 500 Ops | ✅ Pass | Teilt sich auf bei Bedarf |
| Nested items[] in Listen | ✅ Pass | Funktioniert bis ~100 Items |
| Migration-Verify (Count-Abgleich) | ✅ Pass | Lokal == Remote bestätigt |
| Offline-Cache (Persistence) | ✅ Pass | Read-Cache funktioniert |
| Write-Queue während Offline | ⚠️ Partial | Queued, aber Konflikt-Logik fehlt noch |

### Rezept-Import (Clipper-to-Recipe)

| Szenario | Status | Notiz |
|----------|--------|-------|
| JSON-LD-Parser (deterministisch) | ✅ Pass | 80%+ Rezepte komplett geparst |
| KI-Parser (Structured Output) | ✅ Pass | Claude Opus 5, ~1.5 KB pro Rezept |
| Zutaten-Matcher (Confidence ≥ 0.5) | ✅ Pass | 70% automatisch zugeordnet |
| Bilddownload (SSRF-safe) | ✅ Pass | Private-IP-Blocklist wirkt |
| Allergie-Warnung im Editor | ✅ Pass | Bestaetigt + vermutet korrekt |

---

## ⚠️ Bekannte Limitationen [stated]

| Grenze | Status | Workaround |
|--------|--------|-----------|
| Multi-Device Konflikt-Lösung | ❌ Nicht gelöst | Last-write-wins (= State nach Sync) |
| Offline-Edits + Sync | ⚠️ Partial | Conflict-Markierung, nicht auto-merge |
| Tasks in nested items[] | ⚠️ Skaliert bis ~100 | Später: Subsammlung pro Liste |
| Max 500 Batch-Operations | ✅ Built-in | Firebase-Limit, wird geteilt |
| 1 MB Firestore-Doc-Größe | ✅ Workaround | Externe Bilder zu Storage |
| file:// URLs | ❌ Keine Cloud | Braucht http(s) Server |
| Rezept-Import > 8 MB Fotos | ❌ Blockiert | Storage-Limit pro Datei |

---

## 📈 Performance-Messungen [stated]

| Operation | Zeit | Notiz |
|-----------|------|-------|
| App-Start | <1s | Vanilla JS, keine Build |
| Firebase-Init | 2–3s | Persistence-Cache laden |
| OAuth-Popup (Google) | ~5s | Browser-Dialog, netzwerkabhängig |
| OAuth-Popup (Microsoft) | ~4s | Entra ID, schneller |
| 20-Event-Kalender-Import | ~2s | Google/Outlook API |
| Migration (50 Rezepte) | ~3s | Batch-Write + Image-Upload |
| Rezept-Clipper (Parse + Upload) | ~8s | Parser (5s) + Image-DL (3s) |
| Allergie-Aggregation (100 Zutaten) | <100ms | Lokal berechnet |

---

## ✅ Code-Quality Standards [stated]

### Sicherheit

- ✅ PKCE-OAuth (kein Client-Secret)
- ✅ Firestore-Rules (granular, ohne Catch-all)
- ✅ SHA-256-Hashes für Tokens
- ✅ Timing-safe Vergleiche
- ✅ SSRF-Schutz für externe URLs
- ✅ XSS-Schutz (textContent, keine innerHTML)

### Fehlerbehandlung

- ✅ 14 normalisierte Error-Codes
- ✅ Retry-Backoff mit Jitter
- ✅ Graceful Degradation (optional Firebase)
- ✅ Offline-Fallback (localStorage)

### Optimierungen

- ✅ Hash-basierte Diffs (nur geänderte Docs)
- ✅ Token-Caching in Custom Claims
- ✅ Composite Indexes für Performance
- ✅ Storage-Externalisierung für große Dokumente

---

## 📋 Phase 2 Testing Roadmap (Sept 4 – Sept 11, 2026) [stated]

**Firebase Architect Phase 1 Complete. Phase 2 ist Full Testing & Refinement.**

**Timeline:** ~7 Stunden Arbeit

### Task 1: Lokal Emulator Testing (2-3h) [READY]
```
[ ] Firebase Emulator starten (firestore, auth, storage)
[ ] App laden über http://localhost:8000
[ ] Rezept hinzufügen → localStorage speichert
[ ] Firebase Init funktioniert
[ ] Real-time Listener aktiv: NB.cloud.isWatching() → true
[ ] Offline Mode: DevTools offline → Cache funktioniert
```

### Task 2: Firebase Emulator Sync (1-2h) [READY]
```
[ ] Google OAuth Popup (Emulator)
[ ] Haushalt erstellen
[ ] Rezept hochladen → Firestore
[ ] Firestore Console: Rezept visible?
[ ] Listener updatet State automatisch
[ ] Changes Push funktioniert (Debounced 1200ms)
```

### Task 3: Two-Device Sync (1-2h) [READY]
```
Device 1 (Tab 1):
[ ] Login
[ ] Haushalt erstellen
[ ] Rezept "Test1" hinzufügen
[ ] Subscribe aktivieren

Device 2 (Tab 2):
[ ] Login
[ ] Beitrittscode eingeben
[ ] → "Test1" nach ~2 Sekunden sichtbar
[ ] Rezept "Test2" hinzufügen
[ ] Device 1: "Test2" sichtbar nach ~2 Sekunden
```

### Task 4: Offline Mode (30 min) [READY]
```
[ ] Rezepte hochladen + Subscribe
[ ] DevTools → Network → Offline
[ ] Neue Rezepte lokal hinzufügen
[ ] Online schalten
[ ] Rezepte zu Firestore synced?
[ ] Anderer Tab sieht sie?
[ ] Re-offline + Changes queued (visible in Network)?
```

### Task 5: Error Scenarios (1-2h) [READY]
```
[ ] Bild > 10 MB → Clear error message
[ ] Bild > 1 MiB in Dokument → "Document too large"
[ ] Firebase offline + Permission Error → Graceful fallback
[ ] Same recipe edited on 2 devices → Last-write-wins confirmed
[ ] Invalid Code → "Haushalt nicht gefunden"
[ ] Permission Denied (wrong Rules) → User notification
```

**Expected Results:** All greens. Then ready for Production Setup (DEPLOYMENT.md Phase 3).

---

## 🔗 Noch zu testen [future]

- [ ] Multi-Device Konflikt-Resolution (>2 Devices)
- [ ] Offline-Edits auf >10k Dokumenten
- [ ] Firestore ↔ localStorage Rückwärts-Migration
- [ ] Load-Test: 100+ Rezepte gleichzeitig importieren
- [ ] Cypress-E2E-Tests für kritische Flows
- [ ] Performance-Monitoring (Sentry/Analytics)
- [ ] Cloud Functions Deployment (optional, later)

---

## 📋 Deployment Validation Checklist [stated]

- [x] Alle Security-Rules getestet
- [x] Deploy-Reihenfolge (Rules → Indexes → Functions)
- [x] Email-Versand funktioniert
- [x] OAuth-Tokens sicher gespeichert
- [x] Firestore-Indexes vorhanden
- [x] Storage-CORS konfiguriert (Fotos)
- [x] App Check (reCAPTCHA v3) aktiviert
- [x] Anthropic-API-Key gesetzt (Bot 4)
- [x] Rate-Limiting funktioniert
- [ ] Load-Test mit Produktivdaten

---

## 🧪 Lokale Test-Suite (Build Optimizer, 2026-09-03) [stated]

**Quelle:** Build-/Test-Session auf `release/play-store`, Commit `7b01fe1`.
**Prüfgegenstand:** die **v1-Fassung ohne Firebase** (`index.html`, 2968 Zeilen).
Die Firebase-Fassung auf `main` wurde **nicht** von dieser Suite getestet.

---

### Ergebnis

| Prüfung | Ergebnis | Kommando |
|---|---|---|
| Test-Suite | **43/43 grün** | `npm test` |
| Health-Check inkl. echtem Chromium | **11/11 grün** | `npm run health:live` |
| Security-Check | 0 blockierende Befunde | `npm run audit:security` |
| Performance-Budgets | alle eingehalten | `npm run audit:perf` |
| Konsolenfehler im echten Browser | **keine** | `node scripts/capture-screenshots.mjs` |

---

### Aufbau der Suite [stated]

| Ebene | Datei | Prüft |
|---|---|---|
| Unit | `tests/unit/assets.test.mjs` | Manifest-Gültigkeit, Icon-Referenzen, SW-Lifecycle, Syntax der Inline-Skripte, Offline-Tauglichkeit |
| Unit | `tests/unit/structure.test.mjs` | jede per `getElementById` angesprochene ID existiert im Markup |
| Integration | `tests/integration/app.test.mjs` | Boot, Tab-Wechsel, Aufgaben/Abos anlegen, Persistenz, kaputter localStorage, Backup-Export (jsdom) |
| Integration | `tests/integration/server.test.mjs` | Ausliefern, MIME-Typen, Path-Traversal |

**Test-Runner:** `node --test` (eingebaut, keine Abhängigkeit).
**DOM:** jsdom. **Echter Browser:** Playwright/Chromium.

---

### Gefundene Fehler & Fixes [stated]

| Fund | Stufe | Fix |
|---|---|---|
| Dev-Server lieferte `.git` und `node_modules` aus | HIGH | Blockliste im Server; relevant bei `--host 0.0.0.0` im WLAN |
| Foto-Data-URLs ungefiltert in `src="…"` | MEDIUM | **offen** — 5 Stellen, `escapeHtml()` existiert bereits |
| `node --test` mit `shell:true` fand 0 Tests, meldete Erfolg | MEDIUM | `shell:false` |
| Build-Check meldete grün trotz offener Punkte | MEDIUM | `process.exitCode = 1` bei offenen Punkten |
| Live-Check klickte gegen modalen Profil-Dialog | LOW | Erststart-Flow im Test nachbilden (kein App-Bug) |

#### Attribut-Injection — offener Punkt [stated]

Betroffene Stellen in `index.html` (Stand `7b01fe1`):

| Zeile | Ausdruck |
|---|---|
| 1959 | `dataUrl` |
| 2079 | `ing.photo` |
| 2389 | `dataUrl` |
| 2446 | `r.photo` |
| 2748 | `r.photo` |

Die Werte werden per String-Verkettung in ein `src="…"`-Attribut geschrieben.
Enthält der Wert ein `"`, bricht er aus dem Attribut aus.

**Einziger realistischer Angriffsweg:** Import einer präparierten
Sicherungsdatei. Aus der Kamera stammen die Werte aus `canvas.toDataURL()`
und sind immer sauber.

**Fix:** Werte durch `escapeHtml()` schicken (Funktion existiert,
`index.html:1004`), wie es die 19 anderen `innerHTML`-Stellen bereits tun.

---

### Erststart-Verhalten [stated]

Bei leerem `localStorage` öffnet die App den Profil-Dialog **modal** und
blockiert die Tab-Leiste, bis ein Profil gewählt ist. Das ist beabsichtigt.

**Konsequenz für Automatisierung:** Browser-Tests müssen entweder den
Profil-Dialog durchlaufen oder vor dem ersten Rendern
`nestbau-active-profile` im `localStorage` setzen. Ein Klick auf einen Tab
läuft sonst 30 s in den Timeout.

---

### Performance-Messungen — v1-Fassung, lokal [stated]

Gemessen mit `scripts/perf-audit.mjs` gegen feste Budgets.

| Messgröße | Wert | Budget |
|---|---|---|
| Übertragungsgröße gesamt (gzip) | **37,7 KB** | 60 KB |
| `index.html` roh | 191.919 Bytes | — |
| Boot bis erste Ansicht | **178 ms** | 1000 ms |
| Tab-Wechsel | **≤ 6 ms** | 50 ms |
| 200 Aufgaben rendern | **12 ms** | 200 ms |
| localStorage-Auslastung bei 200 Aufgaben | **0,34 %** | — |

**Befund:** Die Fassung braucht keine Performance-Optimierung. Die Budgets
sind mit großem Abstand eingehalten.

> **Unterschied zu den Zahlen weiter oben:** Die Messungen unter
> *Performance-Messungen [stated]* (App-Start < 1 s, Firebase-Init 2–3 s)
> stammen aus der **Firebase-Fassung**. Beide Zahlenreihen sind gültig, sie
> beschreiben verschiedene Stände.

---

### Store-Assets aus der laufenden App [stated]

`scripts/capture-screenshots.mjs` startet den Dev-Server, setzt Demo-Daten,
klickt durch alle fünf Tabs und nimmt 1080×1920-Screenshots auf
(Viewport 360×640 bei `deviceScaleFactor: 3`).

Das Skript ist zugleich ein **Smoke-Test**: Es bricht mit Exit-Code 1 ab,
wenn im echten Browser ein Konsolenfehler auftritt. Beim Lauf am 2026-09-03
traten **keine** auf.

Verifiziert wurde dabei auch die Finanz-Berechnung gegen die Anzeige:
5 Abos → CHF 2285.20/Monat, CHF 27422.60/Jahr (Nachrechnung stimmt).

---

### CI/CD [stated]

| Workflow | Läuft bei | Inhalt |
|---|---|---|
| `.github/workflows/ci.yml` | Push auf `main`, `release/**`, PRs | Tests, Health, Security, Performance; prüft, dass eingecheckte Icons zu `icon.svg` passen |
| `.github/workflows/pages.yml` | Push auf `main` | veröffentlicht die PWA auf GitHub Pages |

**Noch nicht aktiv:** Pages muss einmalig unter
*Settings → Pages → Source: „GitHub Actions"* eingeschaltet werden.

---

### Play-Store-Bereitschaft — Stand 2026-09-03 [stated]

| Punkt | Stand |
|---|---|
| Icons (13 Größen + 2 maskable) | ✅ erzeugt |
| Play-Icon 512×512 | ✅ erzeugt |
| Feature-Graphic 1024×500 | ✅ erzeugt |
| Phone-Screenshots 1080×1920 | ✅ 5 Stück |
| `twa-manifest.json` (targetSdk 35) | ✅ vorbereitet |
| JDK, Android SDK, Build-Tools | ✅ vorhanden |
| **Öffentliche HTTPS-URL** | ❌ offen — Pages aktivieren |
| **Signatur-Keystore** | ❌ offen — Mensch muss anlegen |
| **AAB gebaut** | ❌ blockiert durch die zwei Punkte darüber |

**Es existiert kein APK/AAB.** Beide Blocker liegen außerhalb des Codes.

Stand jederzeit abfragen: `node scripts/build-twa.mjs --check`

---

## 🔗 Verwandte Erkenntnisse

- [[nestbau-tech]] – Technische Details
- [[haushalts-app]] – Feature-Übersicht
