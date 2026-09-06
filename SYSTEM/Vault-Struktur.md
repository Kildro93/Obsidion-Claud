# Vault-Struktur

Übersicht über diese Vault und das Loop-System. Stand: 2026-09-06.

## Ordner

```
SYSTEM/                     Zentrale Steuerung – nur hier definiert, von jedem Chat gelesen
├─ MEMORY_INDEX.md          Einstiegspunkt / Dashboard
├─ Profil.md                Wer ist der Nutzer, was macht er
├─ Regeln.md                Kommunikationsstil & No-Gos
└─ Vault-Struktur.md        Diese Übersicht

PROJEKTE/
├─ Nestbau/                 Hauptprojekt (Household-App) – Einstieg: README.md
│  ├─ PROJEKT-LOOP/-UPDATE/-LEARNINGS/-ACCESS.md   Loop-Steuerung
│  ├─ README.md · VERKNUEPFUNGEN.md · DATEI-TREE.txt
│  ├─ NESTBAU_AKTUELL.md · ARTIFACT_LINKS.md · Learnings.md
│  ├─ REQUIREMENTS/         Features, User-Stories, Tech-Stack
│  ├─ DESIGN/               Design-System, User-Flows
│  ├─ CODE/                 Zeiger auf die echten Repos + lose Snippets
│  ├─ Knowledge/            tech, testing, haushalts-app, quickref, INDEX
│  ├─ Chat-Exports/         Session-Ergebnisse + INDEX
│  └─ Fact-Sheets/          Firebase-Architektur, Kochbuch-Datenmodell
└─ GitHub-Automation/       Tool: HTML-App zum Anlegen von GitHub-Repos aus Obsidian-Notizen

LERNEN/
├─ Primarlehrer/            Unterrichtsvorbereitung
├─ Technik/                 Interesse
└─ Anime/                   Interesse

KOCH-WISSEN/                Persönliches Koch-Wissen (Rezepte, Techniken)
ROUTINEN/                   Alltags-Workflows
ARCHIV/                     Abgelegte / veraltete Dateien

Nestbau/                    CODE – Git-Repo der App (nicht anfassen ausser im Projekt-Kontext)
nestbau-firebase/           CODE – Firebase-Backend, eigenes Git-Repo
Claude outputs/             CODE + generierte Bundles + Bot-Prompt-Vorlagen
.gitignore                  Vault-Root – schliesst Secrets + Build-Cache aus (für geplanten Push)
```

Reine Build-Ordner (z. B. das gelöschte `C:\nestbau-build`) gehören NICHT in die Vault – reproduzierbar aus dem Repo.

## Loop-System – Kurzfassung

Jedes Projekt in PROJEKTE/ hat vier Steuer-Dateien:

- **PROJEKT-LOOP.md** – erklärt CEO-Rolle und Bot-Rollen
- **PROJEKT-UPDATE.md** – der CEO schreibt hier vor jedem Bot-Start den aktuellen Stand
- **PROJEKT-LEARNINGS.md** – der CEO schreibt hier nach jedem Bot-Ende das Fazit
- **PROJEKT-ACCESS.md** – Zugangs-Vorlagen (keine echten Keys)

Ablauf: CEO briefed Bot → Bot arbeitet nur im eigenen Projektordner → Bot schreibt Summary → CEO zieht Learnings + aktualisiert Update → nächster Bot.

## Verhalten jedes Projekt-Chats

Beim Start in einem Projekt-Chat zuerst lesen:

1. SYSTEM/MEMORY_INDEX.md, SYSTEM/Regeln.md, SYSTEM/Profil.md
2. PROJEKTE/<Projekt>/PROJEKT-LOOP.md
3. PROJEKTE/<Projekt>/PROJEKT-UPDATE.md
4. PROJEKTE/<Projekt>/PROJEKT-LEARNINGS.md

Dann erst arbeiten. Nicht die ganze Vault durchsuchen, nicht in anderen Projekten schreiben, SYSTEM/ nur durch den CEO ändern.

## Neues Projekt anlegen

Ordner unter PROJEKTE/ anlegen, die vier PROJEKT-Dateien aus Nestbau als Vorlage kopieren und anpassen, in MEMORY_INDEX.md verlinken.


## Betriebs-Ebene (seit 2026-09-06)

```
SYSTEM/
  QUICK-START.md      Einstieg für neue Chats/Bots
  DEBUGGING.md        Fehlerbilder Git, Sync, Nestbau
  SETUP/
    PROJEKT-CREDENTIALS.md   Zugangs-Übersicht (Templates, keine Keys)
    SETUP-GITHUB-TOKEN.md    PAT erstellen und in Windows hinterlegen
    SETUP-FIREBASE.md        Projekt nestbau-app, Rules, Secrets
    SETUP-ENV-LOCAL.md       nb-config.local.js, Function-Secrets, keystore.properties
    AUTO-SYNC.md             Task Scheduler, alle 30 Minuten
    BACKUP-STRATEGY.md       drei Ebenen: GitHub, ZIP, ausser Haus
    SECURITY-AUDIT.md        Audit-Stand und Wiederholungs-Rezept
scripts/
  vault-sync.ps1            Commit + Push, läuft per Aufgabe
  install-autosync-task.ps1 registriert die Aufgabe
  weekly-backup.ps1         ZIP nach backups/, hält 8 Stück
  install-backup-task.ps1   registriert die Backup-Aufgabe
  push.ps1                  manueller Sofort-Push
  logs/                     vault-sync.log
```

Git: Vault-Wurzel ist ein eigenes Repo (Kildro93/obsidian-vault). `Nestbau/` und `nestbau-firebase/` bleiben eigene Repos und sind per `.gitignore` ausgeschlossen — `PROJEKTE/Nestbau/` (Notizen) ist davon nicht betroffen.
