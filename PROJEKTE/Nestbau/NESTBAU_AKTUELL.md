# Nestbau – App-Übersicht & Status

## 📸 Schnellübersicht
**Nestbau** ist eine Household-Management-App für 2 Personen (Indra + Partnerin).
- **Plattform**: Web-App (Android-Installation möglich)
- **Hauptfeatures**: Aufgaben, Kalender, Finanzen/Abos, Kochbuch
- **Status**: Produktiv (letzte Änderung: 28.08.2026)
- **Links**: siehe [[ARTIFACT_LINKS]]

## ✅ Fertige Features

### Aufgaben-Tab
- 5 Standardlisten (Aufgaben, Einkäufe, Geschenke, Haushalt, Arbeit)
- Benutzerdefinierte Listen erstellbar
- Filter: Für mich / Alle / Partnerin / Gemeinsam
- Pro Aufgabe: Fälligkeitsdatum, Uhrzeit, Wiederholung, Erinnerung, Ziel-Liste
- Wiederkehrende Tasks legen automatisch Folgetermine an
- Scrollbare Wochenübersicht (Mo–So nach Datum sortiert)
- Erledigte Aufgaben verschwinden automatisch

### Kalender-Tab
- Wochenansicht als Standard (umschaltbar auf Monat)
- Analoge SBB-Uhr für Start-/Endzeit-Wahl
- Kategorien: Schule, Arbeit, Haushalt, Privat (Sichtbarkeit je Person wählbar)
- To-Dos pro Termin mit automatischem Fälligkeitsdatum
- Wiederholungen: täglich/wöchentlich/monatlich
- Wochenansicht in Monatsansicht per Drag aufklappbar

### Finanzen-Tab (Abos & Ausgaben)
- Abo-Kategorien: Abos, Haushalt, Urlaub, Versicherungen, Lebensmittel (je mit Farbe)
- Zahlungsintervalle: Monatlich, Vierteljährlich, Halbjährlich, Jährlich
- Jahresübersicht mit Ø-Berechnung pro Monat
- Segmentierter Balkendiagramm je Intervall
- Personenauswahl: Meine, Partnerin, Gemeinsam

### Kochbuch-Tab
**Unterreiter: Zutaten**
- Zutaten-Datenbank mit 12 Standard- + benutzerdefinierten Kategorien
- Pro Zutat: Nährwerte (pro 100g, anpassbar), optional Vitamine/Aminosäuren/Allergene
- Kamerafunktion: Foto uploaden/machen, als Kategoriebild automatisch übernommen
- Bearbeitungsmodus mit Löschen-Icon
- Mehrfachkategorien pro Zutat möglich

**Unterreiter: Rezepte**
- Rezept-Kachelraster mit Foto + Kalorienangabe
- Kategorien: Frühstück, Mittag-/Abendessen, Snack, Dessert, Getränk (+ benutzerdefiniert)
- Filter: Alle / ★ Favoriten / nach Kategorie / "Lange nicht mehr gekocht"
- Favoriten-Stern auf Kachel
- Neue Leseansicht: Antippen der Kachel zeigt Rezept (Foto, Zeit, Portionen, Zutaten, Schritte)
- Pro Rezept: Vorbereitung (Schritte) + Zubereitung (nummerierte Schritte), Utensilien als Tags
- Nährwerte automatisch aus verknüpften Zutaten berechnet

**Unterreiter: Menüplan**
- Wochen-/Monatsansicht (wie Kalender)
- 4 Slots pro Tag: Frühstück / Mittagessen / Abendessen / Snacks
- Mengen-Stepper pro Eintrag (Makros skalieren automatisch)
- Snacks: freier Text (z. B. "Apfel 100g") mit automatischer Zutat-Auswahl
- "+"-Overlay zum Hinzufügen (Slot wählen → Rezept-Kategorie → Rezept)
- Schnell-Kopie Mittagessen → Abendessen (selber Tag)
- Verschieben-Icon prominent + Foto-Thumbnails
- Saisonale Priorisierung bei Rezept-Vorschlägen
- "Heute auf Speiseplan" zeigt Frühstück/Mittag/Abend/Snacks mit Kalorien

**Unterreiter: Einkaufsliste** (aus Menüplan)
- Einkaufszettel-Icon im Menüplan (nicht eigener Tab)
- Analysiert Rezepte des ausgewählten Tages → trägt Zutaten in "Einkäufe"-Task-Liste ein
- 8 Warengruppen-Farben (Obst, Gemüse, Milchprodukte, Fleisch & Fisch, Trockenes, Gewürze, Tiefkühl, Non-Food)
- Zusammenführung gleicher Zutaten (Mengen addiert)
- Bestehende abgehakte Einträge bleiben bestehen

### Profile & Anmeldung
- 2 Profile: "Ich" (Indra) + "Partnerin" (benutzerdefinierter Name)
- Profil-Name, Farbe, Alter, Gewicht, Grösse, Fitnesslevel konfigurierbar
- Lokaler Login (Pro-Gerät)
- Zahnrad-Icon öffnet Profil-Wähler + Profil-Editor

## 🚀 Firestore-Integration (v2.0)

**Status: v2.0 – LIVE in GitHub** [stated: 2026-09-04]

### Was speichert Firestore jetzt
- ✅ **Aufgaben & Listen** (`lists` collection + nested `items`)
- ✅ **Events/Termine** (`events` collection)
- ✅ **Abos/Finanzen** (`subscriptions` collection)
- ✅ **Kochbuch** (Rezepte, Zutaten, Kategorien, Menüplan)
- ✅ **Bilder** in Firebase Storage (1 MB Limit pro Doc → externe Refs)

### Synchronisierung
- **Local → Cloud:** Migration via `migrate.run()` (mit Backup)
- **Cloud → Local:** `cloud.watch()` live-Snapshots + `cloud.pushChanges()` Updates
- **Offline:** Firestore Persistence Cache (Tab-übergreifend)

### Nicht in Firebase (lokal nur)
- OAuth Tokens (im `nb2:…` localStorage)
- Kalender-Sync-Marker (lokale Referenzstände)

### Fehler & Fixes [stated]
| Fehler | Ursache | Fix | Test |
|--------|--------|-----|------|
| Export überschrieb sich selbst | `run()` überschrieb alte `pushed`-State | `pushLocal()` frisch laden vor Überschreiben | ✅ Import → Update → Export |
| Zweites Gerät löschte Cloud-Daten | Leerer Haushalt beim Beitritt → Snapshot überschrieb Kochbuch | `watch()` prüft Migration-Marker vor Apply | ✅ Device2 liest, überschreibt nicht |
| Service Worker cachte JSON als HTML | SW cachte alle GETs → Sync bekam HTML statt JSON | SW nur eigene Routes, Callback nie | ✅ Netzwerk-Tab sauber |

## 🐛 Bekannte Issues / Offene Punkte

| Issue | Status | Notiz |
|-------|--------|-------|
| Google Kalender | ✅ Live | OAuth + PKCE, inkrementelle Sync via syncToken |
| Outlook Kalender | ✅ Live | Microsoft Graph, PKCE gegen Entra ID |
| Firebase-Kochbuch | ✅ Live | Mit Haushalt + Beitrittscode |
| Tasks in Subsammlung | ⏳ Optimization | Aktuell: Lists mit nested items[] (funktioniert, nicht optimal) |
| Offline-Edits | ⏳ Future | Conflict-Resolution für parallele Änderungen |

## 🔮 Nächste Schritte
- [ ] Client-IDs in `nb-config.local.js` eintragen
- [ ] `firebase deploy --only firestore:rules,storage`
- [ ] Tasks zu Subsammlung refaktorieren (perf)
- [ ] Conflict-Resolution testen (2+ Geräte sync)

## 📚 Knowledge Base – Firebase Phase 1

Seit 04.09.2026 zentrale **Knowledge-Sammlung** mit Erkenntnissen aus allen 4 Bots:

- **[[NESTBAU-KNOWLEDGE-INDEX]]** – Start hier! Navigation zu allen Docs, Critical Fixes, Best Practices
- **[[nestbau-tech]]** – Firebase Rules, Security Patterns, Email-Versand, OAuth, Custom Claims
- **[[nestbau-testing]]** – 17 Security-Tests (✅ bestanden), Bugs & Fixes (Bot 1–4), Performance-Messungen
- **[[Learnings]]** – Alle Feature-Änderungen seit August 2026

## 📞 Support-Links
- Aktuelle Artifact: siehe [[ARTIFACT_LINKS]] > Aktuell
- Alte Versionen: siehe [[ARTIFACT_LINKS]] > Archiv
- Knowledge Base: siehe [[NESTBAU-KNOWLEDGE-INDEX]]

---
*Zuletzt aktualisiert: 04.09.2026*  
**Phase 1**: Firebase Auth + Firestore ✅ Abgeschlossen  
**Phase 2**: Vollständige Daten-Migration (geplant)
