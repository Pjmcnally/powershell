# Get rid of annoying beeping on backspace
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
. $HOME\Documents\WindowsPowerShell\envs.ps1

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
        Write-Host "`r`nUpdating $($_.key)"
        Write-Host "========================="
        Workon $_.key
        git fetch --all --prune
        git pull
        git push
    }
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

    # Delete personal PowerShell Config Folder.
    Write-Host "`n`rDeleting Windows PowerShell Config..."
    &cmd.exe /c rd /s /q "C:\Users\Patrick\Documents\WindowsPowerShell"
    Write-Host "Process Complete: Delete Windows PowerShell Config"

    # Delete folder storing Windows Backgrounds.
    Write-Host "`n`rDeleting Desktop Backgrounds Folder..."
    &cmd.exe /c rd /s /q "C:\Users\Patrick\Documents\Desktop Backgrounds"
    Write-Host "Process Complete: Delete Desktop Backgrounds Folder"

    # Delete main AHK launching file.
    Write-Host "`n`rDeleting Main AHK file..."
    Remove-Item "C:\Users\Patrick\Documents\Autohotkey.ahk" -Force
    Write-Host "Process Complete: Delete Main AHK file"
}
