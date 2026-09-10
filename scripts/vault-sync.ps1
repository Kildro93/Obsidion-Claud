# OneNote to GitHub Sync Script
param([string]$LogPath = "C:\KI Programme\Obsidion für Claud\scripts\logs\vault-sync.log")

$VaultPath = "C:\KI Programme\Obsidion für Claud"

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
        Log "✅ No changes detected" "INFO"
    } else {
        Log "📝 Changes detected:" "INFO"
        $GitStatus | ForEach-Object { Log "  $_" }

        git add PROJEKTE/Primarlehrer-Studium/Studienmaterial/
        Log "✅ Files staged" "INFO"

        $CommitMsg = "Auto-Sync OneNote: $(Get-Date -Format 'dd.MM.yyyy HH:mm') [$(Get-Date -Format 'dddd')]"
        git commit -m $CommitMsg
        Log "✅ Committed" "INFO"

        git push origin main
        Log "✅ Pushed to GitHub" "INFO"
    }

    Log "=== Sync completed ===" "COMPLETE"
}
catch {
    Log "❌ Error: $($_.Exception.Message)" "ERROR"
    exit 1
}