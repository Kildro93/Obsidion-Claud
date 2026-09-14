# Aufgaben-Struktur für Chat "Prüfung Studium"

Der Chat findet seine Arbeits-Inhalte in:

```
STUDIUM/primarlehrer/
├── modules/              # OneNote-Inhalte (Prüfungs-Quellen)
├── englisch/             # Englisch-Lektionen & Aufgaben
├── performance/          # Tracking-Dateien (progress.json, scores.json, srs-schedule.json)
├── srs-schedule.md       # Aktuelle SRS-Planung
├── modules/README.md     # Modul-Übersicht
└── englisch/struktur.md  # CEFR-Lernpfad
```

## Chat-Initialisierung

Der Prompt liest:
1. `STUDIUM/primarlehrer/modules/` → Listét verfügbare Prüfungs-Bereiche
2. `STUDIUM/primarlehrer/englisch/` → Englisch-Kapitel & -Level
3. `STUDIUM/primarlehrer/performance/progress.json` → Beherrschte vs. schwache Kapitel
4. `STUDIUM/primarlehrer/performance/srs-schedule.json` → Nächste Review-Termine

## Beispiel-Kommandos im Chat

```
"Erstelle mir eine Prüfung aus Biologie Kapitel 3"
"Gib mir Englisch A1-Lektionen zu Grundgrammatik"
"Wie sieht mein Progress aus?"
"SRS: Zeige mir die Lernziele für heute"
"Prüfungs-Export: PDF für Kapitel 1-5"
```

## Updates durch Chat

Der Chat schreibt zurück nach:
- `STUDIUM/primarlehrer/performance/progress.json` (Fortschritt)
- `STUDIUM/primarlehrer/performance/srs-schedule.json` (nächste Sessions)
- `STUDIUM/primarlehrer/performance/scores.csv` (Prüfungs-Ergebnisse)
