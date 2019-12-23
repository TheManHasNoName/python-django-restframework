$Imported_csv = Import-Csv -Path "D:\Programs\userlist.csv" 

$Imported_csv | ForEach-Object {

        try {
            $User = $_.Name
            Get-ADUser $User -ErrorAction Stop | Out-Null
            Write-Host $User " exists"

        }

        catch {

            Write-Host $User " NOT FOUND"

        }
 }