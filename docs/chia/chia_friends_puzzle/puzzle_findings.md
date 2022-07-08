# Chia Friends Puzzle findings

## Knowns in the community

Some Links to sites that collect things that are known:

- [scotopic - The race to solve the Chia Friends puzzle](https://www.scotopic.xyz/the-race-to-solve-the-chia-friends-puzzle/)
- [chialinks Rarity List](https://chialinks.com/chiafriends/)

## New Attempts

These are ideas where i don't know if they are right or wrong

### Something significant about 1854
- Seth Jenks [posted on Twitter there is "something significant" on chia friend #1854](https://twitter.com/sethjenks/status/1544891610483556352)
- [Playfair cipher](https://en.wikipedia.org/wiki/Playfair_cipher) was invented in year 1854
- Sethjenks did not have control over order of chiafriends. So maybe nothing special in ChiaFriends NFT Data

### K32s and Timelords are best friends

K32s and Timelords are best friends. There are Timelords with a symbol on there body, and K32 with the same symbol as a coin above their head.

- [timelords_k32_best_friends.html](files/timelord_k32_best_friends.html)



## Wrong attempts (possibly)

These are ideas i came up with, but are proven as wrong

### Something significant in #1854

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
