$ErrorActionPreference = 'Stop'
$base = Resolve-Path "C:\KI Programme\Obsidion für Claud\STUDIUM"

# ============================================================
# 1) ORDNER UMBENENNEN: Namenskonvention (kleingeschrieben, Bindestriche)
# ============================================================

# Mapping: alter Name -> neuer Name (bottom-up, tiefste zuerst)
$renames = @(
    # Module-Unterordner (tiefste Ebene zuerst)
    @{ Old = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium\(BPBS1) Basisseminar";                           New = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium\bpbs1-basisseminar" }
    @{ Old = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium\(GLST1) Grundlagen Studium";                     New = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium\glst1-grundlagen-studium" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(EWBU1) Bildung und Unterricht";                                  New = "semester-01\FHNW Bach\Module\Grundlagen Modul\ewbu1-bildung-und-unterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(EWIB1) Inklusive Bildung";                                       New = "semester-01\FHNW Bach\Module\Grundlagen Modul\ewib1-inklusive-bildung" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(EWIG1) Schule Institution und Gesellschaft";                     New = "semester-01\FHNW Bach\Module\Grundlagen Modul\ewig1-schule-institution-gesellschaft" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FEDA1) wissenschaftlichen Denkens und Arbeitens";                New = "semester-01\FHNW Bach\Module\Grundlagen Modul\feda1-wissenschaftliches-denken-arbeiten" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDDE1) für den Deutschunterricht";                             New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfdde1-deutschunterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDEN1) für den Englischunterricht";                            New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfden1-englischunterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDEN11)für den Englischunterricht";                            New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfden11-englischunterricht" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDGE1) für den Unterricht in den Disziplinen de";              New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfdge1-gesellschaftswissenschaften" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDMI1) für den Medien- und Informatikunterricht";              New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfdmi1-medien-informatik" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDMK1) für den Mathematikunterricht";                          New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfdmk1-mathematik" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul\(FWFDNMG1) für den Sachunterricht Natur, Mensch, G";              New = "semester-01\FHNW Bach\Module\Grundlagen Modul\fwfdnmg1-natur-mensch-gesellschaft" }

    # Gruppen-Ordner (eine Ebene hoeher)
    @{ Old = "semester-01\FHNW Bach\Module\Basisseminar _ Grundlagen Studium"; New = "semester-01\FHNW Bach\Module\basisseminar-grundlagen-studium" }
    @{ Old = "semester-01\FHNW Bach\Module\Grundlagen Modul";                  New = "semester-01\FHNW Bach\Module\grundlagen-modul" }

    # Module-Ordner
    @{ Old = "semester-01\FHNW Bach\Module"; New = "semester-01\FHNW Bach\module" }

    # FHNW Bach
    @{ Old = "semester-01\FHNW Bach"; New = "semester-01\fhnw-bach" }
)

Write-Host "=== ORDNER UMBENENNEN ===" -ForegroundColor Cyan

foreach ($r in $renames) {
    $oldPath = Join-Path $base $r.Old
    $newPath = Join-Path $base $r.New

    if (Test-Path $oldPath) {
        # Rename-Item braucht nur den neuen Blatt-Namen
        $newLeaf = Split-Path $newPath -Leaf
        Rename-Item -Path $oldPath -NewName $newLeaf
        Write-Host "  OK: $($r.Old) -> $newLeaf" -ForegroundColor Green
    } else {
        Write-Host "  SKIP: $($r.Old) existiert nicht (evtl. schon umbenannt)" -ForegroundColor Yellow
    }
}

# ============================================================
# 2) Modulbeschreibung.md -> modulbeschreibung.md (Datei umbenennen)
# ============================================================

Write-Host "`n=== DATEIEN UMBENENNEN ===" -ForegroundColor Cyan

$mdFiles = Get-ChildItem -Path $base -Recurse -Filter "Modulbeschreibung.md"
foreach ($f in $mdFiles) {
    Rename-Item -Path $f.FullName -NewName "modulbeschreibung.md"
    Write-Host "  OK: $($f.FullName) -> modulbeschreibung.md" -ForegroundColor Green
}

# ============================================================
# 3) MODUL-TEMPLATE: Dateien pro Modul anlegen
# ============================================================

Write-Host "`n=== MODUL-TEMPLATE ANLEGEN ===" -ForegroundColor Cyan

# Alle Modul-Ordner finden (enthalten jetzt modulbeschreibung.md)
$modulDirs = Get-ChildItem -Path $base -Recurse -Filter "modulbeschreibung.md" | ForEach-Object { $_.Directory }

$templateFiles = @(
    @{
        Name = "zusammenfassung.md"
        Content = @"
---
title: zusammenfassung
created: $(Get-Date -Format 'yyyy-MM-dd')
updated: $(Get-Date -Format 'yyyy-MM-dd')
status: leer
tags: [typ/zusammenfassung, status/leer]
---

# Zusammenfassung

> Wird im Verlauf des Semesters ergaenzt.

## Kernkonzepte

## Wichtigste Erkenntnisse

## Pruefungsrelevant
"@
    }
    @{
        Name = "lernkarten.md"
        Content = @"
---
title: lernkarten
created: $(Get-Date -Format 'yyyy-MM-dd')
updated: $(Get-Date -Format 'yyyy-MM-dd')
status: leer
tags: [typ/lernkarten, status/leer]
---

# Lernkarten

Format: Frage -> Antwort

---

**F:**
**A:**

---
"@
    }
    @{
        Name = "pruefungsfragen.md"
        Content = @"
---
title: pruefungsfragen
created: $(Get-Date -Format 'yyyy-MM-dd')
updated: $(Get-Date -Format 'yyyy-MM-dd')
status: leer
tags: [typ/pruefung, status/leer]
---

# Pruefungsfragen

## Bekannte Fragen aus Altpruefungen

## Eigene Uebungsfragen

## Schwierige Themen
"@
    }
    @{
        Name = "zeitplan.md"
        Content = @"
---
title: zeitplan
created: $(Get-Date -Format 'yyyy-MM-dd')
updated: $(Get-Date -Format 'yyyy-MM-dd')
status: leer
tags: [typ/zeitplan, status/leer]
---

# Zeitplan

| KW | Thema | Aufgaben | Status |
|----|-------|----------|--------|
|    |       |          |        |
"@
    }
)

foreach ($dir in $modulDirs) {
    Write-Host "  Modul: $($dir.Name)" -ForegroundColor White

    # notizen/ Unterordner
    $notizenDir = Join-Path $dir.FullName "notizen"
    if (-not (Test-Path $notizenDir)) {
        New-Item -ItemType Directory -Path $notizenDir | Out-Null
        Write-Host "    + notizen/" -ForegroundColor Green
    }

    # Template-Dateien
    foreach ($tmpl in $templateFiles) {
        $filePath = Join-Path $dir.FullName $tmpl.Name
        if (-not (Test-Path $filePath)) {
            # UTF-8 ohne BOM fuer Markdown
            [System.IO.File]::WriteAllText(
                (Resolve-Path $dir.FullName | Join-Path -ChildPath $tmpl.Name),
                $tmpl.Content,
                [System.Text.UTF8Encoding]::new($false)
            )
            Write-Host "    + $($tmpl.Name)" -ForegroundColor Green
        } else {
            Write-Host "    = $($tmpl.Name) existiert schon" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n=== FERTIG ===" -ForegroundColor Cyan
Write-Host "Naechster Schritt: Git-Block ausfuehren" -ForegroundColor White
