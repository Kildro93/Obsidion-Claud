# Nestbau v2.0 – Quick-Reference

*Cheat-Sheet für Entwicklung & Wartung. Navigation: [[NESTBAU-KNOWLEDGE-INDEX]].*

**Stand:** 2026-09-04 [stated]

## Struktur

```
PROJEKTE/Nestbau/
├── NESTBAU_AKTUELL.md              ← Feature-Übersicht + Status
├── PROJEKT-UPDATE / -LOOP / -LEARNINGS / -ACCESS
├── Learnings.md                    ← Feature-Changelog
├── Knowledge/
│   ├── NESTBAU-KNOWLEDGE-INDEX.md  ← Navigation
│   ├── nestbau-quickref.md         ← Dieses Dokument
│   ├── haushalts-app.md            ← Produkt-Übersicht
│   ├── nestbau-tech.md             ← Technische Architektur
│   └── nestbau-testing.md          ← Test-Erkenntnisse & Bugs
├── Chat-Exports/                   ← Session-Archive
└── Fact-Sheets/                    ← konsolidierte Referenzen
```

## 🎯 Wann welches Dokument lesen?

| Frage | Datei | Inhalt |
|-------|-------|--------|
| "Was hat Nestbau gerade?" | NESTBAU_AKTUELL.md | Features, bekannte Issues, Roadmap |
| "Wie funktioniert v2?" | nestbau-tech.md | Module, Firestore-Flow, Best Practices |
| "Welche Fehler gab es?" | nestbau-testing.md | Bugs + Fixes, Test-Coverage |
| "Wer arbeitet daran?" | haushalts-app.md | Produkt-Kontext, Team, Links |

## 🚀 Schnell-Referenz: v2.0

### Dateien im Projekt
```
index.html                          ← Haupt-App (3018 Zeilen)
js/
  ├── nb-core.js                   ← Error-Codes, Retry, HTTP
  ├── nb-oauth.js                  ← Google + Microsoft PKCE
  ├── nb-firebase.js               ← Firestore-Collections
  ├── nb-{google,outlook}-cal.js   ← Kalender-APIs
  ├── nb-calendar-sync.js          ← Abgleich-Logik
  ├── nb-migrate.js                ← Migration & Gegenlesen
  ├── nb-integrations-ui.js        ← Buttons im Menü
  ├── nb-config.js                 ← Config-Struktur
  └── nb-config.local.js           ← **NOT IN REPO** (Client-IDs)
oauth-callback.html                ← OAuth Redirect
firestore.rules, storage.rules     ← Sicherheitsregeln
docs/INTEGRATIONEN.md              ← Setup-Guide
```

### Core-Flow
```
localStorage          Firebase
      ↓                  ↓
   State (App)  ←  cloud.watch() [Snapshots]
      ↑              ↓
   persist() ──→  cloud.pushChanges() [Hash-Diff]
```

### Fehlerklassifikation
```
CODES: {
  AUTH_REQUIRED,        // Nicht angemeldet
  NOT_CONFIGURED,       // Kein Firebase/Client-IDs
  NETWORK,              // Kein Internet
  PERMISSION,           // Firestore-Regeln verbieten
  QUOTA,                // Doc >900KB
  NOT_FOUND,            // 404 / Code ungültig
  ABORTED,              // Benutzer abgebrochen
  UNKNOWN,              // Andere Fehler
  ...
}
```

## 🧪 Testing Checklist

**Before Deploy:**
- [ ] Local: `index.html` lauffähig
- [ ] Firebase: `nb-config.local.js` Dummy-Werte ok
- [ ] Kalender: Google/Outlook Sandbox-Zugänge
- [ ] Migration: `migrate.plan()` + `migrate.run()`
- [ ] Snapshots: `cloud.watch()` lauscht
- [ ] Errors: `cloud.pushChanges()` bei Änderung

**Neue Features:**
- [ ] Test mit localStorage (fallback)
- [ ] Test mit Firebase (full)
- [ ] Error-Fall programmiert
- [ ] Docs aktualisiert

## 🔐 Security Checklist

- [ ] Client-IDs nie in Repository
- [ ] PKCE-Verifier zufällig (43–128 chars)
- [ ] Firestore-Regeln: Nur Mitglieder
- [ ] Tokens: `nb2:` Prefix, nicht in Backup
- [ ] Firebase: `schemaVersion` prüfen

## 🚀 Deploy-Schritte

```bash
# 1. Config
cp js/nb-config.local.example.js js/nb-config.local.js
# → Client-IDs eintragen

# 2. Regeln
firebase deploy --only firestore:rules,storage

# 3. GitHub
git add . && git commit -m "..." && git push

# 4. Verify
python -m http.server 8000
# → http://localhost:8000
```

## 🎓 Best Practices (aus v2.0)

1. **Vanilla JS** – Kein Build-Schritt, CDN-Module ok
2. **Bilder extern** – Storage (nicht Firestore), base64 → Hash
3. **Hash-Diffs** – Nur geänderte Docs synchen
4. **Idempotent** – Fehler-Retry funktioniert
5. **Error-Codes** – 14 Kategorien, klare Nachricht pro Code
6. **PKCE** – Nie Client-Secret im Frontend
7. **Backup-First** – Migration sichert immer vor Upload

## 📞 Links

- **GitHub:** https://github.com/Kildro93/Nestbau
- **Firebase Console:** [Projekt-ID hier eintragen]
- **Google Cloud Console:** [OAuth-Projekt hier eintragen]
- **Microsoft Entra:** [Tenant-ID hier eintragen]

## 🔗 Obsidian Links

- [[NESTBAU_AKTUELL]] – App-Features
- [[haushalts-app]] – Produkt-Kontext
- [[nestbau-tech]] – Architektur
- [[nestbau-testing]] – Testing & Bugs

---

**Zuletzt aktualisiert:** 2026-09-04 [stated]

**Nächster Review:** Nach nächstem Major-Feature oder Q4 2026
