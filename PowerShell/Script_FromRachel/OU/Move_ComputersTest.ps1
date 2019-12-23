$TargetOU =  "OU=Test OU,OU=Managed Computers,OU=Dumaguete,OU=Philippines,OU=Content,OU=Manage Objects,DC=spi-global,DC=com"
$Imported_csv = Import-Csv -Path "D:\Programs\computerlist.csv" 

$Imported_csv | ForEach-Object {
     Get-ADComputer $_.Name | Move-ADObject -TargetPath $TargetOU
     #Write-Host $_.Name
 }