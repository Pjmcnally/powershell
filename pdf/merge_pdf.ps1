<#
    This code is based off of two repos I found:
        https://github.com/mikepfeiffer/PowerShell/blob/master/Merge-PDF.ps1
        https://gist.github.com/ATZ0/95f9eb0a8f14339fa2fb
#>

function Merge-PDF {            
    Param($path, $filename)
    
    Add-Type -Path "C:\Users\Patrick\PDFsharp.1.32.3057.0\lib\net20\PdfSharp.dll"                      

    $output = New-Object PdfSharp.Pdf.PdfDocument
    $PdfReader = [PdfSharp.Pdf.IO.PdfReader]            
    $PdfDocumentOpenMode = [PdfSharp.Pdf.IO.PdfDocumentOpenMode]                        
            
    foreach($i in (Get-ChildItem $path *.pdf)) {
        $input = New-Object PdfSharp.Pdf.PdfDocument
        $input = $PdfReader::Open($i.fullname, $PdfDocumentOpenMode::Import)
        $page_count = 0
        ForEach($page in $input.Pages){
            $o_page = $output.AddPage($page)
            if($page_count -eq 0){
                $outline = $output.Outlines.Add($i.Name, $o_page, $TRUE)
            }
            $page_count++
        }
    }                        
            
    $output.Save($filename)            
}

Merge-PDF -path C:\Users\Patrick\Desktop\test -filename "C:\Users\Patrick\Desktop\test\test.pdf"
