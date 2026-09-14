# SRS-Algorithmus: Spaced Repetition (SM-2)

## Grundprinzip

Optimale Wiederholung = Vergessenskurve + adaptive Planung

## SM-2 Formel

```
EF' = EF + (0.1 - (5 - q) * 0.08)

Dabei:
- EF = Leicht-Faktor (startet bei 2.5)
- q = Qualität der Antwort (0-5)
- EF' = neuer Leicht-Faktor
```

## Qualitäts-Scores (q)

| q | Bedeutung |
|---|-----------|
| 5 | Perfekt beantwortet, schnell |
| 4 | Richtig, aber zögernd |
| 3 | Richtig, aber große Anstrengung |
| 2 | Falsch, aber Ansatz erkannt |
| 1 | Falsch, komplett daneben |
| 0 | Nicht beantwortet |

## Interval-Berechnung

```
Interval = Vorheriger Interval × EF

Erste 3 Wiederholungen:
1. Nächster Tag
2. 3 Tage später
3. 7 Tage später

Dann: EF × 7 Tage
```

## Implementation

**Zusätzliche Regeln:**
- Falsch (q ≤ 2) → zurück auf 1-Tage-Interval
- Nicht beantwortet → gleich als falsch behandelt
- Beherrscht (q = 5, 10+ Mal): Interval auf 30 Tage setzen
- Zu schwach (q < 3, häufig) → 1-Woche-Review erzwingen

## Performance-Anpassung

**Wenn Genauigkeit < 70% im Kapitel:**
- SRS-Interval verkürzen (÷ 2)
- Schwerpunkt-Flag setzen
- Häufiger abfragen

**Wenn Genauigkeit > 85%:**
- Interval verlängern (× 1.2)
- Weniger häufig abfragen
- Optional: Zu Fortgeschritten-Level

## Daten-Struktur

```json
{
  "kapitel-xy": {
    "topic": "Kapitel 3: Photosynthese",
    "ef": 2.8,
    "interval_days": 7,
    "last_reviewed": "2026-09-13",
    "next_review": "2026-09-20",
    "repetitions": 5,
    "accuracy": 0.82,
    "quality_scores": [5, 4, 5, 3, 4],
    "schwerpunkt": false
  }
}
```
