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
        Write-Host ("{0,-15}{1}" -f "`nProject Name", "Code run")
        Write-Host ("{0,-15}{1}" -f "============", "========")
        $env_dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host ("{0,-15}{1}" -f $_.key, $_.value)
        }
    } elseif ($project -eq 'all') {  # Update all projects
        $env_dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
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
        if(Test-Path function:deactivate) {deactivate}
    } else {  # Run command associated with key
        Try {
            invoke-expression ($env_dict.$project) -ErrorAction stop
            return
        } Catch {  # Error out on invalid command
            Write-Host "Not a valid command for workon"
        }
    }
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
# Posh Git Settings:
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '`n'
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# Set default encoding to UTF-8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# Build dict containing list of all programming projects. All are located in
# ~/Programming folder. Any folders that exist outside of this folder can be
# symbolically linked back to this folder.
$env_dict = @{}
$folds = Get-ChildItem "~/Programming"
foreach ($fold in $folds) {
    if (Test-Path (Join-Path $fold.FullName ".venv")) {
        $script = "& $(Join-Path $fold.FullName ".venv\Scripts\activate.ps1")"
    } else {
        $script = "if (test-path function:deactivate) {deactivate};"
    }

    $env_dict[$fold.Name] = "
        Set-Location $($fold.FullName)
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

Get-PowerShellRelease
