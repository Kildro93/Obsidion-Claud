# Studium-Cleanup: Leere Stubs, leere Ordner, lose Root-Dateien
# Verwendet git rm fuer getrackte Dateien, Remove-Item als Fallback

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Safe-Remove {
    param([string]$path)
    if (-not (Test-Path $path)) {
        Write-Host "  SKIP (nicht gefunden): $path" -ForegroundColor DarkGray
        return
    }
    $gitOutput = git rm -f $path 2>&1
    if ($LASTEXITCODE -ne 0) {
        Remove-Item $path -Force
        Write-Host "  Geloescht (untracked): $path" -ForegroundColor Green
    } else {
        Write-Host "  Geloescht (git rm): $path" -ForegroundColor Green
    }
}

# === 1. STUDIUM: Leere Untitled-Stubs loeschen ===
Write-Host "`n=== STUDIUM: Leere Untitled-Stubs ===" -ForegroundColor Cyan

$base = "STUDIUM\semester-01\FHNW Bach\Module"

$untitledFiles = @(
    "$base\Basisseminar _ Grundlagen Studium\(BPBS1) Basisseminar\Untitled-20260910170215.md"
    "$base\Basisseminar _ Grundlagen Studium\(GLST1) Grundlagen Studium\Untitled-20260910170217.md"
    "$base\Grundlagen Modul\(EWBU1) Bildung und Unterricht\Untitled-20260910170219.md"
    "$base\Grundlagen Modul\(EWIG1) Schule Institution und Gesellschaft\Untitled-20260910170224.md"
    "$base\Grundlagen Modul\(EWIG1) Schule Institution und Gesellschaft\Untitled-20260910170225.md"
    "$base\Grundlagen Modul\(EWIG1) Schule Institution und Gesellschaft\Untitled-20260910170226.md"
    "$base\Grundlagen Modul\(FWFDEN11)f$([char]0xFC)r den Englischunterricht\Untitled-20260910170234.md"
    "$base\Grundlagen Modul\(FWFDMI1) f$([char]0xFC)r den Medien- und Informatikunterricht\Untitled-20260910170237.md"
)

foreach ($f in $untitledFiles) {
    Safe-Remove $f
}

# === 2. STUDIUM: Inhaltslose Stub-Dateien ===
Write-Host "`n=== STUDIUM: Inhaltslose Stubs ===" -ForegroundColor Cyan

Safe-Remove "STUDIUM\semester-01\FHNW Bach\Wichtige Links f$([char]0xFC)r FHNW\Link Liste.md"
Safe-Remove "$base\Grundlagen Modul\(FWFDMK1) f$([char]0xFC)r den Mathematikunterricht\Dokumente.md"

# === 3. STUDIUM: Leere Ordner entfernen ===
Write-Host "`n=== STUDIUM: Leere Ordner ===" -ForegroundColor Cyan

$emptyDirs = @(
    "STUDIUM\semester-01\Deutsch"
    "STUDIUM\semester-01\Mathematik"
    "STUDIUM\semester-01\Naturwissenschaften"
    "STUDIUM\semester-01\P$([char]0xE4)dagogik"
    "STUDIUM\semester-01\Praktikum"
    "STUDIUM\semester-01\Sprache-und-Literatur"
    "STUDIUM\semester-01\FHNW Bach\Wichtige Links f$([char]0xFC)r FHNW"
)

foreach ($d in $emptyDirs) {
    if (Test-Path $d) {
        $items = Get-ChildItem $d -Force -ErrorAction SilentlyContinue
        if ($items.Count -eq 0) {
            Remove-Item $d -Force -Recurse
            Write-Host "  Ordner entfernt: $d" -ForegroundColor Green
        } else {
            Write-Host "  SKIP (nicht leer): $d" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  SKIP (nicht gefunden): $d" -ForegroundColor DarkGray
    }
}

# === 4. Root: Lose Dateien loeschen ===
Write-Host "`n=== ROOT: Lose Dateien ===" -ForegroundColor Cyan

Safe-Remove '2026-09-12.md'
Safe-Remove 'Unbenannt.base'
Safe-Remove 'Unbenannt.canvas'

Write-Host "`ndesktop.ini ist bereits in .gitignore - OK" -ForegroundColor DarkGray
Write-Host "README.md bleibt - OK" -ForegroundColor DarkGray

# === 5. Git stagen ===
Write-Host "`n=== GIT: Stagen ===" -ForegroundColor Cyan
git add -A
git status --short | Select-Object -First 40

Write-Host "`nBereit zum Commit. Fuehre aus:" -ForegroundColor Yellow
Write-Host '  git commit -m "cleanup: studium-stubs, leere ordner, lose root-dateien entfernt"' -ForegroundColor Yellow
