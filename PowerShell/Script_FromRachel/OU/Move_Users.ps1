$TargetOU =  "OU=TestOU,OU=Managed Users,OU=Dumaguete,OU=Philippines,OU=Content,OU=Manage Objects,DC=spi-global,DC=com"
$Imported_csv = Import-Csv -Path "D:\Programs\userlist.csv" 

$Imported_csv | ForEach-Object {
     $UserDN  = (Get-ADUser -Identity $_.Name).distinguishedName
     Move-ADObject  -Identity $UserDN  -TargetPath $TargetOU
 }