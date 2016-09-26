<# 
### Task

    Create a Traffic Manager Profile that will load balance between two websites based on performance.

### Details  

    When performance load balancing is enabled users will be redirected to a website instance that is closer to them.
    You have to manually upgrade the App Service Plan of the websites to Standard after the script is run - required by Traffic Manager.
    If websites are not Standard instances load balancing will not work.

### Initial Infrastructure

    Two websites - one in Euroe and one in US are created.
     
#> 

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$website1Name = $namePrefix + "website1"
$website2Name = $namePrefix + "website2"

Write-Host "Creating infrastructure (prefix: $namePrefix)..."

$website1 = New-AzureWebsite -Name "$website1Name" -Location "North Europe"
$website2 = New-AzureWebsite -Name "$website2Name" -Location "West US"

Write-Host "Running core script..."

$profile = New-AzureTrafficManagerProfile -Name "cert70532TrafficManagerProfile" -DomainName "cert70532profile.trafficmanager.net" -LoadBalancingMethod "Performance" -Ttl 30 -MonitorProtocol "Http" -MonitorPort 80 -MonitorRelativePath "/"
Add-AzureTrafficManagerEndpoint -TrafficManagerProfile $profile -DomainName $website1.EnabledHostNames[0] -Status "Enabled" -Type "AzureWebsite"
Add-AzureTrafficManagerEndpoint -TrafficManagerProfile $profile -DomainName $website2.EnabledHostNames[0] -Status "Enabled" -Type "AzureWebsite"
Set-AzureTrafficManagerProfile -TrafficManagerProfile $profile