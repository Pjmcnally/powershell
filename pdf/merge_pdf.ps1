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
        $bookmark_title = $input.Internals.Catalog.Elements.GetDictionary("/Outlines").Elements.GetDictionary("/First").Elements.GetString("/Title")
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

Merge-PDF -path C:\Users\Patrick\Desktop\test -filename "C:\Users\Patrick\Desktop\test\test.pdf"
