[CmdletBinding()]
    Param
    (
        [Parameter(Position = 0)]
        [String[]]
        $computername = $env:computername,

        [Parameter(Position = 1)]
        [String[]]
        $localgroup = 'Administrators'
    )
    #echo $localgroup
Function Get-LocalGroupMembers {

    $computername = $computername.toupper()
    $ADMINS = get-wmiobject -computername $computername -query "select * from win32_groupuser where GroupComponent=""Win32_Group.Domain='$computername',Name='$localgroup'""" | % {$_.partcomponent}

    foreach ($ADMIN in $ADMINS) {
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_UserAccount.Domain=","") # trims the results for a user
                $admin = $admin.replace("\\$computername\root\cimv2:Win32_Group.Domain=","") # trims the results for a group
                $admin = $admin.replace('Name=',"")
                #$admin = $admin.REPLACE("""","")#strips the last "

                $objOutput = New-Object PSObject -Property @{
                    LocalGroup = $localgroup.replace('{}','')
                    UserName = ($admin.replace(',','\')).replace('"','')
                    #UserName = ($admin.split(",")[1]).replace('"','')
                    #DomainName  =($admin.split(",")[0]).replace('"','')
                }#end object

    $objreport+=@($objoutput)
    }
    $objreport = ($objreport | Sort UserName )
    $objreport
}#end function

Get-LocalGroupMembers