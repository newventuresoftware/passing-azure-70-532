<# 
### Task

    Update an existing VM with an instance level public IP (ILPIP).

### Details  

    Instance level IP allows you to connect directly to a VM. 
    The script creates ILPIP and when print the IP to the console;

    Using piping when creating the VM config

### Initial Infrastructure

    A standard VM is first created.
     
#> 

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$resourceGroupName = $namePrefix + "grp"
$storageAccountName = $namePrefix + "strg"
$vmServiceName = $namePrefix + "srvc"
$user = "tester"
$password = "myP@ssword"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword) 
$location = "North Europe"

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location "$location"
$storageAccount = New-AzureRmStorageAccount -StorageAccountName "$storageAccountName" -Location "$location" -ResourceGroupName $resourceGroupName -SkuName Standard_RAGRS

$osDiskUri = $storageAccount.PrimaryEndpoints.Blob.ToString() + "vhds/myOsDisk.vhd"

# Create a virtual network
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name subnet -AddressPrefix "192.168.0.0/16"
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Location "$location" -Name "vnet" -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name subnet -VirtualNetwork $vnet

$ipconfig = New-AzureRmNetworkInterfaceIpConfig -Name "ipconfig" -PrivateIpAddressVersion IPv4 -PrivateIpAddress "192.168.0.100" -Subnet $subnet
$nic = New-AzureRmNetworkInterface -Name "NetworkInterface1" -ResourceGroupName $resourceGroupName -Location "$location" -IpConfiguration $ipconfig

# Using ` (backtick) to continue comman on the next line
$vmConfig = New-AzureRmVMConfig -VMName $vmServiceName -VMSize "Standard_A1" | `
    Set-AzureRmVMSourceImage -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest" | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmServiceName -Credential $cred | `
    Add-AzureRmVMNetworkInterface -Id $nic.Id | `
    Set-AzureRmVMOSDisk -Name "myOsDisk" -VhdUri $osDiskUri -CreateOption FromImage

New-AzureRmVM -ResourceGroupName $resourceGroupName -Location "North Europe" -VM $vmConfig

Write-Host "Runnig core script..."

#$vm = Get-AzureVM -ServiceName "$vmServiceName" -Name "$vmServiceName"
#$vm | Set-AzurePublicIP -PublicIPName "vmIP"| Update-AzureVM

#Write-Host "The public IP is: $vm.PublicIPAddress"