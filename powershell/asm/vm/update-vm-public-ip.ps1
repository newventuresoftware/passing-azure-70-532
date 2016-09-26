<# 
### Task

    Update an existing VM with an instance level public IP (ILPIP).

### Details  

    Instance level IP allows you to connect directly to a VM. 
    The script creates ILPIP and when print the IP to the console;
    
    Use 'Get-AzurevmImage | Where-Object {$_.Label -like '*2012 R2*'} | Format-List -Property ImageName, Label' to find appropriate VM image, if needed.

### Initial Infrastructure

    A standard VM is first created.
     
#> 

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$storageAccountName = $namePrefix + "strg"
$vmServiceName = $namePrefix + "srvc"
$vmImageName = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20160812-en.us-127GB.vhd"

Write-Host "Creating infrastructure (prefix: $namePrefix)..."

New-AzureStorageAccount -StorageAccountName "$storageAccountName" -Location "North Europe"
Set-AzureSubscription –SubscriptionName 'NVS-BizSpark' -CurrentStorageAccountName "$storageAccountName"
$vmConfig = New-AzureVMConfig -Name $vmServiceName -ImageName $vmImageName -InstanceSize Small
$vmProvisionConfig = Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername "tester" -Password "Pass@word1"
New-AzureVm -VMs $vmConfig -Location "North Europe" -ServiceName "$vmServiceName" -WaitForBoot

Write-Host "Runnig core script..."

$vm = Get-AzureVM -ServiceName "$vmServiceName" -Name "$vmServiceName"
$vm | Set-AzurePublicIP -PublicIPName "vmIP"| Update-AzureVM

Write-Host "The public IP is: $vm.PublicIPAddress"