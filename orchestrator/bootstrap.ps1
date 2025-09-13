param(
  [Parameter(Mandatory=$false)][ValidateSet('Dev','Test','Prod')]$Environment = 'Dev'
)

$ErrorActionPreference = 'Stop'

# Ensure modules
$modules = @('PnP.PowerShell','Microsoft.Graph')
foreach($m in $modules){
  if(-not (Get-Module -ListAvailable $m)){ Install-Module $m -Scope CurrentUser -Force }
}

# Load env config
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $root 'env.config.json'
if(-not (Test-Path $configPath)){
  Write-Warning "Missing env.config.json. Copy env.config.example.json and set values."
  $configPath = Join-Path $root 'env.config.example.json'
}
$cfg = Get-Content $configPath -Raw | ConvertFrom-Json
$envCfg = $cfg.$Environment

Write-Host "Connecting to: $($envCfg.AdminUrl) as $Environment" -ForegroundColor Cyan
Connect-PnPOnline -Url $envCfg.AdminUrl -Interactive

# Validate term store access
try {
  $null = Get-PnPTermGroup -ErrorAction Stop
} catch {
  Write-Warning "Term Store access not detected. Ensure TermStore permissions for your account/app."
}
