# Example Astrophotography Startup

A barebones example of starting PHD2 and NINA for astrophotography automation.

## Overview

This example demonstrates the minimal setup required to:
1. Start PHD2 (guiding software) and connect equipment
2. Start NINA (Nighttime Imaging 'N' Astronomy) with a sequence file

The scripts in this folder are simplified versions of a production setup. 

## Prerequisites

- **Python 3.14** (or compatible version)
- **PHD2** installed (default path: `C:\Program Files (x86)\PHDGuiding2\phd2.exe`)
- **NINA** installed (default path: `C:\Program Files\N.I.N.A. - Nighttime Imaging 'N' Astronomy\NINA.exe`)
- **Python dependencies**:
  - `phd2client` - Install with: `pip install phd2client`
  - `start-phd2.py` and `start-nina.py` scripts (in project root)

## Files

- **`ap-startup.bat`** - Main batch script that orchestrates PHD2 and NINA startup
- **`config.start-nina.json`** - Configuration file for NINA startup

## Configuration

### 1. Configure PHD2 Profile

Edit `ap-startup.bat` and set your PHD2 equipment profile:

```batch
@set "PHD2_PROFILE=C8E+2600+EQ6+DSO"
```

Replace with your actual PHD2 profile name.

### 2. Configure PHD2 Path (if needed)

If PHD2 is installed in a different location, update the path:

```batch
@set "PHD2_PATH=C:\Program Files (x86)\PHDGuiding2\phd2.exe"
```

### 3. Configure NINA

Edit `config.start-nina.json` and update:

- **Sequence file path**: Change the `-s` argument to point to your NINA sequence file
- **NINA executable path**: Update if NINA is installed elsewhere

Example configuration:

```json
{
  "skip_if_running": "NINA.exe",
  "programs": [
    {
      "path": "C:\\Program Files\\N.I.N.A. - Nighttime Imaging 'N' Astronomy\\NINA.exe",
      "args": ["-s", "C:\\Path-To-Your-Sequence\\DEFAULT.json", "-r"],
      "foreground": false
    }
  ]
}
```

**Configuration fields:**
- `skip_if_running`: Process name to check. If this process is already running, the script will skip starting all programs.
- `programs`: Array of programs to start in sequence
  - `path`: Full path to the executable
  - `args`: Command-line arguments (array of strings)
  - `foreground`: `true` to wait for completion, `false` to start in background

## Usage

1. Ensure Python scripts `start-phd2.py` and `start-nina.py` are available in your PATH or in the project root
2. Configure the files as described above
3. Run the batch file:

```batch
ap-startup.bat
```

## How It Works

1. **PHD2 Startup**: 
   - Checks if PHD2 is already running
   - Starts PHD2 if needed
   - Waits for PHD2 server to be ready (port 4400)
   - Connects equipment using the specified profile
   - Handles timeouts and already-connected scenarios gracefully

2. **Wait Period**: 5 second delay to allow PHD2 to stabilize

3. **NINA Startup**:
   - Checks if NINA is already running (skips if found)
   - Starts NINA with the configured sequence file
   - Runs in background (`foreground: false`)

## Error Handling

- If PHD2 startup fails, a warning is displayed but the script continues
- If PHD2 equipment connection times out (e.g., due to a blocking popup), the script continues anyway
- If NINA is already running, the startup is skipped entirely

## Notes

- PHD2 must be started **before** NINA, as NINA may depend on PHD2 being available
- The script uses `python3.14` - adjust if your Python executable has a different name
- All paths use Windows-style backslashes and must be properly escaped in JSON
