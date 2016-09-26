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

$namePrefix = (get-random -Count 10 -InputObject "123456".ToCharArray()) -join ''
$websiteName = $namePrefix + "website"
$jobName = "SimpleWebJob"
$jobCollectionName = $namePrefix + "jobCollection5"
$location = "North Europe"

Write-Host "Creating infrastructure (prefix: $namePrefix)..."

$website = New-AzureWebsite -Name "$websiteName" -Location "NorthEurope"

# Generating authorization header
$credentials = "$($website.PublishingUsername):$($website.PublishingPassword)"
$credentialsBytes = [System.Text.Encoding]::UTF8.GetBytes($credentials);
$credentialsEncoded = [System.Convert]::ToBase64String($credentialsBytes);
$headers = @{"Authorization" = "Basic $credentialsEncoded"}

Write-Host "Running core script..."

$job = New-AzureWebsiteJob -Name $website.Name -JobName "$jobName" -JobType Triggered -JobFile ".\SimpleWebJob.zip"
$jobCollection = New-AzureSchedulerJobCollection -Location $location -JobCollectionName $jobCollectionName
New-AzureSchedulerHttpJob -JobCollectionName $jobCollectionName -JobName "$jobName" -Method POST -URI "$($job.Url)\run" -Location $location -StartTime "2015-01-1" -EndTime "2020-01-1" -Interval 1 -Frequency Minute -Headers $headers