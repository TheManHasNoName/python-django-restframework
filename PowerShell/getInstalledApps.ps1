#Test-Connection -Computer 192.168.254.105 -count 1 -quiet
$adminaccount = "desktop-kudf5il\xavier"
$PASSWORD = ConvertTo-SecureString "Xrepyh20090790" -AsPlainText -Force
$UNPASSWORD = New-Object System.Management.Automation.PsCredential $adminaccount, $PASSWORD

Get-WmiObject -Class Win32_Product -ComputerName 192.168.254.105 -Credential $UNPASSWORD | select __SERVER, Name, Version -ErrorAction SilentlyContinue