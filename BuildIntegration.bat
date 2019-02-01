REM what needs to be restored?

Powershell.exe -executionpolicy remotesigned -file RestoreFromBackup.ps1 -FromBackup Integration  -ToEnvironment DESKTOP-CGRB0T0\LIVE

REM what branch needs to be pulled?

Powershell.exe -executionpolicy remotesigned -file GitPull.ps1 -BranchID Development

REM what IDs need to be built?

Powershell.exe -executionpolicy remotesigned -file Build.ps1 -ControlFile C:\MarTechControlFiles\Integration.txt -Environment Diamond -Test False -Rollback false