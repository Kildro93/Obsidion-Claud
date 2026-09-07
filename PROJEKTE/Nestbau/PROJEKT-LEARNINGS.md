# PROJEKT-LEARNINGS: Nestbau

**Zweck:** Zentrale Sammlung von Erkenntnissen aus abgeschlossenen Bot-Sessions – für den CEO und zukünftige Projekte.
**Last Updated:** 2026-09-06

Detailtiefe in den Knowledge-Docs: [[nestbau-tech]], [[nestbau-testing]], [[haushalts-app]], [[NESTBAU-KNOWLEDGE-INDEX]].

## Top 5 Erkenntnisse

### 1. Firestore Security Rules vereinigen sich mit OR
- Was gelernt: Eine `match /{document=**}`-Catch-all-Regel hebt jede spezifischere Regel auf – jeder Angemeldete kann dann alles lesen.
- Relevant für zukünftige Projekte: Ja, für jedes Firebase-Projekt.
- Fix: Keine Catch-all-Regel. Spezifische Matches, Rest ist implizit deny.

### 2. Email-Verifikation ist ein manueller Prozess
- Was gelernt: `generateEmailVerificationLink()` erzeugt nur einen Link, verschickt nichts.
- Relevant: Ja, bei jedem Auth-Flow mit Firebase.
- Fix: Link erzeugen → in `mail`-Collection schreiben → Extension "Trigger Email from Firestore" versendet.

### 3. Cloud-Sessions haben einen Git-Proxy
- Was gelernt: Push zu Kildro93/Nestbau aus einer Cloud-Session schlägt mit 403 fehl, wenn das Repo nicht in den autorisierten Sources der Session ist.
- Relevant: Ja, für jedes Projekt mit GitHub-Push aus der Cloud.
- Fix: Repo in Session-Sources freigeben ODER lokal via Claude Code (eigene GitHub-Credentials) pushen.

### 4. CSS-Spezifität versteckt Dark-Mode-Bugs
- Was gelernt: Wiederverwendung von `.chip-btn.active` übersteuerte per Spezifität die Kachel-Farbe – nur im Dunkelmodus sichtbar.
- Relevant: Ja, bei jedem UI-Projekt mit Theme-Umschaltung.
- Fix: Eigene Klasse statt Wiederverwendung; Screenshot-Review in BEIDEN Themes, Code-Lesen reicht nicht.

### 5. Migrationslogik bei jeder Datenmodell-Änderung mitdenken
- Was gelernt: String→Array-Umstellungen (Menüplan-Slots, Vitamine, Utensilien, Dish-Kategorien) brechen bestehende gespeicherte Zustände beim nächsten Laden.
- Relevant: Ja, bei jeder App mit persistiertem State.
- Fix: Migration beim Laden (alte Form erkennen, konvertieren), Alt-Daten nie erfinden.

## Best Practices & Patterns

### Mirror-Collection für Datenschutz
- Beschreibung: Privates Profil (`profiles/{uid}`) + öffentliche Mitglieder-Karte (`households/{hid}/members/{uid}`), Cloud Function kopiert selektiv (immer: Name/Farbe/Rolle; nie: Alter/Gewicht).
- Wann nutzen: Wenn Mitglieder Teildaten anderer brauchen, aber nicht alles.
- Vorsicht: Function muss bei jeder Profiländerung laufen.

### Hash-Diffs für Sync
- Beschreibung: SHA(altes JSON) ≠ SHA(neues JSON) → nur geänderte Docs hochladen. `applyingRemote`-Flag verhindert persist() während Remote-Update.
- Wann nutzen: localStorage ↔ Cloud Sync.
- Vorsicht: Ohne Flag entstehen Sync-Loops.

### Feature-Batches an einen detailliert gebrieften Subagenten delegieren
- Beschreibung: Große, klar spezifizierte Batches (inkl. Testing + Publish) laufen zuverlässig, wenn Dateistruktur, IDs, CSS-Klassen und Datenmodell vollständig mitgegeben werden.
- Wann nutzen: Klar abgegrenztes Feature mit bekannter Codebasis.
- Vorsicht: Bei unklarer Spezifikation zerfasert das Ergebnis.

### Bilder extern (Storage), nicht in Firestore
- Beschreibung: Firestore-Doc max 1 MiB. Base64 → Storage-URL, Content-Hash gegen Duplikate.
- Wann nutzen: Sobald Fotos/Uploads im Spiel sind.

### PKCE-OAuth, nie Client-Secret im Frontend
- Beschreibung: State + Code Challenge/Verifier. Tokens nur im `Authorization: Bearer`-Header, nie in URL/Query.

## Häufige Fehler & Lösungen

| Fehler | Grund | Lösung | Verhindert durch |
|--------|-------|--------|------------------|
| Export überschrieb sich selbst | `run()` überschrieb alten `pushed`-State | `pushLocal()` frisch laden vor Überschreiben | Hash-Diff-Pattern |
| Zweites Gerät löschte Cloud-Daten | Leerer Haushalt beim Beitritt → Snapshot überschrieb Kochbuch | `watch()` prüft Migration-Marker vor Apply | Migration-Marker |
| Service Worker cachte JSON als HTML | SW cachte alle GETs | SW nur eigene Routes, Callback nie cachen | Explizite Cache-Liste |
| Playwright-Test rief `uid()`/`state` | Private Funktionen in der App-IIFE | Tests nur über sichtbare UI-Interaktionen | Test-Regel im Loop |
| SSRF auf Private-IP-Ranges | `fetch(userUrl)` ungeprüft | Blocklist 10.0.0.0/8, 169.254.0.0/16; max 3 Redirects mit IP-Check | SSRF-Schutz-Pattern |
| Token im Klartext gespeichert | Direkt in DB geschrieben | SHA-256-Hash vor DB-Speicherung | — |
| `node --test` mit `shell:true` fand 0 Tests, meldete Erfolg | Shell frisst das Glob-Muster | `shell:false` | — |
| Prüfskript grün trotz offener Punkte | Exit-Code nicht gesetzt | `process.exitCode = 1` bei offenen Punkten | — |
| assetlinks.json nicht gefunden | Nur in Domain-Wurzel gesucht, nie im Projektpfad | Eigene Domain oder Repo `<user>.github.io` | — |
| Adressleiste in Store-App sichtbar | Play App Signing ändert Fingerprint | Fingerprint aus Play Console in assetlinks.json, nicht nur Upload-Key | — |

## Offene strukturelle Punkte

- [x] ~~Vault-Wurzel ist noch KEIN Git-Repo~~ – erledigt 2026-09-06: Vault-Wurzel als Git-Repo initialisiert (Kildro93/Obsidion-Claud). Erst-Push zu GitHub steht noch aus.
- [ ] Repo Kildro93/Nestbau hat drei divergierte Stände: `main` (Firebase), `release/play-store` (Tests/CI/Store), `master` (nestbau-firebase-Struktur). Merge-Entscheidung offen.
- [ ] Die 43 Tests prüfen die Fassung OHNE Firebase.

## Externe Links

- Repo: https://github.com/Kildro93/Nestbau
- Firebase Console: https://console.firebase.google.com
- Artifact-Links: [[ARTIFACT_LINKS]]

## Update-Log

**2026-09-06 – Vault-Reorganisation (Code-Bot)**
- Loop-Struktur eingeführt (CEO + Bot-Rollen), 4 PROJEKT-Dateien angelegt.
- Erkenntnisse aus Bot 1–4, Firebase Architect, Build Optimizer und der Kochbuch-/GitHub-Session konsolidiert.
- Neue Erkenntnis (strukturell): Cloud-Session-Git-Proxy blockiert Pushes zu nicht-autorisierten Repos.

**2026-09-06 – Konsolidierung + Build-Ordner-Cleanup**
- REQUIREMENTS/, DESIGN/, CODE/, Chat-Exports/INDEX, VERKNUEPFUNGEN, README, DATEI-TREE angelegt; Code als Zeiger-Landkarte, nicht kopiert.
- `C:\nestbau-build` (152 MB) war 100% redundant (Artefakte byte-identisch mit `Nestbau/dist/`, Scaffold identisch mit `Nestbau/android/`, Rest Cache) → gelöscht.
- Neue Erkenntnis (Security): `keystore.properties` mit Klartext-Passwörtern lag in zwei Ordnern. Regel: vor jedem geplanten Repo-Push eine passende `.gitignore` anlegen (Secrets + `node_modules`/`build`/`.gradle`/`dist`). Vault-Root-`.gitignore` erstellt.
- Neue Erkenntnis (Struktur): Build-Workspaces gehören nicht in die Notiz-Vault. Reproduzierbar aus dem Repo (`npm run sync && node tools/android-build.js release`).

**2026-09-07 – Nestbau-Arbeitsverzeichnis committet (CEO)**
- 44 offene Änderungen waren nur zu 10 Dateien echt: Windows-Editoren hatten CRLF eingestreut, git zeigte 23 Dateien als komplett geändert (6803+/6729-). Prüfrezept: `git diff --ignore-all-space --stat` — steht dort deutlich weniger, ist es Zeilenenden-Rauschen.
- Fix dauerhaft: `.gitattributes` mit `* text=auto eol=lf`, `*.bat text eol=crlf`, Bilder als `binary`. Danach blieben 23 Scheinänderungen von selbst weg, ohne Datei-Rewrite.
- `emulator.log` und `firestore-debug.log` waren getrackt — Laufzeit-Artefakte gehören per `.gitignore` raus, sonst rauscht jeder Commit.
- Aus der Cloud-Session lässt sich nicht pushen: der Token liegt im Windows Credential Manager, die Session sieht den Ordner über eine Linux-Shell. Committen geht, Pushen macht der PC.
- Push wurde als non-fast-forward abgelehnt: der lokale Klon hatte seit dem 05.09. kein `fetch` gesehen und kannte einen Remote-Commit nicht. `git fetch` + `git rebase origin/main` reichte, kein Konflikt. Regel: vor dem ersten Push nach längerer Pause immer erst `git fetch` und `git rev-list --left-right --count origin/main...main`.

**2026-09-07 – Branch-Entscheidung + Sicherheitshärtung (CEO)**
- Ein Branch ohne gemeinsame History (`master`, eigener Root-Commit) ist kein Merge-Kandidat, sondern ein eigenes Projekt. Prüfrezept: `git merge-base A B` — kommt nichts zurück, gibt es keine gemeinsame Basis.
- Alte Feature-Branches lohnen sich selektiv: aus `release/play-store` waren nur die auslieferungs-unabhängigen Teile (Tests, Audit-Skripte) wertvoll, die TWA-Kette nicht. Die 43 Tests liefen 19 Commits später unverändert grün — gut geschriebene Tests altern langsamer als der Code.
- `innerHTML = '<img src="' + wert + '"…'` ist auch bei scheinbar eigenen Daten angreifbar, sobald es einen Import-Pfad gibt. Fix-Muster: Element per `createElement` bauen, oder bei HTML-Strings `escapeHtml()` um jeden Attributwert.
- `npm audit` nach jedem Abhängigkeits-Update lesen: die hohe Schwachstelle steckte in `sharp` (nur Build-Werkzeug, nicht in der App) — trotzdem billig zu beheben.
- Backup-Skript: eine Ausschlussliste, die nur die oberste Ebene filtert, ist wirkungslos, sobald verschachtelte Projekte im Ordner liegen. Beim ersten Testlauf landeten 96 MB `node_modules` im ZIP. Ausschluss muss pro Pfad-Segment greifen, und `ZipFile.CreateEntryFromFile` spart den Kopierschritt ins Temp-Verzeichnis.
- Merke: ein Backup-Skript ist erst geprüft, wenn man in das erzeugte Archiv hineingeschaut hat, nicht wenn es fehlerfrei durchläuft.
- „Datei wird nicht geladen" war in Wahrheit „Datei enthält den Wert nicht": `nb-config.local.js` war korrekt eingebunden (index.html:866), hatte aber nur Firebase-Emulator-Platzhalter und keine `google.clientId`. Eine zweite, richtige Fassung lag unter `Claude outputs/` und wurde nie kopiert. Prüfreihenfolge bei Konfig-Problemen: erst Inhalt der geladenen Datei, dann Ladeweg — nicht umgekehrt.
- Konfigurationsdateien existieren im Vault mehrfach (Arbeitskopie, `Claude outputs/`, Session-Backups). Vor dem Debuggen `grep -rl` über den Vault: liegt woanders eine vollständigere Fassung?
- Chrome DevTools → Application → Manifest liest Fehler auf, die keine Test-Suite findet: das Manifest verwies nur auf `icon.svg`, obwohl `npm run assets` längst PNGs nach `assets/icons/` schreibt. Die Datei-Existenz-Tests prüfen nur, was in `index.html` verlinkt ist, nicht die Manifest-Verweise.
- Was im Manifest steht, muss auch der Build kopieren: `build-web.js` kannte `assets/` nicht, die Icons hätten im verpackten Bundle gefehlt.
- Service Worker registrieren sich in Vorschau-/Sandbox-Fenstern nicht. Ein „unknown error when fetching the script" dort ist kein App-Fehler — im echten Chrome gegenprüfen, bevor man ihn jagt.
