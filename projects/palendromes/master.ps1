Write-Host "Finding palendromes:`r`n===================="
Write-Host "Running Python file:"
Write-Host "Results = $(python palendrome.py)"
python -m timeit -u sec -r 5 -s "import palendrome" -p "palendrome.main()"

Write-Host "`r`nRunning PowerShell file:"
Write-Host "$(Measure-Command {Write-Host Results = $(./palendrome.ps1)})"

Write-Host "Finding words`r`n===================="
Write-Host "Running Python file:"
Write-Host "Results = $(python find_words.py)"
python -m timeit -u sec -r 5 -s "import find_words" -p "find_words.main()"
