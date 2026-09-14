---
title: nestbau-ceo-strukturbereinigung
created: 2026-09-13
updated: 2026-09-13
status: offen
tags: [typ/auftrag, status/offen]
autor: gehirn-admin
ziel: nestbau-ceo
---

# Auftrag: Nestbau-Projektordner bereinigen

Der Gehirn-Admin hat beim Vault-Cleanup festgestellt, dass `PROJEKTE/Nestbau/` interne Strukturprobleme hat. Diese sind Nestbau-CEO-Aufgabe, nicht Gehirn-Admin.

## Probleme

### 1. Ordner nicht in kebab-case (§7)

Folgende Ordner verstoßen gegen die Namenskonventionen:

| Ordner | Vorschlag |
|---|---|
| `CODE/` | `code/` |
| `DESIGN/` | `design/` |
| `Fact-Sheets/` | `fact-sheets/` |
| `Knowledge/` | `knowledge/` |
| `REQUIREMENTS/` | `requirements/` |
| `Chat-Exports/` | Aufloesen (siehe Punkt 2) |

### 2. Fazite in Chat-Exports/

`PROJEKTE/Nestbau/Chat-Exports/` enthaelt 2 Fazit-Dateien. Per §19 (Zuordnungsmatrix) gehoeren Fazite nach `FAZITE/nestbau/`. Verschieben und Ordner entfernen.

### 3. Learnings-Duplikate

Zwei Dateien mit ueberlapppendem Inhalt:
- `Learnings.md` (25.174 Bytes)
- `PROJEKT-LEARNINGS.md` (18.232 Bytes)

Merge-Kandidaten: Pruefen, zusammenfuehren, eine Datei behalten.

## Hinweis

Alle Aenderungen mit `git mv` (nicht move/copy). Danach Changelog-Eintrag (§17).
