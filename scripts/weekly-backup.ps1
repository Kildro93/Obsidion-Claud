<#
  weekly-backup.ps1 - Wochen-ZIP des Vaults nach backups/ (git-ignoriert).
  Haelt die letzten 8 Backups, loescht aeltere.
  Registrierung: install-backup-task.ps1
#>

$ErrorActionPreference = 'Stop'

$VaultRoot = Split-Path -Parent $PSScriptRoot
$BackupDir = Join-Path $VaultRoot 'backups'
$Keep      = 8
$Stamp     = Get-Date -Format 'yyyy-MM-dd'
$Target    = Join-Path $BackupDir ("vault-backup-{0}.zip" -f $Stamp)

if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir | Out-Null }

# Was nicht ins Backup gehoert (regenerierbar oder riesig)
$Exclude = @('backups', 'node_modules', '.git', 'build', 'dist', '.gradle')

$temp = Join-Path $env:TEMP ("vault-backup-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temp | Out-Null

try {
    Get-ChildItem -Path $VaultRoot -Force |
        Where-Object { $Exclude -notcontains $_.Name } |
        ForEach-Object {
            Copy-Item $_.FullName -Destination $temp -Recurse -Force -ErrorAction SilentlyContinue
        }

    if (Test-Path $Target) { Remove-Item $Target -Force }
    Compress-Archive -Path (Join-Path $temp '*') -DestinationPath $Target -CompressionLevel Optimal

    $sizeMb = [math]::Round((Get-Item $Target).Length / 1MB, 1)
    Write-Host "Backup erstellt: $Target ($sizeMb MB)"

    # Alte Backups aufraeumen
    Get-ChildItem $BackupDir -Filter 'vault-backup-*.zip' |
        Sort-Object LastWriteTime -Descending |
        Select-Object -Skip $Keep |
        ForEach-Object { Remove-Item $_.FullName -Force; Write-Host "Geloescht: $($_.Name)" }
}
finally {
    Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
}
