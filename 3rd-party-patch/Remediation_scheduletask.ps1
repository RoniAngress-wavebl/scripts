# Script Name: Remediation_scheduletask.ps1
# Description: This script checks if the scheduled task "wavebl-3rd-party-patch" exists,
# runs "winget upgrade --all" if it does, and creates the task if it doesn't.

# Define the name of the scheduled task to check
$taskName = "wavebl-3rd-party-patch"
$taskDescription = "Runs winget upgrade --all"
$taskAction = "winget upgrade --all --accept-source-agreements --accept-package-agreements"
$taskTrigger = New-ScheduledTaskTrigger -AtStartup

# Check if the scheduled task exists
$taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }

if ($taskExists) {
    Write-Output "Scheduled task '$taskName' exists. Running 'winget upgrade --all'."

    # Run winget upgrade --all
    winget upgrade --all --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Output "winget upgrade --all ran successfully."
        exit 0
    } else {
        Write-Error "Failed to run winget upgrade --all."
        exit 1
    }
} else {
    Write-Output "Scheduled task '$taskName' does not exist. Creating the scheduled task."

    # Create the scheduled task
    $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command $taskAction"
    Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $taskAction -Trigger $taskTrigger -User "SYSTEM" -RunLevel Highest

    if ($?) {
        Write-Output "Scheduled task '$taskName' created successfully. Running 'winget upgrade --all'."

        # Run winget upgrade --all
        winget upgrade --all --accept-source-agreements --accept-package-agreements
        if ($LASTEXITCODE -eq 0) {
            Write-Output "winget upgrade --all ran successfully."
            exit 0
        } else {
            Write-Error "Failed to run winget upgrade --all."
            exit 1
        }
    } else {
        Write-Error "Failed to create scheduled task '$taskName'."
        exit 1
    }
}
