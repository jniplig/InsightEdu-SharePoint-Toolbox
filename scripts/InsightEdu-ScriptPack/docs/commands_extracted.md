# Extracted PowerShell Commands (from console buffer)

## PnP Connect
```powershell
Connect-PnPOnline -Url "https://netorgft18192557-admin.sharepoint.com" `
Connect-PnPOnline: Unable to connect using provided arguments
Connect-PnPOnline -Url $clientUrl `
Connect-PnPOnline -Url "https://netorgft18192557.sharepoint.com/sites/Client1" `
Connect-PnPOnline -Url "https://netorgft18192557.sharepoint.com/sites/ed-slt" `
Connect-PnPOnline -Url "https://netorgft18192557.sharepoint.com/sites/ed-pe" `
Connect-PnPOnline -Url "https://netorgft18192557.sharepoint.com/sites/ed-pe" -DeviceLogin
```

## PnP Site Provision
```powershell
New-PnPSite -Type CommunicationSite -Url $clientUrl -Title $clientTitle -Lcid 1033
New-PnPSite: {"error":{"code":"-2147024894, System.IO.FileNotFoundException","message":"File Not Found."}}
Invoke-PnPSiteTemplate -Path "C:\InsightEdu\templates\InsightEdu.Core.xml"
Invoke-PnPSiteTemplate: Template is not valid
New-PnPSite -Type TeamSite -Title "ED - SLT" -Alias "ed-slt" -Owners "jeremy@insightedu.co"
New-PnPSite -Type TeamSite -Title "ED - PE" -Alias "ed-pe" -Owners "jeremy@insightedu.co"
```

## PnP List Library
```powershell
Get-PnPList -Identity "Inspection Evidence" | Select Title, DefaultViewUrl
Get-PnPList -Identity "WAAG" | Select Title, DefaultViewUrl
New-PnPList -Title "WAAG" -Template GenericList -OnQuickLaunch
Add-PnPList -Title "Curriculum"  -Template DocumentLibrary -OnQuickLaunch
Add-PnPList: The term 'Add-PnPList' is not recognized as a name of a cmdlet, function, script file, or executable program.
Add-PnPList -Title "Assessments" -Template DocumentLibrary -OnQuickLaunch
Set-PnPList -Identity "Curriculum"  -ContentTypesEnabled:$true
Set-PnPList: A parameter cannot be found that matches parameter name 'ContentTypesEnabled'.
Set-PnPList -Identity "Assessments" -ContentTypesEnabled:$true
Add-PnPList:
Get-PnPList:
Set-PnPList:
Get-PnPList | Select Title    # quick inventory of lists on THIS site
Get-PnPList: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Get-PnPList
New-PnPList
Set-PnPList
New-PnPList -Title "Curriculum"  -Template DocumentLibrary -OnQuickLaunch
New-PnPList -Title "Assessments" -Template DocumentLibrary -OnQuickLaunch
Get-PnPList | Select Title, Id
Get-PnPList -Identity Curriculum  | Select Title, ContentTypesEnabled
Get-PnPList -Identity Assessments | Select Title, ContentTypesEnabled
Set-PnPList -Identity "Curriculum"  -ContentTypesEnabled $true
Set-PnPList -Identity "Assessments" -ContentTypesEnabled $true
```

## PnP ContentTypes
```powershell
Add-PnPContentType:
Add-PnPContentTypeToList -List "Curriculum"  -ContentType "IE Unit"
Add-PnPContentTypeToList: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Add-PnPContentTypeToList -List "Curriculum"  -ContentType "Document"     # keep basic doc too
Add-PnPContentTypeToList -List "Assessments" -ContentType "IE Assessment"
Add-PnPContentTypeToList -List "Assessments" -ContentType "Document"
Add-PnPContentTypeToList -List "Curriculum"  -ContentType "Document"
Add-PnPContentTypeToList -List "Curriculum"  -ContentType $ctUnit
Add-PnPContentTypeToList: List 'Curriculum' does not exist at site with URL 'https://netorgft18192557.sharepoint.com/sites/ed-pe'.
Add-PnPContentTypeToList -List "Curriculum"  -ContentType $ctDoc
Add-PnPContentTypeToList -List "Assessments" -ContentType $ctAssess
Add-PnPContentTypeToList: List 'Assessments' does not exist at site with URL 'https://netorgft18192557.sharepoint.com/sites/ed-pe'.
Add-PnPContentTypeToList -List "Assessments" -ContentType $ctDoc
Add-PnPContentType -Name "IE Unit"       -Group "InsightEdu Content Types" -ParentContentType $docSet | Out-Null
Add-PnPContentType: A duplicate content type "IE Unit" was found.
Add-PnPContentType -Name "IE Assessment" -Group "InsightEdu Content Types" -ParentContentType $docSet | Out-Null
Add-PnPContentType: A duplicate content type "IE Assessment" was found.
Set-PnPContentType -Identity "IE Unit"       -Name "IE Unit (old)"
Set-PnPContentType -Identity "IE Assessment" -Name "IE Assessment (old)"
Add-PnPContentTypeToList: A duplicate content type "IE Unit" was found.
Add-PnPContentTypeToList: A duplicate content type "IE Assessment" was found.
Set-PnPContentType: Content type 'IE Assessment' not found in site.
Add-PnPContentTypeToList -List "Curriculum"  -ContentType $ctDoc    # keep basic docs too (optional)
Add-PnPContentTypeToList -List "Assessments" -ContentType $ctDoc    # optional
```

## PnP Fields
```powershell
Add-PnPField -List $L -DisplayName "Standard Ref"  -InternalName "StandardRef"  -Type Text -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Evidence Link" -InternalName "EvidenceLink" -Type Text -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "RAG Status"    -InternalName "RAGStatus"    -Type Choice -Choices @("Red","Amber","Green") -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Notes"         -InternalName "Notes"        -Type Note -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Review Due"    -InternalName "ReviewDue"    -Type DateTime -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Phase"          -InternalName "Phase"          -Type Text -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Owner"          -InternalName "Owner"          -Type Text -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Start DateTime" -InternalName "StartDateTime"  -Type DateTime -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "End DateTime"   -InternalName "EndDateTime"    -Type DateTime -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $L -DisplayName "Description"    -InternalName "Description"    -Type Note -ErrorAction SilentlyContinue
Add-PnPField -DisplayName "IE Owner"          -InternalName "IEOwner"          -Type User     -Group $colGroup
Add-PnPField -DisplayName "IE Start DateTime" -InternalName "IEStartDateTime"  -Type DateTime -Group $colGroup
Add-PnPField -DisplayName "IE End DateTime"   -InternalName "IEEndDateTime"    -Type DateTime -Group $colGroup
Add-PnPField -DisplayName "IE Description"    -InternalName "IEDescription"    -Type Note     -Group $colGroup
Add-PnPFieldToList -List "WAAG" -Field "IEDepartment"
Add-PnPFieldToList: The term 'Add-PnPFieldToList' is not recognized as a name of a cmdlet, function, script file, or executable program.
Add-PnPFieldToList -List "WAAG" -Field "IEPhase"
Add-PnPFieldToList -List "WAAG" -Field "IEKeyStage"
Add-PnPFieldToList -List "WAAG" -Field "IEYearGroup"
Add-PnPFieldToList -List "WAAG" -Field "IEOwner"
Add-PnPFieldToList -List "WAAG" -Field "IEStartDateTime"
Add-PnPFieldToList -List "WAAG" -Field "IEEndDateTime"
Add-PnPFieldToList -List "WAAG" -Field "IEDescription"
Add-PnPField -List "WAAG" -DisplayName "IE Owner"          -InternalName "IEOwner"         -Type User     -AddToDefaultView
Add-PnPField -List "WAAG" -DisplayName "IE Start DateTime" -InternalName "IEStartDateTime" -Type DateTime -AddToDefaultView
Add-PnPField -List "WAAG" -DisplayName "IE End DateTime"   -InternalName "IEEndDateTime"   -Type DateTime -AddToDefaultView
Add-PnPField -List "WAAG" -DisplayName "IE Description"    -InternalName "IEDescription"   -Type Note     -AddToDefaultView
Add-PnPField:
Add-PnPFieldToContentType -Field "IEUnitTitle" -ContentType "IE Unit"
Add-PnPFieldToContentType: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Add-PnPFieldToContentType -Field "IEUnitCode"  -ContentType "IE Unit"
Add-PnPFieldToContentType -Field "IESubject"   -ContentType "IE Unit"
Add-PnPFieldToContentType -Field "IEKeyStage"  -ContentType "IE Unit"
Add-PnPFieldToContentType -Field "IEYearGroup" -ContentType "IE Unit"
Add-PnPFieldToContentType -Field "Term"        -ContentType "IE Unit"
Add-PnPFieldToContentType -Field "Qualification" -ContentType "IE Unit"
Add-PnPFieldToContentType -Field "ExamBoard"     -ContentType "IE Unit"
Set-PnPField -Identity "IEAssessmentType" -Values @{ Choices = @("Formative","Summative","Mock","Practical") } | Out-Null
Set-PnPField: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Add-PnPFieldToContentType -Field "IEAssessmentTitle" -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "IEAssessmentType"  -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "IESubject"         -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "IEKeyStage"        -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "IEYearGroup"       -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "Qualification"     -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "ExamBoard"         -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "IEWindowStart"     -ContentType "IE Assessment"
Add-PnPFieldToContentType -Field "IEWindowEnd"       -ContentType "IE Assessment"
Set-PnPField -Identity "IEAssessmentType" -Values @{Choices=@("Formative","Summative","Mock","Practical")} | Out-Null
```

## Other
```powershell
Register-PnPManagementShellAccess -Tenant "insightedu.onmicrosoft.com"
Register-PnPManagementShellAccess: Specified method is not supported.
Add-PnPHubSiteAssociation -Site $clientUrl -HubSite $hubUrl
Add-PnPHubSiteAssociation: The passed configuration 'https://System.Management.Automation.Internal.Host.InternalHost.sharepoint.com/sites/InsightEdu' does not exist
Get-PnPWeb | Select Title, Url
Get-PnPField -List $L | Where-Object {$_.InternalName -in @("StandardRef","EvidenceLink","RAGStatus","Notes","ReviewDue")} |
Set-PnPView -List $L -Identity "All Items" -Values @{ CustomFormatter = $fmt }
Get-PnPView -List $L -Identity "All Items" | Select Title, CustomFormatter | Format-List
Get-PnPField -List $L | Where-Object {$_.InternalName -in @("Phase","Owner","StartDateTime","EndDateTime","Description")} |
New-PnPTerm:
Get-PnPTerm -TermSet $tsName -TermGroup $groupName | Select Name
Get-PnPTerm -TermSet $ts.Id -TermGroup $grp.Id | Select Name
Get-PnPTerm -TermSet $dept.Id -TermGroup $grp.Id | Select -First 12 Name
Get-PnPTermStore: The term 'Get-PnPTermStore' is not recognized as a name of a cmdlet, function, script file, or executable program.
New-PnPTermSet: Cannot bind parameter 'Lcid' to the target. Exception setting "Lcid": "Cannot convert null to type "System.Int32"."
Get-PnPTerm:
Get-PnPTerm: Cannot bind argument to parameter 'TermSet' because it is null.
New-PnPTermSet:
Get-PnPTermSet:
Add-PnPTaxonomyField -List "WAAG" `
Add-PnPTaxonomyField:
Get-PnPField -List "WAAG" -Identity "Phase" | Select Title, InternalName, TypeAsString
Get-PnPField: List 'WAAG' does not exist at site with URL 'https://netorgft18192557-admin.sharepoint.com'.
Get-PnPField -List "WAAG" -Identity "Department" | Select Title, InternalName, TypeAsString
Add-PnPTaxonomyField `
Get-PnPField -Identity "IEPhase" | Select Title, InternalName, Group, TypeAsString
Get-PnPField -Identity "IEDepartment" | Select Title, InternalName, Group, TypeAsString
Get-PnPField -Identity IEOwner, IEStartDateTime, IEEndDateTime, IEDescription |
Get-PnPField: Cannot convert 'System.Object[]' to the type 'PnP.PowerShell.Commands.Base.PipeBinds.FieldPipeBind' required by parameter 'Identity'. Specified method is not supported.
Get-PnPTerm: Specified argument was out of the range of valid values.
Add-IEPnPTermQuiet -TermSetId $yg.Id -GroupId $grp.Id -Name "Year 12"
Add-IEPnPTermQuiet -TermSetId $yg.Id -GroupId $grp.Id -Name "Year 13"
Set-PnPView -List "WAAG" -Identity "All Items" -Values @{ CustomFormatter = $waagFmt }
Add-PnPTaxonomyField -List "WAAG" -DisplayName "IE Phase"       -InternalName "IEPhase"       -TermSetPath "InsightEdu.Core|Phase"        -MultiValue:$false -AddToDefaultView
Add-PnPTaxonomyField -List "WAAG" -DisplayName "IE Department"  -InternalName "IEDepartment"  -TermSetPath "InsightEdu.Core|Department"   -MultiValue:$false -AddToDefaultView
Add-PnPTaxonomyField -List "WAAG" -DisplayName "IE Key Stage"   -InternalName "IEKeyStage"    -TermSetPath "InsightEdu.Core|Key Stage"    -MultiValue:$false -AddToDefaultView
Add-PnPTaxonomyField -List "WAAG" -DisplayName "IE Year Group"  -InternalName "IEYearGroup"   -TermSetPath "InsightEdu.Core|Year Group"   -MultiValue:$false -AddToDefaultView
Set-PnPView: Name cannot begin with the '=' character, hexadecimal value 0x3D. Line 3, position 48.
Get-PnPView -List "WAAG" -Identity "All Items" | Select Title, CustomFormatter | Format-List
Set-PnPView -List "WAAG" -Identity "All Items" -Values @{ CustomFormatter = $json }
Set-PnPView: Name cannot begin with the '=' character, hexadecimal value 0x3D. Line 3, position 54.
Get-PnPView -List "WAAG" -Identity "All Items" | Select -ExpandProperty CustomFormatter
Set-PnPView: Name cannot begin with the '=' character, hexadecimal value 0x3D. Line 2, position 55.
Set-PnPView -List "WAAG" -Identity "All Items" -Values @{ CustomFormatter = [string]$waagFmt }
Set-PnPView -List "WAAG" -Identity "All Items" -Values @{ CustomFormatter = @'
Set-PnPView -List "WAAG" -Identity "All Items" -Fields `
Set-PnPView -List "WAAG" -Identity "All Items" -Values @{
Get-PnPContentType: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Set-PnPDefaultContentTypeToList -List "Curriculum"  -ContentType "IE Unit"
Set-PnPDefaultContentTypeToList: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Set-PnPDefaultContentTypeToList -List "Assessments" -ContentType "IE Assessment"
Set-PnPView -List "Curriculum" -Identity "All Documents" -Fields `
Set-PnPView: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Set-PnPView -List "Assessments" -Identity "All Documents" -Fields `
Set-PnPView -List "Curriculum" -Identity "All Documents" -Values @{
Set-PnPView -List "Assessments" -Identity "All Documents" -Values @{
Set-DefaultCT -List "Curriculum"  -ctName "IE Unit"
Get-PnPContentType:
Set-DefaultCT -List "Assessments" -ctName "IE Assessment"
Get-PnPContentType -List "Curriculum"  | Select Name
Get-PnPContentType -List "Assessments" | Select Name
Get-PnPWeb: Unexpected response from the server. The content type of the response is "text/plain; charset=utf-8". The status code is "NotFound".
Get-PnPTenantSite -IncludeOneDriveSites:$false | Where-Object Url -match "/sites/ed-pe"
Get-PnPContentType: Content type '0x0120D520' not found in site.
Set-PnPView -List "Curriculum"  -Identity "All Documents" -Fields `
Set-PnPView: List 'Curriculum' does not exist at site with URL 'https://netorgft18192557.sharepoint.com/sites/ed-pe'.
Set-PnPView: List 'Assessments' does not exist at site with URL 'https://netorgft18192557.sharepoint.com/sites/ed-pe'.
Set-PnPView -List "Curriculum"  -Identity "All Documents" -Values @{ ViewQuery = "<OrderBy><FieldRef Name='IEYearGroup'/><FieldRef Name='IEKeyStage'/><FieldRef Name='IEUnitTitle'/></OrderBy>" }
Set-PnPView -List "Assessments" -Identity "All Documents" -Values @{ ViewQuery = "<OrderBy><FieldRef Name='IEWindowStart' Ascending='TRUE' /></OrderBy>" }
Get-PnPContentType: List 'Curriculum' does not exist at site with URL 'https://netorgft18192557.sharepoint.com/sites/ed-pe'.
Get-PnPContentType: List 'Assessments' does not exist at site with URL 'https://netorgft18192557.sharepoint.com/sites/ed-pe'.
Get-Command -Module PnP.PowerShell *-PnPList | Select Name
Get-PnPContentType | ? Name -match '^IE ' | Select Name, Id
Get-PnPField -Identity IEUnitTitle, IEUnitCode, IEAssessmentTitle, IEAssessmentType, IEWindowStart, IEWindowEnd `
Get-PnPField | Where-Object { $docsetFields -contains $_.InternalName } |
Set-PnPView -List "Curriculum"  -Identity "All Documents" -Values @{
Add-PnPDocumentSet -List "Curriculum"  -ContentType "IE Unit"        -Name "Y7 Forces"
Add-PnPDocumentSet: Content type 'IE Unit' does not inherit from the base Document Set content type. Document Set content type IDs start with 0x120D520
Add-PnPDocumentSet -List "Assessments" -ContentType "IE Assessment"  -Name "Y7 Forces – Autumn Mock"
Add-PnPDocumentSet: Content type 'IE Assessment' does not inherit from the base Document Set content type. Document Set content type IDs start with 0x120D520
Add-PnPDocumentSet -List "Curriculum"  -ContentType "IE Unit"       -Name "Y7 Forces"
Add-PnPDocumentSet -List "Assessments" -ContentType "IE Assessment" -Name "Y7 Forces – Autumn Mock"
Get-PnPContentType | ? Name -match '^IE ' | Select Name, Id, Group, Sealed, ReadOnly, Hidden
Get-PnPContentType | ? Name -match '^IE ' | Select Name,Id,Group | Sort Name
Get-PnPContentType | ? Name -in @('IE Unit','IE Assessment') | Select Name,Id
Set-PnPDefaultContentTypeToList -List "Curriculum"  -ContentType $ctUnit
Set-PnPDefaultContentTypeToList: Object reference not set to an instance of an object on server. The object is associated with method GetById.
Set-PnPDefaultContentTypeToList -List "Assessments" -ContentType $ctAssess
Get-ConsoleAsText | Out-File -FilePath C:\Temp\current_console.txt
Set-Location: Cannot find path 'C:\temp' because it does not exist.
Set-PnPDefaultContentTypeToList -List "Curriculum"  -ContentType $ctUnitList.Id
Set-PnPDefaultContentTypeToList -List "Assessments" -ContentType $ctAssessList.Id
Get-PnPContentType -List "Curriculum"  | Select Name,Id
Get-PnPContentType -List "Assessments" | Select Name,Id
Get-ConsoleBufferAsText | Out-File -FilePath C:\Temp\full_console_buffer.txt
```
