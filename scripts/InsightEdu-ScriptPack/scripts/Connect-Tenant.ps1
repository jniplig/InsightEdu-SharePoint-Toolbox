[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$TenantName,
    [ValidateSet('WebLogin','DeviceCode','Interactive')][string]$AuthMode = 'Interactive'
)
$ErrorActionPreference = 'Stop'
$tenantUrl = "https://$TenantName.sharepoint.com"
switch ($AuthMode) {
    'WebLogin'    { Connect-PnPOnline -Url $tenantUrl -UseWebLogin }
    'DeviceCode'  { Connect-PnPOnline -Url $tenantUrl -DeviceLogin }
    'Interactive' { Connect-PnPOnline -Url $tenantUrl -Interactive }
}
Write-Host "Connected to $tenantUrl" -ForegroundColor Green