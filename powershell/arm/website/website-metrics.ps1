<# 
### Task

    Get metrics (Request, Average Response Time, and HTTP 4XX) for a website and display them. 

### Details  

    Metrics starting ohe hour from now are retrieved. Metrics for the Production slot with time grain of 1 minute are retrieved.
    Unfortunately metrics will not be available when using a bran-new website. It is best to test this with an already existing site.


### Initial Infrastructure

    One website is created.
     
#> 

$namePrefix = (get-random -Count 8 -InputObject "abcdefg0123456789".ToCharArray()) -join ''
$websiteName = $namePrefix + "site"

Write-Host "Creating infrastructure (prefix: $namePrefix)..."

New-AzureWebsite -Name $websiteName -Location "North Europe"

Write-Host "Running core script..."

$website = Get-AzureWebsite -Name $websiteName
$metrics = Get-AzureWebsiteMetric -Name "$websiteName" -StartDate (Get-Date).AddHours(-1) -MetricNames "Requests", "AverageResponseTime", "Http4xx" -Slot Production -TimeGrain "PT1M"

Write-Host "Requests:"
$metrics[0].Data.Values | Format-Table *

Write-Host "Average Response Time"
$metrics[1].Data.Values | Format-Table *

Write-Host "HTTP 4XX Errors"
$metrics[2].Data.Values | Format-Table *