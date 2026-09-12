# Nestbau – Chat-Exports (Übersicht)

Ergebnisse abgeschlossener Sessions und Bot-Läufe. Ein Export = eine Datei, Schema `YYYY-MM-DD-Thema.md`. Bot-Summaries hier ablegen (`<Bot-Name>-Summary.md`).

## Sessions (als Datei vorhanden)

### Design
- **2026-09-12 – [[2026-09-12-Design-System-Fix]]**
  - Thema: Ursache für „Design nicht konsistent" gefunden (dupliziertes Inline-CSS überschrieb `nestbau-design.css`) und behoben, WCAG-AA-Kontrastfehler korrigiert, mit `main` gemergt, PR #1 erstellt und gemergt
  - Top 3: (1) BUILD-GUIDE.md vor der Diagnose lesen – der Bug war dort schon dokumentiert. (2) Feature-Branch gegen aktuellen `main` prüfen, nicht gegen den Erstellungs-Stand. (3) WCAG-Kontrast bei Pastell-Paletten rechnerisch prüfen, nicht nach Augenmass.

### Kochbuch / Menüplan
- **2026-09-05 – [[2026-09-05-Kochbuch-Menuplan-GitHub]]**
  - Thema: Kochbuch/Menüplan/Zutaten/Rezepte in zwei Feinschliff-Runden, veröffentlicht; GitHub-Push-Versuch
  - Top 3: (1) Cloud-Session-Git-Proxy blockt Push zu nicht-autorisierten Repos → 403. (2) CSS-Spezifität versteckt Dark-Mode-Bugs. (3) Migrationslogik bei jeder Datenmodell-Änderung mitdenken.
  - Snippets: [[menuplan-migration]], [[css-spezifitaet-dark-mode-fix]]

### Setup & Repo-Pflege
- **2026-09-07 – [[2026-09-07-Vault-Setup-Repo-Cleanup]]**
  - Thema: Vault-Repo + Auto-Sync + Backup-Strategie, Security-Audit, Nestbau-Arbeitsverzeichnis committet, Branch-Entscheidung, 43 Tests portiert, XSS-Härtung, Kalender- und Firebase-Integration ans Laufen gebracht, Phase 2 begonnen
  - Top 3: (1) GitHub Actions kann keinen lokalen Vault syncen – nur Task Scheduler. (2) `.gitignore`-Muster ohne führenden Slash greifen auf jeder Ebene. (3) Branch ohne gemeinsame History ist ein eigenes Projekt, kein Merge-Kandidat.
  - Fact-Sheet: [[Branch-Entscheidung]]

### Testing & Build
- **2026-09-04 – [[2026-09-04-Local-App-Test-Report]]** (aus ~/Downloads)
  - „Local App Tester"-Report der v1-Fassung: Deployment, 11 JS-Module, HTTP-Server, Funktionsprüfung
- **2026-09-06 – [[2026-09-06-Testing-CICD]]** (aus ~/Downloads)
  - Playwright-E2E + CI/CD-Pipeline (GitHub Actions), TWA-Build-Setup; 11/11 grün, 2 Bug-Fixes offen

## Sessions ohne eigenen Export (Erkenntnisse konsolidiert)

Diese liefen als Bot-Runs; ihre Prompts liegen als Vorlagen unter `Claude outputs/`, die Erkenntnisse stecken in [[PROJEKT-LEARNINGS]] und [[NESTBAU-KNOWLEDGE-INDEX]].

| Session | Prompt-Vorlage | Ergebnis |
|---------|----------------|----------|
| Git Automation Engineer | `Claude outputs/BOT_0_GIT_AUTOMATION.md` | automatisierter Clone/Commit/Push-Workflow |
| Settings UI Architect | `Claude outputs/BOT_1_SETTINGS_UI.md` | Settings-Redesign (Sections, Cards) |
| Auth & Profile Developer | `Claude outputs/BOT_2_AUTH_PROFILE.md` | Auth-System – Umsetzung: `Claude outputs/nestbau-v2-auth/` |
| Design System Architect (1. Lauf) | `Claude outputs/BOT_3_DESIGN_UPDATE.md` | warme Palette, Gradients – `design-modernization.patch`; Nachfolge-Fix siehe [[2026-09-12-Design-System-Fix]] |
| Local Folder Manager | `Claude outputs/BOT_4_FOLDER_MANAGER.md` | Ordnerstruktur `C:\KI Programme\Nestbau Boter\` |
| Firebase Architect (Phase 1) | — | `Nestbau/FIREBASE-ARCHITECTURE.md`, Indexes, Functions-Templates |

> **Hinweis (Cleanup 2026-09-06):** Folgende überholte Prompt-Dateien aus `Claude outputs/` nach `ARCHIV/cleanup-2026-09-06/` verschoben: firebase-setup-guide.md (ersetzt durch SETUP-FIREBASE), integration-checklist.md (ersetzt durch PROJEKT-LEARNINGS), nestbau-ceo-master-prompt.md (ersetzt durch PROJEKT-LOOP), github-chat-anleitung.md (ersetzt durch QUICK-START). Die BOT_0-4-Prompts bleiben als Referenz.
| Build Optimizer | — | 43 Tests, CI/CD, Play-Store-Assets (`release/play-store`) |
| Rezept-Import | — | `Claude outputs/nestbau-v2-recipe-import/` |
| CEO Master-Prompt | `Claude outputs/nestbau-ceo-master-prompt.md` | Bot-System-Koordination |

## Statistik

- Session-Exports als Datei: 2
- Bot-Runs dokumentiert: 9
- Hauptthemen: Firebase-Integration, Kochbuch, Auth, Design, Build/Play-Store
