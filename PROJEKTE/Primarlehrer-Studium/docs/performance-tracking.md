# Performance-Tracking Schema

## Gespeicherte Metriken

### Pro Kapitel (progress.json)

```json
{
  "kapitel-name": {
    "topic": "Biologie Kapitel 3: Photosynthese",
    "area": "biologie",
    "semester": "1",
    "status": "in-progress",        // in-progress | beherrscht | schwach | nicht-gestartet
    "accuracy_percent": 78.5,
    "attempts": 12,
    "correct": 9,
    "wrong": 3,
    "avg_time_seconds": 45.3,
    "first_attempt": "2026-09-05",
    "last_review": "2026-09-13",
    "next_srs_date": "2026-09-20",
    "schwerpunkt": true,            // flagged als schwach
    "level_current": "Mittel",      // Basis | Mittel | Fortgeschritten
    "level_unlocked": ["Basis", "Mittel"],
    "trend_7d": 5.2,                // %-Punkt-Änderung letzte 7 Tage
    "trend_30d": 12.1
  }
}
```

### Prüfungs-Ergebnisse (scores.csv)

```csv
date,kapitel,area,semester,fragen,korrekt,prozent,zeit_sekunden,level,srs_quality_score
2026-09-13,Photosynthese,biologie,1,10,8,80,45,Mittel,4
2026-09-12,Photosynthese,biologie,1,10,7,70,52,Basis,3
```

### SRS-Planung (srs-schedule.json)

```json
{
  "today_2026-09-13": [
    "Kapitel 1: Zellbiologie",
    "Englisch A1-L2: Present Simple",
    "Chemie Kapitel 2"
  ],
  "upcoming": {
    "2026-09-14": ["Geschichtszahlen"],
    "2026-09-15": ["Photosynthese"],
    "2026-09-20": ["Mathematik Kapitel 5"]
  },
  "overdue": []  // Sollte heute gelernt werden, aber überschritten
}
```

## Dashboard-Ansichten (im Chat)

### Kurz-Übersicht

```
┌─ FORTSCHRITT ──────────────────┐
│ Beherrscht:         6 Kapitel   │
│ In Bearbeitung:    12 Kapitel   │
│ Schwach (< 70%):    4 Kapitel   │
│ Noch nicht gestartet: 8 Kapitel │
│                                 │
│ Gesamtgenauigkeit: 75.3%        │
│ Letzter Test: vor 1 Tag         │
└─────────────────────────────────┘
```

### Trend (7/30 Tage)

```
Genauigkeit Trend:
┌────────────────────────────┐
│ 90% │      ╱╲
│ 80% │    ╱  ╲  ╱
│ 70% │  ╱    ╲╱   ← 75.3% heute
│ 60% │╱
└────────────────────────────┘
  Tag1  Tag3  Tag5  Tag7
```

### Schwerpunkt-Liste

```
Kapitel mit Verbesserungspotential (flagged):
1. Photosynthese (70%) — SRS: Morgen wiederholen
2. Englisch A2-L3 (65%) — Needs extra practice
3. Organische Chemie (68%) — Schwach in Ketonen
```

## Automatische Anpassungen

**Chat passt an, wenn:**

1. **Genauigkeit > 85% für 3+ Tage**
   - Interval × 1.2
   - Schwerpunkt entfernen
   - Level hochstufen

2. **Genauigkeit < 70%**
   - Interval ÷ 2
   - Schwerpunkt-Flag setzen
   - Level herunterstufen

3. **Nicht für 5+ Tage gelernt**
   - Markieren als "Überdue"
   - Im Chat als Priorität zeigen

## Export-Optionen

- **CSV:** Für Excel-Analyse
- **JSON:** Für Chat-Verarbeitung
- **PDF:** Fortschritts-Report (mit Grafiken)
