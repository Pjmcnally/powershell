# TODO: Include files directly in Git Repo so I don't have to copy back and forth
# See: https://docs.microsoft.com/en-us/powershell/wmf/5.0/feedback_symbolic

# TODO: https://github.com/dahlbyk/posh-git/wiki/Customizing-Your-PowerShell-Prompt

# Get rid of annoying beeping on backspace
Set-PSReadlineOption -BellStyle None

# Posh Git Settings:
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '`n'
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# # VirtualEnvWrapper
# # Found at https://github.com/regisf/virtualenvwrapper-powershell/
# $MyDocuments = [Environment]::GetFolderPath("mydocuments")
# $WORKON_HOME = "~/Programming/Envs"
# Import-Module VirtualEnvWrapper


# Import systemVariables file (includes var: [hashtable]env_dict)
. $HOME\Documents\WindowsPowerShell\envs.ps1

# Build list of envs and "help" command
$env_list = (($env_dict.keys) + 'help')

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
        Write-Host ("{0,-15}{1}" -f "`nProject Name", "Code run")
        Write-Host ("{0,-15}{1}" -f "============", "========")
        $env_dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host ("{0,-15}{1}" -f $_.key, $_.value)
        }
    } else {  # Run command associated with key
        Try {
            invoke-expression ($env_dict.$project) -ErrorAction stop
            return
        } Catch {  # Error out on invalid command
            Write-Host "Not a valid command for workon"
        }
    }
}

function deactivate {
    <#
        This is a placeholder until I activate a vitural env and the real
        deactivate function is created.

        This function does nothing.
    #>
}
