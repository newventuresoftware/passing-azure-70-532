<# 
### Task

    Create a Traffic Manager Profile that will load balance between two web apps based on performance.

### Details  

    When performance load balancing is enabled users will be redirected to a web app instance that is closer to them.
    Standard web app plans (or higher) must be used.

### Initial Infrastructure

    Two web apps - one in Euroe and one in US are created.
     
#> 

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$trafficManagerName = $namePrefix + "traffic"
$trafficManagerDnsName = "traffic" + $namePrefix
$webApp1Name = $namePrefix + "website1"
$webApp2Name = $namePrefix + "website2"
$resourceGroupName = $namePrefix + "grp"

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location "North Europe"
$appServicePlan1 = New-AzureRmAppServicePlan -Name "app1Plan" -Location "North Europe" -Tier Standard -WorkerSize Small -ResourceGroupName $resourceGroupName
$appServicePlan2 = New-AzureRmAppServicePlan -Name "app2Plan" -Location "West US" -Tier Standard -WorkerSize Small -ResourceGroupName $resourceGroupName
$webApp1 = New-AzureRmWebApp -Name "$webApp1Name" -AppServicePlan "app1Plan" -Location "North Europe" -ResourceGroupName $resourceGroupName 
$webApp2 = New-AzureRmWebApp -Name "$webApp2Name" -AppServicePlan "app2Plan" -Location "West US" -ResourceGroupName $resourceGroupName 

Write-Host "Running core script..."

$profile = New-AzureRmTrafficManagerProfile -Name $trafficManagerName -RelativeDnsName $trafficManagerDnsName -TrafficRoutingMethod Performance -Ttl 30 -MonitorProtocol HTTP -MonitorPort 80 -MonitorPath "/"  -ResourceGroupName $resourceGroupName
Add-AzureRmTrafficManagerEndpointConfig -TrafficManagerProfile $profile -EndpointName "web1" -TargetResourceId $webApp1.Id -EndpointStatus Enabled -Type AzureEndpoints 
Add-AzureRmTrafficManagerEndpointConfig -TrafficManagerProfile $profile -EndpointName "web2" -TargetResourceId $webApp2.Id -EndpointStatus Enabled -Type AzureEndpoints 
Set-AzureRmTrafficManagerProfile -TrafficManagerProfile $profile