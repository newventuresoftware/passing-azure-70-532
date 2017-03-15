<# 
### Task

    Create a virtual machine with Desired State Configuration to enable Web Role.

### Details  

    Storage account for the VM is first created.
    DSC config is in dsc-for-vm.ps1.
    
    Use 'Get-AzurevmImage | Where-Object {$_.Label -like '*2012 R2*'} | Format-List -Property ImageName, Label' to find appropriate VM image, if needed.

### Initial Infrastructure

    N/A
     
#> 

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$azureSubscriptionName = ""
$storageAccountName = $namePrefix + "storage"
$vmServiceName = $namePrefix + "srvc"
$vmImageName = "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-20160812-en.us-127GB.vhd"

if($azureSubscriptionName -eq "") 
{
    throw "Must provide Azure subscription name"
}

Write-Host "Runnig core script (prefix: $namePrefix)..."

New-AzureStorageAccount -StorageAccountName "$storageAccountName" -Location "North Europe"
Set-AzureSubscription –SubscriptionName "$azureSubscriptionName" -CurrentStorageAccountName "$storageAccountName"

$vmConfig = New-AzureVMConfig -Name $vmServiceName -ImageName $vmImageName -InstanceSize Small
$vmProvisionConfig = Add-AzureProvisioningConfig -VM $vmConfig -Windows -AdminUsername "tester" -Password "Pass@word1"
$dscConfig = Publish-AzureVMDscConfiguration -ConfigurationPath .\dsc-for-vm.ps1 -Force

Set-AzureVMDscExtension -VM $vmConfig -ConfigurationArchive "dsc-for-vm.ps1.zip" -ConfigurationName "VmDsc"
New-AzureVm -VMs $vmConfig -Location "North Europe" -ServiceName "$vmServiceName" -WaitForBoot