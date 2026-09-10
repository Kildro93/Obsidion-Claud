# 2026-09-07 – Vault-Setup, Repo-Cleanup, Integrationen ans Laufen gebracht

**Rolle:** CEO-Chat (Setup + Aufräumen, kein Feature-Bot)
**Dauer:** 06.–10.09.2026
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

### 6. Integrationen ans Laufen gebracht (07.–08.09.)
- **Google Kalender:** OAuth komplett neu aufgesetzt. Die Client-ID in der Konfiguration existierte bei Google nicht — das Projekt hatte nie einen OAuth-Client. Zustimmungsbildschirm („Nestbau Haushalt"), Web-Client, Testnutzer, Kalender-API. Sync läuft, vier Kalender erkannt.
- **Firebase:** Web-Konfiguration eingetragen, Google als Anmeldeanbieter aktiviert (vorher nur E-Mail/Passwort), Firestore- und Storage-Regeln ausgerollt. Anmeldung verbunden.
- **Drei Code-Bugs gefunden und behoben:** Manifest verwies auf ein SVG statt auf die vorhandenen PNGs; Emulator-Modus hing am Hostnamen und zwang jeden lokalen Lauf gegen nicht laufende Emulatoren; Firestore-Regeln kannten `lists`, `events`, `subscriptions` nicht.

### 7. Phase 2 Testing begonnen (08.09.)
- Test 1 (Haushalt anlegen) bestanden, Beitrittscode `KJS7DB90`.
- Test 2 (Kochbuch hochladen) scheiterte: die Migration brach beim ersten Schreibvorgang ab, weil `lists` keine Regel hatte. Ursache statisch gefunden, Regeln ergänzt (76cd20e).
- Tests 3–9 stehen aus.

## Status

| Bereich | Stand |
|---|---|
| Vault-Repo | synchron, Auto-Sync aktiv |
| Nestbau `main` | `79964e3` gepusht, Arbeitsverzeichnis sauber |
| Tests | 43/43 grün |
| Security-Audit App | 0 hoch / 0 mittel / 0 niedrig |
| Performance | alle Budgets eingehalten (38,7 KB gzip, Boot 203 ms) |
| npm audit | 0 Schwachstellen |
| Google-Kalender-Sync | läuft (Token nur 1 h gültig, siehe unten) |
| Firebase-Anmeldung | verbunden |
| Firestore-/Storage-Regeln | ausgerollt; Nachtrag für lists/events/subscriptions committet, Deploy-Status unbestätigt |
| Kochbuch-Upload | offen — nach dem Regel-Deploy erneut versuchen |

## Wichtigste Erkenntnisse

1. **GitHub Actions kann keinen lokalen Vault syncen.** Der Workflow läuft in der Cloud und sieht die Dateien auf dem PC nicht. Lokal → GitHub geht nur über einen Prozess auf dem PC (Task Scheduler).
2. **`.gitignore`-Muster ohne führenden Slash greifen auf jeder Ebene.** `Nestbau/` hätte auch `PROJEKTE/Nestbau/` ausgeschlossen. Immer `/Nestbau/` schreiben, wenn nur der Root gemeint ist.
3. **CRLF-Rauschen erkennen:** `git diff --ignore-all-space --stat` gegen `git diff --stat` halten. 44 „geänderte" Dateien waren real 10. Dauerfix ist `.gitattributes` mit `* text=auto eol=lf`.
4. **Branch ohne gemeinsame History ist kein Merge-Kandidat.** `git merge-base A B` liefert nichts → eigenes Projekt, eigenes Repo.
5. **Gut geschriebene Tests altern langsam.** Die 43 Tests aus einem 19 Commits alten Branch liefen ohne eine einzige Anpassung gegen den aktuellen Stand.
6. **`innerHTML` mit interpoliertem Wert ist auch bei eigenen Daten angreifbar**, sobald es einen Import-Pfad gibt. Muster: `createElement` statt String-Bau, sonst `escapeHtml()` um jeden Attributwert.

## Nächste Schritte

Als Erstes beim nächsten Mal:
1. `firebase deploy --only firestore:rules` im Nestbau-Ordner (der letzte Lauf wurde nicht bestätigt — läuft er durch, ist er auch beim zweiten Mal harmlos)
2. `node scripts/server.mjs --port 8000`, dann „Kochbuch hochladen" — sollte jetzt durchlaufen
3. Weiter mit Test 3–5 aus [[Phase-2-Testplan]]

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

- **Kochbuch-Upload nicht abgeschlossen.** Regeln ergänzt und committet, Deploy nicht bestätigt. Danach erneut versuchen.
- **Google-Token läuft nach 1 Stunde ab.** PKCE im Browser liefert kein Refresh-Token, der 15-Minuten-Auto-Sync greift nur innerhalb dieser Stunde. Dauerhafte Lösung nur serverseitig: Token-Tausch über Cloud Function, Code liegt ungenutzt in `nestbau-firebase/functions/src/tokens.js`.
- **Multi-Device-Konflikte:** Konzept liegt vor ([[Konzept-Multi-Device-Konflikte]]), Option A empfohlen (~1–2 h). Beim Codelesen fiel ein Fall auf, der ohne Offline-Phase auftritt: der Upload ist 1,2 s verzögert, trifft in diesem Fenster ein fremder Snapshot ein, überschreibt er die eigene Änderung, bevor sie gesendet wurde.
- **Clientschlüssel des OAuth-Clients** war in einem Screenshot sichtbar und wird nicht gebraucht (PKCE) — bei Gelegenheit in der Console löschen.
- Keine weiteren Blocker. Der Vault-Klon war zwei Tage ohne `fetch` – bei nächster längerer Pause zuerst `git fetch`, sonst wieder non-fast-forward.
- `master` bleibt als fremder Branch im App-Repo liegen; kein Fehler, aber dauerhaft verwirrend.

## Tipps für zukünftige Chats

- Vor Code-Änderung: `git fetch` und `git rev-list --left-right --count origin/main...main`
- Pushen kann nur der PC – die Cloud-Session hat keine Token. Committen geht, Push meldet „could not read Username".
- Nach Änderungen an `index.html`: `npm test` (43 Tests) und `npm run audit:security` laufen lassen, beides dauert unter 30 Sekunden.
- Lokal starten immer mit `--port 8000`. Die OAuth-Weiterleitung ist auf diesen Port registriert, der Standard 3000 scheitert mit `redirect_uri_mismatch`.
- Bei jeder Erweiterung von `NB.cloud.COLLECTIONS`: Sammlungsnamen gegen die `match`-Blöcke in `firestore.rules` halten. Der Auffangblock sperrt neue Sammlungen lautlos.
- Werte, die ein früherer Chat „erzeugt" hat, ohne dass sie jemand aus einer Console kopiert hat, sind unbestätigt. Eine erfundene Client-ID ist am Format nicht von einer echten zu unterscheiden.
- `npm install` ist Pflicht nach dem Pull – `jsdom` und `sharp` haben sich geändert.
