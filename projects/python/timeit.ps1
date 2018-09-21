ForEach($num in 0..5) {
    $mult = [math]::pow(10,$num)
    $unit = 'msec'

    # $str_a = 'abcdefghijklmnopqrstuvwxyz'
    $str_a = "a" * 26
    # $str_b = 'zyxwvutsrqponmlkjihgfedcba'
    $str_b = "b" * 26

    $setup_str = "from collections import Counter; a = '{0}' * {1}; b = '{2}' * {3}" -f (
        $str_a, $mult,
        $str_b, $mult
    )
    $c_str = "Counter(a) == Counter(b)"
    $s_str = "sorted(a) == sorted(b)"

    Write-Host "`r`nString multiplier = $mult"
    Write-Host "======================================="
    Write-Host ("Testing Counter:" -f $mult) -NoNewline
    Write-Host (python -m timeit -u $unit -s $setup_str $c_str).split(":")[1]
    Write-Host ("Testing Sorted: " -f $mult) -NoNewline
    write-Host (python -m timeit -u $unit -s $setup_str $s_str).split(":")[1]
}
