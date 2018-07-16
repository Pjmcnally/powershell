function main() {
    $p = 0
    $words = Get-Content ".\enable1.txt"
    ForEach($w in $words) {
        $p += ($w -eq ($w[-1..-($w.length)] -join ""))
    }

    return $p
}

main
