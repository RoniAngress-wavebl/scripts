# Unenroll from Intune
Start-Process -FilePath "C:\Windows\System32\DeviceCensus.exe" -ArgumentList "/UnenrollDevice" -NoNewWindow -Wait
# Re-enroll device using the Autopilot Reset method (if device is pre-registered with Autopilot)
Start-Process -FilePath "C:\Windows\System32\sysprep\sysprep.exe" -ArgumentList "/oobe /reboot"
