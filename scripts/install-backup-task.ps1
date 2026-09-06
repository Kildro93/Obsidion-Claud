<#
  Registriert weekly-backup.ps1 als Windows-Aufgabe (Sonntag 02:00).
  Einmalig:  powershell -ExecutionPolicy Bypass -File .\install-backup-task.ps1
#>

$ErrorActionPreference = 'Stop'

$Script   = Join-Path $PSScriptRoot 'weekly-backup.ps1'
$TaskName = 'Obsidian Vault Weekly Backup'

$action  = New-ScheduledTaskAction -Execute 'powershell.exe' `
    -Argument ('-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{0}"' -f $Script)

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At '02:00'

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Description 'Erstellt woechentlich ein ZIP-Backup des Obsidian-Vaults.' -Force

Write-Host "Aufgabe '$TaskName' registriert. Test: Start-ScheduledTask -TaskName '$TaskName'"
