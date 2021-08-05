function Get-GitLabUser {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress
    )

    if ($Username) {
        $UserId = Invoke-GitlabApi GET "users" @{
            username = $Username
        } | Select-Object -First 1 -ExpandProperty id
        Invoke-GitlabApi GET "users/$UserId" | New-WrapperObject -DisplayType 'GitLab.User'
    }
    elseif ($EmailAddress) {
        $UserId = Invoke-GitlabApi GET "search" @{
            scope = 'users'
            search = $EmailAddress
        } | Select-Object -First 1 -ExpandProperty id
        Invoke-GitlabApi GET "users/$UserId" | New-WrapperObject -DisplayType 'GitLab.User'
    }
}

function Get-GitLabGroupMembership {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $EmailAddress
    )
    $User = Get-GitLabUser -Username $Username -EmailAddress $EmailAddress

    Invoke-GitlabApi GET "users/$($User.Id)/memberships" -MaxPages 10 |
        ForEach-Object { New-WrapperObject $_ }
}

function Add-GitLabUserToGroup {
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
    $Group = Get-GitLabGroup -GroupId $GroupName
    $User = Get-GitLabUser -Username $Username -EmailAddress $EmailAddress
    Invoke-GitlabApi POST "groups/$($Group.Id)/members" @{
        user_id = $User.Id
        access_level = $Global:GitLabAccessLevels[$AccessLevel]
    } -WhatIf:$WhatIf | Out-Null

    if(-not $WhatIf) {
        Get-GitLabGroupMembership -Username $Username -EmailAddress $EmailAddress
    }
}

$Global:GitLabAccessLevels = @{developer = 30; maintainer = 40}
