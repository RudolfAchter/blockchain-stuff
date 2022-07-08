$filesBasePath="/home/rudi/git/blockchain-stuff/docs/chia/chia_friends_puzzle/files/bafybeigzcazxeu7epmm4vtkuadrvysv74lbzzbl2evphtae6k57yhgynp4"
$origUrlBase="https://bafybeigzcazxeu7epmm4vtkuadrvysv74lbzzbl2evphtae6k57yhgynp4.ipfs.nftstorage.link"
$puzzleBasePath="/home/rudi/git/blockchain-stuff/docs/chia/chia_friends_puzzle/files"


$objects=Get-ChildItem -Path $filesBasePath -Filter *.json | ForEach-Object {
    $JsonFile=$_
    $json=Get-Content $JsonFile.FullName | ConvertFrom-Json
    $json
}

<#
$HieroglyphsCount=$objects | Where-Object{$_.attributes.trait_type -eq "Hieroglyphs"} | Measure-Object
$traitTypes=$objects | ForEach-Object{$_.attributes.trait_type} | Sort-Object -Unique
$glyphObjects=$objects | Where-Object{$_.attributes.trait_type -eq "Hieroglyphs"}
#>

$i=1
$allObjects=$objects | ForEach-Object {
    $obj=$_
    Write-Progress -Activity "Working on Objects" -Status ("Obj $i of " + $objects.Count) -PercentComplete ($i/$objects.Count * 100)
    $h_props=[ordered]@{
        Name = $obj.name
    }

    $match=$h_props.name | Select-String -Pattern '#([0-9]+)'
    $file=Get-Item -Path ($filesBasePath + "/" + $match.Matches.Groups[1].Value + ".*") | Where-Object{$_.Extension -in @(".gif",".png",".jpg")}
    $h_props.Add("file",$file)
    $h_props.Add("ipfsUrl",($origUrlBase + "/" + $file.Name))

    ForEach($trait in $traitTypes){
        $h_props.Add($trait,($obj.attributes | Where-Object trait_type -eq $trait).value)
    }
    [ChiaFriend]$h_props
    
    $i++
} #| Tee-Object -Variable "allObjects" | Format-Table

$allObjects | Export-Clixml allObjects.cli.xml
$allObjects=Import-Clixml ($puzzleBasePath + "/" + "allObjects.cli.xml")

#$allObjects | Select Name,Accessories,Artifacts,Background,Body,Coins,Expression,Eyes,Hieroglyphs,Keyword,Mouth | Out-ConsoleGridView
#$allObjects | Select Accessories,Artifacts,Background,Body,Coins,Expression,Eyes,Hieroglyphs | Out-ConsoleGridView

$Timelords=@()
$pattern='Timelord \(([^\)]+)\)'
$allObjects | Where-Object {$_.Body -match $pattern} | ForEach-Object {
    $tl=$_
    $match = $tl.Body | Select-String -Pattern $pattern
    $symbolValue=($match.Matches.Groups[1].Value) -replace 'Buterfly','Butterfly'
    Add-Member -InputObject $tl -Type NoteProperty -Name "Symbol" -Value $symbolValue -Force
    $Timelords+=$tl
}

$K32s=@()
$pattern='K32 \(([^\)]+)\)'
$allObjects | Where-Object {$_.Body -match $pattern} | ForEach-Object {
    $k32=$_
    $match = $k32.Body | Select-String -Pattern $pattern
    #Add-Member -InputObject $tl -Type NoteProperty -Name "Symbol" -Value ($match.Matches.Groups[1].Value) -Force
    $K32s+=$k32
}

$header=(Get-Content -Path './include/header.html') -split '`r`n'

$out=''
$out+='<table>'

$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+='<div class="chia_friend">'
    $out+='<img src="' + $tl.ipfsUrl + '" style="width:100px"><br/>'
    $out+='Accessories: ' + $tl.Accessories + '<br/>'
    $out+='Background: ' + $tl.Background + '<br/>'
    $out+='Body: ' + $tl.Body + '<br/>'
    $out+='Coins: ' + $tl.Coins + '<br/>'
    $out+='Eyes: ' + $tl.Eyes + '<br/>'
    $out+='Hieroglyphs: ' + $tl.Hieroglyphs + '<br/>'
    $out+='Mouth: ' + $tl.Mouth + '<br/>'
    $out+='</div>'
    $out+='</td>'
    $out+='<td>'
    $K32s | Where-Object{$_.Coins -eq $tl.Symbol} | ForEach-Object {
        $k32=$_
        #$k32
        $out+='<div class="chia_friend">'
        $out+='<img src="' + $k32.ipfsUrl + '" style="width:100px"><br/>'
        $out+='Accessories: ' + $k32.Accessories + '<br/>'
        $out+='Background: ' + $k32.Background + '<br/>'
        $out+='Body: ' + $k32.Body + '<br/>'
        $out+='Coins: ' + $k32.Coins + '<br/>'
        $out+='Eyes: ' + $k32.Eyes + '<br/>'
        $out+='Hieroglyphs: ' + $k32.Hieroglyphs + '<br/>'
        $out+='Mouth: ' + $k32.Mouth + '<br/>'
        $out+='</div>'
        
    }
    $out+='</td>'
    $out+='</tr>'
}

$out+='</table>'


$footer=(Get-Content -Path './include/footern.html') -split '`r`n'

$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_k32_best_friends.html")

$allObjects | Where-Object{$_.Artifacts -eq "Keyword Token"}