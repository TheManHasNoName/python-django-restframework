[CmdletBinding()]
    Param
    (
        [Parameter(Position = 0)]
        [String[]]
        $computername = $env:computername
    )
    #echo $localgroup
Function Get-LocalGroupMembers {

    $computername = $computername.toupper()
    $ADMINS = get-wmiobject -computer $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='Administrators'""" | % {$_.partcomponent}

    foreach ($ADMIN in $ADMINS) {
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_UserAccount.Domain=","") # trims the results for a user
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_Group.Domain=","") # trims the results for a group
                $admin = $admin.replace('Name=',"")
                #$admin = $admin.REPLACE("""","")#strips the last "

                $objOutput = New-Object PSObject -Property @{
                    LocalGroup = 'Administrators'
                    UserName = ($admin.replace(',','\')).replace('"','')
                    #UserName = ($admin.split(",")[1]).replace('"','')
                    #DomainName  =($admin.split(",")[0]).replace('"','')
                }#end object

    $objreport+=@($objoutput)
    }
    $ADMINS = get-wmiobject -computer $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='Remote Desktop Users'""" | % {$_.partcomponent}

    foreach ($ADMIN in $ADMINS) {
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_UserAccount.Domain=","") # trims the results for a user
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_Group.Domain=","") # trims the results for a group
                $admin = $admin.replace('Name=',"")
                #$admin = $admin.REPLACE("""","")#strips the last "

                $objOutput = New-Object PSObject -Property @{
                    LocalGroup = 'Remote Desktop Users'
                    UserName = ($admin.replace(',','\')).replace('"','')
                    #UserName = ($admin.split(",")[1]).replace('"','')
                    #DomainName  =($admin.split(",")[0]).replace('"','')
                }#end object

    $objreport+=@($objoutput)
    }

    $objreport = ($objreport | Sort LocalGroup,UserName )
    $objreport
}#end function

Get-LocalGroupMembers