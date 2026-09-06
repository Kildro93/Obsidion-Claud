<#
  vault-sync.ps1 - Committet und pusht den Obsidian-Vault nach GitHub.
  Laeuft per Windows Task Scheduler alle 30 Minuten.
  Registrierung: install-autosync-task.ps1 (einmalig, als Admin nicht noetig).
  Log: scripts/logs/vault-sync.log
#>

$ErrorActionPreference = 'Stop'

$VaultRoot = Split-Path -Parent $PSScriptRoot
$LogDir    = Join-Path $PSScriptRoot 'logs'
$LogFile   = Join-Path $LogDir 'vault-sync.log'
$Branch    = 'main'

if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }

function Log($msg) {
    $line = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

# Log kappen, wenn > 1 MB
if ((Test-Path $LogFile) -and ((Get-Item $LogFile).Length -gt 1MB)) {
    Get-Content $LogFile -Tail 200 | Set-Content $LogFile -Encoding UTF8
}

try {
    Set-Location $VaultRoot

    if (-not (Test-Path (Join-Path $VaultRoot '.git'))) {
        Log 'ABBRUCH: kein Git-Repo im Vault-Root.'
        exit 1
    }

    # Gibt es ueberhaupt Aenderungen?
    $status = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($status)) {
        Log 'Keine Aenderungen.'
    } else {
        $count = ($status -split "`n").Count
        git add -A
        $msg = "Auto-sync: {0} ({1} Dateien)" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $count
        git commit -m $msg | Out-Null
        Log "Commit erstellt: $msg"
    }

    # Push (auch wenn nichts Neues: holt haengengebliebene Commits nach)
    $ahead = git rev-list --count "origin/$Branch..$Branch" 2>$null
    if ($LASTEXITCODE -ne 0) { $ahead = '?' }

    if ($ahead -eq '0') {
        Log 'Nichts zu pushen.'
    } else {
        git push origin $Branch 2>&1 | ForEach-Object { Log "push: $_" }
        if ($LASTEXITCODE -eq 0) { Log "Push OK ($ahead Commits)." }
        else { Log "PUSH FEHLGESCHLAGEN (Exit $LASTEXITCODE) - Token pruefen, siehe SYSTEM/SETUP/SETUP-GITHUB-TOKEN.md" }
    }
}
catch {
    Log ("FEHLER: " + $_.Exception.Message)
    exit 1
}
