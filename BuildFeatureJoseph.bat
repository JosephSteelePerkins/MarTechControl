REM what needs to be restored?

Powershell.exe -executionpolicy remotesigned -file RestoreFromTo.ps1 -FromEnvironment  DESKTOP-CGRB0T0\LIVE -ToEnvironment DESKTOP-CGRB0T0

REM what branch needs to be pulled?

REM - n/a

REM what IDs need to be built?
Powershell.exe -executionpolicy remotesigned -file Build.ps1 -Environment Diamond -Test false -Rollback false -BuildID MAR101

pause