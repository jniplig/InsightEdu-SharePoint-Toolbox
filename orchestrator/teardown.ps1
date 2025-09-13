param([ValidateSet('Dev','Test')]$Environment = 'Dev')
. "$PSScriptRoot/bootstrap.ps1" -Environment $Environment
Write-Warning "Danger zone. This script is intended for Dev/Test cleanup only."
# TODO: Enumerate sites with prefix and remove as needed
