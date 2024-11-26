# # Variables
# $TaskName = "WaveBLWeeklyPasswordPolicyUpdate"
# $ScriptPath = "$PSScriptRoot\Set-PasswordPolicy.ps1"

# # Check if task exists
# $existingTask = Get-ScheduledTask | Where-Object {$_.TaskName -eq $TaskName}
# if (!$existingTask) {
#     # Create a scheduled task
#     $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$ScriptPath`""
#     $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 2:00PM
#     $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
#     Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Settings $Settings
#     Write-Host "Scheduled task created to run weekly."
# } else {
#     Write-Host "Scheduled task already exists."
# }

# try {
#     # Define password policy parameters
#     $minPasswordLength = 8
#     $maxPasswordAgeDays = 90
#     $minPasswordAgeDays = 1
#     $passwordHistorySize = 4
#     $lockoutBadCount = 5

#     Write-Host "Applying password policy..."

#     # Set password policy
#     net accounts /minpwlen:$minPasswordLength
#     net accounts /maxpwage:$maxPasswordAgeDays
#     net accounts /minpwage:$minPasswordAgeDays
#     net accounts /uniquepw:$passwordHistorySize

#     # Set account lockout policy
#     net accounts /lockoutthreshold:$lockoutBadCount

#     # Note: Lockout duration and reset time can be managed via Local Security Policy or Intune
#     Write-Host "Password policy applied successfully."
# } catch {
#     Write-Error "Failed to apply password policy. Error: $_"
# }

# Script Name: PasswordPolicy_ScheduleTask.ps1
# Description: This script checks if the scheduled task "WeeklyPasswordPolicyUpdate" exists,
# applies the password policy if it does, and creates the task if it doesn't.

# Define the password policy settings as variables
# Script Name: PasswordPolicy_ScheduleTask.ps1
# Description: This script checks if the scheduled task "WeeklyPasswordPolicyUpdate" exists,
# applies the password policy if it does, and creates the task if it doesn't.

# Define the password policy settings as variables
$MinPasswordLength = 8
$MaxPasswordAge = 90
$MinPasswordAge = 1
$UniquePasswordCount = 5
$LockoutThreshold = 5

# Define the name of the scheduled task
$taskName = "WaveBLWeeklyPasswordPolicyUpdate"
$taskDescription = "Ensures password policies are enforced weekly"

# Build the password policy action string
$taskActionValues = @(
    "net accounts /minpwlen:$MinPasswordLength",
    "net accounts /maxpwage:$MaxPasswordAge",
    "net accounts /minpwage:$MinPasswordAge",
    "net accounts /uniquepw:$UniquePasswordCount",
    "net accounts /lockoutthreshold:$LockoutThreshold"
)
$taskAction = $taskActionValues -join "; "

# Define the scheduled task trigger
$taskTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 2:00PM

# Check if the scheduled task exists
$taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }

if ($taskExists) {
    Write-Output "Scheduled task '$taskName' exists. Applying password policy."

    # Apply password policy
    Invoke-Expression $taskAction
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Password policy applied successfully."
        exit 0
    } else {
        Write-Error "Failed to apply password policy."
        exit 1
    }
} else {
    Write-Output "Scheduled task '$taskName' does not exist. Creating the scheduled task."

    # Create the scheduled task
    $taskActionCommand = $taskActionValues -join "; "
    $taskActionCommandEscaped = $taskActionCommand.Replace('"', '""') # Escape quotes
    $taskActionScript = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-Command `"$taskActionCommandEscaped`""
    
    Register-ScheduledTask -TaskName $taskName -Description $taskDescription -Action $taskActionScript -Trigger $taskTrigger -User "SYSTEM" -RunLevel Highest

    if ($?) {
        Write-Output "Scheduled task '$taskName' created successfully. Applying password policy."

        # Apply password policy
        Invoke-Expression $taskAction
        if ($LASTEXITCODE -eq 0) {
            Write-Output "Password policy applied successfully."
            exit 0
        } else {
            Write-Error "Failed to apply password policy."
            exit 1
        }
    } else {
        Write-Error "Failed to create scheduled task '$taskName'."
        exit 1
    }
}
