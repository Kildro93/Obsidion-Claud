# Primarlehrer-Studium: Lernstruktur

Zentrale Koordination für Prüfungs-Vorbereitung, Englisch-Learning und Performance-Tracking.

## Struktur

- **modules/** — Inhalte aus OneNote (automatisch via onenote-sync)
- **englisch/** — CEFR A1→B1 Grundgrammatik mit Lektionen
- **performance/** — Tracking-Daten (Prüfungs-Ergebnisse, Progress-JSON)
- **checklists/** — Groß-Struktur für Obsidian Widgets (User-Setup)
- **calendar/** — Groß-Struktur für Obsidian Calendar (User-Setup)
- **srs-schedule.md** — Spaced Repetition Planung

## Integration

Der Chat "Prüfung Studium" liest automatisch:
- OneNote-Module aus `modules/`
- Englisch-Inhalte aus `englisch/`
- Tracking-Data aus `performance/`

Chat-Prompt: `PROJEKTE/Primarlehrer-Studium/prompts/pruefung-studium-prompt.md`
