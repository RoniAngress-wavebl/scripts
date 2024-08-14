$apps = Get-Content "C:\scripts\install_apps\apps.txt"
foreach ($app in $apps) {
    winget install --id $app
}