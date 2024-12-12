# Unenroll from Intune
Start-Process -FilePath "C:\Windows\System32\DeviceCensus.exe" -ArgumentList "/UnenrollDevice" -NoNewWindow -Wait
# Leave Azure AD Registered
Write-Output "Unregistering device from Azure AD..."
dsregcmd /leave
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Enrollments" -Recurse
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Provisioning" -Recurse


# Wait for the unenrollment to complete
Start-Sleep -Seconds 10

# Rejoin Azure AD
Write-Output "Joining device to Azure AD..."
$AzureADTenant = "wavebl.onmicrosoft.com"
Start-Process -FilePath "C:\Windows\System32\dsregcmd.exe" -ArgumentList "/join /tenant $AzureADTenant" -NoNewWindow -Wait -RedirectStandardOutput log.txt

# Confirm Azure AD Join Status
Write-Output "Checking Azure AD Join status..."
dsregcmd /status
