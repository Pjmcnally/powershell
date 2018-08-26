function timer_wrapper($func, $name="", $arg=$Null) {
    Write-Host "`r`nStarting function: $name"
    $start = Get-Date

    if ($arg) {
        $return = $func.Invoke($arg)
    } else {
        $return = $func.Invoke()
    }

    $end = Get-Date
    $opp_time = New-Timespan $start $end
    Write-Host "Opperation Complete"
    Write-Host ("Time required = {0:g}`r`n" -f $opp_time)

    return $return
}

function clean_file_name($name) {
    $bad_chars = [System.IO.Path]::GetInvalidFileNameChars() -join ""
    $res = $name -replace $bad_pat, ""

    return $res
}
