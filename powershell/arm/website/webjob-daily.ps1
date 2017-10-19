<# 
### Task

    Create a WebJob that is triggered by Azure Scheduler every minute.

### Details  

    There are various ways to configure how WebJob will be executed. One such way is to use the Azure Scheduler.
    Azure Scheduler allows us to trigger WebJob by sending a HTTP request to the URL of the WebJob.
    The Scheduler need to provide a valid Authorization header with the request in order to be able to trigger the job.
    The job is a simple console application that simply write to the logs when executed.


### Initial Infrastructure

    One website is created where the WebJob will run.
     
#> 

$nameSuffix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$resourceGroupName = "grp" + $nameSuffix
$webAppName = "site" + $nameSuffix
$location="North Europe"
$jobName = "SimpleWebJob"
$jobCollectionName = "jobCollection" + $nameSuffix
$location = "North Europe"

Write-Host "Creating infrastructure (group: $resourceGroupName)..."

# Create a resource group.
$resourceGroup = New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

# Create an App Service plan in Free tier.
New-AzureRmAppServicePlan -Name $webAppName -Location $location -ResourceGroupName $resourceGroupName -Tier Free

# Create a web app.
$website = New-AzureRmWebApp -Name $webAppName -Location $location -AppServicePlan $webAppName -ResourceGroupName $resourceGroupName

Write-Host "Running core script..."

# Generating authorization header
$credentials = "$($website.PublishingUsername):$($website.PublishingPassword)"
$credentialsBytes = [System.Text.Encoding]::UTF8.GetBytes($credentials);
$credentialsEncoded = [System.Convert]::ToBase64String($credentialsBytes);
$headers = @{"Authorization" = "Basic $credentialsEncoded"}

Write-Error "New-AzureWebsiteJob equivalent is currently not available for ARM"
#$job = New-AzureWebsiteJob -Name $website.Name -JobName "$jobName" -JobType Triggered -JobFile ".\SimpleWebJob.zip"
$jobCollection = New-AzureRmSchedulerJobCollection -Location $location -JobCollectionName $jobCollectionName -ResourceGroupName $resourceGroupName
New-AzureRmSchedulerHttpJob -JobCollectionName $jobCollectionName -JobName "$jobName" -Method POST -URI "$($job.Url)\run" -StartTime "2015-01-1" -EndTime "2020-01-1" -Interval 1 -Frequency Minute -Headers $headers


