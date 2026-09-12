<#
  Registriert vault-sync.ps1 als Windows-Aufgabe (alle 30 Minuten).
  Start ueber wscript.exe + VBS-Wrapper statt "-WindowStyle Hidden": Hidden
  unterdrueckt unter dem Taskplaner das kurze Aufblitzen des Konsolenfensters
  nicht zuverlaessig, WScript.Shell.Run(...,0,...) im VBS-Wrapper schon.
  Einmalig ausfuehren:  powershell -ExecutionPolicy Bypass -File .\install-autosync-task.ps1
  Entfernen:            Unregister-ScheduledTask -TaskName "Obsidian Vault Auto-Sync" -Confirm:$false
#>

$ErrorActionPreference = 'Stop'

$VbsScript = Join-Path $PSScriptRoot 'vault-sync-silent.vbs'
$TaskName  = 'Obsidian Vault Auto-Sync'

if (-not (Test-Path $VbsScript)) { throw "VBS-Wrapper fehlt: $VbsScript" }

$action  = New-ScheduledTaskAction -Execute 'wscript.exe' `
    -Argument ('//B "{0}"' -f $VbsScript)

$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
    -RepetitionInterval (New-TimeSpan -Minutes 30) `
    -RepetitionDuration ((New-TimeSpan -Days 9999))

$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable `
    -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 10)

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Description 'Committet und pusht den Obsidian-Vault alle 30 Minuten nach GitHub (ueber VBS-Wrapper, kein sichtbares Fenster).' -Force

Write-Host "Aufgabe '$TaskName' registriert. Test: Start-ScheduledTask -TaskName '$TaskName'"
