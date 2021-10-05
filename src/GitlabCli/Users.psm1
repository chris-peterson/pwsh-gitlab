function Get-GitlabUser {
    param (
        [Parameter(ParameterSetName='ByUsername', Mandatory=$false)]
        [string]
        $Username,

        [Parameter(ParameterSetName='ByEmail', Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter(ParameterSetName='ByMe', Mandatory=$False)]
        [switch]
        $Me,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if ($Username) {
        $UserId = Invoke-GitlabApi GET "users" @{
            username = $Username
        } | Select-Object -First 1 -ExpandProperty id
        Invoke-GitlabApi GET "users/$UserId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
    if ($EmailAddress) {
        $UserId = Invoke-GitlabApi GET "search" @{
            scope = 'users'
            search = $EmailAddress
        } -SiteUrl $SiteUrl -WhatIf:$WhatIf | Select-Object -First 1 -ExpandProperty id
        Invoke-GitlabApi GET "users/$UserId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
    if ($Me) {
        Invoke-GitlabApi GET 'user' -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
}

function Get-GitlabCurrentUser {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Get-GitlabUser -Me -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

function Get-GitlabGroupMembership {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )
    $User = Get-GitlabUser -Username $Username -EmailAddress $EmailAddress -SiteUrl $SiteUrl

    Invoke-GitlabApi GET "users/$($User.Id)/memberships" -MaxPages 10 -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject "Gitlab.GroupMembership"
}

function Add-GitlabUserToGroup {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupName,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        [ValidateSet("developer", "maintainer")]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter()]
        [switch]
        $WhatIf
    )
    $Group = Get-GitlabGroup -GroupId $GroupName
    $User = Get-GitlabUser -Username $Username -EmailAddress $EmailAddress
    Invoke-GitlabApi POST "groups/$($Group.Id)/members" @{
        user_id = $User.Id
        access_level = $Global:GitlabAccessLevels[$AccessLevel]
    } -WhatIf:$WhatIf | Out-Null

    if(-not $WhatIf) {
        Get-GitlabGroupMembership -Username $Username -EmailAddress $EmailAddress
    }
}

$Global:GitlabAccessLevels = @{developer = 30; maintainer = 40}
