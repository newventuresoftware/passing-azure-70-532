<# 
### Task

    Create a virtual machine with Desired State Configuration to enable Web Role.

### Details  

    Storage account for the VM is first created.
    DSC config is in dsc-for-vm.ps1.
    Configuration is uploaded to storage and then assigned to VM
    
### Initial Infrastructure

    A standard VM is first created.
     
#> 

. ".\create-vm.ps1"

Write-Host "Runnig core script..."

# Create storage account to host DSC
$storageAccountName = "storage" + $nameSuffix
New-AzureRmStorageAccount -StorageAccountName "$storageAccountName" -Location "$location" -ResourceGroupName $resourceGroupName -SkuName Standard_RAGRS

# Upload DSC to storage
Publish-AzureRmVMDscConfiguration ".\dsc-for-vm.ps1" -ResourceGroupName $resourceGroupName -StorageAccountName $storageAccountName -Force

# Apply DSC to VM
Set-AzureRmVMDscExtension -ResourceGroupName $resourceGroupName -VMName "$vmName" -ArchiveBlobName "dsc-for-vm.ps1.zip" -ConfigurationName "VmDsc" -ArchiveStorageAccountName $storageAccountName -Version "2.8" -Location "$location"