function test1() {
    $t1List = @()
    #$t1List += "a"
    #$t1List += "b"
    
    #Write-Host "Inside test the var is = $($t1List.GetType().FullName)"
    return [array]$t1List
}

function test2() {
    [OutputType([array])]

    $t2List = @()

    return $t2List
}

function test3() {
    [OutputType([array])]
    
    $t3List = @()

    return ,$t3List
}

function main() {
    Write-Host "`r`nRunning Main"
    $m1 = test1
    Write-Host "Inside main the var m1 = $([array]$m1.GetType().FullName)"

    $m2 = test2
    Write-Host "Inside main the var m2 = $($m2.GetType().FullName)"
    
    $m3 = test3
    Write-Host "Inside main the var m3 = $($m3.GetType().FullName)"
}

function main2() {
    Write-Host "`r`nRunning Main2"
    $l1 = @(test1)
    Write-Host "Inside main2 the var l1 = $($l1.GetType().FullName)"

    $l2 = @(test2)
    Write-Host "Inside main2 the var l2 = $($l1.GetType().FullName)"
}

function wrapper() {
    Clear-Host
    main
    #main2
}

wrapper