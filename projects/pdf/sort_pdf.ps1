<#
    This script sorts PDFs by some value in the name (in this case serial number) into 
    folders based on that number.
#>

cd E:\PayPal-work\SinglePdf
$dest = 'E:\new-files'

$a = Get-ChildItem
ForEach ($file in $a) {
    $asn = $file.name -replace '^\d+-(?<asn>\d+).+\.pdf$', '${asn}'
    $to = Join-Path $dest $asn
    
    if (!(Test-Path $to)){
        New-Item -Path $to -ItemType Directory -Force | Out-Null
    }

    Move-Item -Path $file.FullName -Destination $to
}
