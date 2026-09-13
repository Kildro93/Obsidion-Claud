# Checklisten & To-Dos: Grobstruktur

**Diese Struktur wird von dir später konfiguriert.**

Chat "Prüfung Studium" kann automatisch To-Dos hier eintragen, z.B.:
- "Kapitel 3 schwach (65%) — 3x diese Woche wiederholen"
- "Englisch A2-L6: Vokabeln flashcard-lernen"

## Grobstruktur

```
checklists/
├── README.md (diese Datei)
├── schwerpunkte-heute.md        # Tagesaufgaben (vom Chat auto-gen)
├── schwerpunkte-diese-woche.md  # Wochenplanung
├── schwerpunkte-semester.md     # Semester-Planung
│
├── modul-fortschritt.md         # Pro Modul: zu-machende Aufgaben
├── englisch-aufgaben.md         # Englisch-Aufgaben
├── srs-today.md                 # SRS-Sitzungen heute
│
└── archive/                     # Abgeschlossene Aufgaben
    └── abgeschlossen-2026-09-13.md
```

## Obsidian-Integration

Nach Setup kannst du ein **Obsidian Checklist-Plugin** oder **Dataview-Plugin** verwenden um:
- Automatisch offene Tasks anzeigen
- Mit Checkboxes abarbeiten
- Automatisch zu `archive/` verschieben wenn done

## Chat-Auto-Update

"Prüfung Studium" schreibt z.B.:

```markdown
# Schwerpunkte: 2026-09-14

- [ ] Photosynthese: 3 Prüfungs-Sets (SRS-Wiederholung)
- [ ] Englisch A2-L3: Vokabeln + 5 Grammatik-Fragen
- [ ] Mathematik Ch5: Diese Woche mindestens 2x üben (schwach: 68%)
```

## Setup-Anleitung (später)

1. Obsidian-Plugin installieren: "Checklist" oder "Tasks"
2. `checklists/schwerpunkte-heute.md` als Daily-Note pinnen
3. Pro Task: `- [ ] ...` Checkbox-Format
4. Nach Completion: `- [x] ...` (Chat erkennt das und archiviert)
