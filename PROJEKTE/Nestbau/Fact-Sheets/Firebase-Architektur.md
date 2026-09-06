# Fact-Sheet: Firebase-Architektur (Nestbau v2)

Konsolidierte Kurzfassung. Details: [[nestbau-tech]], [[NESTBAU-KNOWLEDGE-INDEX]].
**Stand:** Phase 1 abgeschlossen (2026-09-04), Phase 2 (Testing) offen.

## Datenmodell (Firestore)

```
households/{hid}
├── members/{uid}          öffentliche Mitglieder-Karte (Mirror aus profiles/)
├── ingredients/{id}
├── recipes/{id}           Bild-URLs (Storage), nicht Base64
├── ingredientCategories/{id}
├── ingredientGroups/{id}
├── dishCategories/{id}
├── menuPlan/{YYYY-MM-DD}   ein Dokument pro Tag
├── events/{id}
├── subscriptions/{id}
├── lists/{id}             Aufgaben mit nested items[] (skaliert bis ~100)
└── meta/migration          Migration-Marker

joinCodes/{CODE}            Lookup-Tabelle für sichere Beitritte (8 Zeichen, URL-safe)
profiles/{uid}              strikt privat (Alter/Gewicht/Allergien)
```

## Sync

- localStorage (schnell) ↔ Firestore (geteilt)
- Schreiben: State → persist() → cloud.pushChanges() (Hash-Diff, debounced 1200ms) → Firestore → Listener → render()
- Lesen: Firestore → onSnapshot-Listener → State → render()
- Offline: `enablePersistence({ synchronizeTabs: true })`
- `applyingRemote`-Flag verhindert persist()-Loop während Remote-Update

## Security

- Haushalt-zentrisch: alle Daten unter `households/{hid}`, nur Mitglieder lesen/schreiben (`isMember()`)
- Keine Catch-all-Rule (würde alle spezifischen Rules aufheben)
- Keine `list()`-Operationen – nur gezielter get/query
- Storage: `households/{hid}/images/{hash}.{ext}`, max 10 MB, Base64 in Docs blockiert
- Custom Claims cachen Rollen im Token (spart Reads), Limit ~1 KB / ~5 Haushalte

## Deploy-Reihenfolge (kritisch)

1. Rules (`firestore:rules`, `storage:rules`)
2. Indexes (`firestore:indexes`) – 8 Composite Indexes vorkonfiguriert
3. Functions
4. Hosting

## Schlüsseldateien im Repo

- `js/nb-firebase.js` – Cloud-Modul (~850 Zeilen, >80% fertig)
- `js/nb-migrate.js` – Backup + Batch-Upload + Verify
- `js/nb-config.js` / `nb-config.local.js` (nicht im Repo)
- `firestore.rules`, `storage.rules`, `firestore.indexes.json`
- `FIREBASE-ARCHITECTURE.md`, `DEPLOYMENT.md`, `IMPLEMENTATION-STATUS.md`, `DEV-QUICKSTART.md`

## Offen (Phase 2)

Emulator-Test, Two-Device-Sync, Offline-Validierung, Error-Szenarien, Multi-Device-Konflikt-Resolution (aktuell last-write-wins).
