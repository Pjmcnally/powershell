# Symbolic links:
Symbolic links allow me to have files inside my repo that are also accessible
outside of the repo. For example my PowerShell profile.

Instructions on how to create symbolic links here:
https://docs.microsoft.com/en-us/powershell/wmf/5.0/feedback_symbolic

To do this and be compatible with Git keep the base file inside the git repo.
Link the "external" file back to the repo.

Commands:
new-item `
    -ItemType SymbolicLink `
    -Path "C:\Users\Patrick\Documents\WindowsPowerShell" `
    -Name profile.ps1 `
    -value "C:\Users\Patrick\Documents\programming\powershell\environment\powershell\profile\profile.ps1"
new-item `
    -ItemType SymbolicLink `
    -Path "C:\Users\Patrick\Documents\WindowsPowerShell" `
    -Name env.ps1 `
    -value "C:\Users\Patrick\Documents\programming\powershell\environment\powershell\profile\env.ps1" `


# Virtual environments:
I have created my own homebrew solution that I plan to keep using. However,
if I ever want to switch back to Virtualenv Wrapper here is the info:

# # VirtualEnvWrapper
# # Found at https://github.com/regisf/virtualenvwrapper-powershell/
# $MyDocuments = [Environment]::GetFolderPath("MyDocuments")
# $WORKON_HOME = "~/Programming/Envs"
# Import-Module VirtualEnvWrapper
