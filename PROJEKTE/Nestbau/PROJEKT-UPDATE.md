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

## Offen
- [ ] Phase 2 Testing: Emulator, Two-Device-Sync, Offline, Error-Szenarien (~7h)
- [ ] Client-IDs in `nb-config.local.js` eintragen, `firebase deploy --only firestore:rules,storage`
- [ ] GitHub-Push Kildro93/Nestbau (aus Cloud blockiert → lokal via Claude Code)
- [ ] Branch-Entscheidung: welche Fassung geht in den Play Store
- [ ] Tasks zu Firestore-Subsammlung refaktorieren (Perf)
- [ ] Multi-Device-Konflikt-Resolution

## Blockers
- GitHub-Push aus Cloud-Session: 403 (Repo nicht in Session-Sources) → lokal pushen
- Nestbau-Repo hat 21 uncommittete Änderungen (Build-Optimizer-/Play-Store-Arbeit nie committet)
- Play Store: GitHub Pages aktivieren (Mensch). Signaturschlüssel ✅ erledigt.
- Vault-Wurzel → GitHub: vor Push verschachtelte `.git` (Nestbau/, nestbau-firebase/) klären, siehe Root-`.gitignore`

## Wichtigste Dateien
- Einstieg: [[README]]
- Ergebnisse: [[INDEX|Chat-Exports/INDEX]]
- Learnings: [[PROJEKT-LEARNINGS]]
- Struktur: [[PROJEKT-LOOP]] · [[VERKNUEPFUNGEN]]
- Features: [[Features]] / [[NESTBAU_AKTUELL]]
- Code: [[CODE-Landkarte]]

**Tipps für nächsten Bot:** Vor Code-Änderung Bereich per grep lokalisieren. Nach jedem Batch `node --check`. Tests nur über UI, nie über App-Closures. Light/Dark-Screenshot-Review vor Publish.
