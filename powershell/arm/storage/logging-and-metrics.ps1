<# 
### Task

    Configure logging and metric option for a storage account in the following way:
        Enable logging for Delete and Write operations for Blob with 15-day retention
        Disable logging for Queue
        Disable logging for Table

        Enable service and API metrics for Blob with 1--day retention
        Disable all metrics for Table
        Disable all metrics for Queue
        Disable all metrics for File

### Details  

    N/A

### Initial Infrastructure

    One storage account is created.
     
#> 

$nameSuffix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$resourceGroupName = "grp" + $nameSuffix
$storageAccountName = "storage" + $nameSuffix

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location "North Europe"
$storageAccount = New-AzureRmStorageAccount -StorageAccountName "$storageAccountName" -Location "North Europe" -ResourceGroupName $resourceGroupName -SkuName Standard_RAGRS

Write-Host "Running core script..."

Write-Host "Setting logging options"
Set-AzureStorageServiceLoggingProperty -Context $storageAccount.Context -ServiceType Blob -LoggingOperations Delete, Write  -RetentionDays 15
Set-AzureStorageServiceLoggingProperty -Context $storageAccount.Context -ServiceType Queue -LoggingOperations None 
Set-AzureStorageServiceLoggingProperty -Context $storageAccount.Context -ServiceType Table -LoggingOperations None 

Write-Host "Setting metrics options"
Set-AzureStorageServiceMetricsProperty -Context $storageAccount.Context -ServiceType Blob -MetricsType Hour -MetricsLevel ServiceAndApi -RetentionDays 10
Set-AzureStorageServiceMetricsProperty -Context $storageAccount.Context -ServiceType Table -MetricsType Hour -MetricsLevel None
Set-AzureStorageServiceMetricsProperty -Context $storageAccount.Context -ServiceType Queue -MetricsType Hour -MetricsLevel None
Set-AzureStorageServiceMetricsProperty -Context $storageAccount.Context -ServiceType File -MetricsType Hour -MetricsLevel None