param(
  [Parameter(Mandatory=$true)][string]$RootUrl,
  [Parameter()][string]$OutDir = "./output"
)
$ErrorActionPreference = "Stop"
if (!(Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
Connect-PnPOnline -Url $RootUrl -Interactive
$session = Get-PnPTaxonomySession
$store   = Get-PnPTermStore -TermStore $session
$groups  = Get-PnPTermGroup -TermStore $store
foreach($g in $groups){
  $sets = Get-PnPTermSet -TermGroup $g
  foreach($set in $sets){
    $terms = Get-PnPTerm -TermSet $set -Recursive
    foreach($t in $terms){
      [PSCustomObject]@{
        Group=$g.Name; TermSet=$set.Name; Term=$t.Name; TermId=$t.Id; Parent=($t.Parent.Name); Path=$t.PathOfTerm
      } | Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "TermStore.csv")
    }
  }
}
