$ErrorActionPreference = 'Stop'
$vaultRoot = Split-Path $PSScriptRoot -Parent
$base = Join-Path $vaultRoot "STUDIUM"

if (-not (Test-Path $base)) {
    Write-Host "FEHLER: STUDIUM-Ordner nicht gefunden unter: $base" -ForegroundColor Red
    exit 1
}

# ============================================================
# 1) ORDNER UMBENENNEN: Namenskonvention (kleingeschrieben, Bindestriche)
# ============================================================

$renames = @(
    @{ Old = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium\(BPBS1) Basisseminar";                      New = "bpbs1-basisseminar" }
    @{ Old = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium\(GLST1) Grundlagen Studium";                New = "glst1-grundlagen-studium" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(EWBU1) Bildung und Unterricht";                             New = "ewbu1-bildung-und-unterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(EWIB1) Inklusive Bildung";                                  New = "ewib1-inklusive-bildung" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(EWIG1) Schule Institution und Gesellschaft";                New = "ewig1-schule-institution-gesellschaft" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FEDA1) wissenschaftlichen Denkens und Arbeitens";           New = "feda1-wissenschaftliches-denken-arbeiten" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDDE1) f$(([char]0xFC))r den Deutschunterricht";          New = "fwfdde1-deutschunterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDEN1) f$(([char]0xFC))r den Englischunterricht";         New = "fwfden1-englischunterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDEN11)f$(([char]0xFC))r den Englischunterricht";         New = "fwfden11-englischunterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDGE1) f$(([char]0xFC))r den Unterricht in den Disziplinen de"; New = "fwfdge1-gesellschaftswissenschaften" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDMI1) f$(([char]0xFC))r den Medien- und Informatikunterricht"; New = "fwfdmi1-medien-informatik" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDMK1) f$(([char]0xFC))r den Mathematikunterricht";       New = "fwfdmk1-mathematik" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDNMG1) f$(([char]0xFC))r den Sachunterricht Natur, Mensch, G"; New = "fwfdnmg1-natur-mensch-gesellschaft" }
    # Gruppen-Ordner
    @{ Old = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium"; New = "basisseminar-grundlagen-studium" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul";                  New = "grundlagen-modul" }
    # Module-Ordner
    @{ Old = "semester-01\FHNW Bach\Module"; New = "module" }
    # FHNW Bach
    @{ Old = "semester-01\FHNW Bach"; New = "fhnw-bach" }
)

Write-Host "=== ORDNER UMBENENNEN ===" -ForegroundColor Cyan

foreach ($r in $renames) {
    $oldPath = Join-Path $base $r.Old
    if (Test-Path $oldPath) {
        Rename-Item -Path $oldPath -NewName $r.New
        Write-Host "  OK: $($r.Old) -> $($r.New)" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: $($r.Old) nicht gefunden" -ForegroundColor Yellow
    }
}

# ============================================================
# 2) Modulbeschreibung.md -> modulbeschreibung.md
# ============================================================

Write-Host "`n=== DATEIEN UMBENENNEN ===" -ForegroundColor Cyan

$mdFiles = Get-ChildItem -Path $base -Recurse -Filter "Modulbeschreibung.md"
foreach ($f in $mdFiles) {
    Rename-Item -Path $f.FullName -NewName "modulbeschreibung.md"
    Write-Host "  OK: $($f.FullName) -> modulbeschreibung.md" -ForegroundColor Green
}

# ============================================================
# 3) MODUL-TEMPLATE pro Modul anlegen
# ============================================================

Write-Host "`n=== MODUL-TEMPLATE ANLEGEN ===" -ForegroundColor Cyan

$modulDirs = @()
$modulDirs += Get-ChildItem -Path $base -Recurse -Filter "modulbeschreibung.md" | ForEach-Object { $_.Directory }
if ($modulDirs.Count -eq 0) {
    $modulDirs += Get-ChildItem -Path $base -Recurse -Filter "Modulbeschreibung.md" | ForEach-Object { $_.Directory }
}

$heute = Get-Date -Format 'yyyy-MM-dd'
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

$templateFiles = @(
    @{
        Name = "zusammenfassung.md"
        Content = "---`r`ntitle: zusammenfassung`r`ncreated: $heute`r`nupdated: $heute`r`nstatus: leer`r`ntags: [typ/zusammenfassung, status/leer]`r`n---`r`n`r`n# Zusammenfassung`r`n`r`n> Wird im Verlauf des Semesters ergaenzt.`r`n`r`n## Kernkonzepte`r`n`r`n## Wichtigste Erkenntnisse`r`n`r`n## Pruefungsrelevant`r`n"
    }
    @{
        Name = "lernkarten.md"
        Content = "---`r`ntitle: lernkarten`r`ncreated: $heute`r`nupdated: $heute`r`nstatus: leer`r`ntags: [typ/lernkarten, status/leer]`r`n---`r`n`r`n# Lernkarten`r`n`r`nFormat: Frage -> Antwort`r`n`r`n---`r`n`r`n**F:**`r`n**A:**`r`n`r`n---`r`n"
    }
    @{
        Name = "pruefungsfragen.md"
        Content = "---`r`ntitle: pruefungsfragen`r`ncreated: $heute`r`nupdated: $heute`r`nstatus: leer`r`ntags: [typ/pruefung, status/leer]`r`n---`r`n`r`n# Pruefungsfragen`r`n`r`n## Bekannte Fragen aus Altpruefungen`r`n`r`n## Eigene Uebungsfragen`r`n`r`n## Schwierige Themen`r`n"
    }
    @{
        Name = "zeitplan.md"
        Content = "---`r`ntitle: zeitplan`r`ncreated: $heute`r`nupdated: $heute`r`nstatus: leer`r`ntags: [typ/zeitplan, status/leer]`r`n---`r`n`r`n# Zeitplan`r`n`r`n| KW | Thema | Aufgaben | Status |`r`n|----|-------|----------|--------|`r`n|    |       |          |        |`r`n"
    }
)

foreach ($dir in $modulDirs) {
    Write-Host "  Modul: $($dir.Name)" -ForegroundColor White

    $notizenDir = Join-Path $dir.FullName "notizen"
    if (-not (Test-Path $notizenDir)) {
        New-Item -ItemType Directory -Path $notizenDir | Out-Null
        Write-Host "    + notizen/" -ForegroundColor Green
    }

    foreach ($tmpl in $templateFiles) {
        $filePath = Join-Path $dir.FullName $tmpl.Name
        if (-not (Test-Path $filePath)) {
            $resolvedDir = Resolve-Path $dir.FullName
            $fullPath = Join-Path $resolvedDir $tmpl.Name
            [System.IO.File]::WriteAllText($fullPath, $tmpl.Content, $utf8NoBom)
            Write-Host "    + $($tmpl.Name)" -ForegroundColor Green
        } else {
            Write-Host "    = $($tmpl.Name) existiert schon" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n=== FERTIG ===" -ForegroundColor Cyan
