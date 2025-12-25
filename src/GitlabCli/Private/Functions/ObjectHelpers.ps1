# Object wrapper helper functions

function Add-AliasedProperty {
    param (
        [PSCustomObject]
        [Parameter(Mandatory=$true, Position = 0)]
        $On,

        [string]
        [Parameter(Mandatory=$true)]
        $From,

        [string]
        [Parameter(Mandatory=$true)]
        $To
    )
    
    if ($null -ne $On.$To -and -NOT (Get-Member -Name $On.$To -InputObject $On)) {
        $On | Add-Member -MemberType NoteProperty -Name $From -Value $On.$To
    }
}
