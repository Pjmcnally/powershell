$folder = "C:\Users\Patrick\Desktop\test"
$file = "C:\Users\Patrick\Desktop\temp.txt"

While ($true) {
    $date = Get-Date
    if($date.Second % 10 -eq 0) {
        $num = (Get-ChildItem $folder).Count
        
        $str = "$num files remaining in folder at $($date.ToString('HH:mm:ss'))"

        Write-Host $str
        $str >> $file

        Start-Sleep -Seconds 8
    } else {
        Start-Sleep -Millisecond 50
    }
}