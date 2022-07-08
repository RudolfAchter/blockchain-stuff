Class ChiaFriend {
    $Name
    $Accessories
    $Artifacts
    $Background
    $Body
    $Coins
    $Expression
    $Eyes
    $file
    $Hieroglyphs 
    $ipfsUrl
    $Keyword
    $Mouth
    
    [string]Render(){
        $out=''
        $out+='<div class="chia_friend">' + "`r`n"
        $out+='<img src="' + $this.ipfsUrl + '" style="width:100px"><br/>' + "`r`n"
        ForEach ($prop in $this.PsObject.Properties){
            if($null -ne $prop -and "" -ne $prop -and $prop.Name -notin @("file","ipfsUrl")){
                $out += $prop.Name + ': ' + $prop.Value + '<br/>' + "`r`n"
            }
        }
        $out+='</div>' + "`r`n"
        return($out)
    }
}



# Converts Object properties to HashTable.
Function Convert-ObjectToHashTable
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [pscustomobject] $Object
    )
    $HashTable = @{}
    $ObjectMembers = Get-Member -InputObject $Object -MemberType *Property
    foreach ($Member in $ObjectMembers) 
    {
        $HashTable.$($Member.Name) = $Object.$($Member.Name)
    }
    return $HashTable
}