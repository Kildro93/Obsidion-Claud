---
title: changelog
created: 2026-09-12
updated: 2026-09-13
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

### Migration-Scripts (nach Abschluss geloescht)
- `vault-migration.ps1` — Phasen 1-9 (teilweise)
- `vault-migration-continue.ps1` — Phasen 9-12 (Abschluss)
- `vault-nachbearbeitung.ps1` — Frontmatter + Wikilinks

## 2026-09-12 — STUDIUM-Cleanup + Root-Bereinigung

Durchgefuehrt durch: Gehirn-Admin-Chat (Cowork)

### STUDIUM/
- 8 leere Untitled-Stubs geloescht (nur onenote-id, kein Inhalt)
- 2 inhaltslose Stub-Dateien geloescht (Link Liste.md, Dokumente.md)
- 6 leere Fach-Ordner entfernt (Deutsch, Mathematik, Naturwissenschaften, Paedagogik, Praktikum, Sprache-und-Literatur)
- STUDIUM-Ausnahme in ordnungs-regeln.md dokumentiert: OneNote-Namen bleiben, kein kebab-case-Zwang

### Root-Bereinigung
- `2026-09-12.md` geloescht (leer)
- `Unbenannt.base` geloescht (leere Base-Tabelle)
- `Unbenannt.canvas` geloescht (leeres Canvas)
- `desktop.ini` war bereits in .gitignore

### Neue Dateien
- `PROJEKTE/Nestbau/aufgaben/repo-merge-nestbau-firebase.md` — Auftrag: Nestbau + nestbau-firebase zusammenfuehren

### Aktualisierte Dateien
- `MEMORY/ordnungs-regeln.md` — STUDIUM-Ausnahme, Frontmatter-Ausnahme dokumentiert
- `MEMORY/changelog.md` — Dieser Eintrag

## 2026-09-13 — Neue Regeln + Strukturentscheidungen

Durchgefuehrt durch: Gehirn-Feedback-Chat (Cowork)

### Neue Regeln in ordnungs-regeln.md
- §5 STUDIUM/ komplett umgeschrieben: `STUDIUM/primarlehrer/` ist die neue Struktur (Indra entschieden), kebab-case fuer alle Modulnamen, Modul-Templates definiert
- §7 Namenskonventionen: STUDIUM-Ausnahme fuer OneNote-Namen entfernt — alles kebab-case
- §14 Prompt-Speicherort: `FAZITE/allgemein/prompts/<chat-name>-v<nr>.md`
- §15 Claude-Outputs-Cleanup: `Claude outputs/` ist kein Vault-Ordner
- §16 Leere-Ordner-Regel: leere Ordner nach Strukturaenderung entfernen
- §17 Changelog-Pflicht: Aenderungen protokollieren VOR Git-Block
- §18 Bot-Uebergabe-Protokoll: `FAZITE/allgemein/auftraege/` mit Lese-Pflicht bei Session-Start
- §19 Datei-Zuordnungspflicht: Zuordnungsmatrix, Anti-Duplikat-Regeln, Bot-Pflichten
- §20 Aenderungskontrolle (umnummeriert von alt-§14)
- §21 Aufraeumung: von monatlich auf woechentlich geaendert, erweiterte Checkliste

### Neue Dateien
- `FAZITE/allgemein/auftraege/gehirn-admin-cleanup-auftrag.md` — Cleanup-Auftrag fuer Gehirn-Admin (Vault-Audit Ergebnisse)
- `FAZITE/allgemein/prompts/gehirn-ceo-v3.md` — CEO-Prompt mit FEHLERVERHALTEN + STATUS-ABFRAGEN
- `FAZITE/allgemein/prompt-block-status-abfragen.md` — Universeller Status-Block fuer alle Bots

### Aktualisierte Dateien
- `MEMORY/regeln.md` — Status-Abfragen-Sektion hinzugefuegt
- `FAZITE/allgemein/feedback-log.md` — FB-006, FB-007 hinzugefuegt
- `MEMORY/changelog.md` — Dieser Eintrag

## 2026-09-13 — Arbeitsprotokoll + "Wie sieht es aus?" Trigger

Durchgefuehrt durch: Gehirn-Feedback-Chat (Cowork)

### Neue Dateien
- `MEMORY/arbeitsprotokoll.md` — Zentrale Bot-Aufgaben-Uebersicht (wer macht was, Status aller Bots)
- `FAZITE/allgemein/prompts/gehirn-ceo-v4.md` — CEO-Prompt mit Arbeitsprotokoll-Pflicht + "Wie sieht es aus?" Trigger

### Aktualisierte Dateien
- `FAZITE/allgemein/prompt-block-status-abfragen.md` — "Wie sieht es aus?" Trigger hinzugefuegt (Kompakt-Update)
- `MEMORY/regeln.md` — "Wie sieht es aus?" in Status-Abfragen ergaenzt
- `MEMORY/ordnungs-regeln.md` — §2 arbeitsprotokoll.md ergaenzt, §22 Arbeitsprotokoll-Regel neu
- `FAZITE/allgemein/prompts/gehirn-ceo-v3.md` — Status auf `veraltet` gesetzt
- `MEMORY/changelog.md` — Dieser Eintrag

## 2026-09-13 — Gehirn-Admin Cleanup

Durchgefuehrt durch: Gehirn-Admin-Chat (Cowork)

### Strukturaenderungen
- `Claude outputs/` aufgeloest: 3 Duplikate geloescht, 3 Scripts nach `scripts/`, 1 Prompt nach `PROJEKTE/Primarlehrer-Studium/prompts/`
- `import/` komplett entfernt (12+ leere OneNote-Stubs)
- Root-Bild `Vorbereitungswoche image...png` entfernt (verwaist)
- `MEMORY/gehirn-feedback-prompt.md` → `FAZITE/allgemein/prompts/gehirn-feedback-v1.md` (§14)
- 13 Modulbeschreibungen von `STUDIUM/semester-01/fhnw-bach/module/` nach `STUDIUM/primarlehrer/modules/` migriert
- `STUDIUM/semester-01/` komplett entfernt (obsolet nach Migration)
- `STUDIUM/import/` entfernt (leer)

### Geloeschte Dateien
- `Claude outputs/ceo-auftrag-onenote-sync.md` (Duplikat)
- `Claude outputs/prompt-block-status-abfragen.md` (Duplikat)
- `Claude outputs/gehirn-ceo-v3.md` (Duplikat)
- `FAZITE/allgemein/feedback-log-1.md` (Duplikat von feedback-log.md)
- `FAZITE/allgemein/gehirn-admin-cleanup-auftrag.md` (aelteres Duplikat, neuere in auftraege/)
- `REST/techniken.md` (gemergt in technik-notizen.md)
- Leere Ordner: `FAZITE/github-automation/`, `STUDIUM/import/`

### Verschobene Dateien
- `MEMORY/gehirn-feedback-prompt.md` → `FAZITE/allgemein/prompts/gehirn-feedback-v1.md` (§14)

### Zusaetzlich geloeschte Duplikate (Originale existierten bereits am Zielort)
- `Claude outputs/onenote-sync.ps1` (Original in scripts/)
- `Claude outputs/onenote-sync-FIXED.ps1` (Original in scripts/)
- `Claude outputs/studium-umbenennung-und-setup.ps1` (Original in scripts/)
- `Claude outputs/CHAT-PROMPT-KOPIERFERTIG.md` (Original in PROJEKTE/Primarlehrer-Studium/prompts/)

### Neue Dateien
- `FAZITE/allgemein/auftraege/nestbau-ceo-strukturbereinigung.md` — Auftrag fuer Nestbau-CEO

### Aktualisierte Dateien
- `MEMORY/memory-index.md` — STUDIUM-Pfad korrigiert, Prompt-Verweis aktualisiert, Arbeitsprotokoll verlinkt
- `MEMORY/arbeitsprotokoll.md` — Gehirn-Admin Cleanup-Status aktualisiert
- `MEMORY/changelog.md` — Dieser Eintrag
- `REST/technik-notizen.md` — techniken.md Inhalt integriert
- `.gitignore` — Claude outputs/ hinzugefuegt
- `FAZITE/allgemein/auftraege/gehirn-admin-cleanup-auftrag.md` — Status auf erledigt
