Write-Host "Running Python file:"
Write-Host "Results = $(python temp.py)"
python -m timeit -u sec -r 5 -s "import temp" -p "temp.main()"

Write-Host "`r`nRunning PowerShell file:"
Write-Host "$(Measure-Command {Write-Host Results = $(./temp.ps1)})"
