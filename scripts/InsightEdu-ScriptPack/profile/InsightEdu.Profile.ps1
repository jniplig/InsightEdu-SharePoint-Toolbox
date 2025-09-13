# InsightEdu PowerShell Profile Snippets (load with: . "$PWD\profile\InsightEdu.Profile.ps1")

function Connect-InsightEduTenant {
    param([Parameter(Mandatory=$true)][string]$TenantName, [ValidateSet('WebLogin','DeviceCode','Interactive')][string]$AuthMode = 'Interactive')
    & (Join-Path $PSScriptRoot '..\scripts\Connect-Tenant.ps1') -TenantName $TenantName -AuthMode $AuthMode
}
Set-Alias cie Connect-InsightEduTenant

function Connect-InsightEduSite {
    param([Parameter(Mandatory=$true)][string]$SiteUrl, [ValidateSet('WebLogin','DeviceCode','Interactive')][string]$AuthMode = 'Interactive')
    & (Join-Path $PSScriptRoot '..\scripts\Connect-Site.ps1') -SiteUrl $SiteUrl -AuthMode $AuthMode
}
Set-Alias cis Connect-InsightEduSite

function Apply-IESiteTemplate {
    param([Parameter(Mandatory=$true)][string]$SiteUrl, [Parameter(Mandatory=$true)][string]$TemplatePath)
    & (Join-Path $PSScriptRoot '..\scripts\Apply-SiteTemplate.ps1') -SiteUrl $SiteUrl -TemplatePath $TemplatePath
}
Set-Alias iapply Apply-IESiteTemplate