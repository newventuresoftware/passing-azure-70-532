<# 
### Task

    Add a Network Security Group to an existing VM to allow inbound traffic for port 3389.

### Details  

    The network security group secures the virtual machine using inbound and outbound rules.

### Initial Infrastructure

    A standard VM is first created.
     
#> 

. ".\create-vm.ps1"

Write-Host "Runnig core script..."

# Create an inbound network security group rule for port 3389 (TCP)
$rdpRule = New-AzureRmNetworkSecurityRuleConfig -Name rdpRule -Protocol Tcp `
    -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
    -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location "$location" `
    -Name networkSecurityGroup -SecurityRules $rdpRule

# Get the NIC of the respective virtual machine 
$nic = Get-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName -Name "nic"

# Assign the Network Security Group to the NIC
$nic.NetworkSecurityGroup = $nsg

# Save NIC changes
Set-AzureRmNetworkInterface -NetworkInterface $nic