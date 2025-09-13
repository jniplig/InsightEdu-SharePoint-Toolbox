param([ValidateSet('Dev','Test','Prod')]$Environment = 'Dev')
. "$PSScriptRoot/bootstrap.ps1" -Environment $Environment
Write-Host "Applying idempotent updates (fields/CTs/templates)..." -ForegroundColor Cyan
# TODO: Add Add-PnPField/Add-PnPContentType reapply, Apply-PnPProvisioningTemplate calls
