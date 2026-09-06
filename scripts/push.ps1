<#
  push.ps1 - Manueller Sofort-Push (fuer Zwischendurch).
  Aufruf: powershell -ExecutionPolicy Bypass -File .\push.ps1 "Mein Commit-Text"
#>
param([string]$Message)

$VaultRoot = Split-Path -Parent $PSScriptRoot
Set-Location $VaultRoot

if (-not $Message) { $Message = "Update: manueller Push {0}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm') }

git add -A
git commit -m $Message
git push origin main
