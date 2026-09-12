# Vault-Nachbearbeitung: Frontmatter + Wikilinks
# Fuegt Pflicht-Frontmatter in Setup-Dateien ein und repariert Wikilinks

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Add-Frontmatter {
    param([string]$file, [string]$title, [string]$created, [string]$tags, [string]$autor)
    if (-not (Test-Path $file)) {
        Write-Warning "SKIP: $file nicht gefunden"
        return
    }
    $content = Get-Content $file -Raw -Encoding UTF8
    if ($content -match "^---") {
        Write-Host "  SKIP (hat bereits Frontmatter): $file" -ForegroundColor DarkGray
        return
    }
    $fm = "---`ntitle: $title`ncreated: $created`nupdated: 2026-09-12`nstatus: aktuell`ntags: [$tags]`nautor: $autor`n---`n`n"
    $newContent = $fm + $content
    Set-Content $file $newContent -Encoding UTF8 -NoNewline
    Write-Host "  Frontmatter hinzugefuegt: $file" -ForegroundColor Green
}

Write-Host "`n=== FRONTMATTER: Setup-Dateien ===" -ForegroundColor Cyan

Add-Frontmatter "MEMORY/setup/auto-sync.md" "auto-sync" "2026-09-06" "typ/setup, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/backup-strategy.md" "backup-strategy" "2026-09-06" "typ/setup, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/checklist.md" "checklist" "2026-09-06" "typ/setup, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/projekt-credentials.md" "projekt-credentials" "2026-09-06" "typ/setup, bereich/security, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/security-audit.md" "security-audit" "2026-09-06" "typ/setup, bereich/security, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/setup-env-local.md" "setup-env-local" "2026-09-06" "typ/setup, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/setup-firebase.md" "setup-firebase" "2026-09-06" "typ/setup, bereich/firebase, status/aktuell" "indra"
Add-Frontmatter "MEMORY/setup/setup-github-token.md" "setup-github-token" "2026-09-06" "typ/setup, bereich/security, status/aktuell" "indra"

Write-Host "`n=== WIKILINKS REPARIEREN ===" -ForegroundColor Cyan

# Alle .md Dateien durchsuchen und alte Links ersetzen
$mdFiles = Get-ChildItem -Path "." -Filter "*.md" -Recurse | Where-Object {
    $_.FullName -notmatch "\\\.git\\" -and
    $_.FullName -notmatch "\\\.obsidian\\" -and
    $_.FullName -notmatch "\\Nestbau\\" -and
    $_.FullName -notmatch "\\nestbau-firebase\\" -and
    $_.FullName -notmatch "\\node_modules\\" -and
    $_.FullName -notmatch "\\backups\\"
}

# Link-Ersetzungen (alt -> neu)
$replacements = @{
    '[[MEMORY_INDEX]]' = '[[MEMORY/memory-index]]'
    '[[Profil]]' = '[[MEMORY/profil]]'
    '[[Regeln]]' = '[[MEMORY/regeln]]'
    '[[Vault-Struktur]]' = '[[MEMORY/vault-struktur]]'
    '[[QUICK-START]]' = '[[MEMORY/quick-start]]'
    '[[DEBUGGING]]' = '[[MEMORY/debugging]]'
    '[[Chat-Closure-Protocol]]' = '[[MEMORY/chat-closure-protocol]]'
    '[[Prompt-Typen-Guide]]' = '[[MEMORY/prompt-typen-guide]]'
    '[[Workflows]]' = '[[MEMORY/workflows]]'
    '[[PROJEKT-CREDENTIALS]]' = '[[MEMORY/setup/projekt-credentials]]'
    '[[SETUP-GITHUB-TOKEN]]' = '[[MEMORY/setup/setup-github-token]]'
    '[[SETUP-FIREBASE]]' = '[[MEMORY/setup/setup-firebase]]'
    '[[SETUP-ENV-LOCAL]]' = '[[MEMORY/setup/setup-env-local]]'
    '[[AUTO-SYNC]]' = '[[MEMORY/setup/auto-sync]]'
    '[[BACKUP-STRATEGY]]' = '[[MEMORY/setup/backup-strategy]]'
    '[[SECURITY-AUDIT]]' = '[[MEMORY/setup/security-audit]]'
    '[[CHECKLIST]]' = '[[MEMORY/setup/checklist]]'
    '[[_INDEX]]' = '[[PROJEKTE/GitHub-Automation/index]]'
    '[[MASTER-INDEX.md]]' = '[[MEMORY/memory-index]]'
    '[[MASTER-INDEX]]' = '[[MEMORY/memory-index]]'
    # Alte SYSTEM/ Pfade
    'SYSTEM/MEMORY_INDEX.md' = 'MEMORY/memory-index.md'
    'SYSTEM/Regeln.md' = 'MEMORY/regeln.md'
    'SYSTEM/Profil.md' = 'MEMORY/profil.md'
    # Chat-Export alte Pfade
    'SYSTEM/Chat-Exports/' = 'FAZITE/allgemein/'
    'PROJEKTE/Nestbau/Chat-Exports/' = 'FAZITE/nestbau/'
}

$totalChanges = 0
foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    if (-not $content) { continue }
    $original = $content
    foreach ($old in $replacements.Keys) {
        $content = $content.Replace($old, $replacements[$old])
    }
    if ($content -ne $original) {
        Set-Content $file.FullName $content -Encoding UTF8 -NoNewline
        $totalChanges++
        Write-Host "  Links repariert: $($file.FullName)" -ForegroundColor Green
    }
}

Write-Host "`n  Insgesamt $totalChanges Dateien aktualisiert" -ForegroundColor Cyan

Write-Host "`n=== GIT: Alles stagen und committen ===" -ForegroundColor Cyan
git add -A
git status --short | Select-Object -First 60

Write-Host "`nBereit zum Commit. Fuehre aus:" -ForegroundColor Yellow
Write-Host '  git commit -m "vault-migration: nachbearbeitung - frontmatter, wikilinks, neue memory-dateien"' -ForegroundColor Yellow
