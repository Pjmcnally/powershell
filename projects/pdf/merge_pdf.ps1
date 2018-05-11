<#
    This code is based off of two repos I found:
        https://github.com/mikepfeiffer/PowerShell/blob/master/Merge-PDF.ps1
        https://gist.github.com/ATZ0/95f9eb0a8f14339fa2fb
#>

function Merge-PDF {            
    Param($path, $filename)
    
    # Setup PdfSharp
    Add-Type -Path "C:\Users\Patrick\PDFsharp.1.32.3057.0\lib\net20\PdfSharp.dll"                      
    $PdfReader = [PdfSharp.Pdf.IO.PdfReader]
    $PdfDocumentOpenMode = [PdfSharp.Pdf.IO.PdfDocumentOpenMode]

    # Create output file
    $output = New-Object PdfSharp.Pdf.PdfDocument
            
    $in_files = Get-ChildItem $path *.pdf
    foreach($i in $in_files) {
        $input = New-Object PdfSharp.Pdf.PdfDocument
        $input = $PdfReader::Open($i.fullname, $PdfDocumentOpenMode::Import)
        $bookmark_title = Get-BookMarkString -filename $i.name
        $page_count = 0
        ForEach($page in $input.Pages){
            $o_page = $output.AddPage($page)
            if($page_count -eq 0){
                $outline = $output.Outlines.Add($bookmark_title, $o_page)
            }
            $page_count++
        }
    }                        
            
    if($output.PageCount){
        $output.Save($filename)
    }
}

Function Get-BookMarkString {
    Param($filename)

    $regex = '^(?<c_num>\d+)-(?<a_num>\d+)-(?<title>[\w-]+)-(?<d_code>[A-Z_]+)-(?<date>\d+).*\.pdf$'
    if ($filename -match $regex) {
        $c_num = $matches.c_num
        $a_num = $matches.a_num
        $title = $matches.title -replace '_', ' '
        $d_code = $mathes.d_code
        $date = $matches.date -replace '^(?<y>\d{4})(?<m>\d{2})(?<d>\d{2})$', '${y}-${m}-${d}'

        $out_string = "{0} {1} {2} {3}" -f($c_num, $a_num, $title, $date)
        return $out_string
    }
}


Merge-PDF -path C:\Users\Patrick\Desktop\test -filename "C:\Users\Patrick\Desktop\test\test.pdf"
