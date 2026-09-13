---
title: ceo-auftrag-onenote-sync
created: 2026-09-13
updated: 2026-09-13
status: offen
tags: [typ/auftrag, status/offen]
autor: gehirn-feedback
ziel: gehirn-ceo
---

# CEO-Auftrag: OneNote-Sync-Script

## Kontext

Die OneNote-Imports für Semester 01 sind manuell umbenannt und eingegliedert (14 Module unter `STUDIUM/semester-01/fhnw-bach/module/`). Das soll künftig automatisch laufen, damit neue Semester-Importe sofort die Vault-Konvention einhalten.

## Auftrag

Erstelle ein PowerShell-Script `scripts/onenote-sync.ps1`, das:

1. **Import-Ordner scannt** — Quellpfad konfigurierbar (Default: `STUDIUM/import/`)
2. **Ordnernamen normalisiert** — OneNote-Format `(KÜRZEL) Langer Name` → `kürzel-langer-name` (kleingeschrieben, Bindestriche, Sonderzeichen entfernt)
3. **Modulbeschreibung.md umbenennt** → `modulbeschreibung.md`
4. **Modul-Templates anlegt** — pro Modul: `zusammenfassung.md`, `lernkarten.md`, `pruefungsfragen.md`, `zeitplan.md`, `notizen/`
5. **Zielstruktur respektiert** — verschiebt normalisierte Module nach `STUDIUM/semester-XX/fhnw-bach/module/gruppenordner/`
6. **Idempotent** ist — bereits existierende Dateien/Ordner überspringen, nie überschreiben
7. **Dry-Run-Modus** hat — `-WhatIf` Flag zeigt Änderungen ohne auszuführen

## Technische Regeln (aus feedback-log)

- **UTF-8 MIT BOM** für .ps1 (REGEL-FB07) — Umlaute als `$([char]0xFC)` etc. escapen
- **Resolve-Path** für alle .NET-Dateimethoden, nie relative Pfade
- **Windows-Rename**: Gross/Klein-Änderung über Temp-Namen (zwei Schritte)
- **ErrorActionPreference**: `Continue` statt `Stop` — Einzelfehler dürfen nicht den ganzen Lauf abbrechen
- **Logging**: Jede Aktion auf der Konsole ausgeben (OK/SKIP/FEHLER mit Farbcodes)

## Parameter

```powershell
param(
    [string]$ImportPfad = "STUDIUM\import",
    [string]$ZielSemester = "semester-01",
    [string]$ZielGruppe = "",          # z.B. "grundlagen-modul" — leer = direkt unter module/
    [switch]$WhatIf
)
```

## Lieferung

- Script: `scripts/onenote-sync.ps1`
- Git-Block: `git add`, `git commit`, `git push`, `drive-mirror.ps1`
- Kurzdoku im Script-Header (Zweck, Parameter, Beispielaufruf)

## Priorität

Mittel — kein Blocker, aber vor Semesterstart (15.09.2026) wäre ideal.
