param([Parameter(Mandatory)][string]$SiteUrl)
Connect-PnPOnline -Url $SiteUrl -Interactive
Get-PnPGroup | ForEach-Object {
  $g = $_
  Get-PnPGroupMember -Identity $g | Select @{N='Group';E={$g.Title}}, LoginName, Email
} | Export-Csv ./out/$((($SiteUrl -split '/')[-1])).permissions.csv -NoTypeInformation
