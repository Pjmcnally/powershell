Write-Host "Finding palendromes:`r`n===================="
Write-Host "Running Python file:"
Write-Host "Results = $(python palendrome.py)"
python -m timeit -u sec -s "import palendrome" -p "palendrome.main()"

Write-Host "`r`nRunning PowerShell file:"
Write-Host "$(Measure-Command {Write-Host Results = $(./palendrome.ps1)})"

Write-Host "`r`nFinding words`r`n===================="
Write-Host "Running Python file:"
Write-Host "Results = $(python find_words.py)"
python -m timeit -u sec -s "import find_words" -p "find_words.main()"
