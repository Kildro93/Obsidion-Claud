# Nestbau – Datenbank-Schema (Firestore)

Maßgeblich implementiert (nicht der frühere BOT_2-Entwurf mit `users/{uid}/profile`). Details: [[Firebase-Architektur]], [[nestbau-tech]], `Nestbau/FIREBASE-ARCHITECTURE.md`.

## Haushalt-zentrisch

```
households/{hid}
├── (Doc-Felder)           name, description, members{uid:{role}}, memberUids[]
├── members/{uid}          geteilte Mitglieder-Karte (Mirror aus profiles/)
├── ingredients/{id}
├── recipes/{id}           Bild-URLs (Storage), nicht Base64
├── ingredientCategories/{id}
├── ingredientGroups/{id}
├── dishCategories/{id}
├── menuPlan/{YYYY-MM-DD}  ein Dokument pro Tag
├── events/{id}
├── subscriptions/{id}
├── lists/{id}             Aufgaben mit nested items[] (skaliert bis ~100)
└── meta/migration         Migration-Marker

profiles/{uid}             strikt privat: Name, Farbe, Alter, Größe, Gewicht, Fitness, Allergien
users/{uid}                nur eigener User: Email, Status, householdIds[], aktiver Haushalt
invites/{id}               Eingeladene + Absender: Haushalt, Email, Rolle, Token-Hash, Ablauf (7 Tage)
joinCodes/{CODE}           Lookup-Tabelle für Beitritt (8 Zeichen, URL-safe)
mail/{id}                  Server-only: Ausgangs-Queue der Email-Extension
clipperTokens/{id}         SHA-256-Hash, nie Klartext (Rezept-Import)
recipeImports/{id}         status-basiert sichtbar bis "committed", dann gelöscht
```

## Regeln (Kurz)

- Alle Haushalts-Collections: nur Mitglieder (`request.auth.uid in household(hid).memberUids`), lesen + schreiben
- **Keine Catch-all-Rule** (würde spezifische Rules per OR-Vereinigung aufheben)
- **Keine `list()`-Operationen** – nur gezielter get/query
- `profiles/{uid}`: nur eigener User
- Storage: `households/{hid}/images/{hash}.{ext}`, max 10 MB, Base64 in Docs blockiert
- Composite Indexes: 8 Stück in `firestore.indexes.json` (u.a. `arrayContains` + `orderBy`)

## Größen & Sync

- Max 1 MiB / Doc → Bilder externalisieren zu Storage, Content-Hash gegen Duplikate
- Batch bis 500 Ops, wird geteilt
- Change-Detection per JSON-Hash, `applyingRemote`-Flag gegen persist()-Loop
- Offline: `enablePersistence({ synchronizeTabs: true })`

## Einheiten-Umrechnung (App)

`UNIT_GRAMS = { g:1, kg:1000, ml:1, l:1000, stueck:100, el:15, tl:5, prise:1 }` – siehe [[kochbuch-naehrwert-berechnung]].
