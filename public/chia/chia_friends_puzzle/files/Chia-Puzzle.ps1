function Render-ChiaFriend {
    [CmdletBinding()]
    param (
        $Friends,
        $Properties,
        $Class="chia_friend"
    )

    $Friends | ForEach-Object {
        $Friend=$_
        $out=''
        $out+='<div class="' + $Class + '">' + "`r`n"
        $out+='<img src="' + $Friend.ipfsUrl + '" style="width:100px"><br/>' + "`r`n"
        ForEach ($prop in $Friend.PsObject.Properties){
            if($null -ne $prop -and "" -ne $prop -and $prop.Name -notin @("file","ipfsUrl")){
                if($null -ne $Properties){
                    if($prop.Name -in $Properties){
                        $out += $prop.Name + ': ' + $prop.Value + '<br/>' + "`r`n"
                    }
                }
                else{
                    $out += $prop.Name + ': ' + $prop.Value + '<br/>' + "`r`n"
                }
                
            }
        }
        $out+='</div>' + "`r`n"
        $out
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