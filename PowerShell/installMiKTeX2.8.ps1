#Set-ExecutionPolicy AllSigned
#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

#create folder MiKTeX2.8
New-Item C:\MiKTeX2.8 -ItemType Directory
New-Item C:\MiKTeX2.8\texmf -ItemType Directory
New-Item C:\MiKTeX2.8\localtexmf -ItemType Directory
#end


$acl = Get-Acl C:\MiKTeX2.8
$ruleList = "ListDirectory", "ReadData", "WriteData", "CreateFiles", "CreateDirectories", "AppendData", "ReadExtendedAttributes", "WriteExtendedAttributes", "Traverse", "ExecuteFile", "DeleteSubdirectoriesAndFiles", "ReadAttributes", "WriteAttributes", "Write", "Delete", "ReadPermissions", "Read", "ReadAndExecute", "Modify", "Synchronize"

<#
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("users","FullControl","Allow")
$RemoveRule1 = New-Object System.Security.AccessControl.FileSystemAccessRule("users","ChangePermissions","Allow")
$RemoveRule2 = New-Object System.Security.AccessControl.FileSystemAccessRule("users","TakeOwnership","Allow")

$acl.SetAccessRule($AccessRule) #add rule
$acl.RemoveAccessRule($RemoveRule1) #remove specific rule
$acl.RemoveAccessRule($RemoveRule2)
#>


foreach ($element in $ruleList) {
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("users", $element,"Allow")
    $acl.AddAccessRule($rule)
}


$denyRule = New-Object System.Security.AccessControl.FileSystemAccessRule("users", "Delete", "Deny")
$acl.SetAccessRule($denyRule)

$acl.SetAccessRuleProtection($true, $true)

$acl | Set-Acl C:\MiKTeX2.8 | fl

#Credentials
$uname = Read-Host "Enter Username: "
$pass = Read-Host "Password: " -AsSecureString


#connect to Network/Repo
$net = New-Object -ComObject WScript.Network
$net.MapNetworkDrive('R:', "\\192.168.254.100\Shared", $false, $uname, $pass)
#[system.enum]::getnames([System.Security.AccessControl.FileSystemRights]) #Display all rules

Start-Sleep -s 3