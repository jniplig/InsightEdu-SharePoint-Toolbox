param(
  [Parameter(Mandatory=$true)][string]$TenantShortName,
  [Parameter()][bool]$IncludeOneDriveSites = $false,
  [Parameter()][string]$OutDir = "./output"
)
$ErrorActionPreference = "Stop"
$adminUrl = "https://$TenantShortName-admin.sharepoint.com"
if (!(Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
Connect-PnPOnline -Url $adminUrl -Interactive

$sites = Get-PnPTenantSite -IncludeOneDriveSites:$IncludeOneDriveSites -Detailed
$sites | Select Title, Url, Template, Owner, StorageUsageCurrent,
                LastContentModifiedDate, IsHubSite, HubSiteId, SharingCapability, TimeZoneId |
  Export-Csv -NoTypeInformation -Path (Join-Path $OutDir "Sites.csv")

$hubs = Get-PnPHubSite
$hubs | Select Id, Title, SiteUrl, Description |
  Export-Csv -NoTypeInformation -Path (Join-Path $OutDir "Hubs.csv")

$hubConns = foreach($hub in $hubs){
  $connected = Get-PnPHubSiteChild -Identity $hub.Id
  foreach($c in $connected){
    [PSCustomObject]@{ HubId=$hub.Id; HubTitle=$hub.Title; HubUrl=$hub.SiteUrl; SiteUrl=$c.SiteUrl }
  }
}
$hubConns | Export-Csv -NoTypeInformation -Path (Join-Path $OutDir "HubConnections.csv")
