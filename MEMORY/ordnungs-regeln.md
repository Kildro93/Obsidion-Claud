---
title: ordnungs-regeln
created: 2026-09-12
updated: 2026-09-13
status: aktuell
tags: [typ/regel, status/aktuell]
autor: gehirn-admin, gehirn-feedback
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
- `arbeitsprotokoll.md` — Zentrale Bot-Aufgaben-Uebersicht (wer macht was)
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

Hauptstruktur unter `STUDIUM/primarlehrer/`. OneNote-Importe werden beim Import in kebab-case umbenannt (via `scripts/onenote-sync.ps1`).

```
STUDIUM/
└── primarlehrer/
    ├── README.md
    ├── srs-schedule.md
    ├── modules/
    │   ├── basisseminar-grundlagen-studium/
    │   │   ├── bpbs1-basisseminar/
    │   │   │   ├── modulbeschreibung.md
    │   │   │   ├── zusammenfassung.md
    │   │   │   ├── lernkarten.md
    │   │   │   ├── pruefungsfragen.md
    │   │   │   ├── zeitplan.md
    │   │   │   └── notizen/
    │   │   └── glst1-grundlagen-studium/
    │   └── grundlagen-modul/
    │       ├── ewbu1-bildung-und-unterricht/
    │       └── ...weitere Module
    ├── englisch/          Englisch-Unterlagen
    ├── performance/       Leistungsnachweise
    ├── calendar/          Stundenplaene, Termine
    └── checklists/        Checklisten
```

Regeln fuer STUDIUM:
- Alle Ordner- und Dateinamen in kebab-case (wie ueberall im Vault)
- Modulkuerzel als Praefix: `bpbs1-basisseminar` (nicht in Klammern)
- Jedes Modul bekommt: modulbeschreibung.md, zusammenfassung.md, lernkarten.md, pruefungsfragen.md, zeitplan.md, notizen/
- OneNote-Frontmatter (`onenote-id`) bleibt erhalten
- Leere Untitled-Stubs (nur `onenote-id`, kein Inhalt) werden bei Aufraeumung geloescht
- Neue Semester: neuer Ordner unter primarlehrer/ oder neuer Studiengang als Geschwister-Ordner

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

## 14. Prompt-Speicherort

Alle Bot-Prompts werden zentral gespeichert:

```
FAZITE/allgemein/prompts/<chat-name>-v<nr>.md
```

- Versioniert: v1, v2, v3 etc. — nur die neueste Version hat `status: aktuell`
- Prompt-Bloecke (wiederverwendbare Sektionen fuer mehrere Bots): `FAZITE/allgemein/prompt-block-<name>.md`
- Kein Bot legt Prompts an anderen Orten ab (nicht in MEMORY/, nicht in PROJEKTE/)
- Ausnahme: `MEMORY/gehirn-feedback-prompt.md` wird nach FAZITE/allgemein/prompts/ verschoben

## 15. Claude-Outputs-Cleanup

Nach jedem `device_commit_files` bleiben Dateien unter `Claude outputs/` (= /mnt/user-data/outputs/) in Obsidian sichtbar. Diese sind Duplikate und muessen bereinigt werden.

Regeln:
- `Claude outputs/` ist KEIN Vault-Ordner — er darf keine dauerhaften Dateien enthalten
- Nach jeder Session pruefen: Sind Dateien in `Claude outputs/`? → Im Cleanup-Schritt erwaehnen
- Der Gehirn-Admin loescht bei jeder Aufraeumung alle Dateien in `Claude outputs/`
- Kein Bot referenziert Dateien aus `Claude outputs/` in Wikilinks

## 16. Leere-Ordner-Regel

- Nach Abschluss einer Strukturaenderung: alle leeren Ordner entfernen
- Staging-Ordner (z.B. `import/`) nach Verarbeitung loeschen
- Alte Strukturen nach Migration entfernen (z.B. `semester-01/fhnw-bach/` wenn `primarlehrer/` die neue Struktur ist)
- Pruefung: Teil des Cleanup-Schritts bei jeder Aufraeumung

## 17. Changelog-Pflicht

- Jede strukturelle Aenderung wird in [[MEMORY/changelog]] protokolliert — BEVOR der Git-Block ausgefuehrt wird
- Gilt fuer: Ordner erstellen/loeschen/umbenennen, Dateien verschieben, Regelaenderungen
- Gilt NICHT fuer: rein inhaltliche Aenderungen an bestehenden Dateien
- Format: Datum, wer (Chat-Name), was geaendert, warum
- Wenn mehrere Bots parallel arbeiten: vor dem eigenen Commit den Changelog lesen und eigenen Eintrag anfuegen
- Changelog ist die einzige "Single Source of Truth" fuer Strukturaenderungen

## 18. Bot-Uebergabe-Protokoll (Auftraege zwischen Bots)

Wenn ein Bot einem anderen Bot eine Aufgabe uebergibt, laeuft das ueber den zentralen Auftrags-Ordner:

```
FAZITE/allgemein/auftraege/
├── gehirn-ceo-onenote-sync.md        (Auftrag AN Gehirn-CEO)
├── gehirn-admin-cleanup-2026-09-13.md (Auftrag AN Gehirn-Admin)
├── nestbau-ceo-ordnerstruktur.md      (Auftrag AN Nestbau-CEO)
└── ...
```

Dateiname: `<ziel-bot>-<thema>.md`

Pflicht-Frontmatter fuer Auftraege:
```yaml
---
title: <auftrag-thema>
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
status: offen | in-arbeit | erledigt
tags: [typ/auftrag, status/offen]
autor: <absender-bot>
ziel: <empfaenger-bot>
---
```

### Lese-Pflicht (WICHTIG)
- Jeder Bot MUSS bei Session-Start pruefen: `FAZITE/allgemein/auftraege/`
- Gibt es dort Auftraege mit seinem Namen als Ziel und `status: offen`?
- Falls ja: dem User melden, z.B. "Du hast 2 offene Auftraege fuer mich. Soll ich sie abarbeiten?"
- Diese Pruefung ist Teil des STATUS-ABFRAGEN Blocks ("Was geht ab?" zeigt auch offene Auftraege)

### Ablauf
1. Absender-Bot erstellt Auftrag in `FAZITE/allgemein/auftraege/`
2. Absender-Bot meldet dem User: "Auftrag fuer [Ziel-Bot] erstellt: [Thema]"
3. User oeffnet Ziel-Bot-Chat
4. Ziel-Bot liest Auftraege bei Session-Start
5. Ziel-Bot arbeitet Auftrag ab
6. Ziel-Bot setzt Status auf `erledigt` und updated-Datum
7. Erledigte Auftraege bleiben 30 Tage, dann loescht der Gehirn-Admin sie

### Regeln
- Ein Auftrag ist EINE Datei, nicht eine Nachricht im Chat
- Auftraege nie in PROJEKTE/, MEMORY/ oder REST/ ablegen
- Auftraege ersetzen keine direkte Kommunikation — der User entscheidet, wann welcher Bot arbeitet
- Kein Bot darf sich selbst Auftraege schreiben

## 19. Datei-Zuordnungspflicht (Anti-Duplikat)

Jede Datei im Vault MUSS genau einem Ort zugeordnet sein. Keine losen Dateien, keine Duplikate.

### Zuordnungsmatrix

| Dateityp | Gehoert nach | NICHT nach |
|---|---|---|
| Bot-Prompt | FAZITE/allgemein/prompts/ | MEMORY/, PROJEKTE/, Root |
| Prompt-Block (wiederverwendbar) | FAZITE/allgemein/ | MEMORY/, PROJEKTE/ |
| Bot-Auftrag | FAZITE/allgemein/auftraege/ | Lose im Chat, PROJEKTE/ |
| Chat-Fazit | FAZITE/<projekt>/ oder FAZITE/allgemein/ | PROJEKTE/, MEMORY/ |
| Feedback-Log | FAZITE/allgemein/ | MEMORY/ |
| PowerShell-Script | scripts/ | Claude outputs/, Root, PROJEKTE/ |
| Regel/Protokoll | MEMORY/ | FAZITE/, PROJEKTE/ |
| Projekt-Datei | PROJEKTE/<projekt>/<unterordner>/ | Root, MEMORY/ |
| Studium-Datei | STUDIUM/primarlehrer/.../ | Root, PROJEKTE/ |
| Einzelnotiz ohne Projekt | REST/ | Root |

### Verbotene Orte
- **Root-Ebene**: Keine losen Dateien (ausser .gitignore, desktop.ini etc.)
- **Claude outputs/**: Kein dauerhafter Speicher (siehe §15)
- **import/**: Nur temporaer, wird nach Verarbeitung geloescht

### Anti-Duplikat-Regeln
- Bevor ein Bot eine Datei erstellt: pruefen ob sie schon existiert (device_list_dir)
- Eine Datei existiert an GENAU einem Ort — nie an zwei
- Wenn eine Datei verschoben wird: alte Version loeschen, nicht kopieren
- Wenn zwei Dateien denselben Inhalt abdecken: zusammenfuehren (merge), nicht beide behalten
- Namensgleiche Dateien in verschiedenen Ordnern sind ein Audit-Fehler

### Bot-Pflichten bei Dateierstellung
1. Zielort bestimmen (nach Zuordnungsmatrix)
2. Pruefen ob Datei/Thema schon existiert
3. Datei am Zielort erstellen (nie woanders und dann verschieben)
4. Falls device_commit_files genutzt: im Status-Bericht erwaehnen, dass Claude outputs/ bereinigt werden muss

## 20. Aenderungskontrolle

- Strukturänderungen nur durch den Gehirn-Admin-Chat
- Inhaltliche Änderungen durch den zuständigen CEO oder Gehirn-Admin
- Alle Änderungen werden in [[MEMORY/changelog]] protokolliert

## 21. Aufräumung

- **Woechentlich** oder auf Befehl, zusaetzlich nach jeder groesseren Strukturaenderung
- Kurzer Status-Bericht im Chat (keine separate Datei)
- Pruefpunkte:
  - Veraltete Dateien (status: veraltet, aelter als 6 Monate?)
  - Duplikate (gleicher Inhalt an mehreren Orten?)
  - Leere Ordner (entfernen)
  - REST/-Inhalte (gehoeren sie in ein Projekt?)
  - Fehlende Frontmatter
  - Claude outputs/ (alle Dateien loeschen)
  - Lose Dateien auf Root (zuordnen oder loeschen)
  - FAZITE/allgemein/auftraege/ (erledigte Auftraege aelter als 30 Tage loeschen)
  - Zuordnungsmatrix (§19) — gibt es Dateien am falschen Ort?
  - Arbeitsprotokoll (§22) — erledigte Aufgaben aelter als 7 Tage entfernen

## 22. Arbeitsprotokoll

Zentrale Datei: [[MEMORY/arbeitsprotokoll]]

### Zweck
- Uebersicht aller aktiven Bots/Chats und ihrer Aufgaben (offen, in Bearbeitung, erledigt)
- Gehirn-CEO liest diese Datei bei JEDER Anfrage und gibt zuerst eine Uebersicht
- Jeder Bot traegt seine eigenen Aufgaben ein und aktualisiert den Status

### Bot-Pflichten
1. **Neue Aufgabe erhalten:** Zeile mit Status `offen` eintragen
2. **Aufgabe begonnen:** Status auf `in Bearbeitung` setzen
3. **Aufgabe abgeschlossen UND funktioniert:** Status auf `erledigt` setzen
4. **Aufgabe abgebrochen:** Zeile entfernen, Grund im Changelog

### Regeln
- `erledigt` bedeutet: getestet und funktioniert — nicht nur geschrieben
- Erledigte Aufgaben bleiben 7 Tage sichtbar, dann entfernt der Gehirn-Admin sie
- Neue Bots werden eingetragen sobald sie einen Prompt und eine Aufgabe haben
- Kein Bot loescht Eintraege anderer Bots (nur eigene oder Gehirn-Admin bei Cleanup)
