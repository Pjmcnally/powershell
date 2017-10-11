Function main(){
    $dir = 'C:\Users\Patrick\Desktop\Errors'
    $a = Get-ChildItem -Path $dir -Recurse -File


    ForEach($file in $a) {
        "While: {0}{1}" -f ($(dir_name_w -dir $file.DirectoryName -goal $dir), $file.BaseName) >> out.txt
        "Recur: {0}{1}" -f ($(dir_name_r -dir $file.DirectoryName -goal $dir), $file.BaseName) >> out.txt
        "`n" >> out.txt
    }
}

Function dir_name_w($dir, $goal){
    $res = ""
    While($dir -ne $goal){
        $end = Split-Path $dir -Leaf
        $dir = Split-Path $dir -Parent
        $res = $end + $res
    }

    return $res
}

Function dir_name_r($dir, $goal){
    if($dir -eq $goal){
        return ""
    } else {
        $end = Split-Path $dir -Leaf
        $new_dir = Split-Path $dir -Parent
        return "{0}{1}" -f ($(dir_name_r -dir $new_dir -goal $goal), $end)
    }
}

main