# Nestbau – Features & Anforderungen

Konsolidiert aus [[haushalts-app]], Play-Store-Listing und den Bot-Prompts. Chronologie: [[Learnings]].

## Produktziel

Alles, was ein Zweipersonenhaushalt täglich braucht, in einer App auf dem Gerät – ohne Konto, ohne Werbung, offline lauffähig. Cloud-Sync und Kalender-Abgleich sind optional zuschaltbar.

## Kern-Features (implementiert)

### Heute
- Tagesüberblick: anstehende Aufgaben, wer dran ist, Speiseplan mit Kalorien

### Aufgaben & Listen
- 5 Standardlisten (Aufgaben, Einkäufe, Geschenke, Haushalt, Arbeit) + eigene
- Pro Aufgabe: Fälligkeit, Uhrzeit, Wiederholung, Erinnerung, Ziel-Liste
- Filter: Für mich / Alle / Partnerin / Gemeinsam
- Wiederkehrende Tasks legen Folgetermine automatisch an
- Scrollbare Wochenübersicht, erledigte Aufgaben verschwinden

### Kalender
- Wochen-/Monatsansicht, analoge SBB-Uhr für Zeitwahl
- Kategorien: Schule, Arbeit, Haushalt, Privat, Wichtig (Sichtbarkeit je Person)
- To-Dos pro Termin mit automatischem Fälligkeitsdatum, landen in kategoriepassender Liste
- Wiederholungen täglich/wöchentlich/monatlich
- Optionaler Sync mit Google Calendar und Outlook (bidirektional, PKCE)

### Finanzen (Abos & Fixkosten)
- Kategorien: Abos, Haushalt, Urlaub, Versicherungen, Lebensmittel (je Farbe)
- Intervalle: monatlich, vierteljährlich, halbjährlich, jährlich
- Jahresübersicht mit Ø/Monat, segmentiertes Balkendiagramm je Intervall
- Personen: Meine / Partnerin / Gemeinsam
- Beträge in CHF (Rundung auf 5 Rappen)

### Kochbuch
- **Zutaten:** Datenbank mit 12+ Kategorien, Nährwerte pro Basisgewicht, optional Vitamine/Aminosäuren/Allergene (10 feste Allergene), Kamerafoto als Kategoriebild
- **Rezepte:** Kachelraster, Kategorien, Filter (Favoriten, Kategorie, „Lange nicht gekocht"), Zutaten-Suche, Leseansicht, Vorbereitung + Zubereitung getrennt, Utensilien-Tags, Nährwerte automatisch aus Zutaten
- **Menüplan:** Wochen-/Monatsansicht, 4 Slots/Tag, Mengen-Stepper (Makros skalieren), Snacks als Freitext, saisonale Priorisierung der Vorschläge
- **Einkaufsliste:** Icon im Menüplan analysiert Rezepte des Tages → trägt Zutaten in „Einkäufe"-Liste, 8 Warengruppen-Farben, gleiche Zutaten werden zusammengeführt

### Profile & Daten
- 2 lokale Profile (Ich / Partnerin), Name, Farbe, Alter, Gewicht, Grösse, Fitnesslevel
- Lokaler Login pro Gerät
- Sicherung/Wiederherstellung als JSON-Datei

### v2.0 – Cloud (optional)
- Firebase Auth (Google Sign-In; Email/Password im Auth-Bundle)
- Firestore-Sync für Aufgaben, Events, Finanzen, Kochbuch
- Haushalt teilen via Beitrittscode
- Offline-Cache (Firestore Persistence, Tab-übergreifend)
- Migration localStorage → Firestore mit Backup + Verify
- Rezept-Import: Browser-Extension + KI-Parser (Claude Opus 5) → Firestore

## Geplant / offen

- [ ] Tasks als Firestore-Subsammlung (Perf, aktuell nested items[])
- [ ] Multi-Device-Konflikt-Resolution (aktuell last-write-wins)
- [ ] Invite-Emails über Cloud Functions
- [ ] Push Notifications
- [ ] Nährwert-API, intelligente Menüplan-Vorschläge, Budget-Alerts
- [ ] Play-Store-Release (Blocker: GitHub Pages + Signaturschlüssel)

## Priorität

- **Hoch:** Firebase Phase 2 Testing, GitHub-Push der lokalen Änderungen
- **Mittel:** Tasks-Subsammlung, Branch-Konsolidierung, Play-Store-Entscheidung
- **Niedrig:** 2027-Roadmap (APIs, Sharing)

## Akzeptanz-Kriterien (übergreifend)

- App startet und arbeitet vollständig offline
- Ohne Firebase-Config: kein Fehler, alles lokal
- Keine Client-Secrets im Frontend
- Firestore-Regeln: nur Haushaltsmitglieder
- Zeitbudget-Realität: < 2h/Woche Entwicklung
