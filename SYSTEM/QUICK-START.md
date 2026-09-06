# Quick-Start fuer neue Chats und Bots

## Reihenfolge beim Start

1. [[MEMORY_INDEX]] — Einstieg und Wegweiser
2. [[Regeln]] — Kommunikationsstil, No-Gos
3. [[Profil]] — wer ich bin, Zeitbudget
4. Projektordner, nur die drei Dateien: [[PROJEKT-LOOP]], [[PROJEKT-UPDATE]], [[PROJEKT-LEARNINGS]]

Nie den kompletten Vault durchsuchen. Fehlt Kontext, gezielt per Suche nachladen.

## Rollen

| Rolle | Macht | Macht nicht |
|---|---|---|
| CEO-Chat | koordiniert, briefed Bots, pflegt UPDATE und LEARNINGS | Code schreiben |
| Bot | arbeitet an genau einer Aufgabe im eigenen Projektordner | in SYSTEM/ oder fremde Projekte schreiben |

## Bot-Ablauf

1. Die drei Projektdateien lesen
2. In Batches arbeiten, nach jedem Batch `node --check` bei JS
3. Ueber echte UI-Interaktionen testen, nie ueber App-interne Closures
4. Light- und Dark-Screenshot pruefen, bevor etwas veroeffentlicht wird
5. `<Bot-Name>-Summary.md` nach `Chat-Exports/` schreiben
6. Dem CEO melden: fertig, Link zur Summary

## Vor Chat-Loeschung

Chat-Export erstellen: Probleme, Code-Erkenntnisse, Prozesse, Fehler, Learnings. Keys immer als `[REDACTED]`. Ablage: `PROJEKTE/<Projekt>/Chat-Exports/JJJJ-MM-TT-Thema.md`, danach `Chat-Exports/INDEX.md` ergaenzen.

## Haeufige Befehle

```powershell
# Sofort pushen
powershell -ExecutionPolicy Bypass -File ".\scripts\push.ps1" "Update: Thema"

# Sync-Log ansehen
Get-Content ".\scripts\logs\vault-sync.log" -Tail 20

# Backup jetzt
powershell -ExecutionPolicy Bypass -File ".\scripts\weekly-backup.ps1"
```

## Verweise

- Setup und Zugaenge: [[PROJEKT-CREDENTIALS]]
- Auto-Sync: [[AUTO-SYNC]] · Backups: [[BACKUP-STRATEGY]]
- Fehlersuche: [[DEBUGGING]]
