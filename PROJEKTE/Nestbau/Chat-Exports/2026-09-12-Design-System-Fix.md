---
tags: [projekt/nestbau, bereich/design, typ/chat-export, status/archiv]
aktualisiert: 2026-09-12
---

# Fazit: Design-System-Fix – 2026-09-12

## Abgeschlossen
- Ursache für „Design nicht konsistent" gefunden und behoben: `index.html` hatte ein dupliziertes Inline-`<style>` mit der alten Palette (`#1c7d70`/`#4a6741`/`#8B4545`), das nach dem `<link>` zu `nestbau-design.css` stand und die neue Palette per Cascade überschrieb – der eigentliche Auftrag aus [[BOT_3_DESIGN_UPDATE]] war beim letzten Mal nur teilweise angekommen.
- WCAG-AA-Kontrastfehler in der neuen Palette gefunden und behoben (weisser Text auf hellen Orange/Peach/Grün-Verläufen lag teils bei 1,6:1 statt 4,5:1).
- Touch-Targets `.icon-btn`/`.todo-add-btn` auf 48×48px gebracht.
- Alte Farben in `icon.svg`, `capacitor.config.json`, `tools/generate-assets.js`, `firebase-bridge.html` ersetzt.
- Mit `main` gemergt (20+ Commits Vorsprung: Bots 1–4, Firebase-Sync, Testsuite, Play-Store-Pipeline), Konflikt gegen einen unvollständigen Parallel-Patch von `main` aufgelöst.
- Icon-/Splash-/Store-Assets neu erzeugt (`npm run assets`).
- PR #1 erstellt, gemergt, Branch-Monitoring durchgeführt.
- Vault-Cleanup: alle 6 Befunde aus der Analyse vom 12.09. behoben (app.json-Filter, doppeltes Changelog, Closure-Protocol-Duplikat, redundantes Backup, ARTIFACT_LINKS.md, Tag-Schema eingeführt).

## Zahlen
- Nestbau-Commits: `eebccee` (Design-Fix), `a71024f` (Merge main), `7fbe95f` (Asset-Regen) → gemergt als `91197f5` auf `main`
- Vault-Commits: `7a16eb7`, `04687a7`, `b2d9bb3`, `c845209` auf `main`
- Dateien geändert (Design-Fix): 6 direkt + 27 durch Merge + 20 regenerierte Icon-Assets
- Tests bestanden: 43/43 (`npm test`), Security-Audit 0 Befunde
- PR: [Kildro93/Nestbau#1](https://github.com/Kildro93/Nestbau/pull/1) – gemergt

## Wichtigste Erkenntnisse
1. **BUILD-GUIDE.md vor der Diagnose lesen**: der Bug war in `BUILD-GUIDE.md` § 10 bereits dokumentiert – ein früherer Bot hatte ihn erkannt, aber nur mit einem Kommentar + geänderten Fallback-Farben umschifft statt behoben. Vor jeder „das ist bestimmt neu"-Diagnose: `BUILD-GUIDE.md` und `git log` auf denselben Dateien prüfen.
2. **Feature-Branch gegen aktuellen `main` prüfen, nicht gegen den Erstellungs-Stand**: `main` war 20+ Commits weiter und hatte denselben Bug parallel (und unvollständig) selbst gepatcht. Ohne Merge-Check hätte der PR den alten, kaputten Patch stillschweigend wiederhergestellt.
3. **WCAG-Kontrast bei Pastell-/Warm-Paletten nicht nach Augenmass beurteilen**: Weiss auf hellem Orange/Peach/Grün sieht am Bildschirm oft „okay" aus, liegt rechnerisch aber bei 1,6–2,3:1. Eine kleine Python-Luminanz-Funktion, um Farbpaare vorab zu prüfen, ist schneller als Nachbessern nach Reviewer-Fund.
4. **GitHub-Schreibzugriff kann sich mitten in der Session ändern**: `git push` scheiterte zuerst mit 403 (App nicht autorisiert), klappte auf Retry ohne weiteres Zutun. `create_branch` über die GitHub-API blieb trotzdem 403 – Git-Proxy-Schreibzugriff und GitHub-API-Schreibzugriff sind getrennte Berechtigungen.

## Nächste Schritte
1. Visuelle Browser-QA (Light/Dark, 375/768/1024px) nachholen – bewusst in dieser Session nicht gemacht, auf Wunsch offen gelassen
2. Focus-visible-Styles für Buttons/Chips/Tabs/Icon-Buttons ergänzen (nur Formularfelder haben aktuell einen eigenen Fokus-Stil) – nächster Design-Bot
3. Firestore-Tasks-Subsammlung-Refactor (Perf) – nicht blind umgesetzt, siehe Offene Probleme
4. Google-Kalender Cloud-Function-Deploy, OAuth-Console-Aufräumen – nur lokal am PC möglich, siehe Offene Probleme
5. Branch `claude/new-session-je60jy` auf GitHub manuell löschen (kosmetisch, gemergt)

## Wo liegt was
- Code: https://github.com/Kildro93/Nestbau, Branch `main`, Commit `91197f5`
- Vault: `PROJEKTE/Nestbau/` (dieser Export), `SYSTEM/Vault-Struktur.md` (Tag-Schema), `BUILD-GUIDE.md` § 10 (Pitfall als behoben markiert)
- Lokal committet: ja
- GitHub gepusht: ja (Nestbau + Vault)
- Vault aktualisiert: ja

## Offene Probleme
- **Firestore-Tasks-Subsammlung-Refactor**: architektonisch relevant (Sync-Kern erst 10.09. neu gebaut, keine automatisierten Tests dafür, keine Firebase-Zugangsdaten in dieser Session) – bewusst nicht blind durchgeführt.
- **Google-Kalender Cloud-Function-Deploy**: Code liegt in `nestbau-firebase/functions/src/tokens.js`, dieses Repo existiert nicht auf GitHub (nur lokal) und diese Session hat keine Firebase-CLI-Authentifizierung.
- **OAuth-Client-Secret löschen / Produktions-Redirect-URI ergänzen**: reine Google-Cloud-Console-Aktionen, kein API-Tool verfügbar.
- **Phase-2 Tests 6–9** (Offline, Konflikt, Regeln, falscher Code): brauchen zwei echte Geräte/Browser gegen das echte Firebase-Projekt, in dieser Sandbox nicht durchführbar.
- **Branch `claude/new-session-je60jy`** liess sich nicht per Tool löschen (403 auf `git push --delete` und auf die GitHub-API `create_branch`-Route; kein `delete_branch`-Tool vorhanden). Harmlos, da gemergt.
- Drei Lücken gegen den Original-Auftrag aus [[BOT_3_DESIGN_UPDATE]]: Responsive-Breakpoints 375/768/1024px nie getestet (nur ein Breakpoint bei 480px existiert), Keyboard-Focus-Visible nur für Formularfelder, keine visuelle Browser-Prüfung durchgeführt.

## Für zukünftige Chats
- `design-modernization.patch` liegt weiterhin im Repo-Root von Nestbau – vermutlich der Rest des allerersten (unvollständigen) Design-Bot-Laufs. Nicht angefasst in dieser Session, könnte beim nächsten Cleanup geprüft werden (ist er noch anwendbar/relevant, oder Altlast?).
- Beim Mergen eines lange stehenden Feature-Branches immer `git diff --name-only <branch-point> origin/main` vor dem PR laufen lassen – zeigt sofort, ob Konfliktpotenzial besteht, bevor GitHub es meldet.
- Diese Session hatte Push-Zugriff auf `Kildro93/Nestbau` UND `Kildro93/Obsidion-Claud` (Vault) im selben Chat – für Design-Sessions künftig gleich beides anfragen, spart das nachträgliche Freischalten.
