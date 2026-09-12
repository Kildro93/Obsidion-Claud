# PROJEKT-UPDATE: Nestbau

**Stand:** 2026-09-12
**Aktualisiert von:** Design-System-Bot (Claude Code)

## Status

**Gesamt-Progress:** v2.0 produktiv, Firebase Phase 1 abgeschlossen, Design-System-Bug behoben
**Aktuell:** Kein Bot aktiv. Google-Kalender-Sync und Firebase-Anmeldung laufen, Design konsistent auf `claude/new-session-je60jy` (PR noch nicht erstellt).
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

- 2026-09-10: **Phase-2-Kernpfad bestanden** (Tests 1–5). Zwei weitere Ursachen gefunden: Brave Shields blockten `firestore.googleapis.com` im zweiten Profil (`ERR_BLOCKED_BY_CLIENT`), und ein vermeintlicher Beitritt der Partnerin hatte nie stattgefunden — die App zeigt die Haushalts-ID aus dem lokalen Speicher, ohne sie beim Server zu prüfen.
- 2026-09-10: **Abgleich ohne Schalter umgebaut** (97583da): Speichern geht immer nach Firebase, der Live-Abgleich startet beim Laden, nach Auth-Wechsel und nach Netzunterbrechung von selbst. Eintreffende Snapshots überschreiben keine lokal geänderten, noch nicht hochgeladenen Dokumente mehr.

- 2026-09-12: **Design-System-Bug gefunden und behoben.** Ursache für „Design nicht konsistent": `index.html` hatte ein dupliziertes Inline-`<style>` mit der alten Palette (`#1c7d70`/`#4a6741`/`#8B4545`), das nach dem `<link>` zu `nestbau-design.css` stand und die neue Palette per Cascade überschrieb — deckt sich mit dem in `BUILD-GUIDE.md` § 10 unabhängig dokumentierten Befund. ~150 Zeilen dupliziertes/widersprüchliches CSS aus `index.html` entfernt, nur app-spezifische Styles (Kalender/Uhr/Kochbuch/Menüplan) bleiben inline. Zusätzlich mehrere WCAG-AA-Kontrastfehler in der neuen Palette gefunden (weisser Text auf hellen Orange/Peach/Grün-Verläufen, teils nur 1,6:1 statt 4,5:1) und behoben: neue Variablen `--on-warm`, `--flame-fg` (dunkler), `--amber-fg`, `--secondary-green-fg`, vereinheitlichtes `--maroon`. `.icon-btn`/`.todo-add-btn` auf 48×48px Touch-Targets gebracht. Alte Farben auch in `icon.svg` (jetzt Orange→Peach-Verlauf, Grün-Akzent), `capacitor.config.json`, `tools/generate-assets.js`, `firebase-bridge.html` ersetzt.
- 2026-09-12: **Mit `main` gemergt, PR erstellt und gemergt.** `main` war seit Branch-Erstellung um 20+ Commits weiter (Bots 1–4, Firebase-Sync, Testsuite, Play-Store-Pipeline) und hatte den Design-Bug unabhängig mit einem eigenen, unvollständigen Patch (andere Hex-Werte, Duplikat blieb bestehen) angefasst — Konflikt in `index.html`/`tools/generate-assets.js` zugunsten der tatsächlichen Ursachenbehebung aufgelöst. `npm test` (43/43) und `npm run audit:security` (0 Befunde) grün. Icon-/Splash-/Store-Assets per `npm run assets` mit der neuen Palette neu erzeugt (Android-Launcher alle Dichten, PWA-Icons, Play-Store-Icon + Feature-Graphic). PR #1 auf Freigabe hin gemergt (91197f5), Branch `claude/new-session-je60jy` kann gelöscht werden. Design-System ist damit auf `main` konsistent.

## Offen
- [x] ~~`firebase deploy --only firestore:rules`~~ – 10.09.2026 ausgerollt, Upload läuft
- [x] ~~Phase 2, Test 1–5~~ – 10.09.2026 bestanden (Haushalt, Upload, Beitritt, Sync in beide Richtungen)
- [ ] Google-Kalender: Token läuft nach 1 h ab, danach „Neu anmelden" nötig. PKCE im Browser liefert kein Refresh-Token. Dauerhafte Lösung: Token-Tausch über Cloud Function (Code existiert in `nestbau-firebase/functions/src/tokens.js`, nicht ausgerollt)
- [x] ~~Google-Client-ID in `nb-config.local.js`~~ – 07.09.2026 eingetragen (lag ungenutzt unter `Claude outputs/`), Ladetest bestätigt
- [x] ~~Firebase-Web-Konfiguration~~ – 07.09.2026 eingetragen, Anmeldung verbunden
- [x] ~~`firebase deploy --only firestore:rules,storage`~~ – 07.09.2026 ausgerollt, beide Regelsätze kompiliert und freigegeben
- [x] ~~Firestore-Datenbank~~ – existiert, Indexes wurden gelesen
- [ ] Clientschlüssel des OAuth-Clients bei Google löschen (wird nicht gebraucht, PKCE)
- [ ] Vor dem Play-Store-Release: Weiterleitungs-URI der Produktionsdomain im OAuth-Client ergänzen (aktuell nur `http://localhost:8000/oauth-callback.html`)
- [x] ~~GitHub-Push Kildro93/Nestbau~~ – erledigt 2026-09-07: 4 Commits auf `main` gepusht (4bbd515..6e689ce)
- [x] ~~Erst-Push des Vault-Repos~~: Repo `Kildro93/Obsidion-Claud` existiert auf GitHub. Push via Token (siehe [[SETUP-GITHUB-TOKEN]])
- [x] ~~Auto-Sync- und Backup-Aufgabe~~ – 07.09.2026 registriert und getestet
- [x] ~~Firebase-API-Key auf eigene Domains eingeschränkt~~ – erledigt
- [x] ~~Branch-Entscheidung~~ – entschieden 2026-09-07: `main` geht in den Play Store, Tests aus `release/play-store` portiert, `master` ist ein eigenes Projekt. Begründung: [[Branch-Entscheidung]]
- [x] ~~XSS-Befunde entschärft~~ – 2026-09-07: Foto-Vorschauen über DOM-API, Attribute escaped, Audit 0/0/0
- [x] ~~sharp-Schwachstelle~~ – 2026-09-07: auf ^0.35.4, npm audit 0 Schwachstellen
- [ ] Tasks zu Firestore-Subsammlung refaktorieren (Perf)
- [x] ~~Multi-Device-Konflikte, Option A~~ – 10.09.2026 umgesetzt: der 1,2-Sekunden-Fall ist geschlossen, offene lokale Änderungen überleben einen Snapshot und werden danach hochgeladen. Offen bleibt nur der echte Offline-Konflikt (beide Geräte ändern dasselbe Dokument offline) — dort gewinnt weiterhin der letzte Schreibvorgang, siehe [[Konzept-Multi-Device-Konflikte]]
- [ ] Test 6–9 (Offline, Konflikt, Regeln, falscher Code) aus [[Phase-2-Testplan]]
- [ ] Optional: Screenshots ins Manifest für die schönere Installations-UI (6 Stück à 1080x1920 liegen unter `play-store/screenshots/`; bewusst weggelassen, weil sie ~900 KB ins App-Bundle ziehen würden)
- [x] ~~Design-Frage: `icon.svg` nutzt noch die alte Palette~~ – 12.09.2026 behoben, siehe Eintrag oben (Commit `eebccee`)
- [x] ~~Service-Worker-Frage~~ – 07.09.2026 in Chrome geprüft: „#487 activated and is running". Die Registrierung scheitert nur in der Vorschau-Ansicht, die App ist in Ordnung.
- [x] ~~PR #1 (`claude/new-session-je60jy` → `main`)~~ – 12.09.2026 gemergt (91197f5)

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
