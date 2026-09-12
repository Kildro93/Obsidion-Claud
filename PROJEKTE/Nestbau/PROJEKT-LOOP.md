---
tags: [projekt/nestbau, typ/status, status/aktuell]
aktualisiert: 2026-09-12
---

# PROJEKT-LOOP: Nestbau

## Was ist dieses Projekt?

Household-Management-App (PWA, Android-installierbar) für Indra + Partnerin: Aufgaben, Kalender, Finanzen/Abos, Kochbuch. v1 lokal (localStorage), v2 mit Firebase/Firestore-Sync. Repo: https://github.com/Kildro93/Nestbau

## Loop-Struktur

### CEO-Chat

Koordiniert den Loop, arbeitet selbst nicht am Code.

Aufgaben:
- Liest PROJEKT-UPDATE.md, bevor ein neuer Bot startet
- Brieft den Bot (Aufgabe, Dateien, IDs, Datenmodell, CSS-Klassen mitgeben)
- Überwacht Fortschritt
- Liest die Bot-Summary nach Abschluss
- Schreibt das Fazit in PROJEKT-LEARNINGS.md
- Aktualisiert PROJEKT-UPDATE.md für den nächsten Bot
- Hält PROJEKT-LOOP.md aktuell

CEO schreibt/updatet:
- PROJEKT-UPDATE.md (vor jedem Bot-Start)
- PROJEKT-LEARNINGS.md (nach jedem Bot-Ende)
- PROJEKT-LOOP.md (Struktur-Änderungen)

### Bot-Rollen (bisher genutzt)

| Bot | Aufgabe | Input | Output |
|-----|---------|-------|--------|
| Git Automation | Klonen, Ändern, Commit, Push ohne manuelle Schritte | UPDATE.md + Repo | Commit-Historie + Summary |
| Settings UI | Einstellungen-Seite neu designen | UPDATE.md + index.html/CSS | UI-Patch + Summary |
| Auth & Profile | Firebase-Auth, Registration/Login, Haushalt-Sync | UPDATE.md + Auth-Modul | Auth-Code + Summary |
| Design System | Farbpalette, Gradients, Animationen, Dark Mode | UPDATE.md + nestbau-design.css | CSS-Update + Summary |
| Folder Manager | Lokale Nestbau-Dateien organisieren | Dateisystem | Ordnerstruktur + Summary |
| Firebase Architect | Firestore-Datenmodell + Doku | UPDATE.md + nb-firebase.js | ARCHITECTURE.md, Indexes, Functions |
| Build Optimizer | Test-Suite, CI/CD, Play-Store-Assets | UPDATE.md + release/play-store | AAB-Kette + Summary |

Neue Bots nach gleichem Muster ergänzen: Name, Aufgabe, Input, Output, nächster Bot.

### Workflow

1. CEO schreibt PROJEKT-UPDATE.md (Stand + nächster Schritt)
2. Bot startet, liest PROJEKT-UPDATE.md + PROJEKT-LEARNINGS.md + relevante Knowledge-Docs
3. Bot arbeitet in klar abgegrenzten Batches (`node --check` nach jedem Batch)
4. Bot testet über echte UI-Interaktionen, Light/Dark-Screenshot-Review vor Veröffentlichung
5. Bot schreibt `<Bot-Name>-Summary.md` in Chat-Exports/
6. Bot meldet dem CEO: fertig + Link zur Summary
7. CEO liest Summary, schreibt Fazit in PROJEKT-LEARNINGS.md
8. CEO aktualisiert PROJEKT-UPDATE.md, nächster Bot startet (oder Projekt pausiert)

## Regeln

- Bots schreiben nur in ihren eigenen Projektordner (PROJEKTE/Nestbau/), nie in SYSTEM/ oder andere Projekte
- PROJEKT-LEARNINGS.md schreibt nur der CEO, nach Bot-Abschluss
- Zeitbudget des Projekts: < 2h/Woche
- Kommunikationsstil: siehe [[Regeln]]

## Verweise

- Projekt-Einstieg: [[README]]
- Status: [[PROJEKT-UPDATE]]
- Erkenntnisse: [[PROJEKT-LEARNINGS]]
- Zugänge: [[PROJEKT-ACCESS]]
- Anforderungen: [[Features]] · [[User-Stories]] · [[Tech-Stack]]
- Design: [[Design-System]] · [[User-Flows]]
- Code-Landkarte: [[CODE-Landkarte]]
- Verknüpfungen: [[VERKNUEPFUNGEN]]
- Feature-Übersicht: [[NESTBAU_AKTUELL]]
- Knowledge Base: [[NESTBAU-KNOWLEDGE-INDEX]]
- Sessions: [[INDEX|Chat-Exports/INDEX]]
