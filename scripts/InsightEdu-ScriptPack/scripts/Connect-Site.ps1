[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SiteUrl,
    [ValidateSet('WebLogin','DeviceCode','Interactive')][string]$AuthMode = 'Interactive'
)
$ErrorActionPreference = 'Stop'
switch ($AuthMode) {
    'WebLogin'    { Connect-PnPOnline -Url $SiteUrl -UseWebLogin }
    'DeviceCode'  { Connect-PnPOnline -Url $SiteUrl -DeviceLogin }
    'Interactive' { Connect-PnPOnline -Url $SiteUrl -Interactive }
}
Write-Host "Connected to $SiteUrl" -ForegroundColor Green