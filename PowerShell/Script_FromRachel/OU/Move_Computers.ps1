$csvComputers = Import-Csv -Path "D:\Programs\computerlist.csv"
$csvProjectOU = Import-Csv -Path "D:\Programs\ProjectOU.csv"

Add-Content -Path D:\Programs\computerlist_result.csv  -Value '"Hostname","Project","Status"'

$csvComputers | ForEach-Object {
        try {
            $Computer = $_.Name
            $Project = $_.Project
            Get-ADComputer $Computer -ErrorAction Stop | Out-Null
            
            $TargetOU = $null
            $csvProjectOU | Where-Object Project -eq $Project | ForEach-Object {
                $TargetOU = $_.distinguishedName
            }

            if($TargetOU -eq $null){
                $ProceedMove = "No"
            }
            else{
                $ProceedMove = "Yes"
            }
            
            if($ProceedMove -eq "Yes"){
                #Get-ADComputer $Computer | Move-ADObject -TargetPath $TargetOU
                $data = $Computer+','+$Project+','+"Successfully Moved!"
                Add-Content -Path D:\Programs\computerlist_result.csv  -Value $data
            }
            else{
                $data = $Computer+','+$Project+','+"Project does not exist!"
                Add-Content -Path D:\Programs\computerlist_result.csv  -Value $data
            }
        }

        catch {
            $data = $Computer+','+$Project+','+"Hostname does not exist!"
            Add-Content -Path D:\Programs\computerlist_result.csv  -Value $data

        }
 }