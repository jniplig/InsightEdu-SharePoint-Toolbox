[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SiteUrl,
    [Parameter(Mandatory=$true)][string]$TemplatePath
)
$ErrorActionPreference = 'Stop'
Connect-PnPOnline -Url $SiteUrl -Interactive
Invoke-PnPSiteTemplate -Path $TemplatePath
Write-Host "Applied template $TemplatePath to $SiteUrl" -ForegroundColor Green