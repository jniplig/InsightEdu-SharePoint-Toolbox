param(
  [Parameter(Mandatory=$true)][string]$TenantAdminUrl,
  [Parameter(Mandatory=$true)][string]$HubTitle,
  [Parameter(Mandatory=$true)][string]$ClientSiteUrl,
  [Parameter(Mandatory=$true)][string]$ClientSiteTitle
)

# Requires: Install-Module PnP.PowerShell
# Run: pwsh ./provision.ps1 -TenantAdminUrl "https://YOURTENANT-admin.sharepoint.com" -HubTitle "InsightEdu Hub" -ClientSiteUrl "https://YOURTENANT.sharepoint.com/sites/InsightEduClient" -ClientSiteTitle "InsightEdu Client Workspace"

Write-Host "Connecting to Tenant Admin..." -ForegroundColor Cyan
Connect-PnPOnline -Url $TenantAdminUrl -Interactive

# 1) Create Client Site (Communication site) if missing
try {
  Get-PnPTenantSite -Url $ClientSiteUrl -ErrorAction Stop | Out-Null
  Write-Host "Site exists: $ClientSiteUrl"
} catch {
  Write-Host "Creating site: $ClientSiteUrl" -ForegroundColor Yellow
  New-PnPTenantSite -Url $ClientSiteUrl -Title $ClientSiteTitle -Template "SITEPAGEPUBLISHING#0" -TimeZone 82 -AllowSelfServiceUpgrade $true -Owner (Get-PnPAdminTenant).CorporateCatalogConnection -ErrorAction SilentlyContinue
  # Fallback owner if above fails
  Set-PnPTenantSite -Url $ClientSiteUrl -Owners (Get-PnPContext).Connection.PSCredential.UserName -ErrorAction SilentlyContinue
}

# 2) Ensure Hub site (register the client site as hub if no hub exists)
$existingHubs = Get-PnPHubSite -ErrorAction SilentlyContinue
if($existingHubs.Count -eq 0){
  Write-Host "Registering hub on client site..." -ForegroundColor Yellow
  Register-PnPHubSite -Site $ClientSiteUrl -Title $HubTitle | Out-Null
  $hubSiteUrl = $ClientSiteUrl
} else {
  $hubSiteUrl = $existingHubs[0].SiteUrl
  Write-Host "Using existing hub: $hubSiteUrl"
  # Associate client to the first hub if different
  if($hubSiteUrl -ne $ClientSiteUrl){
    Add-PnPHubSiteAssociation -Site $ClientSiteUrl -HubSite $hubSiteUrl -ErrorAction SilentlyContinue
  }
}

# 3) Apply PnP provisioning template
Write-Host "Applying provisioning template..." -ForegroundColor Cyan
Connect-PnPOnline -Url $ClientSiteUrl -Interactive
Apply-PnPProvisioningTemplate -Path "$PSScriptRoot/../templates/InsightEdu.Core.xml"

# 4) Create key lists (if they don't exist) and apply formatting
function Ensure-List {
  param([string]$Title, [string]$Template)
  $list = Get-PnPList -Identity $Title -ErrorAction SilentlyContinue
  if(-not $list){
    Write-Host "Creating list $Title ($Template)"
    New-PnPList -Title $Title -Template $Template -OnQuickLaunch
  } else {
    Write-Host "List exists: $Title"
  }
}

Ensure-List -Title "Inspection Evidence" -Template GenericList
Ensure-List -Title "WAAG" -Template GenericList
Ensure-List -Title "Trip Requests" -Template GenericList

# 5) Add Fields to lists
function Ensure-Field {
  param([string]$ListTitle, [string]$InternalName, [string]$Xml)
  $field = Get-PnPField -List $ListTitle -Identity $InternalName -ErrorAction SilentlyContinue
  if(-not $field){
    Add-PnPFieldFromXml -List $ListTitle -FieldXml $Xml | Out-Null
    Write-Host "Added field $InternalName to $ListTitle"
  } else {
    Write-Host "Field exists $InternalName in $ListTitle"
  }
}

# Inspection Evidence fields
$fields = @(
  '<Field Type="Text" Name="StandardRef" DisplayName="Standard Ref" />',
  '<Field Type="Text" Name="EvidenceLink" DisplayName="Evidence Link" />',
  '<Field Type="Choice" Name="RAGStatus" DisplayName="RAG Status"><CHOICES><CHOICE>Red</CHOICE><CHOICE>Amber</CHOICE><CHOICE>Green</CHOICE></CHOICES></Field>',
  '<Field Type="Note" Name="Notes" DisplayName="Notes" />',
  '<Field Type="DateTime" Name="ReviewDue" DisplayName="Review Due" Format="DateOnly" />'
)
foreach($f in $fields){ Ensure-Field -ListTitle "Inspection Evidence" -InternalName (([xml]$f).Field.Name) -Xml $f }

# WAAG fields
$waagFields = @(
  '<Field Type="Text" Name="Phase" DisplayName="Phase" />',
  '<Field Type="Text" Name="Owner" DisplayName="Owner" />',
  '<Field Type="DateTime" Name="StartDateTime" DisplayName="Start DateTime" Format="DateTime" />',
  '<Field Type="DateTime" Name="EndDateTime" DisplayName="End DateTime" Format="DateTime" />',
  '<Field Type="Note" Name="Description" DisplayName="Description" />'
)
foreach($f in $waagFields){ Ensure-Field -ListTitle "WAAG" -InternalName (([xml]$f).Field.Name) -Xml $f }

# Trip Requests fields
$tripFields = @(
  '<Field Type="Text" Name="TripStage" DisplayName="Trip Stage" />',
  '<Field Type="User" Name="TripLeader" DisplayName="Trip Leader" UserSelectionMode="PeopleOnly" />',
  '<Field Type="DateTime" Name="TripDate" DisplayName="Trip Date" Format="DateOnly" />',
  '<Field Type="Number" Name="StudentCount" DisplayName="Student Count" />',
  '<Field Type="Hyperlink" Name="RiskAssessment" DisplayName="Risk Assessment Link" />',
  '<Field Type="Note" Name="MedicalNotes" DisplayName="Medical Notes" />'
)
foreach($f in $tripFields){ Ensure-Field -ListTitle "Trip Requests" -InternalName (([xml]$f).Field.Name) -Xml $f }

# 6) Apply view formatting
function Apply-Formatting {
  param([string]$ListTitle, [string]$Path)
  $fmt = Get-Content -Raw -Path $Path
  Set-PnPView -List $ListTitle -Identity "All Items" -Values @{ CustomFormatter = $fmt }
  Write-Host "Applied formatting to $ListTitle"
}

Apply-Formatting -ListTitle "WAAG" -Path "$PSScriptRoot/../lists/waag-format.json"
Apply-Formatting -ListTitle "Inspection Evidence" -Path "$PSScriptRoot/../lists/inspection-evidence-format.json"
Apply-Formatting -ListTitle "Trip Requests" -Path "$PSScriptRoot/../lists/trip-requests-format.json"

Write-Host "Done." -ForegroundColor Green
