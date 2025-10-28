# MicrophoneLevelGuard

A PowerShell script that guards and maintains your microphone's volume at a specified level. This is useful when certain applications or system events unexpectedly change your microphone volume.

## Features

- Automatically restores volume to desired level when changes are detected
- Includes WhatIf support for testing

## Requirements

- Windows PowerShell or PowerShell Core
- AudioDeviceCmdlets PowerShell module (automatically installed if missing)

## Installation

1. Clone this repository or download the script:

```powershell
git clone https://github.com/Vortiago/MicrophoneLevelGuard.git
```

1. Navigate to the script directory:

```powershell
cd MicrophoneLevelGuard
```

## Usage

Run the script with default settings (maintains current volume level):

```powershell
.\MicrophoneLevelGuard.ps1
```

Set a specific volume level (e.g., 75%):

```powershell
.\MicrophoneLevelGuard.ps1 -DefaultVolume 75
```

Set interval delay (e.g., 1000ms):
```powershell
.\MicrophoneLevelGuard.ps1 -Interval 1000
```

Show detailed progress with verbose logging:

```powershell
.\MicrophoneLevelGuard.ps1 -DefaultVolume 50 -Verbose
```

Preview changes without applying them:

```powershell
.\MicrophoneLevelGuard.ps1 -DefaultVolume 80 -WhatIf
```

View help and usage information:

```powershell
.\MicrophoneLevelGuard.ps1 -Help
```

## Parameters

- `-DefaultVolume <0-100>`: Sets the target volume level (0-100%). If not specified, uses current volume.
- `-Interval <ms>`: Sets the loop interval in miliseconds. Default to 500ms
- `-Help`: Shows the help message with usage instructions.
- `-Verbose`: Shows detailed progress messages.
- `-WhatIf`: Shows what changes would be made without actually making them.

## How It Works

The script runs in a continuous loop, checking the microphone volume every 500 milliseconds (or specified by the user). If it detects that the volume has changed from the specified level, it automatically restores it to the desired value.

When started, it displays a list of all available input devices, highlighting the current default device. The script will continue running until interrupted with Ctrl+C.

## Troubleshooting

If you encounter permission issues, try running PowerShell as Administrator.

Common issues:

1. "Module not found" - The script will attempt to install the required module automatically
1. "Access denied" - Run PowerShell with administrative privileges
1. "No microphone detected" - Ensure your microphone is properly connected and recognized by Windows

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
