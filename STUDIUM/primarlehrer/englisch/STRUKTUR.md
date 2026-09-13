# Englisch Grundgrammatik: Struktur

Siehe `PROJEKTE/Primarlehrer-Studium/docs/englisch-struktur.md` für Lernpfad-Details.

## Dateien

```
englisch/
├── STRUKTUR.md (diese Datei)
├── A1/
│   ├── lektion-01-pronouns.md
│   ├── lektion-02-present.md
│   ├── lektion-03-negation.md
│   ├── lektion-04-vocab-100.md
│   └── lektion-05-articles.md
│
├── A2/
│   ├── lektion-06-past-simple.md
│   ├── lektion-07-irregular-verbs.md
│   ├── lektion-08-present-continuous.md
│   ├── lektion-09-modals.md
│   └── lektion-10-phrases.md
│
├── B1/
│   ├── lektion-11-present-perfect.md
│   ├── lektion-12-conditionals.md
│   ├── lektion-13-passive.md
│   ├── lektion-14-reported-speech.md
│   └── lektion-15-phrasal-verbs.md
│
├── vocab-tracking.json (Vokabeln-Progress)
└── quiz-scores.csv (Test-Ergebnisse)
```

## Chat-Integration

Chat "Prüfung Studium" liest:
- Alle Lektionen
- `vocab-tracking.json` (welche Vokabeln noch schwach)
- `quiz-scores.csv` (welche Lektionen beherrscht)

Kommando-Beispiele:
```
"Englisch A1, Lektion 2: Present Simple Prüfung"
"Vokabeln wiederholen: A1-A2 Level"
"Grammatik-Fehler-Analyse: Wo sind meine Schwächen?"
```

## Inhalts-Template (pro Lektion)

```markdown
# Lektion N: [Thema]

## Grammatik-Erklärung
[Kurze, klare Erklärung mit Regeln]

## Beispiele
[5-10 Beispiele aus realem Englisch]

## Häufige Fehler
[Typische Anfänger-Fehler]

## Vokabeln (Top 20)
[Wichtige Wörter für diese Lektion]

## Übungen
[5 Aufgaben mit Lösungen]
```

## Spaced Repetition für Englisch

- Beherrscht (85%+) → nur 1x im Monat
- In Bearbeitung (70-84%) → 1x die Woche
- Schwach (<70%) → 2-3x die Woche
