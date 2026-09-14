# Prüfung Studium: Features-Übersicht

## 1. Prüfungs-Generierung

**Quelle:** OneNote-Module (`STUDIUM/primarlehrer/modules/`)

**Modi:**
- Nach Bereich/Kapitel filtern
- Nach Semester gruppieren
- Mixmode: Random-Mix aus mehreren Kapiteln

**Formate:**
- Multiple Choice (generiert aus Inhalten)
- Frei-Text-Fragen (mit Lösung)
- Matching/Zuordnung
- Lückentext

---

## 2. Spaced Repetition (SRS)

**Algorithmus:** SM-2 (Supermemo 2) mit Anpassung

**Logik:**
- Fragen, die falsch beantwortet → nächste Woche wiederholen
- Richtig & schnell → in 2-4 Wochen
- Richtig & langsam → in 1 Woche
- Beherrscht (10+ korrekt) → nur 1x im Monat

**Schedule:** `STUDIUM/primarlehrer/performance/srs-schedule.json`

---

## 3. Performance-Tracking

**Gemessen:**
- Genauigkeit pro Kapitel (%)
- Antwort-Zeit pro Frage
- Trend (wie hat sich die Genauigkeit entwickelt?)
- Schwache Punkte (Chapters < 70% → Flagging)

**Daten:** `STUDIUM/primarlehrer/performance/scores.csv`

**Visualisierung:** Trend-Grafik im Chat (7-Tage, 30-Tage, Semester-View)

---

## 4. Multi-Level-Fragen (Adaptive Difficulty)

**Levels:**
- **Basis:** Definitionen, direkte Inhalte (A1)
- **Mittel:** Zusammenhänge, Anwendung (B1)
- **Fortgeschritten:** Synthese, kritisches Denken (B2+)

**Anpassung:** Wenn du 3x Basis-Fragen richtig hast → Sprung zu Mittel

---

## 5. Englisch Grundgrammatik (CEFR A1→B1)

**Struktur:** Nach Lektionen organisiert (siehe `englisch-struktur.md`)

**Features:**
- Interaktive Lektionen (Erklärung + Übungen)
- Vokabular-Tracking
- Grammatik-Schwerpunkte basierend auf Schwächen

---

## 6. Prüfungs-Export

**Format:** PDF, druckbar

**Inhalt:**
- Fragen + Lösungsblatt
- Optional: Ohne Lösungen (für echte Prüfungs-Simulation)
- Mit/ohne Punktevergabe

---

## 7. Fortschritts-Memory

**Gespeichert pro Kapitel:**
- Letzter Zugriff
- Erfolgsquote
- Verbrauchte Zeit (Ø)
- Schwerpunkt-Flag (ja/nein)

**Update:** Nach jeder Prüfung automatisch
