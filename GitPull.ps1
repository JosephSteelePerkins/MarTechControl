Set-Location $PSScriptRoot
#Set-Location 'C:\Users\DBA\MarTech'

    #first prepare the log file.


$LogFileName = 'Log_GitPull_' +  $(get-date).ToString("yyyyMMdd_HHmmss") + ".txt"
$LogFileNameFull = "C:\MarTechLog\" + $LogFileName
$Errored = 0

    if (Test-Path $LogFileNameFull) 
    {
      Remove-Item $LogFileNameFull
    }

New-Item $LogFileNameFull | out-null


    #then, try to get a releaseID


$line = ""

$ErrorActionPreference = "stop"

try
{

$r = Get-Content 'C:\MarTechReleaseIDs\Systest.txt'

        #get the lines from the file contents that match the build/release ID. Assign to the line variable

$r | Where-Object {$_ -match ("Release:")} |  Set-Variable  "line" 

#Write-Host $r

$ReleaseID = $line.Substring(8)
}
catch
{
$ErrorM = $_
Add-Content $LogFileNameFull ($ErrorM)
exit

}


    #if you've got this far and the ReleaseID is empty that means there is no id. Add this to the log file

if (! $ReleaseID) {
Add-Content $LogFileNameFull ("No release ID")

exit}



$ErrorActionPreference = "continue"


git fetch

#incase there are local changes, remove them with a reset

git add .
git reset --hard head


#then checkout release branch
#we need to look at the output of this git statement. It will determine what we do next

$outputm = git checkout -b $ReleaseID 2>&1


   #check to see if there is a fatal git error
$GitError = $outputm | Select-String  -Pattern "fatal"

 
if (! $GitError )
{
    #if there is not then add success to the log
$currentb = git status 2>&1
Add-Content $LogFileNameFull 'Success'
Add-Content $LogFileNameFull $currentb
}
elseif ($GitError -like "fatal: A branch named * already exists.")
{
git checkout $ReleaseID
git pull
$currentb = git status 2>&1
Add-Content $LogFileNameFull 'Success'
Add-Content $LogFileNameFull $currentb}
else
{
Add-Content $LogFileNameFull $GitError
}
