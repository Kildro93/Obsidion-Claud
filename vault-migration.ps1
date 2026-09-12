# Vault-Migration Script
# Erstellt: 2026-09-12 durch Gehirn-Admin
# Sicherung: backup-lokal-2026-09-12 (Branch + ZIP vorhanden)
#
# WICHTIG: Dieses Script nutzt git mv fuer Historie-Erhalt.
# Bei Konflikten bricht es ab statt zu ueberschreiben.

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Vault-Root = aktuelles Verzeichnis (muss von dort gestartet werden)
$vaultRoot = Get-Location
Write-Host "Vault-Root: $vaultRoot" -ForegroundColor Cyan

function Safe-GitMv {
    param([string]$src, [string]$dst)
    if (-not (Test-Path $src)) {
        Write-Warning "SKIP: Quelle nicht gefunden: $src"
        return
    }
    $dstDir = Split-Path $dst -Parent
    if ($dstDir -and -not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
        Write-Host "  Ordner erstellt: $dstDir" -ForegroundColor DarkGray
    }
    if (Test-Path $dst) {
        Write-Error "ABBRUCH: Ziel existiert bereits: $dst"
        exit 1
    }
    git mv $src $dst
    if ($LASTEXITCODE -ne 0) {
        Write-Error "ABBRUCH: git mv fehlgeschlagen: $src -> $dst"
        exit 1
    }
    Write-Host "  OK: $src -> $dst" -ForegroundColor Green
}

function Safe-GitRm {
    param([string]$path)
    if (-not (Test-Path $path)) {
        Write-Warning "SKIP: Datei nicht gefunden: $path"
        return
    }
    git rm -rf $path
    Write-Host "  GELOESCHT: $path" -ForegroundColor Yellow
}

Write-Host "`n=== PHASE 1: Zielordner erstellen ===" -ForegroundColor Cyan
$dirs = @(
    "MEMORY", "MEMORY/setup",
    "FAZITE", "FAZITE/allgemein", "FAZITE/nestbau", "FAZITE/github-automation",
    "STUDIUM",
    "REST",
    "PROJEKTE/Nestbau/docs", "PROJEKTE/Nestbau/notizen", "PROJEKTE/Nestbau/ressourcen",
    "PROJEKTE/Nestbau/aufgaben", "PROJEKTE/Nestbau/code",
    "PROJEKTE/GitHub-Automation/docs", "PROJEKTE/GitHub-Automation/notizen",
    "PROJEKTE/GitHub-Automation/ressourcen", "PROJEKTE/GitHub-Automation/aufgaben",
    "PROJEKTE/GitHub-Automation/code"
)
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
        Write-Host "  Ordner: $d" -ForegroundColor DarkGray
    }
}

Write-Host "`n=== PHASE 2: SYSTEM -> MEMORY ===" -ForegroundColor Cyan

# Hauptdateien
Safe-GitMv "SYSTEM/MEMORY_INDEX.md" "MEMORY/memory-index.md"
Safe-GitMv "SYSTEM/Profil.md" "MEMORY/profil.md"
Safe-GitMv "SYSTEM/Regeln.md" "MEMORY/regeln.md"
Safe-GitMv "SYSTEM/Vault-Struktur.md" "MEMORY/vault-struktur.md"
Safe-GitMv "SYSTEM/Chat-Closure-Protocol.md" "MEMORY/chat-closure-protocol.md"
Safe-GitMv "SYSTEM/Prompt-Typen-Guide.md" "MEMORY/prompt-typen-guide.md"
Safe-GitMv "SYSTEM/QUICK-START.md" "MEMORY/quick-start.md"
Safe-GitMv "SYSTEM/DEBUGGING.md" "MEMORY/debugging.md"

# SETUP-Dateien
Safe-GitMv "SYSTEM/SETUP/AUTO-SYNC.md" "MEMORY/setup/auto-sync.md"
Safe-GitMv "SYSTEM/SETUP/BACKUP-STRATEGY.md" "MEMORY/setup/backup-strategy.md"
Safe-GitMv "SYSTEM/SETUP/CHECKLIST.md" "MEMORY/setup/checklist.md"
Safe-GitMv "SYSTEM/SETUP/PROJEKT-CREDENTIALS.md" "MEMORY/setup/projekt-credentials.md"
Safe-GitMv "SYSTEM/SETUP/SECURITY-AUDIT.md" "MEMORY/setup/security-audit.md"
Safe-GitMv "SYSTEM/SETUP/SETUP-ENV-LOCAL.md" "MEMORY/setup/setup-env-local.md"
Safe-GitMv "SYSTEM/SETUP/SETUP-FIREBASE.md" "MEMORY/setup/setup-firebase.md"
Safe-GitMv "SYSTEM/SETUP/SETUP-GITHUB-TOKEN.md" "MEMORY/setup/setup-github-token.md"

# Veraltet loeschen
Safe-GitRm "SYSTEM/CLEANUP-REPORT-2026-09-06.md"

Write-Host "`n=== PHASE 3: Chat-Exports -> FAZITE ===" -ForegroundColor Cyan

# Allgemeine Fazits
Safe-GitMv "SYSTEM/Chat-Exports/2026-09-06-Vault-Setup-Automation.md" "FAZITE/allgemein/vault-setup-automation-fazit-2026-09-06.md"
Safe-GitMv "SYSTEM/Chat-Exports/System-Setup-Prompt-Erstellung-Fazit-2026-09-12.md" "FAZITE/allgemein/system-setup-prompt-erstellung-fazit-2026-09-12.md"
Safe-GitMv "SYSTEM/Chat-Exports/Vault-Analyse-Fazit-2026-09-12.md" "FAZITE/allgemein/vault-analyse-fazit-2026-09-12.md"

# Nestbau-Fazits aus SYSTEM/Chat-Exports
Safe-GitMv "SYSTEM/Chat-Exports/Nestbau-Setup-Fazit-2026-09-07.md" "FAZITE/nestbau/nestbau-setup-fazit-2026-09-07.md"
Safe-GitMv "SYSTEM/Chat-Exports/CEO-Nestbau-5-Task-Koordination-Fazit-2026-09-12.md" "FAZITE/nestbau/ceo-nestbau-5-task-koordination-fazit-2026-09-12.md"
Safe-GitMv "SYSTEM/Chat-Exports/CEO-Nestbau-5-Task-Koordination-Tasks-2026-09-12.md" "FAZITE/nestbau/ceo-nestbau-5-task-koordination-tasks-2026-09-12.md"

# Nestbau-Fazits aus PROJEKTE/Nestbau/Chat-Exports
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/2026-09-04-Local-App-Test-Report.md" "FAZITE/nestbau/local-app-test-report-fazit-2026-09-04.md"
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/2026-09-05-Kochbuch-Menuplan-GitHub.md" "FAZITE/nestbau/kochbuch-menuplan-github-fazit-2026-09-05.md"
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/2026-09-06-Testing-CICD.md" "FAZITE/nestbau/testing-cicd-fazit-2026-09-06.md"
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/2026-09-07-Vault-Setup-Repo-Cleanup.md" "FAZITE/nestbau/vault-setup-repo-cleanup-fazit-2026-09-07.md"
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/2026-09-12-Design-System-Fix.md" "FAZITE/nestbau/design-system-fix-fazit-2026-09-12.md"
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/INDEX.md" "FAZITE/nestbau/index.md"
Safe-GitMv "PROJEKTE/Nestbau/Chat-Exports/Nestbau-LOCAL-TEST-Fazit-2026-09-04.md" "FAZITE/nestbau/nestbau-local-test-fazit-2026-09-04.md"

Write-Host "`n=== PHASE 4: Studium ===" -ForegroundColor Cyan
Safe-GitMv "PROJEKTE/Primarlehrer-Studium/Studienmaterial" "STUDIUM/semester-01"

Write-Host "`n=== PHASE 5: LERNEN aufloesen ===" -ForegroundColor Cyan
Safe-GitMv "LERNEN/Anime/Notizen.md" "REST/anime-notizen.md"
Safe-GitMv "LERNEN/Technik/Notizen.md" "REST/technik-notizen.md"
Safe-GitRm "LERNEN/Primarlehrer/Notizen.md"

Write-Host "`n=== PHASE 6: KOCH-WISSEN aufloesen ===" -ForegroundColor Cyan
Safe-GitMv "KOCH-WISSEN/Rezepte.md" "REST/rezepte.md"
Safe-GitMv "KOCH-WISSEN/Techniken.md" "REST/techniken.md"

Write-Host "`n=== PHASE 7: ROUTINEN aufloesen ===" -ForegroundColor Cyan
Safe-GitMv "ROUTINEN/Workflows.md" "MEMORY/workflows.md"
Safe-GitRm "ROUTINEN/2026-09-06-Vault-Cleanup-Integration.md"

Write-Host "`n=== PHASE 8: ARCHIV aufloesen ===" -ForegroundColor Cyan
Safe-GitRm "ARCHIV/Chat-Closure-Protocol-v1-superseded.md"
Safe-GitRm "ARCHIV/Entwurf_Test.md"
Safe-GitRm "ARCHIV/Willkommen.md"
Safe-GitRm "ARCHIV/cleanup-2026-09-06"

Write-Host "`n=== PHASE 9: Claude outputs aufloesen ===" -ForegroundColor Cyan

# Bot-Prompts nach PROJEKTE/Nestbau/docs/
Safe-GitMv "Claude outputs/BOT_0_GIT_AUTOMATION.md" "PROJEKTE/Nestbau/docs/bot-0-git-automation.md"
Safe-GitMv "Claude outputs/BOT_1_SETTINGS_UI.md" "PROJEKTE/Nestbau/docs/bot-1-settings-ui.md"
Safe-GitMv "Claude outputs/BOT_2_AUTH_PROFILE.md" "PROJEKTE/Nestbau/docs/bot-2-auth-profile.md"
Safe-GitMv "Claude outputs/BOT_3_DESIGN_UPDATE.md" "PROJEKTE/Nestbau/docs/bot-3-design-update.md"
Safe-GitMv "Claude outputs/BOT_4_FOLDER_MANAGER.md" "PROJEKTE/Nestbau/docs/bot-4-folder-manager.md"
Safe-GitMv "Claude outputs/CHAT_1_CEO_PROJEKTMANAGER.md" "PROJEKTE/Nestbau/docs/chat-1-ceo-projektmanager.md"
Safe-GitMv "Claude outputs/CHAT_2_BOT_BUILDER.md" "PROJEKTE/Nestbau/docs/chat-2-bot-builder.md"

# Ressourcen nach PROJEKTE/Nestbau/ressourcen/
Safe-GitMv "Claude outputs/design-modernization.patch" "PROJEKTE/Nestbau/ressourcen/design-modernization.patch"
Safe-GitMv "Claude outputs/nb-config.local.js" "PROJEKTE/Nestbau/ressourcen/nb-config.local.js"

# Code-Bundles nach PROJEKTE/Nestbau/code/
Safe-GitMv "Claude outputs/nestbau-v2-auth" "PROJEKTE/Nestbau/code/nestbau-v2-auth"
Safe-GitMv "Claude outputs/nestbau-v2-recipe-import" "PROJEKTE/Nestbau/code/nestbau-v2-recipe-import"

# Loeschen
Safe-GitRm "Claude outputs/Nestbau-Setup-Fazit-2026-09-07.md"
Safe-GitRm "Claude outputs/README-Session-Backup.md"
Safe-GitRm "Claude outputs/pruefe-alten-ordner.ps1"
Safe-GitRm "Claude outputs/index.html"
Safe-GitRm "Claude outputs/Nestbau-Session-Backup-2026-09-07"

Write-Host "`n=== PHASE 10: PROJEKTE Nestbau aufraumen ===" -ForegroundColor Cyan
Safe-GitRm "PROJEKTE/Nestbau/Backups/nestbau-sicherung-2026-09-04.json"

# GitHub-Automation Dateien umbenennen (kebab-case)
Safe-GitMv "PROJEKTE/GitHub-Automation/_INDEX.md" "PROJEKTE/GitHub-Automation/index.md"
Safe-GitMv "PROJEKTE/GitHub-Automation/GitHub-Naming-Regeln.md" "PROJEKTE/GitHub-Automation/docs/github-naming-regeln.md"
Safe-GitMv "PROJEKTE/GitHub-Automation/PAT-Setup.md" "PROJEKTE/GitHub-Automation/docs/pat-setup.md"
Safe-GitMv "PROJEKTE/GitHub-Automation/PROJEKT-LOOP.md" "PROJEKTE/GitHub-Automation/docs/projekt-loop.md"
Safe-GitMv "PROJEKTE/GitHub-Automation/QUICK-START.md" "PROJEKTE/GitHub-Automation/docs/quick-start.md"
Safe-GitMv "PROJEKTE/GitHub-Automation/github-automation.html" "PROJEKTE/GitHub-Automation/code/github-automation.html"
Safe-GitMv "PROJEKTE/GitHub-Automation/Projekte" "PROJEKTE/GitHub-Automation/notizen/projekte"

Write-Host "`n=== PHASE 11: Leere Ordner aufraeumen ===" -ForegroundColor Cyan
# Git tracked keine leeren Ordner, aber Obsidian zeigt sie ggf. noch
$emptyDirs = @(
    "SYSTEM/SETUP", "SYSTEM/Chat-Exports", "SYSTEM",
    "LERNEN/Anime", "LERNEN/Primarlehrer", "LERNEN/Technik", "LERNEN",
    "KOCH-WISSEN", "ROUTINEN", "ARCHIV/cleanup-2026-09-06", "ARCHIV",
    "Claude outputs",
    "PROJEKTE/Primarlehrer-Studium/Studienmaterial", "PROJEKTE/Primarlehrer-Studium",
    "PROJEKTE/Nestbau/Chat-Exports", "PROJEKTE/Nestbau/Backups"
)
foreach ($d in $emptyDirs) {
    if ((Test-Path $d) -and (Get-ChildItem $d -Force | Measure-Object).Count -eq 0) {
        Remove-Item $d -Force
        Write-Host "  Leerer Ordner entfernt: $d" -ForegroundColor DarkGray
    }
}

Write-Host "`n=== PHASE 12: .gitignore ergaenzen ===" -ForegroundColor Cyan
$gitignore = Get-Content ".gitignore" -Raw
if ($gitignore -notmatch "desktop\.ini") {
    Add-Content ".gitignore" "`ndesktop.ini"
    Write-Host "  desktop.ini zu .gitignore hinzugefuegt" -ForegroundColor Green
}

Write-Host "`n=== MIGRATION ABGESCHLOSSEN ===" -ForegroundColor Green
Write-Host "Naechster Schritt: Wikilinks reparieren und MEMORY-Dateien neu schreiben" -ForegroundColor Yellow
Write-Host "Commit noch NICHT gemacht - zuerst pruefen!" -ForegroundColor Yellow

# Status anzeigen
git status --short | Select-Object -First 40
