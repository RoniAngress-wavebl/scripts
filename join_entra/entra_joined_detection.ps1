# Variables
$successFilePath = "$env:ProgramData\provisioning_success.txt"

# Check if the provisioning success file exists
if (Test-Path $successFilePath) {
    Write-Host "Success file found at $successFilePath."

    # Optional: Validate content or timestamp
    $fileContent = Get-Content -Path $successFilePath
    if ($fileContent -match "Provisioning package applied successfully") {
        Write-Host "Success file content is valid. Provisioning was successful."
        exit 0
    } else {
        Write-Host "Success file content is invalid. Provisioning may have failed."
        exit 1
    }
} else {
    Write-Host "Success file not found. Provisioning may not have been applied."
    exit 1
}
