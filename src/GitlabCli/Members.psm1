# https://docs.gitlab.com/ee/api/members.html#valid-access-levels
function Get-GitlabMemberAccessLevel {

    param(
        [Parameter(Position=0)]
        [string]
        $AccessLevel
    )

    $Levels = [PSCustomObject]@{
        NoAccess = 0
        MinimalAccess = 5
        Guest = 10
        Reporter = 20
        Developer = 30
        Maintainer = 40
        Owner = 50
    }

    if ($AccessLevel) {
        $Levels.$AccessLevel
    } else {
        $Levels
    }
}

# https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
function Get-GitlabGroupMember {
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $UserId,

        [switch]
        [Parameter(Mandatory=$false)]
        $All,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer', 'owner')]
        $MinAccessLevel,

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
        $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    }

    $Members = $All ? "members/all" : "members"
    $Resource = $User ? "groups/$($Group.Id)/$Members/$($User.Id)" : "groups/$($Group.Id)/$Members"

    $Members = Invoke-GitlabApi GET $Resource -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf
    if ($MinAccessLevel) {
        $MinAccessLevelLiteral = Get-GitlabMemberAccessLevel $MinAccessLevel
        $Members = $Members | Where-Object access_level -ge $MinAccessLevelLiteral
    }

    $Members | New-WrapperObject 'Gitlab.Member'
}

# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
function Add-GitlabGroupMember {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory)]
        [string]
        $UserId,

        [Parameter(Mandatory)]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer')]
        [string]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $SiteUrl -WhatIf:$false

    $Request = @{
        user_id = $User.Id
        access_level = Get-GitlabMemberAccessLevel $AccessLevel
    }

    if ($PSCmdlet.ShouldProcess($Group.FullName, "grant $($User.Username) '$AccessLevel' membership")) {
        Invoke-GitlabApi POST "groups/$($Group.Id)/members" -Body $Request -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Member'
    }
}

# https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
function Remove-GitlabGroupMember {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $SiteUrl

    if ($PSCmdlet.ShouldProcess($Group.FullName, "remove $($User.Username)'s group membership")) {
        try {
            Invoke-GitlabApi DELETE "groups/$($Group.Id)/members/$($User.Id)" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
            Write-Host "Removed $($User.Username) from $($Group.Name)"
        }
        catch {
            Write-Error "Error removing $($User.Username) from $($Group.Name): $_"
        }
    }
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

        [switch]
        [Parameter(Mandatory=$false)]
        $All,

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
        $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    }

    $Members = $All ? "members/all" : "members"
    $Resource = $User ? "projects/$($Project.Id)/$Members/$($User.Id)" : "projects/$($Project.Id)/$Members"

    Invoke-GitlabApi GET $Resource -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Member'
}

# https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
function Add-GitlabProjectMember {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $UserId,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer')]
        [string]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $SiteUrl -WhatIf:$false

    $Query = @{
        user_id = $User.Id
        access_level = Get-GitlabMemberAccessLevel $AccessLevel
    }
    Invoke-GitlabApi POST "projects/$($Project.Id)/members" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Member'
}

# https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
function Remove-GitlabProjectMember {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $UserId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $SiteUrl -WhatIf:$false

    try {
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/members/$($User.Id)" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
        Write-Host "Removed $($User.Username) from $($Project.Name)"
    }
    catch {
        Write-Error "Error removing $($User.Username) from $($Project.Name): $_"
    }
}

# https://docs.gitlab.com/ee/api/users.html#user-memberships-admin-only
function Get-GitlabUserMembership {
    [CmdletBinding(DefaultParameterSetName='ByUsername')]
    param (
        [Parameter(ParameterSetName='ByUsername', Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Username,

        [Parameter(ParameterSetName='Me')]
        [switch]
        $Me,

        [Parameter]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if ($Me) {
        $Username = $(Get-GitlabUser -Me).Username
    }

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
        access_level = Get-GitlabMemberAccessLevel $AccessLevel
    }  -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    Write-Host "$($User.Username) added to $($Group.FullPath)"
}

# https://docs.gitlab.com/ee/api/members.html#edit-a-member-of-a-group-or-project
function Update-GitlabUserMembership {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Group')]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Username,

        [Parameter(ParameterSetName='Group', Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(ParameterSetName='Project', Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        [ValidateSet('developer', 'maintainer', 'owner')]
        $AccessLevel,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -UserId $Username

    $Rows = @()

    $AccessLevelLiteral = Get-GitlabMemberAccessLevel $AccessLevel

    switch ($PSCmdlet.ParameterSetName) {
        Group {
            $Group = Get-GitlabGroup -GroupId $GroupId
            if ($PSCmdLet.ShouldProcess($Group.FullName, "update $($User.Username)'s membership access level to '$AccessLevel' on group")) {
                $Rows = Invoke-GitlabApi PUT "groups/$($Group.Id)/members/$($User.Id)" @{
                    access_level = $AccessLevelLiteral
                } -SiteUrl $SiteUrl
            }
         }
        Project {
            $Project = Get-GitlabProject -ProjectId $ProjectId
            if ($PSCmdLet.ShouldProcess($Project.PathWithNamespace, "update $($User.Username)'s membership access level to '$AccessLevel' on project")) {
                $Rows = Invoke-GitlabApi PUT "projects/$($Project.Id)/members/$($User.Id)" @{
                    access_level = $AccessLevelLiteral
                }  -SiteUrl $SiteUrl
            }
        }
    }

    $Rows | New-WrapperObject 'Gitlab.Member'
}
