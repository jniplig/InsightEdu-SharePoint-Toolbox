param(
  [Parameter(Mandatory=$true)][string]$SitesCsv,
  [Parameter()][string]$OutDir = "./output",
  [Parameter()][string[]]$ExcludeUrlPatterns = @()
)
$ErrorActionPreference = "Stop"
if (!(Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$sites = Import-Csv $SitesCsv
function Skip-Url($url, $patterns){
  foreach($p in $patterns){ if ($url -like "*$p*") { return $true } }
  return $false
}
foreach($s in $sites){
  $url = $s.Url
  if (Skip-Url $url $ExcludeUrlPatterns) { continue }
  try{
    Connect-PnPOnline -Url $url -Interactive
    $lists = Get-PnPList | Where-Object { -not $_.Hidden }
    $lists | Select @{N='SiteUrl';E={$url}},
                     Title, BaseTemplate, ItemCount, EnableVersioning,
                     EnableModeration, ForceCheckout, HasUniqueRoleAssignments |
      Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "Libraries.csv")
    $cts = Get-PnPContentType
    $cts | Select @{N='SiteUrl';E={$url}}, Name, Id, Group, Sealed, ReadOnly |
      Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "ContentTypes.csv")
    $fields = Get-PnPField
    $fields | Select @{N='SiteUrl';E={$url}}, InternalName, Title, TypeAsString, Group, Required |
      Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "Fields.csv")
    $roles = Get-PnPRoleAssignment
    foreach($r in $roles){
      [PSCustomObject]@{
        SiteUrl=$url; Level="Web"; Principal=$r.Member.Title; PrincipalType=$r.Member.PrincipalType;
        Roles=($r.RoleDefinitionBindings | ForEach-Object {$_.Name}) -join ';'
      } | Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "Permissions.csv")
    }
    foreach($l in $lists){
      if($l.HasUniqueRoleAssignments){
        [PSCustomObject]@{
          SiteUrl=$url; Level="List"; ListTitle=$l.Title; ListUrl=$l.RootFolder.ServerRelativeUrl; UniquePerms=$true
        } | Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "Permissions.csv")
      }
    }
  } catch { Write-Warning "Failed on $url : $($_.Exception.Message)" }
}
