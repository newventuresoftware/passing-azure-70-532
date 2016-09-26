<# 
### Task

    Change the performance level of an Sql Server database from "S0" to "S3" when Geo Replication has been enabled.

### Details  

    Changing the performance level is not possible when Geo Replication is enabled.
    In order to do that the second database should be removed first and then recreated.
    You need to provide your IP address in order to be able to access the SQL database.

### Initial Infrastructure

    Two SQL Server are created - one primary (North Europe) and one secondary (West Europe).
    One database is created on the primary server.
    Continuous copy of the database is created on the secondary server.
     
#> 

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$serverName = "srv" + $namePrefix
$dbName = "db" + $namePrefix
$dbUser = "tester"
$dbPass = "myP@ssword"
$myIP = ""

if($myIP -eq "") {
    throw "Please, set your IP address" 
}

Write-Host "Creating infrastructure (prefix: $namePrefix)..."

$server = New-AzureSqlDatabaseServer -Location "North Europe" -AdministratorLogin "$dbUser" -AdministratorLoginPassword "$dbPass" -Version "12.0"
$serverSecondary = New-AzureSqlDatabaseServer -Location "West Europe" -AdministratorLogin "$dbUser" -AdministratorLoginPassword "$dbPass" -Version "12.0"
$securePass = ConvertTo-SecureString –String "$dbPass" –AsPlainText -Force
$serverCredential = New-Object –TypeName "System.Management.Automation.PSCredential" –ArgumentList $dbUser, $securePass
$initialPerformanceLevel = Get-AzureSqlDatabaseServiceObjective -ServerName $server.ServerName -ServiceObjectiveName "S0"
New-AzureSqlDatabaseServerFirewallRule $server.ServerName -RuleName "adminIP" -StartIpAddress "$myIP" -EndIpAddress "$myIP"
$serverContext = New-AzureSqlDatabaseServerContext -ServerName $server.ServerName -Credential $serverCredential
$database = New-AzureSqlDatabase -ConnectionContext $serverContext -DatabaseName "$dbName" -Edition "Standard" -ServiceObjective $initialPerformanceLevel
Start-AzureSqlDatabaseCopy -ServerName $server.ServerName -DatabaseName "$dbName" -PartnerServer $serverSecondary.ServerName -ContinuousCopy -OfflineSecondary

Write-Host "Running core script..."

$newPerformanceLevel = Get-AzureSqlDatabaseServiceObjective -ServerName $server.ServerName -ServiceObjectiveName "S3"
Remove-AzureSqlDatabase -ServerName $serverSecondary.ServerName -DatabaseName "$dbName" -Force
$database = Set-AzureSqlDatabase -ConnectionContext $serverContext -Database $database -ServiceObjective $newPerformanceLevel -Force -PassThru

Write-Host "Waiting for update to complete..."
Start-Sleep -Seconds 180

Start-AzureSqlDatabaseCopy -ServerName $server.ServerName -Database $database -PartnerServer $serverSecondary.ServerName -ContinuousCopy -OfflineSecondary