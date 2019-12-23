$psot = @()

get-content "computerlist.txt"| % {

$objSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$_))

$objSearcher= $objSession.CreateUpdateSearcher()

$colHistory = $objSearcher.QueryHistory(0, 100)

$pso = "" | select Computer,Title,Date

$objSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$_))
$objSearcher= $objSession.CreateUpdateSearcher()
$totalupdates = $objSearcher.GetTotalHistoryCount()
echo $objSearcher.QueryHistory(0,$totalupdates)
#echo $objSearcher

Foreach($objEntry in $colHistory) {

  $pso.Title = $objEntry.Title
  $pso.Date = $objEntry.Date
  $pso.computer = $_



}

$psot += $pso

}

#$psot | ft Computer,Title,Date