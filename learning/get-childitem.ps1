<#
    I am trying to learn powershell.  As part of that I am doing some experimental stuff

    This file will contain some of my learning on the subject with commands and links
#>

# Link = https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Management/Get-Content?view=powershell-5.1
# Link = https://docs.microsoft.com/en-us/powershell/module/Microsoft.PowerShell.Utility/Select-String?view=powershell-5.0
# Link = https://technet.microsoft.com/en-us/library/ee692796.aspx

# To get all items in immediate folder
Get-ChildItem

# to get all items in immediate folder and all subfolders
Get-ChildItem -Recurse

# Use filter (-include and -exclude can be used as flags)
Get-ChildItem *.sql -Recurse

# Count results (| Measure-Object also works)
(Get-ChildItem -include *.sql -Recurse).Count
(Get-ChildItem -exclude *.sql -Recurse).Count

# Get file names (or other attribute)
Get-ChildItem *.sql -recurse | Select-Object Name

# Search file for string
Select-String *.sql -Pattern "al.SourceTable"

# Search all files in Folder/Subfolders for string
Get-ChildItem *.sql -recurse | Select-String -Pattern "al.SourceTable"
