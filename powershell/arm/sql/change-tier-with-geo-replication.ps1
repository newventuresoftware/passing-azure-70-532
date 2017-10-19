<# 
### Task

    Change the performance level of an Sql Server database from "S0" to "S3" when Geo Replication has been enabled.

### Details  

    Contrary to ASM, ARM cmdlets allow us to change performance level of DBs on the fly. 

### Initial Infrastructure

    Two SQL Server are created - one primary (East US) and one secondary (West US 2).
    One database is created on the primary server.
    Continuous copy of the database is created on the secondary server.
     
#> 
$nameSuffix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$resourceGroupName = "grp" + $nameSuffix
$serverName = "srv" + $nameSuffix
$serverSecondaryName = $serverName + "secondary"
$dbName = "db" + $nameSuffix
$dbUser = "tester"
$dbPass = "myP@ssword"
$myIP = ""

if($myIP -eq "") {
    throw "Please, set your IP address" 
}

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location "East US"
$securePass = ConvertTo-SecureString –String $dbPass –AsPlainText -Force
$dbCredentials = New-Object –TypeName "System.Management.Automation.PSCredential" –ArgumentList $dbUser, $securePass
$server = New-AzureRmSqlServer -ResourceGroupName $resourceGroupName -Location "East US" -SqlAdministratorCredentials $dbCredentials -ServerVersion "12.0" -ServerName $serverName
$serverSecondary = New-AzureRmSqlServer -ResourceGroupName $resourceGroupName -Location "West US 2" -SqlAdministratorCredentials $dbCredentials -ServerVersion "12.0" -ServerName $serverSecondaryName

New-AzureRmSqlServerFirewallRule -ServerName $serverName -FirewallRuleName "adminIP" -StartIpAddress $myIP -EndIpAddress $myIP -ResourceGroupName $resourceGroupName
$database = New-AzureRmSqlDatabase -DatabaseName $dbName -RequestedServiceObjectiveName "S0" -ServerName $serverName -ResourceGroupName $resourceGroupName -Edition Standard
New-AzureRmSqlDatabaseSecondary -DatabaseName $dbName -ServerName $serverName -ResourceGroupName $resourceGroupName -PartnerServerName $serverSecondaryName -PartnerResourceGroupName $resourceGroupName

# Write-Host "Running core script..."

Set-AzureRmSqlDatabase -DatabaseName $dbName -ServerName $serverName -ResourceGroupName $resourceGroupName -RequestedServiceObjectiveName "S3"
Set-AzureRmSqlDatabase -DatabaseName $dbName -ServerName $serverSecondaryName -ResourceGroupName $resourceGroupName -RequestedServiceObjectiveName "S3"