. "./Chia-Puzzle.ps1"
. "./config.ps1"


$puzzleBasePath="/home/rudi/git/blockchain-stuff/docs/chia/chia_friends_puzzle/files"
$filesBasePath="$puzzleBasePath/bafybeigzcazxeu7epmm4vtkuadrvysv74lbzzbl2evphtae6k57yhgynp4"
$origUrlBase="https://bafybeigzcazxeu7epmm4vtkuadrvysv74lbzzbl2evphtae6k57yhgynp4.ipfs.nftstorage.link"



$spaceScanApiKey=$Global:ChiaPuzzle.spacescan.apiKey

$h_headers=@{
    "x-api-coin"="XCH"
    "x-auth-id"=$spaceScanApiKey
    "x-api-version"="v0.1"
}

$cat=Invoke-RestMethod -Uri "https://api2.spacescan.io/v0.1/xch/cat/44a1d78b820f6404de3cc45b34932178f9ac8f3d9114db279f657ca83fa751b7" `
    -Headers $h_headers -Method GET -ContentType "application/json"

<#
#FIXME funktioniert nicht: Support Anfrage bei spacescan.ip Support <https://discordapp.com/channels/919680063513968701/984558089401417808/995630948311908362>

$nftCollection=Invoke-RestMethod -Uri "https://api2.spacescan.io/api/nft/collection/col1z0ef7w5n4vq9qkue67y8jnwumd9799sm50t8fyle73c70ly4z0ws0p2rhl" `
    -Headers $h_headers -Method GET -ContentType "application/json"

$nftCollection=Invoke-RestMethod -Uri "https://api2.spacescan.io/api/nft/collection/col1z0ef7w5n4vq9qkue67y8jnwumd9799sm50t8fyle73c70ly4z0ws0p2rhl" `
    -Headers $h_headers -Method POST -ContentType "application/json" -Body ($h_headers | ConvertTo-Json)

    #nft12l69ttcxm8zdk3jc6z3dlhtvudja270sm4k7cw3rhvhgur9lrntqly5hag

$singleNft=Invoke-RestMethod -Uri "https://api2.spacescan.io/api/nft/nft12l69ttcxm8zdk3jc6z3dlhtvudja270sm4k7cw3rhvhgur9lrntqly5hag" `
    -Headers $h_headers -Method GET -ContentType "application/json" -Body ($h_headers | ConvertTo-Json)

#>

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

#Get Image Properties
for($i=0; $i -lt $allObjects.Count; $i++){
    Write-Progress -Activity "Getting Alpha Channels" -Status ("$i of " + $allObjects.Count) -PercentComplete ($i / $allObjects.Count * 100)
    $Format=identify -format '%[channels]' $allObjects[$i].File
    if ($null -eq $allObjects[$i].File.ImageProps){
        Add-Member -InputObject $allObjects[$i].File -Type NoteProperty -Name ImageProps -Value (@{})
    }
    if($null -eq $allObjects[$i].File.ImageProps.Format){
        $allObjects[$i].File.ImageProps.Add("Format",$Format)
    }
}
Write-Progress -Activity "Getting Alpha Channels" -Status ("$i of " + $allObjects.Count) -PercentComplete ($i / $allObjects.Count * 100)


$allTraitTypes = $objects.attributes.trait_type | Sort-Object -Unique

$allCols=@("Name","ipfsUrl")
$allCols+=$allTraitTypes

$allObjects | Sort-Object Name | Select-Object $allCols | Export-Csv -Path ($puzzleBasePath + "/metadata.csv")
$allObjects | Sort-Object Name | Select-Object $allCols | ConvertTo-Json -Depth 5 | Out-File ($puzzleBasePath + "/metadata.json")
$allObjects | Sort-Object Name | Select-Object $allCols | ConvertTo-Yaml | Out-File ($puzzleBasePath + "/metadata.yaml")

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
# Header and Footer preparation for HTML
$header=(Get-Content -Path './include/header.html') -split '`r`n'
$footer=(Get-Content -Path './include/footer.html') -split '`r`n'

# All Timelords Grouped with K32 with same Symbol

$out=''
$out+='<table>'
$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+= Render-ChiaFriend -Friends $tl
    $out+='</td>'
    $out+='<td>'
    $K32s | Where-Object{$_.Coins -eq $tl.Symbol}  | Sort-Object Body,Eyes,Hieroglyphs| ForEach-Object {
        $k32=$_
        #$k32
        $out+=Render-ChiaFriend -Friends $k32
        
    }
    $out+='</td>'
    $out+='</tr>'
}
$out+='</table>'
$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_k32_best_friends.html") -Encoding UTF8




# Timelords Grouped with all 42 Coins having the same symbol

$out=''
$out+='<table>'
$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+= Render-ChiaFriend -Friends $tl
    $out+='</td>'
    $out+='<td>'
    $Coins | Where-Object{$_.Coins -eq $tl.Symbol} | ForEach-Object {
        $coin=$_
        #$k32
        $out+=Render-ChiaFriend -Friends $coin
        
    }
    $out+='</td>'
    $out+='</tr>'
}
$out+='</table>'
$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_coins.html")

# Timelords -> Coins -> Keywords
$out=''
$out+='<table>'
$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+= Render-ChiaFriend -Friends $tl
    $out+='</td>'
    $out+='<td>'
    $Coins | Where-Object{$_.Coins -eq $tl.Symbol} | ForEach-Object {
        $coin=$_
        $matchingKeyword=$KeywordFriends | Where-Object{
            $_.Accessories -eq $coin.Accessories -and
            $_.Body -eq $coin.Body -and
            $_.Eyes -eq $coin.Eyes -and
            $_.Mouth -eq $coin.Mouth -and
            $_.Background -eq $coin.Background
        }
        if($null -ne $matchingKeyword){
            $out+=Render-ChiaFriend -Friends $coin
            $out+=Render-ChiaFriend -Friends $matchingKeyword
            $out+='<hr style="border-top: 2px solid grey; clear:both;">'
        }
    }
    $out+='</td>'
    $out+='</tr>'
}
$out+='</table>'
$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_coin_keyword_match_abemb.html")




# Timelords -> Coins -> Keywords Ignore Background
$out=''
$out+='<table>'
$Timelords | ForEach-Object {
    $tl=$_
    #$tl.Symbol
    $out+='<tr><td>'
    $out+= Render-ChiaFriend -Friends $tl
    $out+='</td>'
    $out+='<td>'
    $Coins | Where-Object{$_.Coins -eq $tl.Symbol} | ForEach-Object {
        $coin=$_
        $matchingKeyword=$KeywordFriends | Where-Object{
            $_.Accessories -eq $coin.Accessories -and
            $_.Body -eq $coin.Body -and
            $_.Eyes -eq $coin.Eyes -and
            $_.Mouth -eq $coin.Mouth
            #$_.Background -eq $coin.Background
        }
        if($null -ne $matchingKeyword){
            $out+=Render-ChiaFriend -Friends $coin
            $out+=Render-ChiaFriend -Friends $matchingKeyword
            $out+='<hr style="border-top: 2px solid grey; clear:both;">'

        }
    }
    $out+='</td>'
    $out+='</tr>'
}
$out+='</table>'
$html=$header + $out + $footer

$html | Out-File -FilePath ($puzzleBasePath + "/out/timelord_coin_keyword_match_abem.html")



$KeywordFriends=$allObjects | Where-Object{$_.Artifacts -eq "Keyword Token"}

# All Keywords

$out=''
$KeywordFriends | Sort-Object Keyword | ForEach-Object {
    $out += (Render-ChiaFriend $_ -Properties @("Keyword") -Class "friend_small")
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/keywords.html")


# All K32

$out=''
$K32s | Sort-Object Coins | ForEach-Object {
    $out += (Render-ChiaFriend $_ )
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32.html")

# All K32 with coins

$out=''
$K32s | Where-Object{$null -ne $_.Coins} | Sort-Object Coins | ForEach-Object {
    $out += (Render-ChiaFriend $_ -Properties @("Coins") -Class "friend_small")
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32_coins.html")



$KeywordFriends | Measure-Object
$Timelords | Measure-Object


# Timelords 5x5

$Timelords = $Timelords |Sort-Object Symbol

$out='<table>'
$i=0
for($y=1;$y -le 5;$y++){
    $out+='<tr>'
    for($x=1;$x -le 5;$x++){
        $out+='<td>'
        $out+=Render-ChiaFriend -Friends ($Timelords[$i]) -Class "friend_small" -Properties @("Symbol")
        $out+='</td>'
        $i++
    }
    $out+='</tr>'
}
$out+='</table>'

$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/timelords_matrix.html")



#Alpha Channels

$out=''
$allObjects | Where-Object{$_.File.ImageProps.Format -eq "srgba"} | ForEach-Object {
    $out += (Render-ChiaFriend $_ -Class "chia_friend_transparent")
}
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/alpha_channel.html")


# All Keywords and [Playfair Chipher tool](http://rumkin.com/tools/cipher/playfair.php)

$KeywordFriends.Keyword | Sort-Object $_ | %{Write-Host -NoNewline $_}

# out/2022-07-10-10-52-21.png



#Byte Data
[byte[]]$bytes=[System.IO.File]::ReadAllBytes("$filesBasePath/1739.png")
[byte[]]$bytes=[System.IO.File]::ReadAllBytes("$filesBasePath/1854.png")
[byte[]]$bytes=[System.IO.File]::ReadAllBytes("$filesBasePath/1805.png")
[byte[]]$bytes=[System.IO.File]::ReadAllBytes("$filesBasePath/1859.png")


$char=""
$start=341
Write-Host("Start at Byte: " + $start)
for($i=$start;$i -le ($bytes.Count -1) -and $char -ne "}";$i=$i+3){
    $char=[System.Text.Encoding]::ASCII.GetString($bytes[$i])
    Write-Host ($char) -NoNewline

    if($char -eq "}"){
        Write-Host("")
        Write-Host("End at Byte: " + $i)
    }
}





$out=''
$K32s | Where-Object {$_.Body -like "*amethyst*" -or $_.Body -like "*jade*"} |
    Sort-Object {$_.Background} |
    ForEach-Object {
        $k32=$_
        $out+=Render-ChiaFriend $_
    }
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32_amethyst_jade_order_background.html")


$out=''
$K32s | Where-Object {($_.Body -like "*amethyst*" -or $_.Body -like "*jade*") -and $null -ne $_.Coins} |
    Sort-Object {$_.Coins} |
    ForEach-Object {
        $k32=$_
        $out+=Render-ChiaFriend $_
    }
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32_amethyst_jade_order_coins.html")



$K32s | Where-Object {($_.Coins -eq "Leaf")}

$out=''
$K32s | Where-Object {$null -ne $_.Coins} |
    Sort-Object {$_.Coins} |
    ForEach-Object {
        $k32=$_
        $out+=Render-ChiaFriend $_
    }
$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/k32_coins.html")


# 42 the answer to everything

($K32s | Where-Object {$_.Body -like "*gold*" -and $null -ne $_.Coins} | Measure-Object).Count
($K32s | Where-Object {$_.Body -like "*jade*" -and $null -ne $_.Coins} | Measure-Object).Count
($K32s | Where-Object {$_.Body -like "*amethyst*" -and $null -ne $_.Coins} | Measure-Object).Count

"K32 Body Groups"

$K32s | Where-Object {$null -ne $_.Coins} | Group-Object Body | ft Count,Name

"Coin Groups"

$allObjects | Group-Object Coins | ft Count,Name

$allObjects | Group-Object Artifacts | Sort-Object Count

$allTraitTypes | ForEach-Object {
    $allObjects | Group-Object $_ | Sort-Object Count
} | Where-Object Count -eq 42



$out=''
$out+='<h1>42 Jade K32s</h1>'
$out+=$K32s | Where-Object {$_.Body -like "*jade*" -and $null -ne $_.Coins} | ForEach-Object {Render-ChiaFriend $_ -Class "friend_small" -Properties @("Name")}
$out+='<hr style="border-top: 2px solid grey; margin-top:10px; clear:both;">'

$allObjects | Where-Object {$null -ne $_.Coins} | Group-Object Coins | ForEach-Object {
    $group=$_
    $out+='<h1>42 ' + $group.Name + '</h1>'
    $out+=$group.Group | ForEach-Object{Render-ChiaFriend $_ -Class "friend_small" -Properties @("Name")}
    $out+='<hr style="border-top: 2px solid grey; margin-top:10px; clear:both;">'
}

$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/42_the_answer.html")


$out=''
$out+='<h1>42 Jade K32s</h1>'
$out+=$K32s | Where-Object {$_.Body -like "*jade*" -and $null -ne $_.Coins} | ForEach-Object {Render-ChiaFriend $_ -Class "friend_small" -Properties @("Name")}
$out+='<hr style="border-top: 2px solid grey; margin-top:10px; clear:both;">'

$allObjects | Where-Object {$null -ne $_.Coins -and $_.Body -like "*jade*"} | Group-Object Coins | ForEach-Object {
    $group=$_
    $out+='<h1>' + $group.Count + " " + $group.Name + '</h1>'
    $out+=$group.Group | ForEach-Object{Render-ChiaFriend $_ -Class "friend_small" -Properties @("Name")}
    $out+='<hr style="border-top: 2px solid grey; margin-top:10px; clear:both;">'
}

$html=$header + $out + $footer
$html | Out-File -FilePath ($puzzleBasePath + "/out/42_jade.html")