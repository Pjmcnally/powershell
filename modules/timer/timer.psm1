function timer_wrapper($func, $arg_list=$Null) {
    $start = Get-Date

    if ($arg_list) {
        $return = $func.Invoke($arg_list)
    } else {
        $return = $func.Invoke()
    }

    $end = Get-Date
    $opp_time = New-Timespan $start $end
    Write-Host "`r`n`r`nOpperation Complete:"
    Write-Host ("Time required = {0:g}`r`n`r`n" -f $opp_time)

    return $return
}
