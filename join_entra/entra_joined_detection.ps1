# Variables
$successFilePath = "$env:ProgramData\provisioning_success.txt"

# Check if the provisioning success file exists
if (Test-Path $successFilePath) {
    Write-Host "Success file found at $successFilePath."

} else {
    Write-Host "Success file not found. Provisioning may not have been applied."
    exit 1
}
