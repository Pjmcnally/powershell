Write-Host "Running Python file:"
Write-Host "Results = $(python palendrome.py)"
python -m timeit -u sec -r 5 -s "import palendrome" -p "palendrome.main()"

Write-Host "`r`nRunning PowerShell file:"
Write-Host "$(Measure-Command {Write-Host Results = $(./palendrome.ps1)})"
