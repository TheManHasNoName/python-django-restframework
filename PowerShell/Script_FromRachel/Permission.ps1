[CmdletBinding()]
    Param
    (
        [Parameter(Position = 0)]
        [String[]]
        $Path = 'D:\Shared'
    )

$FolderPath = dir -Directory -Path $Path -Recurse -Force
$Report = @()
Foreach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access)
        {
            $Properties = [ordered]@{'FolderName'=$Folder.FullName;'AD
Group or
User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Report += New-Object -TypeName PSObject -Property $Properties
        }
}
$Report | Export-Csv -path 'D:\Shared\Permission.csv'