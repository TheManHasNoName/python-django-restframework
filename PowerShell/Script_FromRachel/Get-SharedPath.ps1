[CmdletBinding()]
    Param
    (
        [Parameter(Position = 0)]
        [String[]]
        $ServerName = 'CGPC000026429P'
    )
$connStat = Test-Connection $ServerName -Quiet
$MasterKeys = @()
if($connStat -eq 'True'){
    (Get-WmiObject -Computer $ServerName Win32_Share -filter type=0 | Measure | Select Count | % {
        $Count=$_.Count
    })
    if($Count -eq 0){
        $MasterKeys += New-Object PSObject -property @{SharedNum='No Shared Path';}
        $MasterKeys = ($MasterKeys | Select SharedNum)
        $MasterKeys
    }
    else{
        (Get-WmiObject -Computer $ServerName Win32_Share -filter type=0 | Select Name, Path | % {
            $MasterKeys += New-Object PSObject -property @{
                SharedName=$_.Name
                Path=$_.Path
            }
        })
        $MasterKeys = ($MasterKeys | Select SharedName, Path)
        $MasterKeys
    }
}
else{
    $MasterKeys += New-Object PSObject -property @{ConnectStat='Failed Connection';}
    $MasterKeys = ($MasterKeys | Select ConnectStat)
    $MasterKeys
}