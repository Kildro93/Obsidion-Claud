# OneNote-Sync: Automatische Studium-Modul-Normalisierung
# UTF-8 with BOM required (REGEL-FB07)

param(
    [string]$ImportPfad = "STUDIUM\import",
    [string]$ZielSemester = "semester-01",
    [string]$ZielGruppe = "",
    [switch]$WhatIf
)

# Error handling
$ErrorActionPreference = "Continue"

# Farben für Logging
$Farben = @{
    OK = "Green"
    SKIP = "Yellow"
    FEHLER = "Red"
    INFO = "Cyan"
}

function Log {
    param([string]$Message, [string]$Status = "INFO")
    $Farbe = if ($Farben.ContainsKey($Status)) { $Farben[$Status] } else { "White" }
    Write-Host "[$Status] $Message" -ForegroundColor $Farbe
}

# Normalisiere Ordnernamen: "(KÜRZEL) Langer Name" -> "kürzel-langer-name"
function Normalize-FolderName {
    param([string]$Name)

    # Entferne (KÜRZEL) Präfix
    $Normalized = $Name -replace '^\([A-Z0-9]+\)\s*', ''

    # Kleinbuchstaben, Bindestriche statt Leerzeichen, Sonderzeichen entfernen
    $Normalized = $Normalized.ToLower()
    $Normalized = $Normalized -replace '\s+', '-'
    $Normalized = $Normalized -replace '[^a-z0-9\-]', ''
    $Normalized = $Normalized -replace '\-+', '-'
    $Normalized = $Normalized -replace '^-|-$', ''

    return $Normalized
}

# Erstelle Modul-Templates
function Create-ModuleTemplates {
    param(
        [string]$ModulPath,
        [bool]$IsWhatIf
    )

    $Templates = @{
        "zusammenfassung.md" = "# Zusammenfassung`n`nWichtigste Punkte aus dem Modul.`n"
        "lernkarten.md" = "# Lernkarten`n`nFrage | Antwort`n--- | ---`n`n"
        "pruefungsfragen.md" = "# Pr$([char]0xFC)fungsfragen`n`nPotenzielle Pr$([char]0xFC)fungsfragen mit L$([char]0xF6)sungen.`n"
        "zeitplan.md" = "# Zeitplan`n`nLernschritte und Deadlines.`n"
    }

    $NotizPath = Join-Path $ModulPath "notizen"

    foreach ($Datei in $Templates.Keys) {
        $FilePath = Join-Path $ModulPath $Datei
        if (-not (Test-Path $FilePath)) {
            if ($IsWhatIf) {
                Log "WhatIf: Erstelle $Datei in $([System.IO.Path]::GetFileName($ModulPath))" "INFO"
            } else {
                New-Item -ItemType File -Path $FilePath -Value $Templates[$Datei] -Force | Out-Null
                Log "Erstellt: $Datei" "OK"
            }
        }
    }

    if (-not (Test-Path $NotizPath)) {
        if ($IsWhatIf) {
            Log "WhatIf: Erstelle notizen/ Ordner" "INFO"
        } else {
            New-Item -ItemType Directory -Path $NotizPath -Force | Out-Null
            Log "Erstellt: notizen/ Ordner" "OK"
        }
    }
}

# Hauptlogik
function Main {
    Log "OneNote-Sync startet..." "INFO"
    Log "Import-Pfad: $ImportPfad" "INFO"
    Log "Ziel-Semester: $ZielSemester" "INFO"
    if ($WhatIf) { Log "WHATIF-MODUS: Keine $([char]0xC4)nderungen vorgenommen" "INFO" }

    # Vollst$([char]0xE4)ndige Pfade
    $ImportFull = if ([System.IO.Path]::IsPathRooted($ImportPfad)) {
        $ImportPfad
    } else {
        Resolve-Path (Join-Path $PSScriptRoot "..\$ImportPfad" -Resolve -ErrorAction Stop)
    }

    $ZielBase = if ([System.IO.Path]::IsPathRooted("STUDIUM")) {
        "STUDIUM"
    } else {
        Resolve-Path (Join-Path $PSScriptRoot "..\STUDIUM" -Resolve -ErrorAction Stop)
    }

    $ZielPath = Join-Path $ZielBase $ZielSemester "fhnw-bach" "module"
    if ($ZielGruppe) {
        $ZielPath = Join-Path $ZielPath $ZielGruppe
    }

    Log "Ziel-Struktur: $ZielPath" "INFO"

    # Import-Ordner scannen
    if (-not (Test-Path $ImportFull)) {
        Log "Import-Ordner nicht gefunden: $ImportFull" "FEHLER"
        return
    }

    $ModulOrdner = Get-ChildItem -Path $ImportFull -Directory -ErrorAction SilentlyContinue

    if (-not $ModulOrdner) {
        Log "Keine Module im Import-Ordner gefunden" "SKIP"
        return
    }

    Log "Gefunden: $($ModulOrdner.Count) Module" "INFO"

    foreach ($Ordner in $ModulOrdner) {
        $NormalisierterName = Normalize-FolderName $Ordner.Name
        $ZielModulPath = Join-Path $ZielPath $NormalisierterName

        # Pr$([char]0xFC)fe ob bereits existiert
        if (Test-Path $ZielModulPath) {
            Log "SKIP: $NormalisierterName existiert bereits" "SKIP"
            continue
        }

        # Erstelle Zielordner
        if ($WhatIf) {
            Log "WhatIf: Erstelle Modul-Ordner: $NormalisierterName" "INFO"
        } else {
            New-Item -ItemType Directory -Path $ZielModulPath -Force | Out-Null
            Log "Erstellt: $NormalisierterName" "OK"

            # Kopiere vorhandene Dateien aus Import
            $DateienQuell = Get-ChildItem -Path $Ordner.FullName -File -Recurse
            foreach ($Datei in $DateienQuell) {
                $RelPath = $Datei.FullName.Substring($Ordner.FullName.Length + 1)
                $ZielDatei = Join-Path $ZielModulPath $RelPath
                $ZielDir = Split-Path $ZielDatei

                if (-not (Test-Path $ZielDir)) {
                    New-Item -ItemType Directory -Path $ZielDir -Force | Out-Null
                }

                Copy-Item -Path $Datei.FullName -Destination $ZielDatei -Force
            }

            Log "Dateien kopiert: $($DateienQuell.Count)" "OK"
        }

        # Erstelle Templates
        Create-ModuleTemplates -ModulPath $ZielModulPath -IsWhatIf $WhatIf
    }

    Log "OneNote-Sync abgeschlossen" "INFO"
}

# Starten
Main
