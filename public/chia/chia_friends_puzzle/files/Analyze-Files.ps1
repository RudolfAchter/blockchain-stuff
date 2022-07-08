. "./Chia-Puzzle.ps1"

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

    $traitTypes=$obj.attributes.trait_type

    ForEach($trait in $traitTypes){

        #Korrekturen bei Coins
        if($trait -eq "Coins" -and $null -eq ($obj.attributes | Where-Object trait_type -eq $trait).value){
            $h_props.Add($trait,"Infinity")
        }
        else{
            $h_props.Add($trait,($obj.attributes | Where-Object trait_type -eq $trait).value)
        }
    }

    #Korrektur Butterfly falsch geschrieben
    if($h_props.Body -eq "Timelord (Buterfly)"){
        $h_props.Body="Timelord (Butterfly)"
    }

    [PsCustomObject]$h_props
    
    $i++
} #| Tee-Object -Variable "allObjects" | Format-Table
Write-Progress -Activity "Working on Objects" -Status ("Obj $i of " + $objects.Count) -PercentComplete 100


$allObjects | Export-Clixml allObjects.cli.xml
$allObjects=Import-Clixml ($puzzleBasePath + "/" + "allObjects.cli.xml")

#$allObjects | Select Name,Accessories,Artifacts,Background,Body,Coins,Expression,Eyes,Hieroglyphs,Keyword,Mouth | Out-ConsoleGridView
#$allObjects | Select Accessories,Artifacts,Background,Body,Coins,Expression,Eyes,Hieroglyphs | Out-ConsoleGridView

$Timelords=@()
$pattern='Timelord \(([^\)]+)\)'
$allObjects | Where-Object {$_.Body -match $pattern} | ForEach-Object {
    $tl=$_
    $match = $tl.Body | Select-String -Pattern $pattern
    $symbolValue=($match.Matches.Groups[1].Value) #-replace 'Buterfly','Butterfly'
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

$Coins=$allObjects| Where-Object {$null -ne $_.Coins}

$header=(Get-Content -Path './include/header.html') -split '`r`n'
$footer=(Get-Content -Path './include/footer.html') -split '`r`n'

$out=''
$out+='<table>'
$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+= Render-ChiaFriend -Friend $tl
    $out+='</td>'
    $out+='<td>'
    $K32s | Where-Object{$_.Coins -eq $tl.Symbol} | ForEach-Object {
        $k32=$_
        #$k32
        $out+=Render-ChiaFriend -Friend $k32
        
    }
    $out+='</td>'
    $out+='</tr>'
}
$out+='</table>'
$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_k32_best_friends.html")


$out=''
$out+='<table>'
$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+= Render-ChiaFriend -Friend $tl
    $out+='</td>'
    $out+='<td>'
    $Coins | Where-Object{$_.Coins -eq $tl.Symbol} | ForEach-Object {
        $coin=$_
        #$k32
        $out+=Render-ChiaFriend -Friend $coin
        
    }
    $out+='</td>'
    $out+='</tr>'
}
$out+='</table>'
$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_coins.html")






$KeywordFriends=$allObjects | Where-Object{$_.Artifacts -eq "Keyword Token"}

$out=''
$KeywordFriends | Sort-Object Keyword | ForEach-Object {
    $out += (Render-ChiaFriend $_ -Properties @("Keyword") -Class "friend_small")
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/keyword_friends.html")


$out=''
$K32s | Sort-Object Coins | ForEach-Object {
    $out += (Render-ChiaFriend $_ )
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32.html")

$out=''
$K32s | Where-Object{$null -ne $_.Coins} | Sort-Object Coins | ForEach-Object {
    $out += (Render-ChiaFriend $_ -Properties @("Coins") -Class "friend_small")
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32_coins.html")



$KeywordFriends | Measure-Object
$Timelords | Measure-Object

$Timelords = $Timelords |Sort-Object Symbol

$out='<table>'
$i=0
for($y=1;$y -le 5;$y++){
    $out+='<tr>'
    for($x=1;$x -le 5;$x++){
        $out+='<td>'
        $out+=Render-ChiaFriend -Friend ($Timelords[$i]) -Class "friend_small" -Properties @("Symbol")
        $out+='</td>'
        $i++
    }
    $out+='</tr>'
}
$out+='</table>'

$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/timelords_matrix.html")


