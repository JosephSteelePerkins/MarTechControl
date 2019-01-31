param ([string]$FromEnvironment, [string]$ToEnvironment)

#$FromEnvironment = 'DESKTOP-CGRB0T0\LIVE'
#$ToEnvironment = 'DESKTOP-CGRB0T0'

$FileName = $FromEnvironment

$FileName = $FileName -replace "\\", ""

$Sql = 'BACKUP DATABASE [Diamond] TO  DISK = N''C:\Users\Public\Public Backups\Diamond' + $FileName + '.bak'' WITH NOFORMAT, INIT,  NAME = N''Diamond-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

Invoke-Sqlcmd -query $Sql -ServerInstance $FromEnvironment

$Sql = 'ALTER DATABASE [Diamond] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;'

if($ToEnvironment -eq 'DESKTOP-CGRB0T0\LIVE')
{$SQLFolder = 'LIVE'}
elseif ($ToEnvironment -eq 'DESKTOP-CGRB0T0')
{$SQLFolder = 'MSSQLSERVER'}
elseif ($ToEnvironment -eq 'DESKTOP-CGRB0T0\DEVELOPMENT2')
{$SQLFolder = 'DEVELOPMENT2'}



$FullSQLFolder = 'C:\Program Files\Microsoft SQL Server\MSSQL14.' + $SQLFolder

$Sql = 'use master' +"`n" + 'ALTER DATABASE [Diamond] SET SINGLE_USER WITH ROLLBACK IMMEDIATE' +  "`n" + 'RESTORE DATABASE [Diamond]' + "`n" + 'FROM  DISK = N''C:\Users\Public\Public Backups\Diamond' + $FileName + '.bak''WITH  FILE = 1,' + "`n" + 'MOVE N''Diamond'' TO N''' + $FullSQLFolder + '\MSSQL\DATA\Diamond.mdf'','+ "`n" +  'MOVE N''Diamond_log'' TO N'''+ $FullSQLFolder +'\MSSQL\DATA\Diamond_log.ldf'',  NOUNLOAD,  REPLACE,  STATS = 5' +  "`n" + 'ALTER DATABASE [Diamond] SET multi_user WITH ROLLBACK IMMEDIATE'

Invoke-Sqlcmd -query $Sql -ServerInstance $ToEnvironment

#root folder of DESKTOP-CGRB0T0\DEVELOPMENT2 = C:\Program Files\Microsoft SQL Server\MSSQL14.DEVELOPMENT2
#root folder of DESKTOP-CGRB0T0\LIVE = C:\Program Files\Microsoft SQL Server\MSSQL14.LIVE
#root folder of DESKTOP-CGRB0T0 = C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER


