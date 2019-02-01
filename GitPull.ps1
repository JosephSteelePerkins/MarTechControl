#param ([string]$BranchID='None',[string]$ControlFile)

$BranchID = 'Development'
#$ControlFile = 'C:\MarTechControlFiles\Systest.txt'

    #first prepare the log file.

$LogFileName = 'Log_GitPull_' +  $(get-date).ToString("yyyyMMdd_HHmmss") + ".txt"
$LogFileNameFull = "C:\MarTechLog\" + $LogFileName
$Errored = 0

    if (Test-Path $LogFileNameFull) 
    {
      Remove-Item $LogFileNameFull
    }

New-Item $LogFileNameFull | out-null


    #then, if a BranchID hasn't been explictly supplied, then get it from the control file


if($BranchID -eq 'None')
{

$line = ""

$ErrorActionPreference = "stop"

    try
    {

    $r = Get-Content $ControlFile

            #get the lines from the file contents that match the build/release ID. Assign to the line variable

    $r | Where-Object {$_ -match ("BranchID:")} |  Set-Variable  "line" 

    #Write-Host $r

    $BranchID = $line.Substring(9)
    }
    catch
    {
    $ErrorM = $_
    Add-Content $LogFileNameFull ($ErrorM)
    exit

    }
}

$BranchID

    #if you've got this far and the ReleaseID is empty that means there is no id. Add this to the log file

if (! $BranchID -or $BranchID-eq'None') {
Add-Content $LogFileNameFull ("No Branch ID")

exit}



#the only safe way to do this is to delete the repository, re-clone it and checkout the branch

#first set the location to the parent directory
$ErrorActionPreference = "stop"
try
{

Set-Location $PSScriptRoot
$pathdd = ""
split-path $(get-location)|Set-Variable "pathdd"
$RepoPath = $pathdd + '\Martech'
Set-Location $pathdd

#then delete the repo if it already exists
Remove-Item –path $RepoPath –recurse -Force
}
catch
{
if ($_ -notlike "cannot find path*")
{
Add-Content $LogFileNameFull $_
exit
}
}

#then re-clone the repository

$GitError = "d"

$ErrorActionPreference = "continue"

$outputm = git clone git@github.com:JosephSteelePerkins/MarTech.git 2>&1
$GitError = $outputm | Select-String  -Pattern "fatal"

if ($GitError)
{
Add-Content $LogFileNameFull $GitError
exit
}

Set-Location $RepoPath


#then checkout  branch

$outputm = git checkout -b $BranchID origin/$BranchID 2>&1
$GitError = $outputm | Select-String  -Pattern "fatal"

#check to see if there is a fatal git error

 
if (! $GitError )
{
    #if there is not then add success to the log
$currentb = git status 2>&1
Add-Content $LogFileNameFull 'Success'
Add-Content $LogFileNameFull  $currentb
}
else
{
Add-Content $LogFileNameFull $GitError
}
