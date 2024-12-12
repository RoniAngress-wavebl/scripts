# Set TLS version to 1.2 for secure connections
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Set the execution policy for the process to RemoteSigned without a prompt
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force

# Install the Get-WindowsAutopilotInfo script, forcing any prompts to be accepted
Install-Script -Name Get-WindowsAutopilotInfo -Force -Confirm:$false

# Run the Get-WindowsAutopilotInfo command with the -Online parameter
Get-WindowsAutopilotInfo -Online
