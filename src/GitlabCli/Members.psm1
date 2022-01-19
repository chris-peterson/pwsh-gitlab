$global:GitlabAccessLevels = @{developer = 30; maintainer = 40}

# https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
function Get-GitlabGroupMember {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 10,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $SiteUrl -WhatIf:$false

    Invoke-GitlabApi GET "groups/$($Group.Id)/members" -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf
}


# https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
function Get-GitlabProjectMember {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 10,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $SiteUrl -WhatIf:$false

    Invoke-GitlabApi GET "projects/$($Project.Id)/members" -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

# https://docs.gitlab.com/ee/api/users.html#user-memberships-admin-only
function Get-GitlabUserMembership {
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
    $User = Get-GitlabUser -Username $Username -EmailAddress $EmailAddress -SiteUrl $SiteUrl -WhatIf:$WhatIf

    Invoke-GitlabApi GET "users/$($User.Id)/memberships" -MaxPages 10 -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject "Gitlab.GroupMembership"
}

# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
function Add-GitlabUserToGroup {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        [ValidateSet('developer', 'maintainer')]
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
    $Group = Get-GitlabGroup -GroupId $GroupId
    $User = Get-GitlabUser -Username $Username -EmailAddress $EmailAddress

    Invoke-GitlabApi POST "groups/$($Group.Id)/members" @{
        user_id = $User.Id
        access_level = $global:GitlabAccessLevels[$AccessLevel]
    } -WhatIf:$WhatIf | Out-Null

    Get-GitlabUserMembership -Username $Username -EmailAddress $EmailAddress -WhatIf:$WhatIf
}

# https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
function Remove-GitlabProjectMember {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true)]
        [string]
        $UserId,

        [Parameter()]
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $User = Get-GitlabUser -Username $UserId

    Invoke-GitlabApi DELETE "projects/$($Project.Id)/members/$($User.Id)" -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
