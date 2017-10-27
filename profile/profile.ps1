# Get rid of annoying beeping on backspace
Set-PSReadlineOption -BellStyle None

# Posh Git Settings:
Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '`n'
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# My functions
function workon {
<#
    This function allows me to switch locations and environments with a prefaced 'workon' command
    I am used to this structure from Linux and python virtualenv)
#>
    param(
        [Parameter(
            Mandatory=$True,
            Position=0,
            HelpMessage="Enter the project name or 'help' for list of projects.")]
        [ValidateSet('ahk', 'help', 'pshell')]
        $project
    )

    # To keep this modular $dict is now linked to an external file I can modify
    # on a system by system basis while keep the rest of this func the same.
    . $HOME\Documents\WindowsPowerShell\systemVariables.ps1
    $dict = $env_dict

    if ($project -eq 'help') {  # Display help text
        Write-Host ("{0,-15}{1}" -f "`nProject Name", "Code run")
        Write-Host ("{0,-15}{1}" -f "============", "========")
        $dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host ("{0,-15}{1}" -f $_.key, $_.value)
        }
    } else {  # Run command associated with key
        Try {
            invoke-expression ($dict.$project) -ErrorAction stop
            return
        } Catch {  # Error out on invalid command
            Write-Host "Not a valid command for workon"
        }
    }
}
