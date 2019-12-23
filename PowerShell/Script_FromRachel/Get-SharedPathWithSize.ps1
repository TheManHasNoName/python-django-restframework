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
    (Get-WmiObject -Computer $ServerName Win32_Share -filter type=0 | Select Name, Path | % {
        $NPath = "\\"+$ServerName+"\"+($($_.Path) -replace ":",'$')
        (Get-ChildItem -Path $NPath -Recurse -Force | Measure-Object -Property length -Sum | Select Sum | % {
            $Sum=$_.Sum
        })
        
        if($Sum -gt 1099511627776){
            $Size=($Sum/1TB).ToString('N1')+" TB"
        }
        elseif($Sum -gt 1073741824){
            $Size=($Sum/1GB).ToString('N1')+" GB"
        }
        elseif($Sum -gt 1048576){
            $Size=($Sum/1MB).ToString('N1')+" MB"
        }
        elseif($Sum -gt 1024){
            $Size=($Sum/1KB).ToString('N1')+" KB"
        }
        else{
            $Size = $Sum.ToString()+" bytes"
        }

        $MasterKeys += New-Object PSObject -property @{
            SharedName=$_.Name
            Path=$_.Path
            Size=$Size

        }
    })
    $MasterKeys = ($MasterKeys | Select SharedName, Path, Size)
    $MasterKeys
}
else{
    $MasterKeys += New-Object PSObject -property @{ConnectStat='Failed Connection';}
    $MasterKeys = ($MasterKeys | Select ConnectStat)
    $MasterKeys
}