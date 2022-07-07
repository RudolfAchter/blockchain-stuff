# Chia Friends Puzzle findings

## Something significant in #1854

Seth Jenks [posted on Twitter there is "something significant" on chia friend #1854](https://twitter.com/sethjenks/status/1544891610483556352).

There found an Alphabet in File 1854.png. When you look at this File with a Hex Editor at certain places it seems like every third Byte is a character of the alphabet. I wrote this powershell Script to analyze this.

```powershell
[byte[]]$bytes=[System.IO.File]::ReadAllBytes("/home/rudi/chia_puzzle/all_files/1854.png")

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
```

This Extracts out of 1854.png starting from Byte 341 (decimal) Ending at Byte 581 (decimal)

```
Start at Byte: 341
ABBCDEEFGGHHIIIJJKKLLMNOPQRRSTUUVVWXXXYZ[\\]^_``aabccdeefgghijjklmnopqrrsstuvxy{}
End at Byte: 581
```

