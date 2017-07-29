function main() {
    rename_with_lead_0
}

function rename_with_lead_0() {
    $path = "C:\Users\Pjmcnally\Downloads\Generic Pregen Chars\character"
    $files = Get-ChildItem $path -Recurse -Filter *.pdf

    Foreach($file in $files) {
        $name = $file.Name -replace '^(?<beg>[^\d]*)(?<num>\d{1}).pdf', '${beg}0${num}.pdf'
        Rename-Item $file.Fullname $name
    }
}



# for ($i=1; $i -lt 11; $i++) {
#     $reg = '^.*' + $i + '.pdf$'
#     $reg
#     Foreach($file in $files) {
#         $name = $file.Fullname
#         if ($name -match $reg) {
#             $name
#         }
#     }
# }


# Rename file to add leading 0
# Foreach($file in $files) {
#         $name = $file.Fullname
#         if ($name -match $reg) {
#             $name
#         }
#     }

main
