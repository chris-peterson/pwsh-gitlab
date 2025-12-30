# https://docs.gitlab.com/ee/api/members.html#valid-access-levels
function Get-GitlabMemberAccessLevel {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position=0)]
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
        if ($Levels.$AccessLevel) {
            return $Levels.$AccessLevel
        }
        if ($Levels.PSObject.Properties | Where-Object { $_.Value -eq $AccessLevel }) {
            return $AccessLevel
        }
        throw "Invalid access level '$AccessLevel'. Valid values are: ($($Levels.PSObject.Properties.Name -join ', '))"
    } else {
        $Levels
    }
}

function Get-GitlabMembershipSortKey {
    [CmdletBinding()]
    [OutputType([array])]
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
    [CmdletBinding()]
    [OutputType('Gitlab.Member')]
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
        [ValidateScript({Test-GitlabSettableAccessLevel $_})]
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

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $Group = Get-GitlabGroup -GroupId $GroupId
    if ($UserId) {
        $User = Get-GitlabUser -UserId $UserId
    }

    # https://docs.gitlab.com/api/members/#list-all-members-of-a-group-or-project-including-inherited-and-invited-members
    # https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
    # https://docs.gitlab.com/api/members/#get-a-member-of-a-group-or-project
    $Members = $IncludeInherited ? "members/all" : "members"
    $Resource = $User ?"groups/$($Group.Id)/$Members/$($User.Id)" : "groups/$($Group.Id)/$Members"

    $Members = Invoke-GitlabApi GET $Resource -MaxPages $MaxPages
    if ($MinAccessLevel) {
        $MinAccessLevelLiteral = Get-GitlabMemberAccessLevel $MinAccessLevel
        $Members = $Members | Where-Object access_level -ge $MinAccessLevelLiteral
    }

    $Members | New-GitlabObject 'Gitlab.Member' |
        Add-Member -PassThru -NotePropertyMembers @{
            GroupId = $Group.Id
        } |
        Sort-Object -Property $(Get-GitlabMembershipSortKey)
}

function Set-GitlabGroupMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    [OutputType('Gitlab.Member')]
    param(
        [Parameter()]
        [string]
        $GroupId = '.',

        [Parameter(Position=0, Mandatory)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Position=1, Mandatory)]
        [ValidateScript({Test-GitlabSettableAccessLevel $_})]
        [string]
        $AccessLevel,

        [Parameter(Mandatory)]
        [string]
        $SiteUrl
    )

    $Existing = $Null
    try {
        $Existing = Get-GitlabGroupMember -GroupId $GroupId -UserId $UserId
    }
    catch {
        Write-Verbose "User '$UserId' is not a member of group '$GroupId'"
    }

    if ($Existing) {
        # https://docs.gitlab.com/ee/api/members.html#edit-a-member-of-a-group-or-project
        $Request = @{
            HttpMethod = 'PUT'
            Path       = "groups/$($Existing.GroupId)/members/$($Existing.Id)"
            Body      = @{
                access_level = Get-GitlabMemberAccessLevel $AccessLevel
            }
        }
        if ($PSCmdlet.ShouldProcess("Group '$GroupId'", "update '$($Existing.Name)' membership to '$AccessLevel'")) {
            Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Member'
        }
    } else {
        if ($PSCmdlet.ShouldProcess("Group '$GroupId'", "add '$UserId' as '$AccessLevel'")) {
            Add-GitlabGroupMember -GroupId $GroupId -UserId $UserId -AccessLevel $AccessLevel
        }
    }
}

function Add-GitlabGroupMember {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Member')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory)]
        [string]
        $UserId,

        [Parameter(Mandatory)]
        [ValidateScript({Test-GitlabSettableAccessLevel $_})]
        [string]
        $AccessLevel,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $User    = Get-GitlabUser -UserId $UserId
    $GroupId = Resolve-GitlabGroupId $GroupId

    if ($PSCmdlet.ShouldProcess("group $GroupId", "grant $($User.Username) '$AccessLevel'")) {
        # https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
        $Request = @{
            HttpMethod = 'POST'
            Path       = "groups/$GroupId/members"
            Body = @{
                user_id      = $User.Id
                access_level = Get-GitlabMemberAccessLevel $AccessLevel
            }
        }
        Invoke-GitlabApi @Request |
            New-GitlabObject 'Gitlab.Member'
    }
}

function Remove-GitlabGroupMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
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

    $User = Get-GitlabUser -UserId $UserId

    if ($PSCmdlet.ShouldProcess($GroupId, "remove $($User.Username)'s group membership")) {
        try {
            # https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
            Invoke-GitlabApi DELETE "groups/$(Resolve-GitlabGroupId $GroupId)/members/$($User.Id)" | Out-Null
            Write-Host "Removed $($User.Username) from $GroupId"
        }
        catch {
            Write-Error "Error removing $($User.Username) from $($Group.Name): $_"
        }
    }
}

function Get-GitlabProjectMember {
    [CmdletBinding()]
    [OutputType('Gitlab.Member')]
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

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($UserId) {
        $User = Get-GitlabUser -UserId $UserId
    }

    # https://docs.gitlab.com/api/members/#list-all-members-of-a-group-or-project-including-inherited-and-invited-members
    # https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project
    # https://docs.gitlab.com/api/members/#get-a-member-of-a-group-or-project
    $Members = $IncludeInherited ? "members/all" : "members"
    $Resource = $User ? "projects/$ProjectId/$Members/$($User.Id)" : "projects/$ProjectId/$Members"

    Invoke-GitlabApi GET $Resource -MaxPages $MaxPages |
        New-GitlabObject 'Gitlab.Member' |
        Add-Member -PassThru -NotePropertyMembers @{
            ProjectId = $ProjectId
        } |
        Sort-Object -Property $(Get-GitlabMembershipSortKey)
}

function Set-GitlabProjectMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    [OutputType('Gitlab.Member')]
    param(
        [Parameter()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Position=1, Mandatory)]
        [ValidateScript({Test-GitlabSettableAccessLevel $_})]
        [string]
        $AccessLevel,

        [Parameter(Mandatory)]
        [string]
        $SiteUrl
    )

    $Existing = $Null
    try {
        $Existing = Get-GitlabProjectMember -ProjectId @ProjectId -UserId $UserId
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
        }
        if ($PSCmdlet.ShouldProcess("Project '$ProjectId'", "update '$($Existing.Name)' membership to '$AccessLevel'")) {
            Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Member'
        }
    } else {
        if ($PSCmdlet.ShouldProcess("Project '$ProjectId'", "add '$UserId' as '$AccessLevel'")) {
            Add-GitlabProjectMember -ProjectId $ProjectId -UserId $UserId -AccessLevel $AccessLevel
        }
    }
}

function Add-GitlabProjectMember {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Member')]
    param (
        [Parameter()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Position=1, Mandatory)]
        [ValidateScript({Test-GitlabSettableAccessLevel $_})]
        [string]
        $AccessLevel,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $User      = Get-GitlabUser -UserId $UserId
    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Request = @{
        # https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
        HttpMethod = 'POST'
        Path       = "projects/$ProjectId/members"
        Body       = @{
            user_id      = $User.Id
            access_level = Get-GitlabMemberAccessLevel $AccessLevel
        }
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "grant '$($User.Username)' $AccessLevel membership")) {
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Member'
    }
}

# https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project
function Remove-GitlabProjectMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
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

    $User = Get-GitlabUser -UserId $UserId
    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "Remove $($User.Username)'s membership")) {
        if ($Project.Owner.Username -eq $User.Username) {
            Write-Warning "Can't remove owner '$($User.Username)' from '$($Project.PathWithNamespace)'"
        } else {
            try {
                Invoke-GitlabApi DELETE "projects/$($Project.Id)/members/$($User.Id)" | Out-Null
                Write-Host "Removed $($User.Username) from $($Project.Name)"
            }
            catch {
                Write-Error "Error removing $($User.Username) from $($Project.Name): $_"
            }
        }
    }
}

function Get-GitlabUserMembership {
    [CmdletBinding(DefaultParameterSetName='ByUsername')]
    [OutputType('Gitlab.UserMembership')]
    param (
        [Parameter(ParameterSetName='ByUsername', Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Username,

        [Parameter(ParameterSetName='Me')]
        [switch]
        $Me,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [uint]
        $MaxPages,

        [Parameter()]
        [switch]
        $All
    )

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    if ($Me) {
        $Username = $(Get-GitlabUser -Me).Username
    }

    $User = Get-GitlabUser -Username $Username

    # https://docs.gitlab.com/ee/api/users.html#user-memberships-admin-only
    Invoke-GitlabApi GET "users/$($User.Id)/memberships" -MaxPages $MaxPages |
        New-GitlabObject 'Gitlab.UserMembership'
}

function Remove-GitlabUserMembership {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
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

        [Parameter()]
        [string]
        $SiteUrl
    )

    $User = Get-GitlabUser -Username $Username

    if ($Group) {
        if ($PSCmdlet.ShouldProcess("$($Group -join ',' )", "remove $Username access from groups")) {
            $Group | ForEach-Object {
                $User | Remove-GitlabGroupMember -GroupId $_
            }
        }
    }
    if ($Project) {
        if ($PSCmdlet.ShouldProcess("$($Project -join ',' )", "remove $Username access from project ")) {
            $Project | ForEach-Object {
                $User | Remove-GitlabProjectMember -ProjectId $_
            }
        }
    }
    if ($RemoveAllAccess) {
        $CurrentAccess = $User | Get-GitlabUserMembership
        $Request = @{
            Group   = $CurrentAccess | Where-Object Sourcetype -eq 'Namespace' | Select-Object -ExpandProperty SourceId
            Project = $CurrentAccess | Where-Object Sourcetype -eq 'Project' | Select-Object -ExpandProperty SourceId
        }
        $User | Remove-GitlabUserMembership @Request
    }
}

function Add-GitlabUserMembership {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
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
        $SiteUrl
    )

    $GroupId = Resolve-GitlabGroupId $GroupId
    $User = Get-GitlabUser -UserId $Username

    if ($PSCmdlet.ShouldProcess("group $GroupId", "add $($User.Username) to group")) {
        # https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project
        Invoke-GitlabApi POST "groups/$GroupId/members" @{
            user_id = $User.Id
            access_level = Get-GitlabMemberAccessLevel $AccessLevel
        }
    }
}

# https://docs.gitlab.com/ee/api/members.html#edit-a-member-of-a-group-or-project
function Update-GitlabUserMembership {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Group')]
    [OutputType('Gitlab.Member')]
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
            $GroupId = Resolve-GitlabGroupId $GroupId
            if ($PSCmdLet.ShouldProcess("group $GroupId", "update $($User.Username)'s membership access level to '$AccessLevel' on group")) {
                $Rows = Invoke-GitlabApi PUT "groups/$GroupId/members/$($User.Id)" @{
                    access_level = $AccessLevelLiteral
                }
            }
         }
        Project {
            $Project = Get-GitlabProject -ProjectId $ProjectId
            if ($PSCmdLet.ShouldProcess($Project.PathWithNamespace, "update $($User.Username)'s membership access level to '$AccessLevel' on project")) {
                $Rows = Invoke-GitlabApi PUT "projects/$($Project.Id)/members/$($User.Id)" @{
                    access_level = $AccessLevelLiteral
                }
            }
        }
    }

    $Rows | New-GitlabObject 'Gitlab.Member'
}
