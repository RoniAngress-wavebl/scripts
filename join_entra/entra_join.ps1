# Variables
$ppkgUrl = "https://wavebl-my.sharepoint.com/:u:/g/personal/roni_angress_wavebl_onmicrosoft_com/Ed6T-2mzwapBsGJoxmM1784Bg0EtfrZl-deFW6m5ZwVS7Q?e=boVFkH"
$localPath = "$env:ProgramData\entra_join.ppkg"
$successFilePath = "$env:ProgramData\provisioning_success.txt"

try {
    # Download the .ppkg file
    Write-Host "Downloading provisioning package..."
    Invoke-WebRequest -Uri $ppkgUrl -OutFile $localPath

    # Verify file download
    if (Test-Path $localPath) {
        Write-Host "Provisioning package downloaded successfully to $localPath."

        # Apply the provisioning package
        Write-Host "Applying provisioning package..."
        Add-ProvisioningPackage -PackagePath $localPath -ForceInstall -QuietInstall

        # If successful, create a success file
        Write-Host "Provisioning package applied successfully."
        Set-Content -Path $successFilePath -Value "Provisioning package applied successfully on $(Get-Date)."
    } else {
        Write-Host "Failed to download the provisioning package."
        exit 1
    }
} catch {
    Write-Host "An error occurred: $_"
}
