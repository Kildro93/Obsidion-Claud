<#
  weekly-backup.ps1 - Wochen-ZIP des Vaults nach backups/ (git-ignoriert).
  Haelt die letzten 8 Backups, loescht aeltere.
  Registrierung: install-backup-task.ps1

  Ausgeschlossen wird auf JEDER Ebene, nicht nur im Vault-Root: node_modules,
  .git, build, dist, .gradle, www, backups. Das ist der Unterschied zwischen
  einem 2-MB-Backup der Notizen und einem 42-MB-Backup voller Abhaengigkeiten,
  die sich mit einem npm install wiederherstellen lassen.
#>

$ErrorActionPreference = 'Stop'

$VaultRoot = Split-Path -Parent $PSScriptRoot
$BackupDir = Join-Path $VaultRoot 'backups'
$Keep      = 8
$Stamp     = Get-Date -Format 'yyyy-MM-dd'
$Target    = Join-Path $BackupDir ("vault-backup-{0}.zip" -f $Stamp)

# Verzeichnisnamen, die auf jeder Ebene uebersprungen werden
$SkipDirs  = @('node_modules', '.git', 'build', 'dist', '.gradle', 'www', 'backups', 'logs', '.gradle-cache')
# Einzelne Dateiendungen, die nichts im Backup verloren haben
$SkipExt   = @('.apk', '.aab', '.log')

if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir | Out-Null }

Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null

$rootLen = $VaultRoot.Length + 1

# Dateiliste aufbauen und dabei filtern
$files = Get-ChildItem -Path $VaultRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
        $rel   = $_.FullName.Substring($rootLen)
        $parts = $rel -split '\\'
        $dirs  = $parts[0..([Math]::Max(0, $parts.Count - 2))]
        -not ($dirs | Where-Object { $SkipDirs -contains $_ }) -and
        ($SkipExt -notcontains $_.Extension.ToLower())
    }

if (Test-Path $Target) { Remove-Item $Target -Force }

$zip = [System.IO.Compression.ZipFile]::Open($Target, 'Create')
try {
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($rootLen)
        try {
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $zip, $f.FullName, $rel, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
        } catch {
            Write-Warning "uebersprungen: $rel ($($_.Exception.Message))"
        }
    }
}
finally { $zip.Dispose() }

$sizeMb = [math]::Round((Get-Item $Target).Length / 1MB, 1)
Write-Host ("Backup erstellt: {0} ({1} Dateien, {2} MB)" -f $Target, $files.Count, $sizeMb)

# Alte Backups aufraeumen
Get-ChildItem $BackupDir -Filter 'vault-backup-*.zip' |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Skip $Keep |
    ForEach-Object { Remove-Item $_.FullName -Force; Write-Host "Geloescht: $($_.Name)" }
