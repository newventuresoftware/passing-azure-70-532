# Azure Quick Facts
Last updated - 2016-10-11

## Cloud Services
* Role startup tasks cannot directly execute a Powershell script – use console application or a batch file that starts the PowerShell script.
* Setting RoleEnvironmentChangingEventArgs.Cancel to true will take the respective instance offline and bring it back again after the configuration changes have been applied.

## SQL
* SQL Server service tier cannot be changed when Geo-Replication is enabled.
* Restore window for Basic tier is 7 days.
* Restore window for Standard tier is 14 days.
* Restore window for Premium tier is 35 days.

## Redis Cache
* Port should not be specified in the connection string.
* Sharding/clustering is only available with the Premium plans.

## Azure Storage
* Get Queue Metadata is used to retrieve the approximate size of the queue.
* Shared Access Signature without Stored Access Policy can only be revoked by changing the account key.
* Page Blobs are optimized for random I/O operations.
* Block Blobs are optimized for sequential I/O operations.
* Zone redundant storage does not support page blobs.

## Virtual Machines
* Sysprep with Generalzie option is used to prepare a VM to be captured as an image.
* Waagent with Deprovision option is used to prepare a Linux to be captured as an image.
* Only VMs in the same cloud service can be part of an availability set.

## Access Control Lists
* When an endpoint is first created, all traffic is permitted for that endpoint.
* When one or more Permit rules are added, traffic is implicitly denied for all IP ranged not included in the Permit rules.
* When one or more Deny rules are added, traffic is implicitly allowed for all IP ranged now included in the Deny rules.
* No implicit rules are applied when both Permit and Deny rules are used.

## Cloud Storage
* CloudQueue.FetchAttributes must be used before ApproximateMessageCount property can be read. 
* ApproximateMessageCount provides the approximate number of messages in the queue.

## Web Apps
* When swapping, App Settings can be configured to be swapped or to stick.
* When swapping, Configuration settings can be configured to be swapped or to stick.
* When swapping, diagnostic settings are always swapped.
* When swapping, endpoints are not swapped.
* When swapping, Webjob content is swapped.
* When swapping, Webjob schedulers are not swapped.