function Render-ChiaFriend {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true)]
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
            if($null -ne $prop -and "" -ne $prop -and $prop.Name -notin @("file","meta","ipfsUrl","ipfsMeta")){
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
    


function Show-ChiaFriend {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true)]
        $Friends,
        $Properties,
        $Class="chia_friend"
    )

    Begin {
        
    }
    
    Process {
        $Friends | ForEach-Object {
            $Friend=$_
            $filterProps=@()
            ForEach ($prop in $Friend.PsObject.Properties){
                if($null -ne $prop -and "" -ne $prop -and $prop.Name -notin @("file","meta","ipfsUrl","ipfsMeta")){
                    $filterProps+=$prop.Name
                }
            }
            $Friend | Select-Object $filterProps
        }    
    }

    End{}

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