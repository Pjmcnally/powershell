Write-Host "Finding palindromes:`r`n===================="
Write-Host "Running Python file:"
Write-Host "Results = $(python palindrome.py)"
python -m timeit -u sec -s "import palindrome" -p "palindrome.main()"

Write-Host "`r`nRunning PowerShell file:"
Write-Host "$(Measure-Command {Write-Host Results = $(./palindrome.ps1)})"

Write-Host "`r`nFinding words`r`n===================="
Write-Host "Running Python file:"
Write-Host "Results = $(python find_words.py)"
python -m timeit -u sec -s "import find_words" -p "find_words.main()"
