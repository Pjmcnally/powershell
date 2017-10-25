<#
    Code below heavily based on code found at:
        http://merill.net/2013/06/creating-pdf-files-dynamically-with-powershell/
#>

# Add PdfSharp.dll so I can use .net methods
Add-Type -Path "C:\Users\Patrick\PDFsharp.1.32.3057.0\lib\net20\PdfSharp.dll"

# Create Doc object
$doc = New-Object PdfSharp.Pdf.PdfDocument
$doc.Info.Title = "Created dynamically"

# Add page to doc
$page = $doc.AddPage()

# Add outline to doc and page to outline
$outline = $doc.Outlines
$outline.Add("Root", $page, $TRUE) | Out-Null

# Honestly I don't know exactly what these do
# Basically they write the message to the page
$gfx = [PdfSharp.Drawing.XGraphics]::FromPdfPage($page)
$font = New-Object PdfSharp.Drawing.XFont("Verdana", 20, [PdfSharp.Drawing.XFontStyle]::BoldItalic)
$msg = "Hello World"
$rect = New-Object PdfSharp.Drawing.XRect(0,0,$page.Width, $page.Height)
$gfx.DrawString($msg, $font, [PdfSharp.Drawing.XBrushes]::Black, $rect, [PdfSharp.Drawing.XStringFormats]::Center)

# Save the doc to the harddrive
$doc.Save("C:\Users\Patrick\Desktop\test\HelloWorld.pdf")
