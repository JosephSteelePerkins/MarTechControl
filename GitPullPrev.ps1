#param ([string]$BranchID='None',[string]$ControlFile)

$BranchID = 'None'
$ControlFile = 'C:\MarTechControlFiles\Systest.txt'




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



$ErrorActionPreference = "continue"


#the only safe way to do this is to delete the repository, re-clone it and checkout the branch

#first set the location to the parent directory

Set-Location $PSScriptRoot
$pathdd = ""
split-path $(get-location)|Set-Variable "pathdd"
$RepoPath = $pathdd + '\Martech'
Set-Location $pathdd

#then delete the repo if it already exists
rmdir $RepoPath -ErrorAction Ignore


$RepoPath = $pathdd + '\Martech'
Set-Location $pathdd


git fetch

#incase there are local changes, remove them with a reset

git add .
git reset --hard head


#then checkout  branch
#we need to look at the output of this git statement. It will determine what we do next

$outputm = git checkout -b $BranchID 2>&1


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
git checkout $BuildID
git pull
$currentb = git status 2>&1
Add-Content $LogFileNameFull 'Success'
Add-Content $LogFileNameFull $currentb}
else
{
Add-Content $LogFileNameFull $GitError
}
