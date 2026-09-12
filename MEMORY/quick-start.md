---
title: quick-start
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/guide, status/aktuell]
autor: indra
---

# Quick-Start für neue Chats und Bots

## Reihenfolge beim Start

1. [[MEMORY/memory-index]] — Einstieg und Wegweiser
2. [[MEMORY/regeln]] — Kommunikationsstil, No-Gos
3. [[MEMORY/profil]] — wer ich bin, Zeitbudget
4. Projektordner: `PROJEKTE/<Projekt>/README.md`

Nie den kompletten Vault durchsuchen. Fehlt Kontext, gezielt per Suche nachladen.

## Rollen

| Rolle | Macht | Macht nicht |
|---|---|---|
| CEO-Chat | koordiniert, briefed Bots, pflegt README | Code schreiben |
| Bot | arbeitet an genau einer Aufgabe im eigenen Projektordner | in MEMORY/ oder fremde Projekte schreiben |

## Bot-Ablauf

1. `PROJEKTE/<Projekt>/README.md` lesen
2. In Batches arbeiten, nach jedem Batch `node --check` bei JS
3. Über echte UI-Interaktionen testen, nie über App-interne Closures
4. Light- und Dark-Screenshot prüfen
5. **Sofort und direkt melden: "Fertig. [Was erledigt wurde]."**
6. Fazit schreiben nach [[MEMORY/chat-closure-protocol]]

## Vor Chat-Löschung

Fazit erstellen: Probleme, Code-Erkenntnisse, Prozesse, Fehler, Learnings. Keys immer als `[REDACTED]`. Ablage: `FAZITE/<projekt>/<chat-name>-fazit-<YYYY-MM-DD>.md`

## Häufige Befehle

```powershell
# Sofort pushen
powershell -ExecutionPolicy Bypass -File ".\scripts\push.ps1" "Update: Thema"

# Sync-Log ansehen
Get-Content ".\scripts\logs\vault-sync.log" -Tail 20

# Backup jetzt
powershell -ExecutionPolicy Bypass -File ".\scripts\weekly-backup.ps1"
```

## Verweise

- Setup und Zugänge: [[MEMORY/setup/projekt-credentials]]
- Auto-Sync: [[MEMORY/setup/auto-sync]] · Backups: [[MEMORY/setup/backup-strategy]]
- Fehlersuche: [[MEMORY/debugging]]
