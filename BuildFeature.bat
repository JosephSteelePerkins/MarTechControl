REM what needs to be restored?

Powershell.exe -executionpolicy remotesigned -file RestoreFromBackup.ps1 -FromBackup FeatureJoe -ToEnvironment DESKTOP-CGRB0T0
REM what branch needs to be pulled?

pause

REM - n/a

REM what IDs need to be built?
Powershell.exe -executionpolicy remotesigned -file Build.ps1 -Environment Diamond -Test false -Rollback false -BuildID MAR101

pause