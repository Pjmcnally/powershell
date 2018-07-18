function main() {
    $p = 0
    $words = Get-Content ".\dicts\alphabetical.txt"
    ForEach($w in $words) {
        $p += ($w -eq ($w[-1..-($w.length)] -join ""))
    }

    return $p
}

main
