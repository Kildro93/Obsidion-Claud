---
title: projekt-vorlage
created: 2026-09-12
updated: 2026-09-12
status: aktuell
tags: [typ/vorlage, status/aktuell]
autor: gehirn-admin
---

# Projekt-Vorlage

Template für neue Projekte unter `PROJEKTE/`. Beim Anlegen eines neuen Projekts diese Struktur kopieren.

## Ordnerstruktur

```
PROJEKTE/<projekt-name>/
├── README.md
├── docs/
├── notizen/
├── ressourcen/
├── aufgaben/
└── code/
```

## README.md Template

```markdown
---
title: <projekt-name>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
status: aktuell
tags: [projekt/<name>, typ/status, status/aktuell]
autor: chat-1-<projekt-name>
---

# <Projekt-Name>

## Beschreibung
<Was macht dieses Projekt, 1-2 Sätze>

## Aktuelle Aufgaben
<!-- CEO schreibt hier, Workers lesen -->
- [ ] <Aufgabe 1>
- [ ] <Aufgabe 2>

## Abgeschlossene Aufgaben
- [x] <Aufgabe>: <Ergebnis, Datum>

## Team
- CEO: chat-1-<projekt-name>
- Bot 0: bot-0-<aufgabe> — <Rolle>
- Bot 1: bot-1-<aufgabe> — <Rolle>

## Verweise
- Fazite: [[FAZITE/<projekt-name>/]]
- Vault-Index: [[MEMORY/memory-index]]
```

## FAZITE-Ordner anlegen

Bei neuem Projekt auch `FAZITE/<projekt-name>/` erstellen.

## In memory-index.md eintragen

Neues Projekt in [[MEMORY/memory-index]] unter "Projekte" verlinken.

## Checkliste

- [ ] Ordner `PROJEKTE/<name>/` mit allen Unterordnern erstellt
- [ ] README.md mit Frontmatter angelegt
- [ ] `FAZITE/<name>/` erstellt
- [ ] In memory-index.md eingetragen
- [ ] CEO-Chat benannt: `chat-1-<name>`
