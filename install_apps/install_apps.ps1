$apps = Get-Content "$PSScriptRoot\apps.txt"
foreach ($app in $apps) {
    winget install --id $app
}
