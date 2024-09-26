# Prompt the user to choose between Developers or Global installations
$choice = Read-Host "Choose installation type (1 = Developers, 2 = Global)"

# Set the appropriate file based on user choice
if ($choice -eq "1") {
    $appFile = "$PSScriptRoot\dev_apps.txt"
} elseif ($choice -eq "2") {
    $appFile = "$PSScriptRoot\global_apps.txt"
} else {
    Write-Host "Invalid choice." -ForegroundColor Red
    exit 1
}

# Read each line from the chosen file and install it using winget
$apps = Get-Content $appFile
foreach ($app in $apps) {
    winget install --id $app --accept-source-agreements --accept-package-agreements
}
