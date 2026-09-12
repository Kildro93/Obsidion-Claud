# OneNote to GitHub Sync Script
param([string]$LogPath = "C:\KI Programme\Obsidion fÃ¼r Claud\scripts\logs\vault-sync.log")

$VaultPath = "C:\KI Programme\Obsidion fÃ¼r Claud"

function Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    $LogMessage = "[$Timestamp] [$Level] $Message"
    Write-Host $LogMessage
    Add-Content -Path $LogPath -Value $LogMessage
}

$LogDir = Split-Path $LogPath
if (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }
Log "=== OneNote Sync started ===" "START"

try {
    Set-Location $VaultPath
    Log "Working directory: $VaultPath"

    $GitStatus = git status --porcelain
    
    if ([string]::IsNullOrWhiteSpace($GitStatus)) {
        Log "âœ… No changes detected" "INFO"
    } else {
        Log "ðŸ“ Changes detected:" "INFO"
        $GitStatus | ForEach-Object { Log "  $_" }

        git add STUDIUM/
        Log "âœ… Files staged" "INFO"

        $CommitMsg = "Auto-Sync OneNote: $(Get-Date -Format 'dd.MM.yyyy HH:mm') [$(Get-Date -Format 'dddd')]"
        git commit -m $CommitMsg
        Log "âœ… Committed" "INFO"

        git push origin main
        Log "âœ… Pushed to GitHub" "INFO"
    }

    Log "=== Sync completed ===" "COMPLETE"
}
catch {
    Log "âŒ Error: $($_.Exception.Message)" "ERROR"
    exit 1
}
