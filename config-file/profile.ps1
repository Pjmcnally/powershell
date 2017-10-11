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

	# This dict contains my aliases and their coresponding functions
	# This dict will change based on the system and the virtualenv/projects on that system
	$dict = @{
		'devops' = 'set-location C:\Dev\BHIP\DevOps\'; 
		'iptools' = 'set-location C:\Dev\BHIP\IPTools';
		'ahk' = 'set-location C:\Users\Patrick\Documents\programming\ahk\'; 
		'pshell' = 'set-location C:\Users\Patrick\Documents\programming\powershell\';
	}
	
	if ($args.Count -eq 1) {								# Check that only 1 arg provided
		$name = $args[0]
		if ($name -eq 'help') { 							# Check if name is help
			$dict.GetEnumerator() | ForEach-Object {
				Write-Host $_.key $_.value
			}
		} elseif ($dict.ContainsKey($name)) {				# Run command associated with key
			$func = $dict[$name]
			invoke-expression $func 
			return
		} else {
			Write-Host "Not a valid command for workon"		# Error out on invalid command
		}
	} else {
		Write-Host 'Please provide 1 and only 1 arguemnt'
	}
}
