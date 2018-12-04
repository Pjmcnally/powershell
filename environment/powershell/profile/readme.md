# Symbolic links:
Symbolic links allow me to have files inside my repo that are also accessible outside of the repo. For example my PowerShell profile.  
To do this and be compatible with Git keep the base file inside the git repo. Link the "external" file back to the repo.  
[Instructions on how to create symbolic](https://docs.microsoft.com/en-us/powershell/wmf/5.0/feedback_symbolic)



# Commands:
### Windows PowerShell 5.x
```
$userFolder = Resolve-Path "~"
$myDocs = [environment]::getfolderpath("mydocuments")
new-item `
    -ItemType SymbolicLink `
    -Path (Join-Path $myDocs WindowsPowerShell) `
    -Name profile.ps1 `
    -value (Join-Path $userFolder "programming\powershell\environment\powershell\profile\profile.ps1")
new-item `
    -ItemType SymbolicLink `
    -Path (Join-Path $myDocs WindowsPowerShell) `
    -Name envs.ps1 `
    -value (Join-Path $userFolder "programming\powershell\environment\powershell\profile\envs.ps1")
```

### Windows PowerShell Core (6.x)
```
$userFolder = Resolve-Path "~"
$myDocs = [environment]::getfolderpath("mydocuments")
new-item `
    -ItemType SymbolicLink `
    -Path (Join-Path $myDocs PowerShell) `
    -Name profile.ps1 `
    -value (Join-Path $userFolder "programming\powershell\environment\powershell\profile\profile.ps1")
new-item `
    -ItemType SymbolicLink `
    -Path (Join-Path $myDocs PowerShell) `
    -Name envs.ps1 `
    -value (Join-Path $userFolder "programming\powershell\environment\powershell\profile\envs.ps1")
```


# Virtual environments:
I have created my own homebrew solution that I plan to keep using. However, if I ever want to switch back to Virtualenv Wrapper here is the info:  
[VirtualEnvWrapper](https://github.com/regisf/virtualenvwrapper-powershell/)
