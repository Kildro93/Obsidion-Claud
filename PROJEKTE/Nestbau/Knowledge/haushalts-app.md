# Haushalts-App – Nestbau v2.0

*Area: Produktive Software für Indra & Partnerin | Status: v2.0 auf `main`, Play-Store-Vorbereitung auf `release/play-store` — siehe Branch-Divergenz*

## 📋 Überblick

**Nestbau** ist die zentrale Household-Management-App für:
- Aufgaben & Listen (gemeinsam + persönlich)
- Kalender (Termine + Erinnerungen)
- Finanzen (Abos, Ausgaben)
- Kochbuch (Rezepte, Nährwerte, Menüplan)

**Architektur:** Web-App (vanilla JS), optional Firestore-Sync

**Links:**
- GitHub: https://github.com/Kildro93/Nestbau
- Technisch: [[nestbau-tech]]
- Testing: [[nestbau-testing]]

## 🎯 Kernziele

1. ✅ **Lokal lauffähig** – ohne Cloud, ohne Konto
2. ✅ **Optionale Cloud** – Aufgaben + Events + Finanzen + Kochbuch zu Firestore
3. ✅ **Kalender-Integration** – Google & Outlook lesen/schreiben
4. ✅ **Haushalt teilen** – via Beitrittscode

## 🚀 Aktuelle Features

### v2.0 (Sept 2026)
- [x] OAuth (Google, Microsoft) mit PKCE
- [x] Firestore für alle Datentypen
- [x] Kalender-Sync (bidirektional)
- [x] Migration localStorage → Firebase
- [x] Offline-Cache (Firestore Persistence)

### v1.0 (Baseline)
- [x] Aufgaben mit Listen & Filtern
- [x] Kalender (Woche/Monat, Termine, Erinnerungen)
- [x] Finanzen (Abos mit Intervallen)
- [x] Kochbuch (Rezepte, Zutaten, Menüplan)
- [x] Sicherung/Wiederherstellung (JSON)

## ✅ Status pro Bereich

| Bereich | v1 | v2 (Firebase) | Nächstes |
|---------|----|----|---|
| **Aufgaben** | ✅ | ✅ Lists-Collection | Multi-Device-Konflikt |
| **Kalender** | ✅ | ✅ Events-Collection + Google/Outlook-Sync | Recurrence-Export |
| **Finanzen** | ✅ | ✅ Subscriptions-Collection | Statistik-API |
| **Kochbuch** | ✅ | ✅ Vollständig migriert | Nährwert-API, OCR |
| **Authentifizierung** | 🟡 Lokal | ✅ OAuth + Firebase | Magic-Link optional |
| **Haushalt-Verwaltung** | ❌ | ✅ Beitrittscode | Invite-Emails |
| **Offline-Modus** | ✅ localStorage | ✅ Firestore-Cache | Conflict-Resolution |
| **Firestore Architektur** | ❌ | ✅ Phase 1 DONE (2026-09-04) | Phase 2: Testing |

## 🔧 Setup (Neuer Benutzer)

1. Repo klonen: `git clone https://github.com/Kildro93/Nestbau`
2. Lokal starten: `python -m http.server 8000`
   - auf `release/play-store` stattdessen: `npm run setup`, dann `npm run dev` (Port 3000)
3. **Ohne Cloud:** Fertig, alles läuft lokal
4. **Mit Cloud:** Siehe [[nestbau-tech]] → Firestore-Setup

## 📊 Datenumfang

**Typisch:**
- ~30 Aufgaben pro Liste (5 Listen)
- ~100 Events pro Jahr
- ~10–20 Abos
- ~50 Rezepte, ~100 Zutaten
- ~365 Menüplan-Einträge

**Firestore-Kosten:** <$1/Monat bei normalem Gebrauch

## 🤝 Zusammenarbeit

- **Zwei Profile:** Indra (ich) + Partnerin
- **Persönliche Aufgaben:** Filter "Für mich" zeigt nur eigene
- **Gemeinsame Abos:** "Gemeinsam"-Kategorie
- **Gemeinsamer Menüplan:** Ein Haushalts-Menüplan für beide

## 🔐 Sicherheit

- PKCE-OAuth (no client-secret)
- Firestore-Regeln (nur Mitglieder können lesen)
- Tokens im localStorage (nicht gesendet an Server)
- Backup-Datei ist JSON (lokal speicherbar)

## ⚠️ Branch-Divergenz seit 2026-09-03 [stated]

**Das Repo hat zwei Stände, die verschiedene Apps beschreiben.**
Geprüft am 2026-09-04 gegen `github.com/Kildro93/Nestbau`.

| | `main` | `release/play-store` |
|---|---|---|
| Commit | `738eebd` | `7b01fe1` |
| Gemeinsame Basis | \_\_\_\_ `38d84e8` \_\_\_\_ | |
| Firebase / Firestore | ✅ vorhanden | ❌ nicht vorhanden |
| OAuth (Google, Microsoft) | ✅ vorhanden | ❌ nicht vorhanden |
| Kalender-Sync | ✅ vorhanden | ❌ nicht vorhanden |
| JS-Module | 11 (`js/`, `src/`) | 0 |
| `index.html` | 3017 Zeilen / 191.557 B | 2968 Zeilen / 191.919 B |
| Test-Suite (43 Tests) | ❌ nicht vorhanden | ✅ vorhanden |
| CI/CD-Workflows | ❌ nicht vorhanden | ✅ vorhanden |
| Play-Store-Assets | ❌ nicht vorhanden | ✅ vorhanden |

**Divergenz:** `main` ist 5 Commits voraus, `release/play-store` 1 Commit —
beide seit der gemeinsamen Basis `38d84e8`. Ein dritter Branch `master`
(`5760cd2`) enthält die `nestbau-firebase`-Struktur.

### Konsequenzen [stated]

1. **Die 43 Tests prüfen die Fassung ohne Firebase.** Der Firebase-Code auf
   `main` ist von dieser Suite nie getestet worden.
2. **Die Play-Store-Angaben hängen an der Wahl.** Die v1-Fassung hat keine
   Netzwerkaufrufe → Play-Datensicherheit durchweg „nein". Die Firebase-Fassung
   überträgt Daten an Google und Microsoft → braucht Datenschutzerklärung,
   OAuth-Verifizierung und entsprechende Angaben.
3. **Ein Merge ist noch nicht erfolgt.** Wer beides will, muss die
   Test-/Build-Infrastruktur auf den Firebase-Stand übertragen — die Tests
   laufen dann nicht unverändert durch (`structure.test.mjs` prüft IDs, die
   sich geändert haben können).

**Offene Entscheidung:** Welche Fassung geht in den Play Store?
Details: [[nestbau-testing]] → Play-Store-Bereitschaft, [[nestbau-tech]] → PWA/TWA.

---

## 📱 Play-Store-Status [stated]

**Stand 2026-09-03, Branch `release/play-store`.**

Vorbereitet: 13 PWA-Icons, Play-Icon 512×512, Feature-Graphic 1024×500,
5 Phone-Screenshots 1080×1920, `twa-manifest.json` (targetSdk 35),
Build-Skripte, CI/CD.

**Zwei Blocker, beide außerhalb des Codes und nur von einem Menschen zu lösen:**

1. **GitHub Pages aktivieren** — *Settings → Pages → Source: „GitHub Actions"*.
   Eine TWA lädt die App von einer öffentlichen HTTPS-URL; `localhost` geht nicht.
2. **Signaturschlüssel anlegen** — `keytool -genkeypair …`. Hier werden
   Passwörter vergeben; kein Automat sollte das übernehmen.

**Es existiert kein APK/AAB.** Ohne beide Punkte wäre jedes gebaute AAB im
Store unbrauchbar.

Nachgelagerte Falle: `assetlinks.json` wird nur in der **Domain-Wurzel**
gesucht, nie im Projektpfad — siehe [[nestbau-tech]].

---

## 📈 Metriken

### Firebase-Fassung (`main`, Commit `738eebd`) [stated]

- **Code:** 3017 Zeilen `index.html` + 11 JS-Module (`js/`, `src/`)
- **Build-Zeit:** 0 (kein Build nötig)
- **Übertragung:** 191.557 Bytes roh, **38,6 KB gzip** (nicht minifiziert)
- **Datenbank:** Firestore (reads/writes pro Operation)

### v1-Fassung (`release/play-store`, Commit `7b01fe1`) [stated]

Gemessen am 2026-09-03 mit `scripts/perf-audit.mjs`:

- **Code:** 2968 Zeilen `index.html`, keine Module
- **Übertragung gesamt:** **37,7 KB gzip** (Budget 60 KB)
- **Boot bis erste Ansicht:** 178 ms
- **Tab-Wechsel:** ≤ 6 ms
- **200 Aufgaben rendern:** 12 ms
- **Datenbank:** keine — `localStorage`, 0,34 % Auslastung bei 200 Aufgaben

> Die frühere Angabe „~50 KB (minified, vor Gzip)" war nicht belegt: Der Code
> ist nicht minifiziert, roh sind es ~191 KB, gzip ~38 KB.

## 🗓️ Roadmap

### Q3 2026 ✅
- [x] v2.0 Firebase-Integration
- [x] Kalender-Sync

### Q4 2026 🎯
- [ ] Tasks zu Firestore-Subsammlung
- [ ] Multi-Device Conflict-Resolution
- [ ] Invite-Emails (Cloud Functions)
- [ ] Performance-Monitoring

### 2027 🔮
- [ ] Nährwert-API Integration
- [ ] Intelligente Menüplan-Vorschläge
- [ ] Budget-Alerts
- [ ] Rezept-Sharing mit Familie

## 📞 Kontakt

- Repo-Issues: https://github.com/Kildro93/Nestbau/issues
- Obsidian: [[Features]]

---

## 🚀 Firebase Architect Phase 1 – Sept 4, 2026 [stated]

**Status: ✅ COMPLETE**

**Deliverables:**
- ✅ FIREBASE-ARCHITECTURE.md (~400 Zeilen) – Firestore-Design, Collections, Sync-Flows
- ✅ DEPLOYMENT.md (~350 Zeilen) – Local → Production (Emulator, Firebase Setup, Testing)
- ✅ IMPLEMENTATION-STATUS.md (~400 Zeilen) – Phase 1 Done / Phase 2 TODO (~7h)
- ✅ DEV-QUICKSTART.md (~350 Zeilen) – 2-Min-Überblick + 5 konkrete Tasks
- ✅ firestore.indexes.json – 8 Performance-Indexes
- ✅ functions/ (Cloud Functions Templates) – Optional, ready to deploy

**Architecture finalized:**
- **9 Collections** unter `households/{hid}` + 1 Lookup-Table
- **Real-time Sync** via Firestore Listeners (already in nb-firebase.js)
- **Security Rules** via isMember() checks (no enumeration)
- **Image Handling** via Content-Hash Storage URLs
- **Migration Framework** backup + batch-upload + verify

**Phase 2 (Testing):** ~7h for local Emulator + 2-device sync + offline validation

---

*Zuletzt aktualisiert: 2026-09-04 (Knowledge Keeper — Firebase Architect Phase 1 + Branch-Divergenz, Play-Store-Status)*

**Linked Topics:**
- [[nestbau-tech]] – Technische Architektur + Firebase Best Practices
- [[nestbau-testing]] – Test-Erkenntnisse + Phase 2 Roadmap
- Repo: https://github.com/Kildro93/Nestbau
