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
    (Get-WmiObject -Computer $ServerName Win32_logicaldisk -filter drivetype=3 | % {
    
            if($_.FreeSpace -gt 1099511627776){
                $FreeSpace=($_.FreeSpace/1TB).ToString('N2')+" TB"
            }
            elseif($_.FreeSpace -gt 1073741824){
                #$FreeSpace=($_.FreeSpace/1GB).ToString('N2')+" GB"
                $FreeSpace=((($_.FreeSpace/1024)/1024)/1024)
            }
            elseif($_.FreeSpace -gt 1048576){
                $FreeSpace=($_.FreeSpace/1MB).ToString('N2')+" MB"
            }
            elseif($_.FreeSpace -gt 1024){
                $FreeSpace=($_.FreeSpace/1KB).ToString('N2')+" KB"
            }
            else{
                $FreeSpace = $_.FreeSpace.ToString()+" bytes"
            }

            if($_.Size -gt 1099511627776){
                $Size=($_.Size/1TB).ToString('N2')+" TB"
            }
            elseif($_.Size -gt 1073741824){
                $Size=($_.Size/1GB).ToString('N2')+" GB"
            }
            elseif($_.Size -gt 1048576){
                $Size=($_.Size/1MB).ToString('N2')+" MB"
            }
            elseif($_.Size -gt 1024){
                $Size=($_.Size/1KB).ToString('N2')+" KB"
            }
            else{
                $Size = $_.Size.ToString()+" bytes"
            }

            $UsedSpace=$_.Size - $_.FreeSpace

            if($UsedSpace -gt 1099511627776){
                $UsedSpace=($UsedSpace/1TB).ToString('N2')+" TB"
            }
            elseif($UsedSpace -gt 1073741824){
                $UsedSpace=($UsedSpace/1GB).ToString('N2')+" GB"
            }
            elseif($UsedSpace -gt 1048576){
                $UsedSpace=($UsedSpace/1MB).ToString('N2')+" MB"
            }
            elseif($UsedSpace -gt 1024){
                $UsedSpace=($UsedSpace/1KB).ToString('N2')+" KB"
            }
            else{
                $UsedSpace = $UsedSpace.ToString()+" bytes"
            }

        $MasterKeys += New-Object PSObject -property @{
            DriveLetter=$_.DeviceID;
            DriveName=$_.VolumeName;
            FreeSpace=$FreeSpace;
            Size=$Size;
            UsedSpace=$UsedSpace;

        }
    })
    $MasterKeys = ($MasterKeys | Select DriveLetter, DriveName, UsedSpace, FreeSpace, Size)
    $MasterKeys
}
else{
    $MasterKeys += New-Object PSObject -property @{ConnectStat='Failed Connection';}
    $MasterKeys = ($MasterKeys | Select ConnectStat)
    $MasterKeys
}