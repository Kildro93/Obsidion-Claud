# Primarlehrer-Module: OneNote-Inhalte

Hier werden automatisch deine OneNote-Module eingepflegt via `onenote-sync.ps1`.

## Struktur

```
modules/
├── modul-001-biologie/
│   ├── README.md (auto-gen: Modul-Übersicht)
│   ├── notizen/     (OneNote-Inhalte)
│   ├── zusammenfassung.md
│   ├── pruefungsfragen.md (für Chat)
│   └── index.md (Topic-Index)
│
├── modul-002-chemie/
│   └── ...
│
└── index.md (Master-Index: alle Module)
```

## Auto-Generierung

Nach jedem OneNote-Import:
1. `onenote-sync.ps1` liest Dateien aus STUDIUM/import/
2. Normalisiert Ordnernamen zu `modul-XXX-name/`
3. Erstellt Templates: `zusammenfassung.md`, `lernkarten.md`, `pruefungsfragen.md`, `zeitplan.md`
4. Chat kann dann automatisch Prüfungen generieren

## Für Chat "Prüfung Studium"

Der Chat liest:
- Alle `modul-XXX-*/` Ordner
- Filtert nach Kapitel, Semester, Bereich
- Nutzt `pruefungsfragen.md` als Basis für Frage-Generierung
- Erstellt neue Prüfungen basierend auf Inhalten

## Manuell hinzufügen?

Wenn du ein Modul außer OneNote hinzufügen möchtest:
1. Ordner `modul-NNN-name/` erstellen
2. `notizen/` Ordner + Inhalte
3. `pruefungsfragen.md` mit potentiellen Fragen
4. Chat aktualisiert automatisch seinen Index
