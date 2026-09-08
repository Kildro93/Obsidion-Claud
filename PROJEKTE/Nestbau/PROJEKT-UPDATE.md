# PROJEKT-UPDATE: Nestbau

**Stand:** 2026-09-07
**Aktualisiert von:** Code-Bot (Vault-Reorganisation)

## Status

**Gesamt-Progress:** v2.0 produktiv, Firebase Phase 1 abgeschlossen
**Aktuell:** Kein Bot aktiv. Google-Kalender-Sync und Firebase-Anmeldung laufen, Regeln sind ausgerollt (07.09.2026).
**Nächster Schritt:** Phase 2 Testing – Two-Device-Sync, Offline, Fehlerszenarien.

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

- 2026-09-07: Manifest-Fehler behoben – Chrome meldete „icon.svg failed to load" und fehlende quadratische Icons; das Manifest verwies nur auf das SVG, die PNGs (192/512) lagen ungenutzt unter `assets/icons/`. Verlinkt, `build-web.js` kopiert `assets/` jetzt mit.

- 2026-09-07: **Google-Kalender-Sync läuft.** OAuth neu aufgesetzt: Zustimmungsbildschirm („Nestbau Haushalt"), Web-Client `Nestbau Web (lokal)` im Projekt nestbau-app, Client-ID in `nb-config.local.js`. Abgleich erfolgreich, vier Kalender erkannt.

- 2026-09-07: **Firebase-Anmeldung läuft.** Web-Konfiguration in `nb-config.local.js` eingetragen, Emulator-Zwang im Code entfernt, Google als Anmeldeanbieter in Firebase Authentication aktiviert (vorher nur E-Mail/Passwort). Kochbuch-Cloud verbunden.

- 2026-09-07: Firestore- und Storage-Regeln ausgerollt (`firebase deploy`), `.firebaserc` mit Standardprojekt angelegt. Damit ist Phase 1 der Firebase-Einrichtung abgeschlossen.

- 2026-09-08: Test 1–3 begonnen. Haushalt angelegt (Code KJS7DB90), Upload blieb hängen. **Ursache statisch gefunden:** die Firestore-Regeln kannten `lists`, `events` und `subscriptions` nicht — der Sync deckt sie seit der Erweiterung von `NB.cloud.COLLECTIONS` ab, die Regeln nicht. Der Auffangblock sperrte sie, und `lists` steht in der Schreibreihenfolge an erster Stelle. Regeln ergänzt (Commit 76cd20e), noch **nicht ausgerollt**.

## Offen
- [ ] `firebase deploy --only firestore:rules` — die ergänzten Regeln für lists/events/subscriptions ausrollen, **danach** Upload erneut versuchen
- [ ] Phase 2 Testing fortsetzen: Test 2 wiederholen, dann Test 3–5 — Testplan: [[Phase-2-Testplan]]
- [ ] Google-Kalender: Token läuft nach 1 h ab, danach „Neu anmelden" nötig. PKCE im Browser liefert kein Refresh-Token. Dauerhafte Lösung: Token-Tausch über Cloud Function (Code existiert in `nestbau-firebase/functions/src/tokens.js`, nicht ausgerollt)
- [x] ~~Google-Client-ID in `nb-config.local.js`~~ – 07.09.2026 eingetragen (lag ungenutzt unter `Claude outputs/`), Ladetest bestätigt
- [x] ~~Firebase-Web-Konfiguration~~ – 07.09.2026 eingetragen, Anmeldung verbunden
- [x] ~~`firebase deploy --only firestore:rules,storage`~~ – 07.09.2026 ausgerollt, beide Regelsätze kompiliert und freigegeben
- [x] ~~Firestore-Datenbank~~ – existiert, Indexes wurden gelesen
- [ ] Clientschlüssel des OAuth-Clients bei Google löschen (wird nicht gebraucht, PKCE)
- [ ] Vor dem Play-Store-Release: Weiterleitungs-URI der Produktionsdomain im OAuth-Client ergänzen (aktuell nur `http://localhost:8000/oauth-callback.html`)
- [x] ~~GitHub-Push Kildro93/Nestbau~~ – erledigt 2026-09-07: 4 Commits auf `main` gepusht (4bbd515..6e689ce)
- [x] ~~Erst-Push des Vault-Repos~~: Repo `Kildro93/Obsidion-Claud` existiert auf GitHub. Push via Token (siehe [[SETUP-GITHUB-TOKEN]])
- [ ] Auto-Sync- und Backup-Aufgabe registrieren (`scripts/install-autosync-task.ps1`, `scripts/install-backup-task.ps1`)
- [ ] Firebase-API-Key in der Cloud Console auf eigene Domains einschränken (siehe [[SECURITY-AUDIT]])
- [x] ~~Branch-Entscheidung~~ – entschieden 2026-09-07: `main` geht in den Play Store, Tests aus `release/play-store` portiert, `master` ist ein eigenes Projekt. Begründung: [[Branch-Entscheidung]]
- [x] ~~XSS-Befunde entschärft~~ – 2026-09-07: Foto-Vorschauen über DOM-API, Attribute escaped, Audit 0/0/0
- [x] ~~sharp-Schwachstelle~~ – 2026-09-07: auf ^0.35.4, npm audit 0 Schwachstellen
- [ ] Tasks zu Firestore-Subsammlung refaktorieren (Perf)
- [ ] Multi-Device-Konflikt-Resolution — Konzept liegt vor: [[Konzept-Multi-Device-Konflikte]], empfohlen ist Option A (~1–2 h), erst nach Test 7
- [ ] Optional: Screenshots ins Manifest für die schönere Installations-UI (6 Stück à 1080x1920 liegen unter `play-store/screenshots/`; bewusst weggelassen, weil sie ~900 KB ins App-Bundle ziehen würden)
- [ ] Design-Frage: `icon.svg` nutzt noch die alte Palette (Petrol/Grün `#1c7d70`/`#4a6741`), `theme_color` ist Orange `#FF8C42`
- [x] ~~Service-Worker-Frage~~ – 07.09.2026 in Chrome geprüft: „#487 activated and is running". Die Registrierung scheitert nur in der Vorschau-Ansicht, die App ist in Ordnung.

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
