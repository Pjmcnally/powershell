<#
    Code below heavily based on code found at:
        http://merill.net/2013/06/creating-pdf-files-dynamically-with-powershell/
#>

Add-Type -Path "C:\Users\Patrick\PDFsharp.1.32.3057.0\lib\net20\PdfSharp.dll"

$doc = New-Object PdfSharp.Pdf.PdfDocument
$doc.Info.Title = "Created dynamically"
$page = $doc.AddPage()
$gfx = [PdfSharp.Drawing.XGraphics]::FromPdfPage($page)
$font = New-Object PdfSharp.Drawing.XFont("Verdana", 20, [PdfSharp.Drawing.XFontStyle]::BoldItalic)
$msg = "Hello World"
$rect = New-Object PdfSharp.Drawing.XRect(0,0,$page.Width, $page.Height)
$gfx.DrawString($msg, $font, [PdfSharp.Drawing.XBrushes]::Black, $rect, [PdfSharp.Drawing.XStringFormats]::Center)
$doc.Save("HelloWorld.pdf")