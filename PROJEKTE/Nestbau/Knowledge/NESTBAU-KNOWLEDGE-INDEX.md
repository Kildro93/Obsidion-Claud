# Nestbau v2.0 – Knowledge Index [stated]

**Zentrale Sammlung aller technischen Erkenntnisse aus Bot 1–4**

---

## 📚 Dokumente

### Hauptarchitektur
- **[[haushalts-app]]** – Feature-Übersicht, Datenmodell, Auth-Flow, Deploy-Checkliste
  - Zielgruppe: Projektüberblick, Integration neuer Bots
  - Schlüssel: Profile/Haushalt/Mirror-Pattern, Einladungsflow, Deploy-Reihenfolge

### Technische Tiefe
- **[[nestbau-tech]]** – Firebase Best Practices, Sicherheit, Architektur-Patterns, Bot-4-Details
  - Zielgruppe: Developer, die Code lesen/ändern
  - Schlüssel: Rules-Logik, Email-Versand, Custom Claims, SSRF-Schutz

### Testpläne
- **[[Phase-2-Testplan]]** – Two-Device-Sync, Offline, Konflikt, Regeln (Stand 07.09.2026)
  - Zielgruppe: wer den Sync abnimmt
  - Schlüssel: Kernpfad in 20 Minuten, Klickpfade aus dem Code, erwartete Ergebnisse

### Konzepte
- **[[Konzept-Multi-Device-Konflikte]]** – heutiges Verhalten, drei Optionen, Empfehlung (Entwurf, nicht umgesetzt)

### Testing & Validierung
- **[[nestbau-testing]]** – Security-Tests, Bugs & Fixes, Performance, Deployment-Checklist
  - Zielgruppe: QA, Deployment-Manager
  - Schlüssel: 17 bestandene Tests, kritische Bugs (Rules-Order, Email-Send)

---

## 🔑 Critical Fixes [ERROR-CRITICAL]

### 1. Firestore Security Rules Order [stated]

❌ **FALSCH** (aus Setup-Guide):
```javascript
match /{document=**} { allow read: if request.auth != null; }
```

✅ **KORREKT**: Keine Catch-all-Regel. Spezifische Matches definieren Zugriff, Rest implizit deny.

**Impact**: Sicherheitslücke hätte jedem Angemeldeten alle Daten gezeigt.

---

### 2. Email-Verifikation ist manuell [stated]

❌ **FALSCH**: `generateEmailVerificationLink()` → User erhält keine Mail

✅ **KORREKT**: Link erzeugen → `mail`-Collection → Extension versendet

**Impact**: Nutzer konnten sich registrieren, aber Email-Verifikation funktionierte nicht.

---

### 3. Deploy-Reihenfolge [stated]

```bash
1. Rules ZUERST (firestore:rules, storage:rules)
2. Indexes (firestore:indexes)
3. Functions
4. Hosting
```

**Impact**: Wenn Functions vor Rules deployen, läuft die App kurz ungeschützt.

---

### 4. SSRF-Schutz für externe Bild-Downloads [stated]

❌ **FALSCH**: `fetch(userProvidedUrl)` → Private-IP-Ranges angreifbar

✅ **KORREKT**: Blocklist [10.0.0.0/8, 169.254.0.0/16], Max 3 Redirects mit IP-Check pro Hop

**Impact**: Bot 4 hätte AWS-Metadata-Endpunkte herunterladen können.

---

## 🏆 Best Practices [stated]

### Architecture

- **State Machine**: Separate Functions pro State, nicht alles in einem
- **Mirror Collection**: Privates Profil + öffentliche Mitglieder-Karte
- **Hash-Diffs**: Nur geänderte Dokumente hochladen
- **Custom Claims**: Rollen im Token cachen, Firestore-Reads sparen

### Security

- **Bearer Tokens**: Nur in Headers, nie in URLs
- **PKCE-OAuth**: State + Challenge-Response, kein Client-Secret
- **Email Enumeration**: Gleiche Fehlermeldung für alle "nicht gefunden"-Fälle
- **Timing-Safe Comparisons**: `crypto.timingSafeEqual()` für Token-Vergleiche

### Operations

- **Firestore Composite Indexes**: Vor Deploy in `firestore.indexes.json` schreiben
- **Storage Rules**: Nicht Firestore in Rules lesen (teuer), Path-Checks reichen
- **Email über Extension**: "Trigger Email from Firestore" spart API-Keys in Code
- **Offline Cache**: `enablePersistence({synchronizeTabs: true})` für Multi-Tab-Sync

---

## 📊 Bekannte Grenzen [stated]

| Grenze | Status | Details |
|--------|--------|---------|
| Multi-Device Konflikt-Lösung | ❌ Nicht gelöst | Momentan: Last-write-wins |
| Tasks in nested items[] | ⚠️ Bis ~100 Items | Später: Subsammlung |
| Max 500 Batch-Operations | ✅ Built-in | Firebase-Limit, wird geteilt |
| Firestore-Doc Max 1 MB | ✅ Workaround | Externe Bilder zu Storage |
| Rezept-Import > 8 MB | ❌ Blockiert | Storage-Datei-Limit |
| offline-Edits + Sync | ⚠️ Conflict-Marking | Auto-Merge noch nicht implementiert |

---

## 🔄 Abkürzungen & Begriffe

| Term | Bedeutung |
|------|-----------|
| **Mirror-Collection** | Öffentliche Kopie privater Daten (selective Fields) |
| **Custom Claims** | Rollen im Auth-Token (schneller als Firestore-Lookup) |
| **Composite Index** | Firestore-Index mit mehreren Feldern (für `arrayContains` + `orderBy`) |
| **Hash-Diff** | Vergleich: SHA(altes JSON) ≠ SHA(neues JSON) → Dokument geändert |
| **PKCE-Flow** | Oauth ohne Client-Secret (Code Challenge + Verifier) |
| **SSRF** | Server-Side Request Forgery (External URL zu Private-IP missbraucht) |
| **Timing-Safe Comparison** | Konstante Zeit für Vergleiche (verhindert Timing-Attacks) |

---

## 🔗 Externe Links

- **GitHub**: https://github.com/Kildro93/Nestbau
- **Firebase Console**: https://console.firebase.google.com
- **Anthropic API**: https://console.anthropic.com

---

## 📋 Quick-Reference: Wo finde ich was?

### Ich möchte ...

**... die App starten**: [[haushalts-app]] → Setup-Sektion

**... verstehen, wie Auth funktioniert**: [[haushalts-app]] → Auth-Flow

**... Firestore-Rules debuggen**: [[nestbau-tech]] → Security Rules Vereinigung

**... Email-Versand reparieren**: [[nestbau-tech]] → Email-Verifikation ist manuell

**... Rezept-Import deployen**: [[nestbau-tech]] → Deploy-Checkliste

**... Bugs nachvollziehen**: [[nestbau-testing]] → Bugs gefunden & gefixt

**... Performance optimieren**: [[nestbau-testing]] → Performance-Messungen

**... Security-Tests sehen**: [[nestbau-testing]] → Security Rules 17 Test Cases

---

## 📦 Nachtrag: Build, Test & Play Store (2026-09-03) [stated]

**Quelle:** Build-Optimizer-Session, Branch `release/play-store`, Commit `7b01fe1`.

### Wichtigster neuer Fakt: das Repo hat zwei divergierte Stände

| | `main` (`738eebd`) | `release/play-store` (`7b01fe1`) |
|---|---|---|
| Firebase, OAuth, Kalender-Sync | ✅ | ❌ |
| Test-Suite, CI/CD, Store-Assets | ❌ | ✅ |

Gemeinsame Basis `38d84e8`; `main` +5 Commits, `release/play-store` +1.
**Die 43 Tests prüfen die Fassung ohne Firebase.**
Details: [[haushalts-app]] → Branch-Divergenz.

### Critical Fixes aus dieser Session

**4. assetlinks.json nur in der Domain-Wurzel** [ERROR-CRITICAL]
Android sucht die Datei nie im Projektpfad. Bei GitHub Pages in einem
Unterverzeichnis nicht ablegbar — eigene Domain oder Repo `<user>.github.io`.
*Impact:* AAB installiert, App zeigt aber die Adressleiste.

**5. Play App Signing ändert den Fingerprint** [ERROR-CRITICAL]
Google signiert die Auslieferung mit eigenem Schlüssel. In `assetlinks.json`
gehört der Fingerprint aus der Play Console, nicht nur der lokale Upload-Key.

**6. Node-Glob nur mit `shell:false`** [ERROR]
`execFile(node, ["--test", "tests/**/*.test.mjs"], {shell:true})` findet
0 Tests und meldet Exit-Code 0 — ein Erfolg, der keiner ist.

### Wo finde ich …

**... den Play-Store-Weg**: [[nestbau-tech]] → PWA, Play Store & Build
**... die lokale Test-Suite**: [[nestbau-testing]] → Lokale Test-Suite
**... offene Store-Blocker**: [[haushalts-app]] → Play-Store-Status

### Offene Punkte aus dieser Session

- [ ] **GitHub Pages aktivieren** (Mensch) — blockiert den TWA-Build
- [ ] **Signaturschlüssel anlegen** (Mensch) — blockiert den TWA-Build
- [ ] Attribut-Injection bei Foto-Data-URLs (5 Stellen, `escapeHtml()` existiert)
- [ ] Datenschutzerklärung als Seite (Play verlangt eine URL)
- [ ] Entscheiden, welche Fassung in den Store geht

---

## 🗂️ Struktur

```
PROJEKTE/Nestbau/Knowledge/
├── NESTBAU-KNOWLEDGE-INDEX.md   ← Dieses Dokument (Navigation)
├── haushalts-app.md             ← Feature-Übersicht & Architektur
├── nestbau-tech.md              ← Technische Details & Best Practices
├── nestbau-testing.md           ← Tests, Bugs, Performance
└── nestbau-quickref.md          ← Cheat-Sheet (Deploy, Error-Codes, Checklisten)
```

---

---

## 🏗️ Firebase Architect Phase 1 (2026-09-04) [stated – NEUE PHASE]

**Session:** Design + Documentation der Firestore-Architektur für v2.0  
**Output:** FIREBASE-ARCHITECTURE.md, DEPLOYMENT.md, IMPLEMENTATION-STATUS.md, DEV-QUICKSTART.md, firestore.indexes.json, functions/

**Kernerkenntnisse:**

1. **9 Collections under households/{hid}** ← Haushalt-zentrisch für Security
2. **Real-time Sync via Listeners** ← Bestehendes nb-firebase.js ~85% komplett
3. **Security via isMember()** ← Keine Enumeration, Join-Codes für Zugang
4. **Image Handling via Content-Hash** ← Base64 → Storage URLs, Dedup
5. **Performance via Composite Indexes** ← 8 vorkonfiguriert in firestore.indexes.json
6. **Migration Framework Complete** ← Backup + Batch-Upload + Verify

**Nächster Step: Phase 2 Testing** (~7h)
- Task 1: Lokal Emulator (2-3h)
- Task 2: Firebase Emulator Sync (1-2h)
- Task 3: Two-Device Sync (1-2h)
- Task 4: Offline Mode (30 min)
- Task 5: Error Scenarios (1-2h)

**Status**: Phase 1 ✅ COMPLETE. Phase 2 ready to start. All deliverables committed to Repo (Commits 8f4994b, 5a8aff9, f132a73, 6624822).

---

**Status**: [stated: 2026-09-04] – Firebase Architect Phase 1 DONE + Bot 1–4 Implementierung + Build-/Play-Store-Session

**Nächste Schritte**:
- [ ] Phase 2 Testing starten (Emulator + Two-Device Sync)
- [ ] Load-Test mit Produktivdaten
- [ ] Multi-Device Konflikt-Lösung implementieren
- [ ] E2E-Tests (Cypress) schreiben
- [ ] Performance-Monitoring aufsetzen (Sentry)
