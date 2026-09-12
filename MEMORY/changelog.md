---
title: changelog
created: 2026-09-12
updated: 2026-09-12
status: aktuell
tags: [typ/status, status/aktuell]
autor: gehirn-admin
---

# Changelog

Protokoll aller strukturellen Vault-Änderungen. Inhaltliche Änderungen einzelner Dateien werden hier nicht erfasst.

## 2026-09-12 — Grosse Vault-Migration

Durchgeführt durch: Gehirn-Admin-Chat (Cowork)

### Strukturänderungen
- `SYSTEM/` aufgelöst → Inhalte nach `MEMORY/` verschoben (kebab-case)
- `LERNEN/` aufgelöst → Einzelnotizen nach `REST/`
- `KOCH-WISSEN/` aufgelöst → Einzelnotizen nach `REST/`
- `ROUTINEN/` aufgelöst → `workflows.md` nach `MEMORY/`
- `ARCHIV/` aufgelöst → veraltete Dateien gelöscht
- `Claude outputs/` aufgelöst → Bot-Prompts nach `PROJEKTE/Nestbau/docs/`, Code-Bundles nach `PROJEKTE/Nestbau/code/`, Ressourcen nach `PROJEKTE/Nestbau/ressourcen/`
- `PROJEKTE/Primarlehrer-Studium/` → Studienmaterial nach `STUDIUM/semester-01/`
- `PROJEKTE/GitHub-Automation/` intern umstrukturiert (kebab-case, Unterordner docs/notizen/code)
- Chat-Exports aus allen Orten zentral nach `FAZITE/` verschoben
- Alle leeren Ordner entfernt

### Neue Dateien
- `MEMORY/ordnungs-regeln.md` — Verbindliche Vault-Regeln
- `MEMORY/projekt-vorlage.md` — Template für neue Projekte
- `MEMORY/glossar.md` — Feste Tag-Liste
- `MEMORY/changelog.md` — Diese Datei

### Aktualisierte Dateien
- `MEMORY/memory-index.md` — Alle Pfade und Links aktualisiert
- `MEMORY/vault-struktur.md` — Komplett neu geschrieben
- Alle MEMORY-Dateien: Frontmatter auf Pflichtformat aktualisiert
- Wikilinks in allen Dateien auf neue Pfade korrigiert

### Gelöschte Dateien
- `SYSTEM/CLEANUP-REPORT-2026-09-06.md`
- `LERNEN/Primarlehrer/Notizen.md`
- `ROUTINEN/2026-09-06-Vault-Cleanup-Integration.md`
- `ARCHIV/Chat-Closure-Protocol-v1-superseded.md`
- `ARCHIV/Entwurf_Test.md`
- `ARCHIV/Willkommen.md`
- `ARCHIV/cleanup-2026-09-06/`
- `Claude outputs/Nestbau-Setup-Fazit-2026-09-07.md` (Duplikat)
- `Claude outputs/README-Session-Backup.md`
- `Claude outputs/pruefe-alten-ordner.ps1`
- `Claude outputs/index.html`
- `Claude outputs/Nestbau-Session-Backup-2026-09-07/`
- `PROJEKTE/Nestbau/Backups/nestbau-sicherung-2026-09-04.json`

### Migration-Scripts
- `vault-migration.ps1` — Phasen 1-9 (teilweise)
- `vault-migration-continue.ps1` — Phasen 9-12 (Abschluss)
