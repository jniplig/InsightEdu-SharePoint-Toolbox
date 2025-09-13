[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SiteUrl,
    [Parameter(Mandatory=$true)][string]$ListTitle,
    [ValidateSet('GenericList','DocumentLibrary','Announcements','Contacts','Calendar','Tasks','IssueTracking')][string]$Template = 'GenericList'
)
$ErrorActionPreference = 'Stop'
Connect-PnPOnline -Url $SiteUrl -Interactive
if ($Template -eq 'DocumentLibrary') {
    if (-not (Get-PnPList -Identity $ListTitle -ErrorAction SilentlyContinue)) {
        Add-PnPList -Title $ListTitle -Template DocumentLibrary | Out-Null
    }
} else {
    if (-not (Get-PnPList -Identity $ListTitle -ErrorAction SilentlyContinue)) {
        Add-PnPList -Title $ListTitle -Template $Template | Out-Null
    }
}
Write-Host "Ensured list '$ListTitle' at $SiteUrl" -ForegroundColor Green