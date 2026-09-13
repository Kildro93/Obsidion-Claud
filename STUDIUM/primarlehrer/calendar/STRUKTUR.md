# Kalender: Grobstruktur

**Diese Struktur wird von dir später konfiguriert.**

Chat "Prüfung Studium" kann automatisch Kalender-Einträge setzen für:
- Geplante Prüfungs-Sessions
- Kapitel-Deadlines (schwache Bereiche)
- Englisch-Lern-Blöcke

## Grobstruktur

```
calendar/
├── README.md (diese Datei)
├── exam-schedule.md             # Alle geplanten Prüfungen
├── review-sessions.md           # SRS-Sitzungen (Tag für Tag)
├── deadlines.md                 # Kapitel-Fertig-Termine
│
└── weekly-view.md               # Wochenübersicht
```

## Obsidian-Integration

Nach Setup kannst du **Obsidian Calendar Plugin** oder **Google Calendar Sync** verwenden um:
- Kalender-Einträge visualisieren
- Mit iCal/Google Calendar synchen
- Mobile Zugriff via Telefon

## Chat-Auto-Update

"Prüfung Studium" erstellt z.B.:

```markdown
# Prüfungs-Planung: September 2026

| Datum | Zeit | Kapitel | Schwierigkeit | Status |
|-------|------|---------|----------------|--------|
| 2026-09-14 | 14:00 | Photosynthese | Mittel | SRS |
| 2026-09-15 | 10:00 | Englisch A2 | Basis | Neu |
| 2026-09-20 | 16:00 | Organische Chemie | Fortgeschritten | Schwerpunkt |
```

## Setup-Anleitung (später)

1. Obsidian-Plugin: "Calendar" oder "Dataview"
2. Google Calendar: Sync via `calendar/exam-schedule.ics`
3. Täglich `review-sessions.md` checken für SRS-Aufgaben

## Mobile-Zugriff

Wenn Google Calendar sync:
- Smartphone-App zeigt deine Lernziele an
- Push-Notifications möglich ("Heute: Prüfung um 14:00")
