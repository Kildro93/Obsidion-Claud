# Vault-Migration FORTSETZUNG v3
# Startet ab Phase 9 (Code-Bundles)
# nb-config.local.js bereits verschoben

# NICHT Stop verwenden - git stderr wird sonst als Fehler behandelt
$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Safe-GitMv {
    param([string]$src, [string]$dst)
    if (-not (Test-Path $src)) {
        Write-Warning "SKIP: Quelle nicht gefunden: $src"
        return
    }
    $dstDir = Split-Path $dst -Parent
    if ($dstDir -and -not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
    }
    if (Test-Path $dst) {
        Write-Host "  ABBRUCH: Ziel existiert bereits: $dst" -ForegroundColor Red
        exit 1
    }
    # try git mv, bei Fehler Fallback auf Move-Item
    $gitOutput = git mv $src $dst 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  git mv nicht moeglich, verwende Move-Item..." -ForegroundColor DarkYellow
        Move-Item $src $dst -Force
        Write-Host "  OK (Fallback Move): $src -> $dst" -ForegroundColor Green
    } else {
        Write-Host "  OK: $src -> $dst" -ForegroundColor Green
    }
}

function Safe-GitRm {
    param([string]$path)
    if (-not (Test-Path $path)) {
        Write-Warning "SKIP: Datei nicht gefunden: $path"
        return
    }
    $gitOutput = git rm -rf $path 2>&1
    if ($LASTEXITCODE -ne 0) {
        Remove-Item $path -Recurse -Force
        Write-Host "  GELOESCHT (nicht-tracked): $path" -ForegroundColor Yellow
    } else {
        Write-Host "  GELOESCHT: $path" -ForegroundColor Yellow
    }
}

Write-Host "`n=== PHASE 9 FORTSETZUNG: Claude outputs ===" -ForegroundColor Cyan

# Code-Bundles (koennen teilweise nicht-tracked sein)
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
$emptyDirs = @(
    "SYSTEM/SETUP", "SYSTEM/Chat-Exports", "SYSTEM",
    "LERNEN/Anime", "LERNEN/Primarlehrer", "LERNEN/Technik", "LERNEN",
    "KOCH-WISSEN", "ROUTINEN",
    "ARCHIV/cleanup-2026-09-06", "ARCHIV",
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

git status --short | Select-Object -First 50
