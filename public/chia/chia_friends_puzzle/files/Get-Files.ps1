
$base="https://bafybeigzcazxeu7epmm4vtkuadrvysv74lbzzbl2evphtae6k57yhgynp4.ipfs.nftstorage.link"

$page=Invoke-WebRequest -Uri $base

$pattern='/([0-9]+\.(json|png|gif|jpg|jpeg))'
$page.Links | Where-Object {$_.href -match $pattern} | ForEach-Object {
    $link=$_
    $match=$link.href | Select-String -Pattern $pattern
    $filename=$match.Matches.Groups[1].Value
    $filename
    Invoke-WebRequest -Uri ($base + "/" + $filename) -OutFile ("all_files/" + $filename)
}