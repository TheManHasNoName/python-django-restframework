	[CmdletBinding()]
    Param
    (
        [Parameter(Position = 0)]
        [String[]]
        $Name = 'CGPC000026429P'
    )
	Begin
	{
		$LMkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall","SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
		$LMtype = [Microsoft.Win32.RegistryHive]::LocalMachine
		$CUkeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall"
		$CUtype = [Microsoft.Win32.RegistryHive]::CurrentUser
		
	}
	Process
	{
		ForEach($Computer in $Name)
		{
			$MasterKeys = @()
			If(!(Test-Connection -Computer $Computer -count 1 -quiet))
			{
				Write-Error -Message "Unable to contact $Computer. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $Computer
				Break
			}
			$CURegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($CUtype,$computer)
			$LMRegKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($LMtype,$computer)
			ForEach($Key in $LMkeys)
			{
				$RegKey = $LMRegKey.OpenSubkey($key)
				If($RegKey -ne $null)
				{
					ForEach($subName in $RegKey.getsubkeynames())
					{
						foreach($sub in $RegKey.opensubkey($subName))
						{
							$MasterKeys += (New-Object PSObject -Property @{
							"ComputerName" = $Computer
							"Name" = $sub.getvalue("displayname")
							"SystemComponent" = $sub.getvalue("systemcomponent")
							"ParentKeyName" = $sub.getvalue("parentkeyname")
							"Version" = $sub.getvalue("DisplayVersion")
							"InstallDate" = $sub.getvalue("InstallDate")
							"UninstallCommand" = $sub.getvalue("UninstallString")
							})
						}
					}
				}
			}
			ForEach($Key in $CUKeys)
			{
				$RegKey = $CURegKey.OpenSubkey($Key)
				If($RegKey -ne $null)
				{
					ForEach($subName in $RegKey.getsubkeynames())
					{
						foreach($sub in $RegKey.opensubkey($subName))
						{
							$MasterKeys += (New-Object PSObject -Property @{
							"ComputerName" = $Computer
							"Name" = $sub.getvalue("displayname")
							"SystemComponent" = $sub.getvalue("systemcomponent")
							"ParentKeyName" = $sub.getvalue("parentkeyname")
							"Version" = $sub.getvalue("DisplayVersion")
							"InstallDate" = $sub.getvalue("InstallDate")
							"UninstallCommand" = $sub.getvalue("UninstallString")
							})
						}
					}
				}
			}
			$MasterKeys = ($MasterKeys | Where {$_.Name -ne $Null -AND $_.SystemComponent -ne "1" -AND $_.ParentKeyName -eq $Null} | select Name,Version | sort Name)
			$MasterKeys
            # | Export-Csv -path 'D:\Shared\test.csv'
		}
	}