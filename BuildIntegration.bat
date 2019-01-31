REM what needs to be restored?

Powershell.exe -executionpolicy remotesigned -file RestoreFromBackup.ps1 -FromBackup Integration  -ToEnvironment DESKTOP-CGRB0T0\LIVE

REM what branch needs to be pulled?

REM what IDs need to be built?

Powershell.exe -executionpolicy remotesigned -file Build.ps1 -BuildID MAR-23 -Environment Diamond -Test False -Rollback false

Powershell.exe -executionpolicy remotesigned -file Build.ps1 -BuildID MAR-24 -Environment Diamond -Test False -Rollback false
