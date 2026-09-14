# ============================================================================
# Vault-Cleanup 2026-09-13 -- Gehirn-Admin
# ============================================================================
# Ausfuehren im Vault-Root: C:\KI Programme\Obsidion fuer Claud
# PowerShell 5.1+ kompatibel (kein && verwenden)
#
# WICHTIG: Vor dem Ausfuehren sicherstellen, dass git status sauber ist!
# ============================================================================

$ErrorActionPreference = "Stop"
$VaultRoot = "C:\KI Programme\Obsidion f$([char]0xFC)r Claud"

Set-Location $VaultRoot
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:GIT_REDIRECT_STDERR = '2>&1'

$errors = @()
$actions = @()

function Safe-GitMv {
    param([string]$Source, [string]$Dest)
    if (-not (Test-Path $Source)) {
        $script:errors += "SKIP git mv: Quelle nicht gefunden: $Source"
        return
    }
    $destDir = Split-Path $Dest -Parent
    if ($destDir -and -not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    if (Test-Path $Dest) {
        $script:errors += "ABORT git mv: Ziel existiert bereits: $Dest"
        return
    }
    git mv $Source $Dest
    if ($LASTEXITCODE -eq 0) {
        $script:actions += "MOVED: $Source -> $Dest"
    } else {
        $script:errors += "FEHLER git mv: $Source -> $Dest"
    }
}

function Safe-Remove {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        $script:errors += "SKIP rm: Nicht gefunden: $Path"
        return
    }
    if (Test-Path $Path -PathType Container) {
        git rm -r --cached $Path 2>$null
        Remove-Item $Path -Recurse -Force
        $script:actions += "DELETED dir: $Path"
    } else {
        git rm --cached $Path 2>$null
        Remove-Item $Path -Force
        $script:actions += "DELETED file: $Path"
    }
}

Write-Host ""
Write-Host "=== VAULT-CLEANUP START ===" -ForegroundColor Cyan
Write-Host "Vault: $VaultRoot"
Write-Host ""

# -- PHASE 1: Claude outputs/ aufloesen ------------------------------------
Write-Host "Phase 1: Claude outputs/ aufloesen..." -ForegroundColor Yellow

# Duplikate loeschen (Originale existieren bereits anderswo)
Safe-Remove "Claude outputs\ceo-auftrag-onenote-sync.md"
Safe-Remove "Claude outputs\prompt-block-status-abfragen.md"
Safe-Remove "Claude outputs\gehirn-ceo-v3.md"

# Scripts: Originale existieren bereits in scripts/ - daher loeschen
Safe-Remove "Claude outputs\onenote-sync.ps1"
Safe-Remove "Claude outputs\onenote-sync-FIXED.ps1"
Safe-Remove "Claude outputs\studium-umbenennung-und-setup.ps1"

# Prompt: Original existiert bereits in PROJEKTE/Primarlehrer-Studium/prompts/ - daher loeschen
Safe-Remove "Claude outputs\CHAT-PROMPT-KOPIERFERTIG.md"

# Restliche Dateien in Claude outputs/ pruefen
if (Test-Path "Claude outputs") {
    $remaining = Get-ChildItem "Claude outputs" -Recurse -File
    if ($remaining.Count -eq 0) {
        Remove-Item "Claude outputs" -Recurse -Force
        $actions += "DELETED empty dir: Claude outputs\"
    } else {
        $errors += "WARNUNG: Claude outputs/ hat noch $($remaining.Count) Dateien"
    }
}

# -- PHASE 2: import/ + Root-Dateien entfernen ------------------------------
Write-Host "Phase 2: import/ + Root-Dateien entfernen..." -ForegroundColor Yellow

Safe-Remove "import"
Safe-Remove "Vorbereitungswoche image 0cd2845b71b9d0a6.png"

# -- PHASE 3: FAZITE/ bereinigen --------------------------------------------
Write-Host "Phase 3: FAZITE/ bereinigen..." -ForegroundColor Yellow

Safe-Remove "FAZITE\allgemein\feedback-log-1.md"
Safe-Remove "FAZITE\allgemein\gehirn-admin-cleanup-auftrag.md"

# Leeren Ordner entfernen
if (Test-Path "FAZITE\github-automation") {
    $items = Get-ChildItem "FAZITE\github-automation" -Recurse
    if ($items.Count -eq 0) {
        Remove-Item "FAZITE\github-automation" -Recurse -Force
        $actions += "DELETED empty dir: FAZITE\github-automation\"
    } else {
        $errors += "WARNUNG: FAZITE\github-automation\ ist nicht leer"
    }
}

# -- PHASE 4: STUDIUM/ konsolidieren ----------------------------------------
Write-Host "Phase 4: STUDIUM/ konsolidieren..." -ForegroundColor Yellow

# Modulbeschreibungen aus semester-01 nach primarlehrer/modules/ migrieren
$semester01Base = "STUDIUM\semester-01\fhnw-bach\module"

$allModules = @(
    "basisseminar-grundlagen-studium\bpbs1-basisseminar",
    "basisseminar-grundlagen-studium\glst1-grundlagen-studium",
    "grundlagen-modul\ewbu1-bildung-und-unterricht",
    "grundlagen-modul\ewib1-inklusive-bildung",
    "grundlagen-modul\ewig1-schule-institution-gesellschaft",
    "grundlagen-modul\feda1-wissenschaftliches-denken-arbeiten",
    "grundlagen-modul\fwfdde1-deutschunterricht",
    "grundlagen-modul\fwfden1-englischunterricht",
    "grundlagen-modul\fwfden11-englischunterricht",
    "grundlagen-modul\fwfdge1-gesellschaftswissenschaften",
    "grundlagen-modul\fwfdmi1-medien-informatik",
    "grundlagen-modul\fwfdmk1-mathematik",
    "grundlagen-modul\fwfdnmg1-natur-mensch-gesellschaft"
)

foreach ($mod in $allModules) {
    $moduleName = $mod.Split("\")[-1]
    $srcFile = "$semester01Base\$mod\modulbeschreibung.md"
    $destDir = "STUDIUM\primarlehrer\modules\$moduleName"
    $destFile = "$destDir\modulbeschreibung.md"

    if (Test-Path $srcFile) {
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Safe-GitMv $srcFile $destFile
    } else {
        $errors += "SKIP: modulbeschreibung.md nicht gefunden: $srcFile"
    }
}

# semester-01/ komplett loeschen (nur noch leere Templates)
Safe-Remove "STUDIUM\semester-01"

# Leeren Import-Ordner in STUDIUM loeschen
if (Test-Path "STUDIUM\import") {
    $items = Get-ChildItem "STUDIUM\import" -Recurse
    if ($items.Count -eq 0) {
        Remove-Item "STUDIUM\import" -Recurse -Force
        $actions += "DELETED empty dir: STUDIUM\import\"
    } else {
        $errors += "WARNUNG: STUDIUM\import\ ist nicht leer"
    }
}

# -- PHASE 5: Prompt-Regel verschieben -------------------------------------
Write-Host "Phase 5: Prompt-Verschiebung..." -ForegroundColor Yellow

Safe-GitMv "MEMORY\gehirn-feedback-prompt.md" "FAZITE\allgemein\prompts\gehirn-feedback-v1.md"

# -- PHASE 6: REST/ bereinigen ---------------------------------------------
Write-Host "Phase 6: REST/ bereinigen..." -ForegroundColor Yellow

# techniken.md loeschen (Inhalt wurde in technik-notizen.md gemergt)
Safe-Remove "REST\techniken.md"

# -- PHASE 7: .gitignore aktualisieren -------------------------------------
Write-Host "Phase 7: .gitignore aktualisieren..." -ForegroundColor Yellow

$gitignore = Get-Content ".gitignore" -Raw -Encoding UTF8
if ($gitignore -notmatch "Claude outputs/") {
    $newLine = "`n# Bot-Output (kein Vault-Ordner)`nClaude outputs/`n"
    Add-Content ".gitignore" $newLine -Encoding UTF8 -NoNewline
    $actions += "UPDATED: .gitignore -- Claude outputs/ hinzugefuegt"
} else {
    $actions += "SKIP: .gitignore hat bereits Claude outputs/"
}

# -- ZUSAMMENFASSUNG -------------------------------------------------------
Write-Host ""
Write-Host "=== ZUSAMMENFASSUNG ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Aktionen ($($actions.Count)):" -ForegroundColor Green
$actions | ForEach-Object { Write-Host "  $_" }

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "Fehler/Warnungen ($($errors.Count)):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
} else {
    Write-Host ""
    Write-Host "Keine Fehler!" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== CLEANUP FERTIG ===" -ForegroundColor Cyan
Write-Host "Naechster Schritt:"
Write-Host "  git add -A"
Write-Host "  git commit -m 'vault-cleanup 2026-09-13 (gehirn-admin)'"
Write-Host "ACHTUNG: Vor dem Commit pruefen mit 'git status' und 'git diff --cached'"
