<#
  Registriert weekly-backup.ps1 als Windows-Aufgabe (Sonntag 02:00).
  Start ueber wscript.exe + VBS-Wrapper statt "-WindowStyle Hidden": Hidden
  unterdrueckt unter dem Taskplaner das kurze Aufblitzen des Konsolenfensters
  nicht zuverlaessig, WScript.Shell.Run(...,0,...) im VBS-Wrapper schon.
  Einmalig:  powershell -ExecutionPolicy Bypass -File .\install-backup-task.ps1
#>

$ErrorActionPreference = 'Stop'

$VbsScript = Join-Path $PSScriptRoot 'weekly-backup-silent.vbs'
$TaskName  = 'Obsidian Vault Weekly Backup'

if (-not (Test-Path $VbsScript)) { throw "VBS-Wrapper fehlt: $VbsScript" }

$action  = New-ScheduledTaskAction -Execute 'wscript.exe' `
    -Argument ('//B "{0}"' -f $VbsScript)

$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At '02:00'

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Description 'Erstellt woechentlich ein ZIP-Backup des Obsidian-Vaults (ueber VBS-Wrapper, kein sichtbares Fenster).' -Force

Write-Host "Aufgabe '$TaskName' registriert. Test: Start-ScheduledTask -TaskName '$TaskName'"
