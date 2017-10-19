<# 
### Task

    Create a virtual machine.

### Details  

    -

### Initial Infrastructure

    -
     
#> 

$nameSuffix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$resourceGroupName = "grp" + $nameSuffix
$vmName = "vm" + $nameSuffix
$user = "tester"
$password = "myP@ssword"
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword) 
$location = "East US"

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

New-AzureRmResourceGroup -Name $resourceGroupName -Location "$location"

# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name subnet -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName -Location "$location" `
    -Name vNet -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig    

# Create a public IP address and specify a DNS name
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName -Location "$location" `
    -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name "ip$nameSuffix"

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name nic -ResourceGroupName $resourceGroupName -Location "$location" `
    -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id

# Create a virtual machine configuration
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Standard_DS2 | `
    Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
    Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2016-Datacenter -Version latest | `
    Set-AzureRmVMOSDisk  -Name osDisk -DiskSizeInGB 128 -CreateOption FromImage -Caching ReadWrite | `
    Add-AzureRmVMNetworkInterface -Id $nic.Id

New-AzureRmVM -ResourceGroupName $resourceGroupName -Location "$location" -VM $vmConfig