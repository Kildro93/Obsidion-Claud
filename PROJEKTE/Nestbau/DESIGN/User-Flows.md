# Nestbau – User-Flows

## App-Navigation (v1, lokal)

```
Erststart → Profil-Dialog (modal, blockiert Tab-Leiste bis Profil gewählt)
   → Tab-Leiste unten: Heute | Aufgaben | Kalender | Finanzen | Kochbuch
   Zahnrad-Icon → Profil-Wähler + Profil-Editor + Daten (Sicherung) + Integrationen
```

Hinweis für Tests: bei leerem `localStorage` ist der Profil-Dialog modal – vor UI-Tests `nestbau-active-profile` setzen oder den Dialog durchlaufen.

## Aufgabe aus Termin

```
Kalender → Tag wählen → Termin öffnen/anlegen → To-Do hinzufügen (mit Kategorie)
   → Kategorie bestimmt Person + Ziel-Liste (Arbeit→Arbeit-Liste, Haushalt→Haushalt, sonst Aufgaben)
   → To-Do erscheint mit auto-Fälligkeitsdatum in Wochenübersicht
```

## Menüplan → Einkaufsliste

```
Kochbuch → Menüplan → Tag füllen (Slot wählen → Rezept-Kategorie → Rezept, Mengen-Stepper)
   → Einkaufszettel-Icon → analysiert Rezepte/Zutaten des Tages
   → gruppiert nach 8 Warengruppen → trägt als To-Dos in "Einkäufe"-Liste
   → gleiche Zutaten werden zusammengeführt, abgehakte bleiben
```

## v2 – Auth & Haushalt (Auth-Bundle)

```
Registrieren → Email bestätigen → Profil-Wizard (3 Schritte) → Haushalt → App
                                   1. Name / Farbe / Foto
                                   2. Alter / Größe / Gewicht / Fitness
                                   3. Allergien / Ernährung
```

- Controller routet bei jedem Auth-State-Wechsel neu, springt an die letzte Position im Wizard. Abbruch kostet nichts.
- Einladung: Link in Email `auth.html?invite=<id>&token=<token>` → Token nur gehasht gespeichert, nach Einlösen sofort aus der Adresszeile entfernt (`history.replaceState`).
- Mirror-Pattern: `profiles/{uid}` bleibt privat; Cloud Function kopiert Name/Farbe/Foto/Rolle nach `households/{hid}/members/{uid}`, Allergien nur bei Freigabe. Alter/Größe/Gewicht verlassen das private Profil nie.

## v2 – Migration localStorage → Firebase

```
Anmelden (Firebase) → Haushalt erstellen/beitreten → Zahnrad → Cloud → Hochladen
   → Backup anlegen → Bilder zu Storage → Listen/Events/Subscriptions/Kochbuch zu Firestore
   → Live-Sync startet → alle Geräte synchron
```

## v2 – Rezept-Import (Clipper)

```
Browser-Extension "Zu Nestbau speichern" → POST clipRecipe() (Bearer-Token)
   → status:"pending" Doc (Function antwortet sofort)
   → processRecipeImport (Trigger): JSON-LD-Parse → KI-Fallback → Zutaten-Abgleich → Bild (SSRF-safe)
   → status:"ready" → Import-Posteingang im Web-UI
   → Nutzer prüft/editiert → commitRecipeImport() → echtes Rezept, status:"committed"
```

HTTP-Codes Clipper: 202 ok · 400 leere Seite · 401 Token · 409 kein Haushalt · 413 Seite > 400 KB · 429 Rate-Limit
