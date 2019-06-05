# PowerCLI script for instant-clone lab 03
# Version 1.0
# This Script does the following
# Powers off ICWin7
# Make a backup copy of the VM by cloning ICWin7 to ICWin7_Backup and then delete the orginal VM
#
#
# Specify vCenter Server, vCenter Server username and vCenter Server user password
# Specify the VM name of the new VM
# Specify the VM you want to clone
$clone="ICWin7"
#
$New_VM_name="ICWin7_Backup"
#
$vCenter="sa-vcsa-01.vclass.local"
$vCenterUser="administrator@vsphere.local"
$vCenterUserPassword="VMware1!"

# Specify the datastore or datastore cluster placement
$ds="SA-Shared-03 Remote"
# Specify the vSphere Cluster
$Cluster="Clone Cluster"

#_______________________________________________________
#_______________________________________________________
## Connect to vCenter Server
write-host Breaking System  -foreground green
# write-host  Connecting to vCenter Server $vCenter -foreground green
Connect-viserver $vCenter -user $vCenterUser -password $vCenterUserPassword -WarningAction 0
## Power off VM that will be cloned if it is powered on
Get-VMGuest -VM $clone  | Where-Object {$_.State -eq "Running"}  | Shutdown-VMGuest -Confirm:$False
# Shutdown-VMGuest -VM $Clone -Confirm:$false > $null
## Clone VM 
$ESXi=Get-Cluster $Cluster | Get-VMHost -state connected | Get-Random
New-VM -Name $New_VM_Name -VM $clone -VMHost $ESXi -Datastore $ds > $null
write-host Still breaking System  -foreground green

# Remove orginal VM
#_______________________________________________________
#_______________________________________________________
#
Remove-VM -VM "$clone" -DeletePermanently -Confirm:$false > $null

# Inform student that the lab is broken and ask to continue
Write-Host "System is Broken Press any key to continue ..." -foreground Yellow
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host You are ready to start the lab! -foreground Green
