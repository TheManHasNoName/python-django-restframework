    $session = New-Object -ComObject Microsoft.Update.Session            
    $searcher = $session.CreateUpdateSearcher()            
            
    $result = $searcher.Search("IsInstalled=0 and Type='Software' and ISHidden=0" )            
            
    if ($result.Updates.Count -gt 0){            
     $result.Updates |             
     select Title, IsHidden, IsDownloaded, IsMandatory,             
     IsUninstallable, RebootRequired, Description            
    }
    else {            
     Write-Host " No updates available"            
    }