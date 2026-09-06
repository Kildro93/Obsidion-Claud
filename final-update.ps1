# final-update.ps1 — Chat-Export + Bot-Abschluss-Regel
# Ausfuehren: powershell -ExecutionPolicy Bypass -File final-update.ps1

$ErrorActionPreference = "Stop"
$vault = "C:\KI Programme\Obsidion für Claud"
Set-Location $vault

Write-Host "=== 1/4: Regeln.md — Bot-Abschluss-Regel ==="
$regeln = Get-Content "SYSTEM\Regeln.md" -Raw -Encoding UTF8
$old = "## Zusammenarbeit`r`n- Bei Unklarheit kurz rückfragen, ansonsten selbstständig handeln`r`n- Updates bei wichtigen Zwischenschritten geben, nicht nur am Ende"
$new = @"
## Zusammenarbeit
- Bei Unklarheit kurz rückfragen, ansonsten selbstständig handeln
- Updates bei wichtigen Zwischenschritten geben, nicht nur am Ende

## Bot/Chat-Abschluss
- Sobald ein Bot/Chat seine Arbeit erledigt hat, meldet er sofort und direkt: "Fertig. [1 Satz was erledigt wurde]."
- Kein Drumherumreden, keine Zusammenfassungen zwischen tausend Worten — die Fertig-Meldung kommt so früh und knapp wie möglich
- Danach: Chat-Export erstellen, damit der Chat geschlossen werden kann ohne Wissensverlust
"@
if ($regeln.Contains("Bot/Chat-Abschluss")) {
    Write-Host "  Bereits vorhanden."
} else {
    $regeln = $regeln.Replace($old, $new)
    Set-Content "SYSTEM\Regeln.md" -Value $regeln -Encoding UTF8 -NoNewline
    Write-Host "  OK"
}

Write-Host "=== 2/4: QUICK-START.md — Punkt 6 ==="
$qs = Get-Content "SYSTEM\QUICK-START.md" -Raw -Encoding UTF8
$oldQs = "6. Dem CEO melden: fertig, Link zur Summary"
$newQs = '6. **Sofort und direkt melden: "Fertig. [Was erledigt wurde]."** — nicht zwischen tausend Worten verstecken'
if ($qs.Contains("Sofort und direkt melden")) {
    Write-Host "  Bereits vorhanden."
} else {
    $qs = $qs.Replace($oldQs, $newQs)
    Set-Content "SYSTEM\QUICK-START.md" -Value $qs -Encoding UTF8 -NoNewline
    Write-Host "  OK"
}

Write-Host "=== 3/4: MEMORY_INDEX.md — Chat-Export Verweis ==="
$mi = Get-Content "SYSTEM\MEMORY_INDEX.md" -Raw -Encoding UTF8
if ($mi.Contains("Vault-Cleanup-Integration")) {
    Write-Host "  Bereits vorhanden."
} else {
    $mi = $mi.Replace(
        "- Alltags-Routinen: ROUTINEN/",
        "- Alltags-Routinen: ROUTINEN/`r`n- Vault-Cleanup & Integration: [[2026-09-06-Vault-Cleanup-Integration]]"
    )
    $mi = $mi -replace "Zuletzt aktualisiert:.*", "Zuletzt aktualisiert: 2026-09-06 – Cleanup durchgefuehrt, Bot-Abschluss-Regel eingefuehrt*"
    Set-Content "SYSTEM\MEMORY_INDEX.md" -Value $mi -Encoding UTF8 -NoNewline
    Write-Host "  OK"
}

Write-Host "=== 4/4: Chat-Export erstellen ==="
$export = @"
# Chat-Export: Vault-Cleanup & Integration [2026-09-06]

## Zusammenfassung
Vault von Altlasten bereinigt, Repo-Name-Konsistenz hergestellt (obsidian-vault -> Obsidion-Claud), GitHub-Token eingerichtet und ersten Push durchgefuehrt. Neue Regel eingefuehrt: Bots melden Fertig sofort und direkt.

## Geloeste Probleme
- 5 ueberholte Dateien aus Claude outputs/ und Root geloescht (firebase-setup-guide, integration-checklist, nestbau-ceo-master-prompt, GitHub-Projects.zip, Unbenannt.canvas)
- github-chat-anleitung.md war bereits vorher geloescht
- Phantom-Link [[household-app]] in GitHub-Automation/_INDEX.md entfernt (Datei existierte nie)
- Veralteter Tech-Stack in GitHub-Automation/Projekte/nestbau.md korrigiert (React/TS -> Vanilla JS)
- 8 Referenzen von obsidian-vault auf Obsidion-Claud in 7 Dateien korrigiert
- ZIP-Entpackung landete in Unterordner statt Root — per Copy-Item korrigiert
- PowerShell-Pfad mit Umlaut (fuer vs fuer) verursachte Fehler

## Ergebnisse
- SYSTEM/CLEANUP-REPORT-2026-09-06.md — Detaillierter Cleanup-Report
- SYSTEM/Regeln.md — Neue Regel: Bot/Chat-Abschluss (sofortige Fertig-Meldung)
- SYSTEM/QUICK-START.md — Bot-Ablauf Punkt 6 aktualisiert
- .env.local — Token-Backup (git-ignored)
- SYSTEM/SETUP/SETUP-GITHUB-TOKEN.md — Token-Backup-Abschnitt ergaenzt
- Token im Windows Credential Manager hinterlegt
- Alle Aenderungen auf GitHub gepusht

## Erkenntnisse
- ZIP-Entpackung unter Windows erstellt oft einen Unterordner statt direkt ins Ziel. Kuenftig PowerShell-Script statt ZIP verwenden.
- Pfade mit Umlauten in Anleitungen immer exakt aus dem System kopieren, nicht tippen
- Tokens NIE in einen Chat posten — auch nicht zum Testen
- "Fertig-Meldung" als Regel etabliert: Bots verstecken das Ende nicht in langen Zusammenfassungen

## Status
- Vault-Cleanup: erledigt
- Repo-Konsistenz: erledigt (0 Reste von obsidian-vault)
- Token: eingerichtet, Push funktioniert
- Neue Regel (Bot-Abschluss): in Regeln.md und QUICK-START.md eingefuegt

## Verweise
- Cleanup-Report: [[CLEANUP-REPORT-2026-09-06]]
- Vault-Struktur: [[Vault-Struktur]]
- Regeln: [[Regeln]]
- Quick-Start: [[QUICK-START]]
- Token-Setup: [[SETUP-GITHUB-TOKEN]]

---
*Exportiert am 2026-09-06*
"@
Set-Content "ROUTINEN\2026-09-06-Vault-Cleanup-Integration.md" -Value $export -Encoding UTF8 -NoNewline
Write-Host "  OK"

Write-Host ""
Write-Host "=== Alles angewendet. Jetzt committen: ==="
Write-Host 'git add -A; git commit -m "Chat-Export + Bot-Abschluss-Regel"; git push origin main'
