[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$TenantName,
    [Parameter(Mandatory=$true)][string]$DeptName,
    [string]$OwnerUPN,
    [ValidateSet('Communication','Team')][string]$Type = 'Communication'
)
$ErrorActionPreference = 'Stop'
$siteUrl = "https://$TenantName.sharepoint.com/sites/$DeptName"
if ($Type -eq 'Communication') {
    New-PnPSite -Type CommunicationSite -Title "$DeptName Department" -Url $siteUrl -Lcid 1033 -AllowFileSharingForGuestUsers:$false
} else {
    if (-not $OwnerUPN) { throw "OwnerUPN required for Team site" }
    New-PnPSite -Type TeamSite -Title "$DeptName Department" -Url $siteUrl -Lcid 1033 -AllowFileSharingForGuestUsers:$false -Owners $OwnerUPN
}
Write-Host "Created $Type site at $siteUrl" -ForegroundColor Green