# ServiceDefinition vs ServiceConfiguration Cheat Sheet
Last updated - 2016-10-19

## Service Definition and Service Configuration Schemas
The information here is based on the schemas for [ServiceDefinition](https://msdn.microsoft.com/en-us/library/azure/ee758711.aspx) and [ServiceConfiguration](https://msdn.microsoft.com/en-us/library/azure/ee758711.aspx)

## Cheat Sheet

Setting | Service Definition (.csdef) | Service Configuration (.cscfg)
--- | :---: | :---:
Service name | ![Blue dot](../images/blue-dot.png)
Upgrade domain count | ![Blue dot](../images/blue-dot.png)
Role definitions | ![Blue dot](../images/blue-dot.png) |
Role name | ![Blue dot](../images/blue-dot.png) |
Role virtual machine size | ![Blue dot](../images/blue-dot.png) |
Role ConfigurationSettings | ![Blue dot](../images/blue-dot.png) | ![Blue dot](../images/blue-dot.png)
Role LocalResources | ![Blue dot](../images/blue-dot.png) |
Role LocalStorage| ![Blue dot](../images/blue-dot.png) |
Role enpoints | ![Blue dot](../images/blue-dot.png)
Role certificates | ![Blue dot](../images/blue-dot.png) | ![Blue dot](../images/blue-dot.png)
Associate endpoint with certificate | ![Blue dot](../images/blue-dot.png) |
Certificate thumbprint and algorithm | | ![Blue dot](../images/blue-dot.png)
Role module imports | ![Blue dot](../images/blue-dot.png)
Role execution context | ![Blue dot](../images/blue-dot.png)
Role environment variables | ![Blue dot](../images/blue-dot.png)
Role startup task | ![Blue dot](../images/blue-dot.png)
Role content files and folders | ![Blue dot](../images/blue-dot.png)
Web Role sites | ![Blue dot](../images/blue-dot.png)
Web Role site endpoint bindings | ![Blue dot](../images/blue-dot.png)
Network Traffic Rules | ![Blue dot](../images/blue-dot.png)
Load Balancer Probes | ![Blue dot](../images/blue-dot.png)
Network configuration | | ![Blue dot](../images/blue-dot.png)
DNS servers | | ![Blue dot](../images/blue-dot.png)
Virtual network of cloud service | | ![Blue dot](../images/blue-dot.png)
Access control for enpoints | | ![Blue dot](../images/blue-dot.png)
Reserved IPs | | ![Blue dot](../images/blue-dot.png)
Associate roles with subnet | | ![Blue dot](../images/blue-dot.png)
Service Guest OS | | ![Blue dot](../images/blue-dot.png)
Service Guest OS version | | ![Blue dot](../images/blue-dot.png)
Role instance count | | ![Blue dot](../images/blue-dot.png)

