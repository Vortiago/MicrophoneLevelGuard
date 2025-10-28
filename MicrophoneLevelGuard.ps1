[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$false)]
    [ValidateRange(0,100)]
    [int]$DefaultVolume = -1,
    [int]$Interval = 500,

    [Parameter(Mandatory=$false)]
    [switch]$Help
)

# Show help text if -Help is specified
if ($Help) {
    Write-Output @"
MicrophoneLevelGuard Script
--------------------------

This script guards and maintains your microphone's volume at a specified level.

Usage:
    .\MicrophoneLevelGuard.ps1 [-DefaultVolume <0-100>] [-Help] [-Verbose] [-WhatIf]

Parameters:
    -DefaultVolume <0-100>
        Sets the target volume level (0-100%). If not specified, uses current volume.

    -Interval <ms>
        Sets the loop interval in miliseconds
    
    -Help
        Shows this help message.
    
    -Verbose
        Shows detailed progress messages.
    
    -WhatIf
        Shows what would happen without making changes.

Examples:
    .\monitor-mic-volume.ps1
    .\MicrophoneLevelGuard.ps1
        Guards and maintains current volume level
    
    .\MicrophoneLevelGuard.ps1 -DefaultVolume 75
        Guards and maintains volume at 75%
    
    .\MicrophoneLevelGuard.ps1 -DefaultVolume 50 -Verbose
        Guards volume with detailed logging
"@
    exit 0
}

# Function to get the current default input device volume
function Get-MicrophoneVolume {
    try {
        $volume = Get-AudioDevice -RecordingVolume
        if ($volume -match '(\d+)%') {
            return [int]$Matches[1]
        }
        return $null
    }
    catch {
        Write-Error "Error getting default input device volume: $_"
        return $null
    }
}

# Function to set the default input device volume
function Set-MicrophoneVolume {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(0,100)]
        [int]$Volume
    )
    try {
        if ($PSCmdlet.ShouldProcess("Default Microphone", "Set volume to $Volume%")) {
            Set-AudioDevice -RecordingVolume $Volume
        }
    }
    catch {
        Write-Error "Error setting default input device volume: $_"
    }
}

# First, ensure we have the required module
if (-not (Get-Module -ListAvailable -Name AudioDeviceCmdlets)) {
    Write-Verbose "Installing required AudioDeviceCmdlets module..."
    Install-Module -Name AudioDeviceCmdlets -Force -Scope CurrentUser
}

Import-Module AudioDeviceCmdlets

# List all input devices and show default
Write-Output "`nAvailable Input Devices:"
Write-Output "------------------------"
$inputDevices = Get-AudioDevice -List | Where-Object Type -eq "Recording"
foreach ($device in $inputDevices) {
    $prefix = if ($device.Default) { "* " } else { "  " }
    Write-Output "$prefix$($device.Name) ($($device.ID))"
}
Write-Output "`n* indicates default device`n"

# If no default volume specified, use current device volume
if ($DefaultVolume -eq -1) {
    $DefaultVolume = Get-MicrophoneVolume
    if ($null -eq $DefaultVolume) {
        Write-Error "Could not detect microphone volume"
        exit 1
    }
}

Write-Output "Starting microphone volume monitor. Default volume: $DefaultVolume%"
Write-Output "Press Ctrl+C to stop monitoring"

# Main monitoring loop
while ($true) {
    $currentVolume = Get-MicrophoneVolume

    if ($null -ne $currentVolume -and $currentVolume -ne $DefaultVolume) {
        Write-Verbose "Volume changed to $currentVolume%. Resetting to $DefaultVolume%..."
        Set-MicrophoneVolume -Volume $DefaultVolume
    }

    Start-Sleep -Milliseconds $Interval
}
