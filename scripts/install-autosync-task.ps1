<#
  Registriert vault-sync.ps1 als Windows-Aufgabe (alle 30 Minuten).
  Einmalig ausfuehren:  powershell -ExecutionPolicy Bypass -File .\install-autosync-task.ps1
  Entfernen:            Unregister-ScheduledTask -TaskName "Obsidian Vault Auto-Sync" -Confirm:$false
#>

$ErrorActionPreference = 'Stop'

$Script   = Join-Path $PSScriptRoot 'vault-sync.ps1'
$TaskName = 'Obsidian Vault Auto-Sync'

$action  = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument ('-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{0}"' -f $Script)

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Minutes 30) `
    -RepetitionDuration ([TimeSpan]::MaxValue)

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Description 'Committet und pusht den Obsidian-Vault alle 30 Minuten nach GitHub.' -Force

Write-Host "Aufgabe '$TaskName' registriert. Test: Start-ScheduledTask -TaskName '$TaskName'"
