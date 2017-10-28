# Get rid of annoying beeping on backspace
Set-PSReadlineOption -BellStyle None

# Posh Git Settings:
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '`n'
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# Import systemVariables file (includes vars: [enum]envs, [hashtable]env_dict)
. $HOME\Documents\WindowsPowerShell\envs.ps1

# My functions
function workon {
<#
    This function allows me to switch locations and environments with a
    prefaced 'workon' command. This is similar to Linux and python virtualenv
#>
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
