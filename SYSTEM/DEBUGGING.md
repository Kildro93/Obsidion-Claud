# Debugging-Guide

## Git und Sync

| Symptom | Ursache | Fix |
|---|---|---|
| `fatal: not a git repository` | im falschen Ordner oder `.git` fehlt | in den Vault-Root wechseln, sonst `git init` |
| Push 403 | Token fehlt, abgelaufen oder ohne Contents-Write | [[SETUP-GITHUB-TOKEN]] |
| `! [rejected] non-fast-forward` | GitHub hat Commits, die lokal fehlen | `git pull --rebase origin main` |
| Auto-Sync commitet nichts | Dateien stehen in `.gitignore` | `git check-ignore -v <pfad>` |
| Datei sollte ignoriert sein, ist aber drin | war schon getrackt, bevor die Regel kam | `git rm --cached <pfad>` |
| Sync-Log leer | Aufgabe laeuft nicht | Taskplaner → Verlauf, ExecutionPolicy pruefen |

## Nestbau App

| Symptom | Erster Blick |
|---|---|
| Weisse Seite | Browser-Konsole: fehlendes Script oder Syntaxfehler; `node --check js/<datei>.js` |
| Firebase "permission denied" | Firestore Rules, Nutzer im richtigen Haushalt? |
| Login geht nicht | Authorized Domains in Firebase Auth, Redirect-URI in Cloud Console |
| Kalender-Sync leer | OAuth-Scopes, Token abgelaufen, `nb-config.local.js` gesetzt? |
| Dark Mode kaputt | CSS-Spezifitaet, siehe [[css-spezifitaet-dark-mode-fix]] |
| Emulator startet nicht | [[Emulator-Setup]] |

## Vorgehen bei unklarem Fehler

1. Bereich per `grep` lokalisieren, nicht raten
2. Kleinste reproduzierbare Aktion in der UI finden
3. Konsole und Netzwerk-Tab lesen, bevor Code geaendert wird
4. Eine Aenderung pro Batch, danach `node --check`
5. Fehler mit Loesung in die Fehlertabelle in [[PROJEKT-LEARNINGS]] eintragen

## Wenn ein Bot sich verrennt

Abbrechen, Summary schreiben lassen mit dem, was bekannt ist, und im UPDATE als Blocker vermerken. Kein Bot arbeitet laenger als eine Sitzung an derselben Sackgasse.
