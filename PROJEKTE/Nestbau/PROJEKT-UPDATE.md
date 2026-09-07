# PROJEKT-UPDATE: Nestbau

**Stand:** 2026-09-06
**Aktualisiert von:** Code-Bot (Vault-Reorganisation)

## Status

**Gesamt-Progress:** v2.0 produktiv, Firebase Phase 1 abgeschlossen
**Aktuell:** Kein Bot aktiv. Kochbuch/Menüplan/Rezepte zuletzt überarbeitet und als Artifact veröffentlicht (05.09.2026).
**Nächster Schritt:** Firebase Phase 2 (Testing) oder GitHub-Push der lokalen Änderungen.

## Erledigt (letzte Sessions)
- Firebase Architect Phase 1: Datenmodell, Rules, Indexes, Functions-Templates
- Bot 1–4: Auth, Firestore, Kalender-Sync, Rezept-Import
- Build Optimizer: 43 Tests, CI/CD, Play-Store-Assets (Branch release/play-store)
- Kochbuch/Menüplan/Zutaten/Rezepte: zwei Feinschliff-Runden, veröffentlicht
- Release-Keystore angelegt (`~/.nestbau-keys/nestbau-release.jks`), signiertes AAB gebaut → `Nestbau/dist/nestbau-2.0.0-release.aab` (versionCode 1, 2.0.0)
- 2026-09-06: Vault konsolidiert (REQUIREMENTS/DESIGN/CODE/…); Wegwerf-Ordner `C:\nestbau-build` gelöscht; Vault-Root-`.gitignore` angelegt
- 2026-09-06: `C:\Users\indra` durchsucht – redundanten Klon `~/Nestbau` gelöscht (= origin/main); 3 Dateien aus ~/Downloads in den Vault (2 Chat-Exports + 1 Daten-Sicherung); Release-Keystore `~/.nestbau-keys/` bleibt (Secret, nicht in Vault)
- 2026-09-06: redundante Klone `C:\KI Programme\Nestbau Boter` + `C:\KI Programme\nestbau-app` gelöscht (0 uncommitted/unpushed); `.claude/launch.json` „nestbau" → Vault-Klon; Emulator `NestbauTest` (4,5 GB) gelöscht, Rebuild-Anleitung: [[Emulator-Setup]]

- 2026-09-06: Vault-Wurzel als Git-Repo initialisiert (2 Commits), `.gitignore` auf Root-Pfade angepasst, Setup-Doku unter SYSTEM/SETUP/, Auto-Sync + Backup-Scripts unter scripts/, Security-Audit durchgeführt (keine Keys im Repo)

- 2026-09-07: Nestbau-Arbeitsverzeichnis aufgeräumt, committet und gepusht (4 Commits): .gitattributes/LF-Normalisierung + Logs untracked, Kamera-Entfernung inkl. Berechtigungen, Build-Tools, Play-Store-Unterlagen. Arbeitsverzeichnis ist sauber.

- 2026-09-07: Branch-Lage analysiert und entschieden; 43 Tests + Audit-Skripte nach `main` portiert (6fa2fbe), alle grün, Security 0 hoch / Performance im Budget

- 2026-09-07: Sicherheitsbefunde behoben (2 Commits, noch nicht gepusht): XSS-Härtung der Foto-Vorschauen + sharp ^0.35.4

- 2026-09-07: Blocker „Client-ID fehlt" gelöst – die aktive `nb-config.local.js` enthielt nur Emulator-Platzhalter, die echte Google-Client-ID lag in einer zweiten Fassung unter `Claude outputs/`. Zusammengeführt, alte Fassung als `.bak-2026-09-07` daneben.

- 2026-09-07: Fix in der laufenden App verifiziert (localhost:8000): `NB.config.google.clientId` gesetzt (72 Zeichen), Google-Karte zeigt „Nicht verbunden – Verbinden", Redirect-URI der Installation stimmt mit der Registrierung überein. „Client-ID fehlt" steht jetzt nur noch bei Outlook (zurückgestellt) und Firebase (Werte fehlen noch).

## Offen
- [ ] Phase 2 Testing: Emulator, Two-Device-Sync, Offline, Error-Szenarien (~7h)
- [x] ~~Google-Client-ID in `nb-config.local.js`~~ – 07.09.2026 eingetragen (lag ungenutzt unter `Claude outputs/`), Ladetest bestätigt
- [ ] Firebase-Web-Konfiguration aus der Konsole in `nb-config.local.js` (Block liegt auskommentiert bereit), dann `firebase deploy --only firestore:rules,storage`
- [x] ~~GitHub-Push Kildro93/Nestbau~~ – erledigt 2026-09-07: 4 Commits auf `main` gepusht (4bbd515..6e689ce)
- [x] ~~Erst-Push des Vault-Repos~~: Repo `Kildro93/Obsidion-Claud` existiert auf GitHub. Push via Token (siehe [[SETUP-GITHUB-TOKEN]])
- [ ] Auto-Sync- und Backup-Aufgabe registrieren (`scripts/install-autosync-task.ps1`, `scripts/install-backup-task.ps1`)
- [ ] Firebase-API-Key in der Cloud Console auf eigene Domains einschränken (siehe [[SECURITY-AUDIT]])
- [x] ~~Branch-Entscheidung~~ – entschieden 2026-09-07: `main` geht in den Play Store, Tests aus `release/play-store` portiert, `master` ist ein eigenes Projekt. Begründung: [[Branch-Entscheidung]]
- [x] ~~XSS-Befunde entschärft~~ – 2026-09-07: Foto-Vorschauen über DOM-API, Attribute escaped, Audit 0/0/0
- [x] ~~sharp-Schwachstelle~~ – 2026-09-07: auf ^0.35.4, npm audit 0 Schwachstellen
- [ ] Tasks zu Firestore-Subsammlung refaktorieren (Perf)
- [ ] Multi-Device-Konflikt-Resolution
- [ ] Prüfen: Service Worker registrierte sich in der Vorschau-Ansicht nicht („unknown error when fetching the script"), obwohl `/sw.js` mit 200 und `text/javascript` ausgeliefert wird. Vermutlich eine Einschränkung der Vorschau, nicht der App — in Chrome gegenprüfen (DevTools → Application → Service Workers)

## Blockers
- Play Store: GitHub Pages aktivieren (Mensch). Signaturschlüssel ✅ erledigt.
- ~~Vault-Wurzel → GitHub: verschachtelte `.git` klären~~ erledigt 2026-09-06: beide Ordner bleiben eigene Repos, per `.gitignore` ausgeschlossen

## Wichtigste Dateien
- Einstieg: [[README]]
- Ergebnisse: [[INDEX|Chat-Exports/INDEX]]
- Learnings: [[PROJEKT-LEARNINGS]]
- Struktur: [[PROJEKT-LOOP]] · [[VERKNUEPFUNGEN]]
- Features: [[Features]] / [[NESTBAU_AKTUELL]]
- Code: [[CODE-Landkarte]]

**Tipps für nächsten Bot:** Vor Code-Änderung Bereich per grep lokalisieren. Nach jedem Batch `node --check`. Tests nur über UI, nie über App-Closures. Light/Dark-Screenshot-Review vor Publish.
