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
        Admin = 60
    }

    if ($AccessLevel) {
        $Levels.$AccessLevel
    } else {
        $Levels
    }
}

function Get-GitlabMembershipSortKey {
    param(
    )

    @(
        @{
            Expression = 'AccessLevel'
            Descending = $true
        },
        @{
            Expression = 'Username'
            Descending = $false
        }
    )
}

function Get-GitlabGroupMember {
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId = '.',

        [Parameter()]
        [string]
        $UserId,

        [switch]
        [Parameter()]
        $IncludeInherited,

        [Parameter()]
        [string]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer', 'owner')]
        $MinAccessLevel,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $SiteUrl
    if ($UserId) {
        $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    }

    # https://docs.gitlab.com/api/members/#list-all-members-of-a-group-or-project-including-inherited-and-invited-members
    # https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
    # https://docs.gitlab.com/api/members/#get-a-member-of-a-group-or-project
    $Members = $IncludeInherited ? "members/all" : "members"
    $Resource = $User ?"groups/$($Group.Id)/$Members/$($User.Id)" : "groups/$($Group.Id)/$Members"

    $Members = Invoke-GitlabApi GET $Resource -MaxPages $MaxPages -SiteUrl $SiteUrl
    if ($MinAccessLevel) {
        $MinAccessLevelLiteral = Get-GitlabMemberAccessLevel $MinAccessLevel
        $Members = $Members | Where-Object access_level -ge $MinAccessLevelLiteral
    }

    $Members | New-WrapperObject 'Gitlab.Member' |
        Add-Member -PassThru -NotePropertyMembers @{
            GroupId = $Group.Id
        } |
        Sort-Object -Property $(Get-GitlabMembershipSortKey)
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
    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $SiteUrl

    $Request = @{
        user_id = $User.Id
        access_level = Get-GitlabMemberAccessLevel $AccessLevel
    }

    if ($PSCmdlet.ShouldProcess($Group.FullName, "grant $($User.Username) '$AccessLevel' membership")) {
        Invoke-GitlabApi POST "groups/$($Group.Id)/members" -Body $Request -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Member'
    }
}

function Remove-GitlabGroupMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Username')]
        [string]
        $UserId,
        
        [Parameter()]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Group = Get-GitlabGroup -GroupId $GroupId -SiteUrl $SiteUrl
        
    if ($PSCmdlet.ShouldProcess($Group.FullName, "remove $($User.Username)'s group membership")) {
        try {
            # https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
            Invoke-GitlabApi DELETE "groups/$($Group.Id)/members/$($User.Id)" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
            Write-Host "Removed $($User.Username) from $($Group.Name)"
        }
        catch {
            Write-Error "Error removing $($User.Username) from $($Group.Name): $_"
        }
    }
}

function Get-GitlabProjectMember {
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',
        
        [Parameter()]
        [Alias('Username')]
        [string]
        $UserId,

        [switch]
        [Parameter()]
        $IncludeInherited,
                
        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $SiteUrl

    if ($UserId) {
        $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    }

    # https://docs.gitlab.com/api/members/#list-all-members-of-a-group-or-project-including-inherited-and-invited-members
    # https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
    # https://docs.gitlab.com/api/members/#get-a-member-of-a-group-or-project
    $Members = $IncludeInherited ? "members/all" : "members"
    $Resource = $User ? "projects/$($Project.Id)/$Members/$($User.Id)" : "projects/$($Project.Id)/$Members"

    Invoke-GitlabApi GET $Resource -MaxPages $MaxPages -SiteUrl $SiteUrl |
        New-WrapperObject 'Gitlab.Member' |
        Add-Member -PassThru -NotePropertyMembers @{
            ProjectId = $Project.Id
        } |
        Sort-Object -Property $(Get-GitlabMembershipSortKey)
}

function Set-GitlabProjectMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer', 'owner')]
        [string]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Existing = $Null
    try {
        $Existing = Get-GitlabProjectMember -ProjectId @ProjectId -UserId $UserId -SiteUrl $SiteUrl
    }
    catch {
        Write-Verbose "User '$UserId' is not a member of '$ProjectId'"
    }

    if ($Existing) {
        # https://docs.gitlab.com/ee/api/members.html#edit-a-member-of-a-group-or-project
        $Request = @{
            HttpMethod = 'PUT'
            Path       = "projects/$($Existing.ProjectId)/members/$($Existing.Id)"
            Body      = @{
                access_level = Get-GitlabMemberAccessLevel $AccessLevel
            }
            SiteUrl = $SiteUrl
        }
        if ($PSCmdlet.ShouldProcess("Project '$ProjectId'", "update '$($Existing.Name)' membership to '$AccessLevel'")) {
            Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.Member'
        }
    } else {
        if ($PSCmdlet.ShouldProcess("Project '$ProjectId'", "add '$UserId' as '$AccessLevel'")) {
            Add-GitlabProjectMember -ProjectId $ProjectId -UserId $UserId -AccessLevel $AccessLevel -SiteUrl $SiteUrl
        }
    }
}

function Add-GitlabProjectMember {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer', 'owner')]
        [string]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $SiteUrl

    $Request = @{
        # https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/members"
        Body       = @{
            user_id      = $User.Id
            access_level = Get-GitlabMemberAccessLevel $AccessLevel
        }
        SiteUrl = $SiteUrl
    }

    if ($PSCmdlet.ShouldProcess($Project.PathWithNamespace, "grant '$($User.Username)' $AccessLevel membership")) {
        Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.Member'
    }
}

# https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
function Remove-GitlabProjectMember {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl
    $Project = Get-GitlabProject -ProjectId $ProjectId -SiteUrl $SiteUrl

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "Remove $($User.Username)'s membership")) {
        if ($Project.Owner.Username -eq $User.Username) {
            Write-Warning "Can't remove owner '$($User.Username)' from '$($Project.PathWithNamespace)'"
        } else {
            try {
                Invoke-GitlabApi DELETE "projects/$($Project.Id)/members/$($User.Id)" -SiteUrl $SiteUrl | Out-Null
                Write-Host "Removed $($User.Username) from $($Project.Name)"
            }
            catch {
                Write-Error "Error removing $($User.Username) from $($Project.Name): $_"
            }
        }
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

function Remove-GitlabUserMembership {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $Username,

        [Parameter()]
        $Group,

        [Parameter()]
        $Project,

        [Parameter()]
        [switch]
        $RemoveAllAccess,

        [Parameter]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -Username $Username -SiteUrl $SiteUrl

    if ($Group) {
        if ($PSCmdlet.ShouldProcess("$($Group -join ',' )", "remove $Username access from groups")) {
            $Group | ForEach-Object {
                $User | Remove-GitlabGroupMember -GroupId $_ -SiteUrl $SiteUrl
            }
        }
    }
    if ($Project) {
        if ($PSCmdlet.ShouldProcess("$($Project -join ',' )", "remove $Username access from project ")) {
            $Project | ForEach-Object {
                $User | Remove-GitlabProjectMember -ProjectId $_ -SiteUrl $SiteUrl
            }
        }
    }
    if ($RemoveAllAccess) {
        $CurrentAccess = $User | Get-GitlabUserMembership
        $Request = @{
            Group   = $CurrentAccess | Where-Object Sourcetype -eq 'Namespace' | Select-Object -ExpandProperty SourceId
            Project = $CurrentAccess | Where-Object Sourcetype -eq 'Project' | Select-Object -ExpandProperty SourceId
            SiteUrl = $SiteUrl
        }
        $User | Remove-GitlabUserMembership @Request
    }
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
