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
        [ValidateSet('<name of project>')]
        $project
    )

    # This dict contains my aliases and their coresponding functions
    # This dict will change based on the system and the virtualenv/projects on that system
    $dict = @{
        '<name of project>' = '<code to run to workon project>'
    }

    if ($project -eq 'help') {                          # Check if name is help
        Write-Host ("{0,-15}{1}" -f "`nProject Name", "Code run")
        Write-Host ("{0,-15}{1}" -f "============", "========")
        $dict.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host ("{0,-15}{1}" -f $_.key, $_.value)
        }
    } elseif ($dict.ContainsKey($project)) {            # Run command associated with key
        $func = $dict[$project]
        invoke-expression $func
        return
    } else {
        Write-Host "Not a valid command for workon"     # Error out on invalid command
    }
}
