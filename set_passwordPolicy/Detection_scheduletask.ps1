# Define the name of the scheduled task to check
$taskName = "WaveBLWeeklyPasswordPolicyUpdate"

# Check if the scheduled task exists
$taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }

# Output the result
if ($taskExists) {
    Write-Output "Scheduled task '$taskName' exists."
    exit 0 # Success code
} else {
    Write-Output "Scheduled task '$taskName' does not exist."
    exit 1 # Error code
}