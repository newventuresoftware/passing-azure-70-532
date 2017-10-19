<# 
### Task

    Get metrics (Request, Average Response Time, and HTTP 4XX) for a website and display them. 

### Details  

    Metrics starting ohe hour from now are retrieved. Metrics for the Production slot with time grain of 1 minute are retrieved.
    Unfortunately metrics will not be available when using a bran-new website. It is best to test this with an already existing site.

    To get metrics for e specific slot use Get-AzureRmWebAppSlotMetrics

### Initial Infrastructure

    One website is created.
     
#> 

$nameSuffix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$resourceGroupName = "grp" + $nameSuffix
$webAppName = "site" + $nameSuffix
$location="North Europe"

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

# Create a resource group.
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

# Create an App Service plan in Free tier.
New-AzureRmAppServicePlan -Name $webAppName -Location $location -ResourceGroupName $resourceGroupName -Tier Free

# Create a web app.
New-AzureRmWebApp -Name $webAppName -Location $location -AppServicePlan $webAppName -ResourceGroupName $resourceGroupName

Write-Host "Running core script..."

$metrics = Get-AzureRmWebAppMetrics -ResourceGroupName "$resourceGroupName" -Name "$webAppName" -StartTime (Get-Date).AddHours(-1) -EndTime (Get-Date) -Metrics {"Requests", "AverageResponseTime", "Http4xx"} -Granularity "PT1M"

Write-Host "Requests:"
$metrics[0].Data.Values | Format-Table *

Write-Host "Average Response Time"
$metrics[1].Data.Values | Format-Table *

Write-Host "HTTP 4XX Errors"
$metrics[2].Data.Values | Format-Table *