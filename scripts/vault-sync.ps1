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
    $changed = @(git status --porcelain | Where-Object { $_ -ne '' })
    if ($changed.Count -eq 0) {
        Log 'Keine Aenderungen.'
    } else {
        git add -A
        $msg = "Auto-sync: {0} ({1} Dateien)" -f (Get-Date -Format 'yyyy-MM-dd HH:mm'), $changed.Count
        $out = git commit -m $msg 2>&1
        if ($LASTEXITCODE -eq 0) { Log "Commit erstellt: $msg" }
        else { Log "COMMIT FEHLGESCHLAGEN: $out" }
    }

    # Push (auch wenn nichts Neues: holt haengengebliebene Commits nach)
    # Kein origin/main bekannt (Erst-Push) -> $ahead bleibt '?', es wird gepusht
    $ahead = git rev-list --count "origin/$Branch..$Branch" 2>$null
    if ($LASTEXITCODE -ne 0) { $ahead = '?' }

    if ($ahead -eq '0') {
        Log 'Nichts zu pushen.'
    } else {
        # git schreibt Fortschritt auf stderr -> ErrorActionPreference kurz lockern
        $prev = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $out = & git push origin $Branch 2>&1
        $code = $LASTEXITCODE
        $ErrorActionPreference = $prev
        foreach ($line in $out) { Log "push: $line" }
        if ($code -eq 0) { Log "Push OK ($ahead Commits)." }
        else { Log "PUSH FEHLGESCHLAGEN (Exit $code) - Token pruefen, siehe SYSTEM/SETUP/SETUP-GITHUB-TOKEN.md" }
    }
}
catch {
    Log ("FEHLER: " + $_.Exception.Message)
    exit 1
}
