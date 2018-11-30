<#  Define functions for Powershell #>

# This function allows me to switch locations and environments with a
# prefaced 'workon' command. This is similar to Linux and python virtualenv
function workon {
    param(
        [Parameter(
            Mandatory=$True,
            Position=0,
            HelpMessage="Enter the project name or 'help' for list of projects.")]
        [envs]$env_name
    )

    # Convert param to string to use as dict key
    $project = ($env_name.ToString())

    if ($project -eq 'help') {  # Display help text
        Show-help $env_dict
    } elseif ($project -eq 'all') {  # Update all projects
        Update-All $env_dict
    } else {  # Run command associated with key
        Try {
            invoke-expression ($env_dict.$project) -ErrorAction stop
            return
        } Catch {  # Error out on invalid command
            Write-Host "Not a valid command for workon"
        }
    }
}

function Show-Help($envs) {
    Write-Host ("{0,-15}{1}" -f "`nProject Name", "Code run")
    Write-Host ("{0,-15}{1}" -f "============", "========")
    $envs.GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host ("{0,-15}{1}" -f $_.key, $_.value)
    }
}

function Update-All ($envs) {
    $envs.GetEnumerator() | Sort-Object Name | ForEach-Object {
        Workon $_.key
        Write-Host "`r`nUpdating $($_.key)"
        Write-Host "Branch => $(git rev-parse --abbrev-ref HEAD)"
        Write-Host "========================="
        git fetch --all --prune
        git checkout master
        git pull
        git push
    }

    # Reset everything back to normal
    Set-Location ~
    if(test-path function:deactivate) {deactivate}
}

function Get-Out {
    # This script is a quick way to remove personal data from my computer
    # It only removes personal data and doesn't affect work data in any way.

    <#  Below is an old Dos command which deletes a folder and all contents
        rd = Remove directory, /s = recurse, /q = quiet

        I am using this because the -Recurse flag on Remove-Item is broken
        and frequently generates errors.
    #>

    # Remove personal programming folder.
    Write-Host "`n`rDeleting Programming..."
    &cmd.exe /c rd /s /q "C:\Users\Patrick\Documents\programming"
    Write-Host "Process Complete: Delete programming folder"

    # Delete main AHK launching file.
    Write-Host "`n`rDeleting Main AHK file..."
    Remove-Item "C:\Users\Patrick\Documents\Autohotkey.ahk" -Force
    Write-Host "Process Complete: Delete Main AHK file"
}

Function Get-PowerShellRelease {
    <# Pulled from: http://www.virtu-al.net/2017/03/27/powershell-core-date/

    Look into this https://github.com/jdhitsolutions/PSReleaseTools as a
    way to download and install new versions.
    #>

    if ($PSVersionTable.PSVersion.Major -le 5) {
        return
    }
    #Using this to get rid of the nasty output Invoke-WebRequest gives you in PowerShell on the Mac
    $progress = $ProgressPreference
    $ProgressPreference = "SilentlyContinue"
    $JSON = Invoke-WebRequest "https://api.github.com/repos/powershell/powershell/releases/latest" | ConvertFrom-Json
    If ($PSVersionTable.GitCommitId) {
        If ($JSON.tag_name -ne "v$($PSVersionTable.GitCommitId)") {
            Write-Output "New version of PowerShell available!"
            $JSON.body
        } Else {
            "PowerShell is currently up to date!"
        }
    }
    $ProgressPreference = $progress
}

<# Commands to run before every session. #>

# Get rid of annoying beeping on backspace
Import-Module -Name PSReadLine
Set-PSReadLineOption -BellStyle None

# Posh Git Settings:
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '`n'
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# Set default encoding to UTF-8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# Set aliases
Set-Alias -Name Which -Value Get-Command

# Import systemVariables file (includes var: [hashtable]env_dict)
. $(Join-Path ($profile.currentUserAllHosts | Split-Path -Parent) "envs.ps1")

# Build list of envs. Add "help" and "all" commands
$env_list = $env_dict.keys
$env_list += "help"
$env_list += "all"

# Build env_string as Here-String with 'help' + all dict keys from env_dict
$env_string = @"
Enum envs {
$(ForEach($item in ($env_list| Sort-Object)){"`t$item`n"})
}
"@

# Invoke env_string to create Enum envs and cleanup vars
Invoke-Expression $env_string
Remove-Variable env_string
Remove-Variable env_list

Get-PowerShellRelease
