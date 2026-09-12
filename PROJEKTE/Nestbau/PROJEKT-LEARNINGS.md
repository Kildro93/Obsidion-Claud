---
tags: [projekt/nestbau, typ/status, status/aktuell]
aktualisiert: 2026-09-12
---

# PROJEKT-LEARNINGS: Nestbau

**Zweck:** Zentrale Sammlung von Erkenntnissen aus abgeschlossenen Bot-Sessions – für den CEO und zukünftige Projekte.
**Last Updated:** 2026-09-12

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
- `Fehler 401: invalid_client` heisst: Google kennt diese Client-ID nicht. Die ID in `nb-config.local.js` war formal makellos (12-stellige Projektnummer, 32-stelliger Zufallsteil, korrekte Endung) und existierte trotzdem nirgends — das Projekt hatte nie einen OAuth-Client. Eine erfundene ID ist von einer echten am Format nicht zu unterscheiden; nur die Console beweist es.
- Konsequenz fuer die Zusammenarbeit: Werte, die ein Chat "erzeugt" hat, ohne dass jemand sie aus der Console kopiert hat, sind unbestaetigt. Vor dem Debuggen pruefen, ob der Wert in der Console tatsaechlich existiert — das spart die Suche im Code.
- Beim Anlegen eines Web-Clients: JavaScript-Quellen duerfen keinen Pfad enthalten (`http://localhost:8000`), die Callback-URL gehoert in die Weiterleitungs-URIs (`http://localhost:8000/oauth-callback.html`). Zwei getrennte Felder, haeufige Verwechslung.
- Der Zustimmungsbildschirm-Wizard lehnte den Anwendungsnamen "Nestbau" ab ("entspricht nicht den Anforderungen"), "Nestbau Haushalt" ging durch. Bei dieser Fehlermeldung nicht suchen, sondern einen anderen Namen probieren.
- Emulator-Modus nie am Hostnamen festmachen: `if (location.hostname === 'localhost')` zwang jeden lokalen Lauf gegen die Emulatoren. Ohne laufende Suite endete der Login in `ERR_CONNECTION_REFUSED` auf Port 9099, und gegen das echte Projekt liess sich lokal gar nicht testen. Jetzt: `NB.config.firebase.emulator`, Standard aus.
- Weisses Popup auf `<projekt>.firebaseapp.com/__/auth/handler`, das sich sofort schliesst = der Anmeldeanbieter ist in Firebase Authentication nicht aktiviert. In `nestbau-app` war nur E-Mail/Passwort an, Google fehlte. Die Console zeigt das unter Authentication → Anmeldemethode auf einen Blick.
- Firebase legt beim Aktivieren von Google einen eigenen OAuth-Client an. Der ist getrennt vom selbst erstellten Client fuer den Kalender-Zugriff (PKCE) - zwei Clients im Projekt sind hier korrekt, kein Duplikat.
- Firestore-Regeln altern gegen den Code: als der Sync von „nur Kochbuch" auf Haushalts-Ebene erweitert wurde (`lists`, `events`, `subscriptions`), blieben die Regeln stehen. Der Auffangblock `match /{document=**} { allow read, write: if false }` sperrte die neuen Sammlungen lautlos. Prüfrezept, dauert 10 Sekunden: Sammlungsnamen aus `NB.cloud.COLLECTIONS` gegen die `match`-Blöcke in `firestore.rules` halten — bei jeder Erweiterung des Datenmodells.
- Symptom war irreführend: „Upload passiert nichts" statt einer Fehlermeldung, weil `lists` in der Schreibreihenfolge an erster Stelle steht und schon dort abbrach. Wer nur die Oberfläche beobachtet, sucht an der falschen Stelle — der Regelabgleich fand es ohne Browser.
- Google-OAuth im Browser (PKCE) liefert kein Refresh-Token: nach einer Stunde ist Schluss, der 15-Minuten-Auto-Sync greift nur innerhalb dieser Stunde. Dauerhaft geht das nur serverseitig mit Client-Secret.
- `ERR_BLOCKED_BY_CLIENT` in der Konsole heisst Browser oder Erweiterung, nicht Server: Brave Shields blockten `firestore.googleapis.com` als Google-Tracker. Symptom war ein hängender Upload ohne Fehlermeldung — die Anfrage ging nie raus. Fix: Schilde für localhost herunterfahren. Gilt genauso für Adblocker auf dem Zielgerät.
- Die App zeigt die Haushalts-ID aus dem lokalen Speicher, ohne sie beim Server zu prüfen. Nach einem Kontowechsel sah es deshalb nach erfolgreichem Beitritt aus, obwohl die neue Kennung nie in `memberUids` stand. Wer prüfen will, ob ein Beitritt wirklich stattfand, liest `memberUids` des Haushalts-Dokuments — nicht die Karte.
- Ein Sync, der von Hand gestartet werden muss, ist kein Sync. Nach jedem Neuladen stand er auf pausiert; wer das übersah, verlor beim nächsten Snapshot seine Änderungen. Seit 10.09.2026 gibt es keinen Schalter mehr.

**2026-09-12 – NESTBAU_AKTUELL.md gelöscht (CEO-Cleanup)**
- Datei war seit 28.08.2026 nicht aktualisiert, behauptete u.a. "Outlook Kalender: Live" ohne Beleg. Inhalt vollständig abgedeckt durch [[Features]] (Feature-Liste) und [[PROJEKT-UPDATE]] (Status). 12 Verweise in 9 Dateien repariert, dann gelöscht. Regel: eine zentrale Status-Datei reicht – Duplikate veralten garantiert.

**2026-09-12 – Design-System-Fix (Design-Bot)**
- Ein dupliziertes Inline-`<style>` in `index.html` überschrieb `nestbau-design.css` per Cascade-Reihenfolge – das war der eigentliche Grund, warum die alte Palette trotz „fertigem" Design-System weiter sichtbar war. War in `BUILD-GUIDE.md` § 10 bereits dokumentiert, aber nur mit einem Workaround-Kommentar umschifft statt behoben. Regel: vor jeder Bug-Diagnose `BUILD-GUIDE.md` und `git log <Datei>` prüfen, ob das Problem schon mal jemand gefunden hat.
- Feature-Branch war beim PR-Erstellen 20+ Commits hinter `main` – und `main` hatte denselben Bug parallel, unvollständig gepatcht (andere Hex-Werte, Duplikat blieb bestehen). Ohne `git diff --name-only <branchpoint> origin/main` vor dem PR wäre der kaputte Parallel-Patch beim Merge wiederhergestellt worden. Regel: bei länger laufenden Branches immer gegen den aktuellen `main`-Stand prüfen, nicht gegen den Stand bei Branch-Erstellung.
- Weisser Text auf hellen Pastell-Verläufen (Orange/Peach/Grün) sieht am Bildschirm oft „okay" aus, lag hier aber rechnerisch bei 1,6–2,3:1 statt der geforderten 4,5:1 (WCAG AA). Eine kleine Luminanz-/Kontrast-Funktion vorab laufen lassen ist schneller als Nachbessern nach Reviewer-Fund – gilt für jede warme/pastellige Palette.
- GitHub-Schreibzugriff kann sich mitten in der Session ändern: `git push` scheiterte zuerst mit 403, klappte kurz danach ohne weiteres Zutun. Git-Proxy-Schreibzugriff und GitHub-API-Schreibzugriff (`create_branch` etc.) sind getrennte Berechtigungen – eines kann funktionieren, während das andere weiter 403 gibt.
- Diese Session hatte Zugriff auf zwei Repos gleichzeitig (Nestbau + Vault `Obsidion-Claud`) und konnte den Vault direkt nach jedem Schritt aktuell halten, statt es am Ende in einem Rutsch nachzuholen – für Design-/Code-Sessions künftig beide Repos gleich zu Beginn anfragen.
