# 2026-09-07 – Vault-Setup, Repo-Cleanup, Branch-Entscheidung

**Rolle:** CEO-Chat (Setup + Aufräumen, kein Feature-Bot)
**Dauer:** 06.–07.09.2026
**Repos berührt:** `Kildro93/Obsidion-Claud` (Vault), `Kildro93/Nestbau` (App)

## Abgeschlossene Aufgaben

### 1. Vault-Betrieb aufgesetzt
- Vault-Wurzel als Git-Repo initialisiert, `.gitignore` auf Root-Pfade verankert
- Setup-Doku unter `SYSTEM/SETUP/`: PROJEKT-CREDENTIALS, SETUP-GITHUB-TOKEN, SETUP-FIREBASE, SETUP-ENV-LOCAL, AUTO-SYNC, BACKUP-STRATEGY, SECURITY-AUDIT, CHECKLIST
- `SYSTEM/QUICK-START.md` (Einstieg für neue Chats) und `SYSTEM/DEBUGGING.md` (Fehlerbilder)
- Scripts unter `scripts/`: `vault-sync.ps1`, `install-autosync-task.ps1`, `weekly-backup.ps1`, `install-backup-task.ps1`, `push.ps1`
- Auto-Sync läuft produktiv (Windows-Aufgabe, alle 30 Min, Log unter `scripts/logs/vault-sync.log`)

### 2. Security-Audit Vault
- Keine PATs, Anthropic-Keys oder privaten Schlüssel im Repo
- Keystore-Passwörter untracked und ignoriert
- `obsidian42-brat/data.json` aus dem Tracking genommen (Feld für GitHub-PAT)

### 3. Nestbau-Repo aufgeräumt (4 Commits + Push)
- `.gitattributes` für LF-Zeilenenden, `emulator.log`/`firestore-debug.log` untracked
- Kamera-Entfernung inkl. reduzierter Berechtigungen committet
- Build-Tools und Play-Store-Unterlagen committet
- Push nach `git fetch` + `git rebase origin/main` (non-fast-forward gelöst)

### 4. Branch-Entscheidung getroffen
- `main` geht in den Play Store
- `release/play-store` nicht gemergt (TWA-Weg), nur Tests + Audit-Skripte portiert
- `master` ist ein eigenes Projekt ohne gemeinsame History
- Details: [[Branch-Entscheidung]]

### 5. Tests und Sicherheitshärtung
- 43 Tests + `health-check`, `security-check`, `perf-audit`, `server`, `error-report` nach `main` portiert, 43/43 grün
- XSS-Härtung: vier Foto-Vorschauen über DOM-API (`setPhotoPreview`), zwei HTML-String-Stellen escaped → Audit von 0/2/6 auf **0/0/0**
- `sharp` auf ^0.35.4 → `npm audit` 0 Schwachstellen

## Status

| Bereich | Stand |
|---|---|
| Vault-Repo | synchron, Auto-Sync aktiv |
| Nestbau `main` | `79964e3` gepusht, Arbeitsverzeichnis sauber |
| Tests | 43/43 grün |
| Security-Audit App | 0 hoch / 0 mittel / 0 niedrig |
| Performance | alle Budgets eingehalten (38,7 KB gzip, Boot 203 ms) |
| npm audit | 0 Schwachstellen |

## Wichtigste Erkenntnisse

1. **GitHub Actions kann keinen lokalen Vault syncen.** Der Workflow läuft in der Cloud und sieht die Dateien auf dem PC nicht. Lokal → GitHub geht nur über einen Prozess auf dem PC (Task Scheduler).
2. **`.gitignore`-Muster ohne führenden Slash greifen auf jeder Ebene.** `Nestbau/` hätte auch `PROJEKTE/Nestbau/` ausgeschlossen. Immer `/Nestbau/` schreiben, wenn nur der Root gemeint ist.
3. **CRLF-Rauschen erkennen:** `git diff --ignore-all-space --stat` gegen `git diff --stat` halten. 44 „geänderte" Dateien waren real 10. Dauerfix ist `.gitattributes` mit `* text=auto eol=lf`.
4. **Branch ohne gemeinsame History ist kein Merge-Kandidat.** `git merge-base A B` liefert nichts → eigenes Projekt, eigenes Repo.
5. **Gut geschriebene Tests altern langsam.** Die 43 Tests aus einem 19 Commits alten Branch liefen ohne eine einzige Anpassung gegen den aktuellen Stand.
6. **`innerHTML` mit interpoliertem Wert ist auch bei eigenen Daten angreifbar**, sobald es einen Import-Pfad gibt. Muster: `createElement` statt String-Bau, sonst `escapeHtml()` um jeden Attributwert.

## Nächste Schritte

Braucht dich:
- [ ] Backup-Aufgabe registrieren: `powershell -ExecutionPolicy Bypass -File ".\scripts\install-backup-task.ps1"`
- [ ] Firebase-API-Key in der Cloud Console auf eigene Domains einschränken ([[SETUP-FIREBASE]], Abschnitt 4)
- [ ] Client-IDs in `Nestbau/js/nb-config.local.js` eintragen, dann `firebase deploy --only firestore:rules,storage`
- [ ] Keystore + Passwörter ausser Haus sichern ([[BACKUP-STRATEGY]], Ebene 3)
- [ ] GitHub-Token läuft in 90 Tagen ab – Kalendereintrag

Kann ein Bot übernehmen:
- [ ] Phase 2 Testing: Emulator, Two-Device-Sync, Offline, Fehlerszenarien (~7h) – blockiert bis Client-IDs stehen
- [ ] Multi-Device-Konflikt-Resolution (Konzept + Umsetzung)
- [ ] Tasks zu Firestore-Subsammlung refaktorieren (Perf)
- [ ] Entscheiden, ob `master` in ein eigenes Repo `nestbau-firebase` umzieht

## Dateipfade

```
SYSTEM/QUICK-START.md                          Einstieg für neue Chats
SYSTEM/DEBUGGING.md                            Fehlerbilder Git, Sync, App
SYSTEM/SETUP/                                  8 Setup-Dokumente inkl. CHECKLIST
scripts/                                       5 PowerShell-Scripts + logs/
PROJEKTE/Nestbau/Fact-Sheets/Branch-Entscheidung.md
Nestbau/tests/                                 43 Tests
Nestbau/scripts/                               health-check, security-check, perf-audit
```

## Offene Probleme

- Keine Blocker. Der Vault-Klon war zwei Tage ohne `fetch` – bei nächster längerer Pause zuerst `git fetch`, sonst wieder non-fast-forward.
- `master` bleibt als fremder Branch im App-Repo liegen; kein Fehler, aber dauerhaft verwirrend.

## Tipps für zukünftige Chats

- Vor Code-Änderung: `git fetch` und `git rev-list --left-right --count origin/main...main`
- Pushen kann nur der PC – die Cloud-Session hat keine Token. Committen geht, Push meldet „could not read Username".
- Nach Änderungen an `index.html`: `npm test` (43 Tests) und `npm run audit:security` laufen lassen, beides dauert unter 30 Sekunden.
- `npm install` ist Pflicht nach dem Pull – `jsdom` und `sharp` haben sich geändert.
