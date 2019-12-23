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
    (Get-WmiObject -Computer $ServerName Win32_computersystem | Select Name | % {
        $Hostname=$_.Name
    })
    (Get-WmiObject -Computer $ServerName -Class Win32_OperatingSystem | Select Caption | % {
        $OSName = $_.Caption
    })
    (Get-WmiObject -Computer $ServerName -Class Win32_physicalmemory | Measure-Object 'Capacity' -Sum | Select Sum | % {
        $RAM=$_.Sum/1GB
    })
    (Get-WmiObject Win32_Share -Computer $ServerName -filter "Type=0" | Measure | Select Count | % {
        $NumOfSharedPath=$_.Count
    })
    (Get-WmiObject -Computer $ServerName -Class Win32_processor | Select Name | % {
        $ProcessorName= $_.Name
    })
    (Get-WmiObject -Computer $ServerName -Class Win32_processor | Measure-Object 'NumberOfCores' -Sum | Select Count,Sum | % {
        $NumOfProcessor=$_.Count
        $TotalNumOfCore=$_.Sum
    })
    (Get-WmiObject -Computer $ServerName Win32_operatingsystem | Select OSArchitecture | % {
        $OSArch=$_.OSArchitecture
    })
    (Get-WmiObject -Computer $ServerName Win32_logicaldisk -filter drivetype=3 | Measure | Select Count | % {
        $NumOfLocalDisk=$_.Count
    })
    (Get-WmiObject -Computer $ServerName Win32_Bios | Select SerialNumber | % {
        $SerialNumber=$_.SerialNumber
    })
    (Get-WmiObject -Computer $ServerName Win32_networkadapterconfiguration | Select macaddress, DNSDomain | % {
        if(($_.DNSDomain -eq "spi-global.com") -or ($_.DNSDomain -eq  "dgt.sgs.spi-global.com")){
            $DNSDomain=$_.DNSDomain
            $macaddress=$_.macaddress
        }
    })
    $MasterKeys += New-Object PSObject -property @{
        Hostname=$Hostname;
        OSName=$OSName;
        Processor=$ProcessorName+" ( "+$NumOfProcessor+" processors )";
        RAM=$RAM.ToString()+".00 GB";
        OSArch=$OSArch+" Operating System";
        SerialNumber=$SerialNumber
        MacAddress=$macaddress
        DNSDomain=$DNSDomain
        TotalNumOfCore=$TotalNumOfCore.ToString()+" Cores";
        NumOfSharedPath=$NumOfSharedPath;
        NumOfLocalDisk=$NumOfLocalDisk;
    }
    $MasterKeys = ($MasterKeys | Select Hostname, OSName, Processor, RAM, OSArch, SerialNumber, MacAddress, DNSDomain, TotalNumOfCore, NumOfSharedPath, NumOfLocalDisk)
    $MasterKeys
}
else{
    $MasterKeys += New-Object PSObject -property @{ConnectStat='Failed Connection';}
    $MasterKeys = ($MasterKeys | Select ConnectStat)
    $MasterKeys
}