#Requires -Module posh-git

# Set misc variables
Set-StrictMode -Version latest

# Set default encoding to UTF-8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# Setup posh-git
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '`n'
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# This function allows me to switch locations and environments with a
# prefaced 'workon' command. This is similar to Linux and python virtualenv
function workon {
    param(
        [Parameter(
            Mandatory = $True,
            Position = 0,
            HelpMessage = "Enter the project name or 'help' for list of projects.")]
        [envs]$env_name
    )

    # Convert param to string to use as dict key
    $project = ($env_name.ToString())

    if ($project -eq 'help') {
        # Display help text
        Write-Host ("{0,-15}{1}" -f "`nProject Name", "Code run")
        Write-Host ("{0,-15}{1}" -f "============", "========")
        $env_dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host ("{0,-15}{1}" -f $_.key, $_.value)
        }
    } elseif ($project -eq 'all') {
        # Update all projects
        $env_dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Workon $_.key
            if (Test-Path "./.git") {
                # Test if git directory is preset.
                $currentBranch = git rev-parse --abbrev-ref HEAD
                if ($_.key -in ("IPTools", "DevOps")) {
                    $defaultBranch = "master"
                } else {
                    $defaultBranch = "main"
                }

                Write-Host "`r`nUpdating $($_.key)"
                Write-Host "Default Branch => $defaultBranch"
                Write-Host "Current Branch => $currentBranch"
                Write-Host "========================="
                git fetch --all --prune
                git checkout $defaultBranch
                git pull
                git push
                if ($defaultBranch -ne $currentBranch) {
                    git checkout $currentBranch
                }
            }
        }

        # Reset everything back to normal
        Set-Location ~
        if (Test-Path function:deactivate) { deactivate }
    } else {
        # Run command associated with key
        Try {
            Invoke-Expression ($env_dict.$project) -ErrorAction stop
            return
        } Catch {
            # Error out on invalid command
            Write-Host "Not a valid command for workon"
        }
    }
}

function New-PythonEnv {
    <# Updates newly created Python virtual environment #>
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = "Enter the path of the Python environment")]
        [string]$envPath
    )
    # deactivate any active virtual env
    if (Test-Path function:deactivate) {
        deactivate
    }

    # Create new Virtual Environment
    Write-Host "Creating new virtual environment: $envPath"
    python -m venv $envPath

    # Replace default activate script for Python venv with personal script.
    Write-Host "Replacing Activate.ps1 file"
    $localActivate = Join-Path $envPath "Scripts\Activate.ps1" -Resolve
    $sourceActivate = Resolve-Path "~\Programming\powershell\environment\python\activate.ps1"
    Rename-Item -Path $localActivate -NewName "$localActivate.old"
    Copy-Item -Path $sourceActivate -Destination $localActivate

    # Activate new venv and update python install tools
    Write-Host "Activating virtual environment & updating Pip, SetupTools, & Wheel"
    & $localActivate
    python -m pip install --upgrade pip setuptools wheel
}

function Update-PythonEnv {
    <# Updates newly created Python virtual environment #>
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = "Enter the path of the Python environment")]
        [string]$envPath
    )
    # deactivate any active virtual env
    if (Test-Path function:deactivate) {
        deactivate
    }

    # Getting full path to envPath
    $fullPath = Resolve-Path $envPath -ErrorAction Stop

    # Updating Virtual Env
    Write-Host "Updating Python Environment: $fullPath"
    python -m venv $fullPath --upgrade
}

# Build dict containing list of all programming projects. All are located in
# ~/Programming folder. Any folders that exist outside of this folder can be
# symbolically linked back to this folder.
$env_dict = @{}
foreach ($fold in Get-ChildItem "~/Programming") {
    # Filter out folders with spaces in the name as they will break the enum
    if ($fold.Name -match " ") {
        Write-Warning """$($fold.Name)"" not included in workon due to space in name."
        continue
    }

    if (Test-Path (Join-Path $fold.FullName ".venv")) {
        $script = "& ""$(Join-Path $fold.FullName ".venv\Scripts\activate.ps1")"""
    } else {
        $script = "if (test-path function:deactivate) {deactivate};"
    }

    $env_dict[$fold.Name] = "
        Set-Location ""$($fold.FullName)""
        $script
    "
}

$env_list = $env_dict.keys
$env_list += "help"
$env_list += "all"

# Build env_string as Here-String with 'help' + all dict keys from env_dict
$env_string = @"
    Enum envs {
        $(ForEach($item in ($env_list)){"`t$item`n"})
    }
"@

# Invoke env_string to create Enum envs and cleanup vars
Invoke-Expression $env_string
Remove-Variable env_string
Remove-Variable env_list
