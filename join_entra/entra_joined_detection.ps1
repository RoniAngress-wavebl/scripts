# Variables
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$localPath = Join-Path $scriptDirectory "entra_join.ppkg"

# Check if the provisioning success file exists
if (Test-Path $localPath) {
    Write-Host "Success file found at $localPath."
    exit 0

} else {
    Write-Host "Success file not found. Provisioning may not have been applied."
    exit 1
}
