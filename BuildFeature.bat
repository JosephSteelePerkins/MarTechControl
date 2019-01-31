REM what needs to be restored?

REM what branch needs to be pulled?

REM what IDs need to be built?
Powershell.exe -executionpolicy remotesigned -file Build.ps1 -BuildID MAR101 -Environment Diamond -Test false -Rollback false