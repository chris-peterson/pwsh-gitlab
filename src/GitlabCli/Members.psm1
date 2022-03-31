# https://docs.gitlab.com/ee/api/members.html#valid-access-levels
function Get-GitlabMemberAccessLevel {

    [PSCustomObject]@{
        NoAccess = 0
        MinimalAccess = 5
        Guest = 10
        Reporter = 20
        Developer = 30
        Maintainer = 40
        Owner = 50
    }
}


# https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
function Get-GitlabGroupMember {
    param (
        [Parameter(Position=0)]
        [string]
        $GroupId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $UserId,

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

    if ($UserId) {
        $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl -WhatIf:$false
    }

    $Resource = $User ? "groups/$($Group.Id)/members/$($User.Id)" : "groups/$($Group.Id)/members"

    Invoke-GitlabApi GET $Resource -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Member'
}


# https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
function Get-GitlabProjectMember {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $UserId,

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

    if ($UserId) {
        $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl -WhatIf:$false
    }

    $Resource = $User ? "projects/$($Project.Id)/members/$($User.Id)" : "projects/$($Project.Id)/members"

    Invoke-GitlabApi GET $Resource -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Member'
}

# https://docs.gitlab.com/ee/api/users.html#user-memberships-admin-only
function Get-GitlabUserMembership {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Username,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $User = Get-GitlabUser -Username $Username -SiteUrl $SiteUrl

    Invoke-GitlabApi GET "users/$($User.Id)/memberships" -MaxPages 10 -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.UserMembership'
}

# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
function Add-GitlabUserMembership {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Username,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Position=2, Mandatory=$true)]
        [string]
        [ValidateSet('developer', 'maintainer', 'owner')]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $WhatIf
    )

    $Group = Get-GitlabGroup -GroupId $GroupId
    $User = Get-GitlabUser -UserId $Username

    Invoke-GitlabApi POST "groups/$($Group.Id)/members" @{
        user_id = $User.Id
        access_level = $(Get-GitlabMemberAccessLevel)."$AccessLevel"
    }  -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    Write-Host "$($User.Username) added to $($Group.FullPath)"
}

# https://docs.gitlab.com/ee/api/members.html#edit-a-member-of-a-group-or-project
function Update-GitlabUserMembership {
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Username,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Position=2, Mandatory=$true)]
        [string]
        [ValidateSet('developer', 'maintainer', 'owner')]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $WhatIf
    )

    $Group = Get-GitlabGroup -GroupId $GroupId
    $User = Get-GitlabUser -UserId $Username

    Invoke-GitlabApi PUT "groups/$($Group.Id)/members/$($User.Id)" @{
        access_level = $(Get-GitlabMemberAccessLevel)."$AccessLevel"
    }  -SiteUrl $SiteUrl -WhatIf:$WhatIf |
    New-WrapperObject 'Gitlab.Member'
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
