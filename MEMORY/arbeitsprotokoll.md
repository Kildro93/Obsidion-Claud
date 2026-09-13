---
title: arbeitsprotokoll
created: 2026-09-13
updated: 2026-09-13
status: aktuell
tags: [typ/status, status/aktuell]
autor: gehirn-feedback
---

# Arbeitsprotokoll

Zentrale Uebersicht aller aktiven Bots/Chats und ihrer Aufgaben. Wird von jedem Bot bei Aufgabenaenderung aktualisiert.

## Aktive Bots

### Gehirn-CEO
- **Typ:** Cowork | **Ordner:** C:\KI Programme\Obsidion fuer Claud
- **Rolle:** CEO der Vault-Infrastruktur. Fuehrt das System, nicht einzelne Projekte.
- **Prompt:** [[FAZITE/allgemein/prompts/gehirn-ceo-v3]]

| Status | Aufgabe | Seit | Details |
|---|---|---|---|
| offen | OneNote-Sync-Script bauen | 2026-09-13 | Auftrag: [[FAZITE/allgemein/ceo-auftrag-onenote-sync]] |

### Gehirn-Admin
- **Typ:** Cowork | **Ordner:** C:\KI Programme\Obsidion fuer Claud
- **Rolle:** Aufraeumung, Strukturaenderungen, Cleanup
- **Prompt:** (noch kein versionierter Prompt)

| Status | Aufgabe | Seit | Details |
|---|---|---|---|
| offen | Vault-Cleanup nach Audit | 2026-09-13 | Auftrag: [[FAZITE/allgemein/auftraege/gehirn-admin-cleanup-auftrag]] |

### Gehirn-Feedback
- **Typ:** Cowork | **Ordner:** C:\KI Programme\Obsidion fuer Claud
- **Rolle:** Kommunikation, Prompts, Learnings, Regeln, Feedback-Analyse
- **Prompt:** (noch kein versionierter Prompt)

| Status | Aufgabe | Seit | Details |
|---|---|---|---|
| erledigt | Feedback-Log FB-001 bis FB-007 | 2026-09-13 | [[FAZITE/allgemein/feedback-log]] |
| erledigt | CEO-Prompt v3 mit FEHLERVERHALTEN + STATUS | 2026-09-13 | [[FAZITE/allgemein/prompts/gehirn-ceo-v3]] |
| erledigt | Neue Regeln §14-§21 | 2026-09-13 | [[MEMORY/ordnungs-regeln]] |
| erledigt | Arbeitsprotokoll erstellt | 2026-09-13 | Diese Datei |

### Nestbau-CEO
- **Typ:** (noch nicht aktiv)
- **Rolle:** CEO des Nestbau-Projekts (Haushalts-App)
- **Prompt:** (noch kein versionierter Prompt)

| Status | Aufgabe | Seit | Details |
|---|---|---|---|
| — | Keine offenen Aufgaben | — | Projekt pausiert |

## Regeln fuer dieses Protokoll

1. **Wer traegt ein:** Der zustaendige CEO traegt die Aufgaben seiner Worker ein — er ist fuer die Aufgabenverteilung verantwortlich
   - Gehirn-CEO: traegt Gehirn-Admin, Gehirn-Feedback und eigene Aufgaben ein
   - Nestbau-CEO: traegt Nestbau-Worker und eigene Aufgaben ein
   - Jeder CEO traegt auch seine eigenen Aufgaben ein
2. **Ausnahme — Worker traegt selbst ein:** Nur wenn der User einen Worker direkt beauftragt hat (CEO uebergangen). Der Worker vermerkt: `(direkt vom User)` in der Details-Spalte
3. **Status aktualisieren:**
   - Neue Aufgabe → CEO traegt Zeile mit `offen` ein
   - Aufgabe begonnen → Status auf `in Bearbeitung` setzen (darf der Worker selbst)
   - Aufgabe abgeschlossen UND funktioniert → Status auf `erledigt` setzen (darf der Worker selbst)
   - Aufgabe abgebrochen → Zeile entfernen mit Kommentar im Changelog
4. **Status-Werte:** `offen`, `in Bearbeitung`, `erledigt`
5. **Erledigt = funktioniert.** Nicht "erledigt" setzen wenn ungetestet oder fehlerhaft
6. **Gehirn-CEO liest dieses Protokoll bei JEDER Anfrage** und gibt zuerst eine Uebersicht
7. **Erledigte Aufgaben:** bleiben 7 Tage sichtbar, dann entfernt der Gehirn-Admin sie
8. **Neue Bots:** Werden hier eingetragen sobald sie einen Prompt und eine Aufgabe haben
