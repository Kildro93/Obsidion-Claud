# Prueft, ob C:\Users\indra\Nestbau geloescht werden kann
# Ausgabe in den Chat kopieren

$alt = "C:\Users\indra\Nestbau"
cd $alt

Write-Host "=== 1. UNCOMMITTED CHANGES ===" -ForegroundColor Cyan
git status --short
Write-Host "(leer = alles committet)"

Write-Host ""
Write-Host "=== 2. NICHT GEPUSHTE COMMITS ===" -ForegroundColor Cyan
git fetch origin 2>$null
git log --oneline origin/main..HEAD
Write-Host "(leer = alles auf GitHub)"

Write-Host ""
Write-Host "=== 3. UNTRACKED / IGNORIERTE DATEIEN (das Wichtige!) ===" -ForegroundColor Yellow
git status --short --untracked-files=all --ignored |
    Where-Object { $_ -match '^(\?\?|!!)' } |
    Where-Object { $_ -notmatch 'node_modules|\.gradle|build/|dist/|\.cache' }

Write-Host ""
Write-Host "=== 4. SCHLUESSEL & CONFIGS ===" -ForegroundColor Red
Get-ChildItem -Recurse -Force -Include `
    "*.local.js","*.keystore","*.jks","keystore.properties",".env",".env.*", `
    "*secret*","*credential*","google-services.json","firebase-*.json" `
    -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch 'node_modules|\.git\\' } |
    Select-Object FullName, Length, LastWriteTime

Write-Host ""
Write-Host "=== 5. BRANCHES ===" -ForegroundColor Cyan
git branch -vv

Write-Host ""
Write-Host "=== 6. GROESSE ===" -ForegroundColor Cyan
"{0:N1} MB" -f ((Get-ChildItem -Recurse -Force -ErrorAction SilentlyContinue |
    Measure-Object -Property Length -Sum).Sum / 1MB)
