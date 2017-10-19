<# 
### Task

    To connect to a VM you need its public IP. 
    This script show how you can get the IP.

### Details  

    This sciprt uses the base create-vm.ps1 script to provision a virtual machine.

### Initial Infrastructure

    A standard VM is first created.
     
#> 

. ".\create-vm.ps1"

Write-Host "Runnig core script..."

$ip = Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroupName -Name "ip$nameSuffix" | `
        Select-Object IpAddress

Write-Host "Public IP address: $ip"
    