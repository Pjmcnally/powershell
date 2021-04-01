function Remove-InvalidFileNameChars($string) {
    $badChars = [System.IO.Path]::GetInvalidFileNameChars() -join ""
    $result = $string -replace $badChars, ""

    return $result
}
