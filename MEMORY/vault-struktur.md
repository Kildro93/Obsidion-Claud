---
title: vault-struktur
created: 2026-09-06
updated: 2026-09-12
status: aktuell
tags: [typ/status, status/aktuell]
autor: gehirn-admin
---

# Vault-Struktur

Übersicht über diese Vault. Stand: 2026-09-12 (nach Grosser Migration).

## Top-Level (5 Ordner)

```
MEMORY/                     Zentrale Steuerung — Regeln, Profil, Setup
├── memory-index.md         Einstiegspunkt für jeden Chat
├── profil.md               Wer ist der Nutzer
├── regeln.md               Kommunikationsstil & No-Gos
├── ordnungs-regeln.md      Verbindliche Vault-Regeln
├── vault-struktur.md       Diese Übersicht
├── chat-closure-protocol.md Fazit-Protokoll
├── quick-start.md          Schnelleinstieg für Chats/Bots
├── prompt-typen-guide.md   Chat vs Code vs Cowork
├── debugging.md            Fehlersuche-Guide
├── workflows.md            Wiederkehrende Abläufe
├── projekt-vorlage.md      Template für neue Projekte
├── glossar.md              Feste Tag-Liste & Begriffe
├── changelog.md            Änderungsprotokoll
└── setup/                  Technische Setup-Dokumente
    ├── projekt-credentials.md
    ├── setup-github-token.md
    ├── setup-firebase.md
    ├── setup-env-local.md
    ├── auto-sync.md
    ├── backup-strategy.md
    ├── checklist.md
    └── security-audit.md

PROJEKTE/                   Alle aktiven Projekte
├── Nestbau/                Hauptprojekt (Household-App)
│   ├── README.md           CEO schreibt, Workers lesen
│   ├── docs/               Bot-Prompts, Anleitungen
│   ├── notizen/            Arbeitsnotizen
│   ├── ressourcen/         Patches, Configs
│   ├── aufgaben/           Tasks
│   └── code/               Code-Bundles (nestbau-v2-auth, nestbau-v2-recipe-import)
└── GitHub-Automation/      Tool: GitHub-Repos aus Obsidian-Notizen
    ├── index.md            Projektübersicht
    ├── docs/               Anleitungen
    ├── notizen/            Arbeitsnotizen
    └── code/               HTML-App

STUDIUM/                    Primarlehrer-Studium
└── semester-01/            Erstes Semester (Material)

FAZITE/                     Alle Chat-Fazite
├── allgemein/              Projektübergreifend
└── nestbau/                Nestbau-Projektfazite

REST/                       Einzelnotizen ohne Projektzugehörigkeit
├── anime-notizen.md
├── technik-notizen.md
├── rezepte.md
└── techniken.md
```

## Geschützte Ordner (nicht anfassen)

- `Nestbau/` — Git-Repo der App (eigenes Repo)
- `nestbau-firebase/` — Firebase-Backend (eigenes Repo)
- `.git`, `.obsidian`, `backups/`, `scripts/`, `node_modules`

## CEO-System

Jedes Projekt hat einen CEO-Chat und bis zu 4 Worker-Bots:
- CEO: `chat-1-<projektname>` — koordiniert, schreibt README
- Workers: `bot-0-<aufgabe>` bis `bot-3-<aufgabe>` — lesen README, arbeiten

Ablauf: CEO briefed via README → Worker arbeitet → Worker meldet "Fertig." → CEO aktualisiert README

## Verhalten jedes Chats beim Start

1. [[MEMORY/memory-index]], [[MEMORY/regeln]], [[MEMORY/profil]] lesen
2. `PROJEKTE/<Projekt>/README.md` lesen
3. Dann erst arbeiten

Nicht die ganze Vault durchsuchen. MEMORY/ nur durch CEO oder Gehirn-Admin ändern.

## Git

Vault-Wurzel ist ein eigenes Repo (`Kildro93/Obsidion-Claud`). `Nestbau/` und `nestbau-firebase/` sind eigene Repos und per `.gitignore` ausgeschlossen. Auto-Sync alle 30 Minuten, Details: [[MEMORY/setup/auto-sync]].

## Namensregeln

- Dateien: `kebab-case` (Kleinbuchstaben, Bindestrich)
- Top-Level-Ordner: GROSSBUCHSTABEN
- Frontmatter: Pflicht in jeder Datei, siehe [[MEMORY/ordnungs-regeln]]
- Tags: feste Liste, siehe [[MEMORY/glossar]]
- Links: Wikilinks mit relativem Pfad, ohne Alias
