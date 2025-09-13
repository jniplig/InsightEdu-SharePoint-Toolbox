. "$PSScriptRoot/../orchestrator/bootstrap.ps1" -Environment Prod
Get-PnPTenantSite | Select Url, StorageUsageCurrent, LastContentModifiedDate |
  Export-Csv ./out/storage-activity.csv -NoTypeInformation
