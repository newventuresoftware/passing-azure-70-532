<# 
### Task

    Add ednpoint for Web traffic to an existing VM.
    Add ACL to default RDP endpoint to allow traffic from a single IP only.

### Details  

    Endpoints control access to your VMs. By creating Endpoints you can open ports on your VM.
    Access Control Lists can be used for fine-grained control over Endpoints and what traffic is allowed or denied for a specific Endpoint.
    
    Use 'Get-AzurevmImage | Where-Object {$_.Label -like '*2012 R2*'} | Format-List -Property ImageName, Label' to find appropriate VM image, if needed.

### Initial Infrastructure

    A standard VM is first created.
     
#>

$azureSubscriptionName = ""
$clientIp = ""
$namePrefix = (get-random -Count 8 -InputObject "abcdefg0123456789".ToCharArray()) -join ''
$storageAccountName = $namePrefix + "strg"
$vmServiceName = "$namePrefix" + "srvc"
$vmName = "$namePrefix" + "vm"
$vmImageName = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20160812-en.us-127GB.vhd"

### Creating infrastructure

if($azureSubscriptionName -eq "") 
{
    throw "Must provide Azure subscription name"
}

if($clientIp -eq "") 
{
    throw "Must provide client IP"
}

Write-Host "Creating infrastructure (prefix: $namePrefix)..."

New-AzureStorageAccount -StorageAccountName "$storageAccountName" -Location "North Europe"
Set-AzureSubscription –SubscriptionName "$azureSubscriptionName" -CurrentStorageAccountName "$storageAccountName"

$vmConfig = New-AzureVMConfig -Name $vmName -ImageName $vmImageName -InstanceSize Small
$vmProvisionConfig = Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername "tester" -Password "Pass@word1"
New-AzureVm -VMs $vmConfig -Location "North Europe" -ServiceName "$vmServiceName" -WaitForBoot

Write-Host "Runnig core script..."

$vm = Get-AzureVM -ServiceName "$vmServiceName" -Name "$vmName"
$rdpAcl = New-AzureAclConfig
Set-AzureAclConfig -ACL $rdpAcl -AddRule -Action Permit -Order 100 -RemoteSubnet $clientIp -Description "Admin PC"
Set-AzureEndpoint -Vm $vm.VM -ACL $rdpAcl -Name "RemoteDesktop"
Add-AzureEndpoint -VM $vm.VM -Name "HttpIn" -Protocol tcp -LocalPort 80 -PublicPort 80

$vm | Update-AzureVM