function Merge-PDF {            
    Param($path, $filename)
    
    Add-Type -Path "C:\Users\Patrick\PDFsharp.1.32.3057.0\lib\net20\PdfSharp.dll"                      
            
    $output = New-Object PdfSharp.Pdf.PdfDocument            
    $PdfReader = [PdfSharp.Pdf.IO.PdfReader]            
    $PdfDocumentOpenMode = [PdfSharp.Pdf.IO.PdfDocumentOpenMode]                        
            
    foreach($i in (gci $path *.pdf -Recurse)) {            
        $input = New-Object PdfSharp.Pdf.PdfDocument            
        $input = $PdfReader::Open($i.fullname, $PdfDocumentOpenMode::Import)            
        $input.Pages | %{$output.AddPage($_)}            
    }                        
            
    $output.Save($filename)            
}

Merge-PDF -path C:\Users\Patrick\Desktop\test -filename "test.pdf"