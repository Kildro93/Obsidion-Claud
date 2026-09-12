---
title: ordnungs-regeln
created: 2026-09-12
updated: 2026-09-12
status: aktuell
tags: [typ/regel, status/aktuell]
autor: gehirn-admin
---

# Ordnungs-Regeln

Verbindliche Regeln für die gesamte Vault-Organisation. Erstellt durch den Gehirn-Admin-Chat.

## 1. Ordnerstruktur

Genau 5 Top-Level-Ordner, nichts anderes auf der obersten Ebene (ausser git/system-Dateien):

```
MEMORY/       Zentrale Steuerung, Regeln, Profil, Setup-Docs
PROJEKTE/     Alle aktiven Projekte mit einheitlicher Vorlage
STUDIUM/      Primarlehrer-Studium, nach Semester und Fach
FAZITE/       Alle Chat-Fazite, nach Projekt gruppiert
REST/         Auffangbecken für Einzelnotizen ohne Projektzugehörigkeit
```

Geschützte Ordner (nicht anfassen): `.git`, `.obsidian`, `Nestbau/`, `nestbau-firebase/`, `node_modules`, `backups/`, `scripts/`

## 2. MEMORY/ Inhalt

- `memory-index.md` — Einstiegspunkt für jeden Chat
- `profil.md` — Wer ist der Nutzer
- `regeln.md` — Kommunikationsstil und No-Gos
- `ordnungs-regeln.md` — Diese Datei
- `vault-struktur.md` — Strukturübersicht
- `chat-closure-protocol.md` — Fazit-Protokoll
- `quick-start.md` — Schnelleinstieg für neue Chats/Bots
- `prompt-typen-guide.md` — Chat vs Code vs Cowork
- `debugging.md` — Fehlersuche-Guide
- `workflows.md` — Wiederkehrende Abläufe
- `projekt-vorlage.md` — Template für neue Projekte
- `glossar.md` — Feste Tag-Liste und Begriffe
- `changelog.md` — Änderungsprotokoll
- `setup/` — Technische Setup-Dokumente

## 3. Projekt-Vorlage

Jedes Projekt unter `PROJEKTE/` folgt dieser Struktur:

```
PROJEKTE/<projekt-name>/
├── README.md          CEO schreibt, Workers lesen
├── docs/              Bot-Prompts, Anleitungen
├── notizen/           Arbeitsnotizen, Ideen
├── ressourcen/        Patches, Configs, Assets
├── aufgaben/          Offene Tasks
└── code/              Code-Bundles, Snippets
```

Nützliche Unterordner, die ein Projekt erstellt, werden bei der nächsten Aufräumung in alle anderen Projekte übernommen — die Vault lernt von sich selbst.

## 4. Projekt-Hierarchie (CEO-System)

- Jedes Projekt hat einen CEO-Chat: `chat-1-<projektname>` (z.B. `chat-1-nestbau`)
- Bis zu 4 Worker-Chats pro Projekt: `bot-0-<aufgabe>` bis `bot-3-<aufgabe>`
- CEO koordiniert, vergibt Aufgaben via README.md, schreibt keine Projektcode
- Workers lesen README.md, arbeiten nur im eigenen Projektordner, melden Ergebnis

Ablauf: CEO schreibt Aufgabe in README → Worker liest README → Worker arbeitet → Worker meldet "Fertig." → CEO aktualisiert README

## 5. STUDIUM/ Struktur

Nach Semester, dann nach Fach (wie OneNote):

```
STUDIUM/
├── semester-01/
│   ├── mathematik/
│   ├── deutsch/
│   └── ...
├── semester-02/
└── ...
```

## 6. FAZITE/ Struktur

Zentral für alle Chat-Fazite, nach Projekt gruppiert:

```
FAZITE/
├── allgemein/          Projektübergreifende Fazite
├── nestbau/            Nestbau-Projektfazite
├── github-automation/  GitHub-Automation-Fazite
└── <neues-projekt>/    Wird bei Bedarf angelegt
```

## 7. Namenskonventionen

- Dateinamen: `kebab-case` (kleinbuchstaben, bindestrich)
- Ordnernamen: `kebab-case` (Ausnahme: Top-Level bleibt GROSSBUCHSTABEN)
- Keine Leerzeichen, keine Umlaute in Dateinamen
- Fazite: `<thema>-fazit-<YYYY-MM-DD>.md`

## 8. Sprache

Deutsch mit englischen Fachbegriffen (z.B. "Firebase Rules", "Pull Request", "Deployment")

## 9. Pflicht-Frontmatter

Jede Datei bekommt:

```yaml
---
title: <dateiname-ohne-extension>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
status: aktuell | veraltet
tags: [<namespace/wert>, ...]
autor: <chat-name oder indra>
---
```

Falls `projekt` relevant: `projekt: <projektname>` ergänzen.

## 10. Tags (feste Liste)

Siehe [[MEMORY/glossar]] für die vollständige Tag-Liste. Namespaces:

- `typ/` — status, regel, setup, wissen, fazit, vorlage, guide
- `status/` — aktuell, veraltet
- `projekt/` — nestbau, github-automation, primarlehrer-studium
- `bereich/` — design, firebase, kalender, kochbuch, security, auth

Neue Tags nur über den Gehirn-Admin-Chat hinzufügen.

## 11. Links

Wikilinks mit relativem Pfad, ohne Alias: `[[MEMORY/profil]]`

## 12. Veraltet-Handling

- Status auf `veraltet` setzen, Tag `status/veraltet` hinzufügen
- Nach 6 Monaten löschen
- Duplikate: aggressiv zusammenführen (merge), nicht doppelt halten

## 13. REST/ Regeln

- Auffangbecken für Einzelnotizen ohne Projektzugehörigkeit
- Gehirn-Admin darf nicht mehr gebrauchte Daten löschen
- Bei Aufräumung: prüfen ob Inhalte in ein Projekt verschoben werden können

## 14. Änderungskontrolle

- Strukturänderungen nur durch den Gehirn-Admin-Chat
- Inhaltliche Änderungen durch den zuständigen CEO oder Gehirn-Admin
- Alle Änderungen werden in [[MEMORY/changelog]] protokolliert

## 15. Aufräumung

- Monatlich oder auf Befehl
- Kurzer Status-Bericht im Chat (keine separate Datei)
- Prüfpunkte: veraltete Dateien, Duplikate, leere Ordner, REST/-Inhalte, fehlende Frontmatter
