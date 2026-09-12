# Auto-Sync: Vault nach GitHub

Ziel: GitHub ist jederzeit aktuell, damit Handy und andere Chats den Vault lesen koennen.

## Warum kein GitHub-Actions-Cron

Ein Actions-Workflow laeuft in der Cloud und sieht die lokalen Dateien nicht. Ein `git add -A` dort findet nichts und erzeugt nur Leerlauf. Lokale Aenderungen koennen nur von einem Prozess auf dem PC gepusht werden. Deshalb: Windows Task Scheduler.

## Einrichtung (einmalig)

Voraussetzung: GitHub-Token liegt im Credential Manager, siehe [[SETUP-GITHUB-TOKEN]].

```powershell
cd "C:\KI Programme\Obsidion für Claud\scripts"
powershell -ExecutionPolicy Bypass -File .\install-autosync-task.ps1
```

Registriert die Aufgabe "Obsidian Vault Auto-Sync": alle 30 Minuten, laeuft nach, wenn der PC beim Termin aus war.

## Test

```powershell
Start-ScheduledTask -TaskName "Obsidian Vault Auto-Sync"
Get-Content "C:\KI Programme\Obsidion für Claud\scripts\logs\vault-sync.log" -Tail 10
```

## Kein sichtbares Fenster

Die Aufgabe startet `wscript.exe` mit dem Wrapper `vault-sync-silent.vbs`, der `vault-sync.ps1` unsichtbar aufruft. Nicht `powershell.exe -WindowStyle Hidden` direkt — das blitzt beim Taskplaner-Start kurz als Konsolenfenster auf, `WScript.Shell.Run(...,0,...)` im VBS unterdrückt es zuverlässig.

## Was das Script tut

1. Prueft, ob es Aenderungen gibt (`git status --porcelain`)
2. `git add -A` + Commit "Auto-sync: Datum (n Dateien)"
3. Push nach `origin main`, nur wenn lokale Commits vorliegen
4. Schreibt jede Aktion nach `scripts/logs/vault-sync.log`, kappt das Log bei 1 MB

## Manueller Push zwischendurch

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\push.ps1 "Update: Nestbau Learnings"
```

## Aufgabe entfernen

```powershell
Unregister-ScheduledTask -TaskName "Obsidian Vault Auto-Sync" -Confirm:$false
```

## Fehlerbilder

| Log-Zeile | Ursache | Fix |
|---|---|---|
| `PUSH FEHLGESCHLAGEN (Exit 128)` | Token abgelaufen | [[SETUP-GITHUB-TOKEN]], Abschnitt "Token erneuern" |
| `ABBRUCH: kein Git-Repo` | `.git` fehlt im Vault-Root | `git init` + Remote setzen |
| `! [rejected] non-fast-forward` | Aenderung direkt auf GitHub gemacht | `git pull --rebase origin main`, dann erneut |
| Log bleibt leer | Aufgabe laeuft nicht | Taskplaner → Verlauf pruefen, ExecutionPolicy |
