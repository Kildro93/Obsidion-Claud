$Quelle = "C:\KI Programme\Obsidion für Claud"
$Ziel   = "G:\Meine Ablage\Obsidian-Vault-Spiegel"
$Log    = "$Quelle\scripts\logs\drive-mirror.log"

New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null

robocopy $Quelle $Ziel /MIR `
  /XD ".git" ".github" ".obsidian" ".claude" ".claudian" "node_modules" "backups" "Nestbau" "nestbau-firebase" `
  /XF "*.tmp" "*.log" ".env*" "keystore.properties" "*.jks" "*.keystore" `
  /R:2 /W:5 /NFL /NDL /LOG+:$Log

Add-Content $Log "Spiegel-Lauf beendet: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"