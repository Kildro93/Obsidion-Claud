# Performance-Tracking: Daten-Speicherung

Chat "Prüfung Studium" liest und schreibt hier automatisch:

## Dateien

```
performance/
├── progress.json          # Kapitel-Status & Metriken
├── srs-schedule.json      # Spaced Repetition Planung
├── scores.csv             # Alle Prüfungs-Ergebnisse (Rohdata)
├── vocab-tracking.json    # Englisch-Vokabeln Progress
├── trends.json            # 7-Tage, 30-Tage Trends
└── README.md (diese Datei)
```

Siehe `PROJEKTE/Primarlehrer-Studium/docs/performance-tracking.md` für Schema-Details.

## Automatische Updates

Nach jeder Prüfung im Chat:
1. `progress.json` — Kapitel-Genauigkeit updatet
2. `scores.csv` — Neue Zeile hinzugefügt
3. `srs-schedule.json` — Nächste Review-Termine angepasst
4. `trends.json` — 7/30-Tage-Durchschnitte neu berechnet

## Daten für Obsidian Widgets

Diese Dateien können von Obsidian-Plugins gelesen werden für:
- **Calendar:** Welche Tage mit Tests
- **Checklisten:** Offene Aufgaben (schwache Kapitel)
- **Dashboard-Widget:** Fortschritt anzeigen

Siehe `checklists/` und `calendar/` für Setup-Anleitung.

## Manuell einsehen

- `progress.json` im Editor öffnen → aktuelle Status sehen
- `scores.csv` in Excel öffnen → alle Tests analysieren
- `srs-schedule.json` → nächste Lernziele
