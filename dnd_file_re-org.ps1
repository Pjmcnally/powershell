$files = Get-ChildItem "C:\Users\Pjmcnally\Downloads\Generic Pregen Chars\By Character" -Recurse -Filter *.pdf

# for ($i=1; $i -lt 11; $i++) {
#     $reg = '^.*' + $i + '.pdf$'
#     $reg
# }


Foreach($file in $files) {
	$name = $file.Fullname
    if ($name -match '^.*1.pdf$') {
        $name
    }
}

