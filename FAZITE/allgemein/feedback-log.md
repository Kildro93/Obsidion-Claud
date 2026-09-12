---
title: feedback-log
created: 2026-09-12
updated: 2026-09-12
status: aktuell
tags: [typ/log, status/aktuell]
autor: gehirn-feedback
---

# Feedback-Log

Chronologisches Protokoll: Was lief schief, warum, was wurde geändert.

---

## 2026-09-12

### FB-001: Blockade statt Fallback
- **Chat:** Gehirn-CEO
- **Auslöser:** Google Drive war noch nicht indexiert. CEO meldete dreimal "BLOCKIERT" statt einen Upload-Weg vorzuschlagen.
- **Ursache:** Prompt enthielt keine Fallback-Logik für fehlende Datenquellen. Bot interpretierte "Daten fehlen" als Stopp-Signal statt als Routing-Problem.
- **Regel:** `REGEL-FB01` — Kein Bot darf "BLOCKIERT" melden, ohne mindestens einen alternativen Weg vorzuschlagen. "Daten fehlen" heisst: anderen Kanal suchen, nicht stehen bleiben.
- **Status:** erledigt — Fix in CEO-Prompt v1 (Zeile "nicht blockieren"), verstärkt in v2 (FEHLERVERHALTEN-Block)

### FB-002: Upload-Kontext mit Vault verwechselt
- **Chat:** Gehirn-CEO
- **Auslöser:** CEO hielt eine Datei aus seinem Upload-Kontext für fehlend im Vault, obwohl sie dort existierte.
- **Ursache:** Bot unterschied nicht zwischen "was ich sehe" (Upload-Kontext) und "was im Vault steht" (tatsächlicher Stand). Keine Verifizierungs-Pflicht im Prompt.
- **Regel:** `REGEL-FB02` — Bevor ein Bot behauptet, eine Datei fehle: Vault prüfen (device_list_dir / device_stage_files). Upload-Kontext ≠ Vault-Stand. Aussagen über den Vault nur nach Verifizierung.
- **Status:** erledigt — Fix in CEO-Prompt v2 (FEHLERVERHALTEN: "Vault vs. Upload-Kontext")

### FB-003: Unnötige Rückfrage nach bekanntem Kontext
- **Chat:** Gehirn-CEO
- **Auslöser:** CEO fragte nach dem Vault-Pfad, obwohl sein eigener Prompt die Rollengrenze beschrieb und der Pfad im System-Kontext stand.
- **Ursache:** Bot las seinen eigenen Prompt / System-Kontext nicht vollständig durch. Rückfrage als Default statt Eigenrecherche.
- **Regel:** `REGEL-FB03` — Vor jeder Rückfrage prüfen: Steht die Antwort bereits im eigenen Prompt, im System-Kontext oder in MEMORY/? Nur fragen, was wirklich unbekannt ist.
- **Status:** erledigt — Fix in CEO-Prompt v2 (FEHLERVERHALTEN: "Rückfragen")

### FB-004: Technische Ursache erfunden
- **Chat:** Gehirn-CEO
- **Auslöser:** CEO erklärte fehlenden Git-Zugriff mit einem "Windows-Update-Problem", statt schlicht zu sagen: "Git geht bei mir nicht."
- **Ursache:** Bot versuchte, eine Erklärung zu liefern, statt die Grenze neutral zu benennen. Spekulativer Fehler — wirkt unglaubwürdig.
- **Regel:** `REGEL-FB04` — Wenn eine Fähigkeit nicht verfügbar ist: klar und ehrlich sagen. Keine Ursachen spekulieren. Format: "[X] geht bei mir nicht. Hier ist ein Workaround: [Y]."
- **Status:** erledigt — Fix in CEO-Prompt v1 (Git-Block-Zeile), verstärkt in v2 (FEHLERVERHALTEN: "Technische Grenzen")

### FB-005: Git-Block ohne push
- **Chat:** Gehirn-Feedback
- **Auslöser:** Gehirn-Feedback lieferte Git-Block ohne `git push`.
- **Ursache:** Prompt-Vorlage für Git-Blöcke war unvollständig.
- **Regel:** `REGEL-FB05` — Jeder Git-Block enthält immer: `git add`, `git commit`, `git push`, danach `drive-mirror.ps1`.
- **Status:** erledigt — ab sofort in allen Chats angewendet
