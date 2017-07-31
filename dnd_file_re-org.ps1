function main() {
    # rename_with_lead_0
    split_by_level
    "process is complete..."
}

function rename_with_lead_0() {
    # Function to add leading 0 to single digit numbers in file names
    $path = "C:\Users\Pjmcnally\Downloads\Generic Pregen Chars\character"
    $files = Get-ChildItem $path -Recurse -Filter *.pdf

    Foreach($file in $files) {
        $name = $file.Name -replace '^(?<beg>[^\d]*)(?<num>\d{1}).pdf', '${beg}0${num}.pdf'
        Rename-Item $file.Fullname $name
    }
}

function split_by_level() {
    # Function to copy files into folders by level
    $inc_path = "C:\Users\Pjmcnally\Downloads\Generic Pregen Chars\character"
    $out_path = "C:\Users\Pjmcnally\Downloads\Generic Pregen Chars\level"
    $files = Get-ChildItem $inc_path -Recurse -Filter *.pdf

    Foreach($file in $files) {
        $num = get_level_num($file.name)
        $dest = $out_path + "\" + $num
        Copy-Item $file.Fullname $dest
    }
}

function get_level_num($name) {
    # function to pull level number out of file.
    $res = $name -match '(\d{2})'
    return $matches[1]
}

main
