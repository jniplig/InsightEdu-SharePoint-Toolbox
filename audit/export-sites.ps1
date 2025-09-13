. "$PSScriptRoot/../orchestrator/bootstrap.ps1" -Environment Prod
Get-PnPTenantSite | Select Url, Title, Template, Owner, StorageQuota, StorageUsageCurrent |
  Export-Csv ./out/sites.csv -NoTypeInformation
