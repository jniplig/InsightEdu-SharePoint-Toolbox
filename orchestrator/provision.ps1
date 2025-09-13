param(
  [Parameter()][ValidateSet('Dev','Test','Prod')]$Environment = 'Dev'
)

. "$PSScriptRoot/bootstrap.ps1" -Environment $Environment

$cfg = Get-Content (Join-Path $PSScriptRoot 'env.config.json') -Raw -ErrorAction SilentlyContinue
if(-not $cfg){
  $cfg = Get-Content (Join-Path $PSScriptRoot 'env.config.example.json') -Raw
}
$envCfg = $cfg | ConvertFrom-Json | Select-Object -ExpandProperty $Environment

$hubUrl = $envCfg.HubUrl

# Ensure Hub site
try {
  $null = Get-PnPSite -Identity $hubUrl -ErrorAction Stop
} catch {
  New-PnPSite -Type CommunicationSite -Title 'InsightEdu Hub' -Url $hubUrl -Lcid 1033 | Out-Null
}
Register-PnPHubSite -Site $hubUrl -ErrorAction SilentlyContinue

# Term Store import (simplified)
$terms = Get-Content (Join-Path $PSScriptRoot 'termstore.json') -Raw | ConvertFrom-Json
foreach($grp in $terms.Groups){
  Ensure-PnPTermGroup -Name $grp.Name -Description $grp.Description | Out-Null
  foreach($set in $grp.Sets){
    Ensure-PnPTermSet -Group $grp.Name -Name $set.Name | Out-Null
    foreach($t in $set.Terms){
      Ensure-PnPTerm -TermGroup $grp.Name -TermSet $set.Name -Name $t | Out-Null
    }
  }
}

# Create Dept-PE site
$deptUrl = "$($hubUrl)/sites/Dept-PE"
try {
  $null = Get-PnPSite -Identity $deptUrl -ErrorAction Stop
} catch {
  New-PnPSite -Type TeamSiteWithoutMicrosoft365Group -Title 'Department - PE' -Url $deptUrl | Out-Null
}
Add-PnPHubSiteAssociation -Site $deptUrl -HubSite $hubUrl -ErrorAction SilentlyContinue

Write-Host "Provisioning complete for $Environment." -ForegroundColor Green
