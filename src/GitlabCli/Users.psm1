function Get-GitlabUser {
    [CmdletBinding(DefaultParameterSetName='Filter')]
    [OutputType('Gitlab.User')]
    param (
        [Parameter(ParameterSetName='Id', Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Alias('Username')]
        [Alias('EmailAddress')]
        [string]
        $UserId,

        [Parameter(ParameterSetName='Filter')]
        [switch]
        $Active,

        [Parameter(ParameterSetName='Filter')]
        [switch]
        $External,

        [Parameter(ParameterSetName='Filter')]
        [switch]
        $Blocked,

        [Parameter(ParameterSetName='Filter')]
        [switch]
        $ExcludeActive,

        [Parameter(ParameterSetName='Filter')]
        [switch]
        $ExcludeExternal,

        [Parameter()]
        [uint]
        $MaxPages = 1,

        [switch]
        [Parameter()]
        $All,

        [Parameter(ParameterSetName='Me')]
        [switch]
        $Me,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Parameters = @{
        MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
        Method   = 'GET'
        Path     = 'users' # https://docs.gitlab.com/ee/api/users.html#for-non-administrator-users
        Query    = @{}
    }

    if ($Active) {
        $Parameters.Query.active = 'true'
    }
    elseif ($ExcludeActive) {
        $Parameters.Query.exclude_active = 'true'
    }
    if ($External) {
        $Parameters.Query.external = 'true'
    }
    if ($ExcludeExternal) {
        $Parameters.Query.exclude_external = 'true'
    }
    if ($Blocked) {
        $Parameters.Query.blocked = 'true'
    }
    if ($PSCmdlet.ParameterSetName -eq 'Id') {
        if ($UserId -match '@') {
            $Parameters.Query.search = $UserId
        }
        else {
            if ([uint]::TryParse($UserId, [ref] $null)) {
                $Parameters.Path = "users/$UserId" # https://docs.gitlab.com/ee/api/users.html#single-user
            }
            else {
                $Parameters.Query.username = $UserId
            }
        }
    } elseif ($Me) {
        $Parameters.Path = 'user' # https://docs.gitlab.com/ee/api/users.html#for-non-administrator-users
    }

    Invoke-GitlabApi @Parameters | New-GitlabObject 'Gitlab.User'
}

function Block-GitlabUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([void])]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Alias('Username')]
        [Alias('EmailAddress')]
        [string]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $User = Get-GitlabUser $UserId

    if ($PSCmdlet.ShouldProcess("$($User.Username)", "block user")) {
        $Parameters = @{
            # https://docs.gitlab.com/ee/api/users.html#block-user
            Method  = 'POST'
            Path    = "users/$($User.Id)/block"
        }
        if (Invoke-GitlabApi @Parameters) {
            Write-Host "$($User.Username) blocked"
        }
    }
}

function Unblock-GitlabUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([void])]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Alias('Username')]
        [Alias('EmailAddress')]
        [string]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $User = Get-GitlabUser $UserId

    if ($PSCmdlet.ShouldProcess("$($User.Username)", "unblock user")) {
        $Parameters = @{
            # https://docs.gitlab.com/ee/api/users.html#unblock-user
            Method  = 'POST'
            Path    = "users/$($User.Id)/unblock"
        }
        if (Invoke-GitlabApi @Parameters) {
            Write-Host "$($User.Username) unblocked"
        }
    }
}

function Remove-GitlabUser {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [int]
        [Alias('Id')]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    )

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    $Request = @{
        # https://docs.gitlab.com/api/users/#delete-a-user
        HttpMethod = 'DELETE'
        Path       = "users/$UserId"
    }
    if ($PSCmdlet.ShouldProcess($UserId, 'delete user')) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "User '$UserId' deleted"
    }
}

function Get-GitlabUserEvent {
    [CmdletBinding(DefaultParameterSetName='ByUserId')]
    [OutputType('Gitlab.Event')]
    param (
        [Parameter(ParameterSetName='ByUserId')]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(ParameterSetName='ByEmail')]
        [string]
        $EmailAddress,

        [Parameter(ParameterSetName='ByMe')]
        [switch]
        $Me,

        [Parameter()]
        [ValidateSet('approved', 'closed', 'commented', 'created', 'destroyed', 'expired', 'joined', 'left', 'merged', 'pushed', 'reopened', 'updated')]
        [string]
        $Action,

        [Parameter()]
        [ValidateSet('epic','issue', 'merge_request', 'milestone', 'note', 'project', 'snippet', 'user')]
        [string]
        $TargetType,

        [Parameter()]
        [GitlabDate()][string]
        $Before,

        [Parameter()]
        [GitlabDate()][string]
        $After,

        [Parameter()]
        [ValidateSet([SortDirection])]
        [string]
        $Sort,

        [Parameter()]
        [uint]
        $MaxPages = 1,

        [Parameter()]
        [switch]
        $FetchProjects,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $GetUserParams = @{}

    if ($Me) {
        $GetUserParams.UserId = $(Get-GitlabUser -Me).Id
    }
    elseif($PSCmdlet.ParameterSetName -eq 'ByUserId') {
        $GetUserParams.UserId = $UserId
    }
    elseif ($PSCmdLet.ParameterSetName -eq 'ByEmail') {
        $GetUserParams.UserId = $EmailAddress
    }
    else {
        throw "Invalid parameter combination"
    }

    $User = Get-GitlabUser @GetUserParams

    $Query = @{}
    if($Before) {
        $Query.before = $Before
    }
    if($After) {
        $Query.after = $After
    }
    if($Action) {
        $Query.action = $Action
    }
    if($TargetType) {
        $Query.target_type = $TargetType
    }
    if($Sort) {
        $Query.sort = $Sort
    }

    # https://docs.gitlab.com/ee/api/events.html#get-user-contribution-events
    $Events = Invoke-GitlabApi GET "users/$($User.Id)/events" -Query $Query -MaxPages $MaxPages |
        New-GitlabObject 'Gitlab.Event'

    if ($FetchProjects) {
        $ProjectIds = $Events.ProjectId | Select-Object -Unique
        $Projects = $ProjectIds | ForEach-Object {
            try {
                Get-GitlabProject $_
            }
            catch {
                $null
            }
        }
        $Events | ForEach-Object {
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'Project' -Value $($Projects | Where-Object Id -eq $_.ProjectId)
        }
    }

    $Events
}

function Get-GitlabCurrentUser {
    [CmdletBinding()]
    [OutputType('Gitlab.User')]
    param (
        [Parameter()]
        [string]
        $SiteUrl
    )

    Get-GitlabUser -Me
}

function Start-GitlabUserImpersonation {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Alias('Username')]
        [Alias('EmailAddress')]
        [string]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $User = Get-GitlabUser $UserId

    if ((Get-GitlabUser -Me | Select-Object -ExpandProperty Id) -eq $User.Id) {
        Write-Verbose "Ignoring impersonation request for current user ($($User.Username))"
        return
    }

    # https://docs.gitlab.com/ee/api/users.html#create-an-impersonation-token
    $Parameters = @{
        Method  = 'POST'
        Path    = "users/$($User.Id)/impersonation_tokens"
        Body = @{
            name = "pwsh-gitlab temporary impersonation token $($User.Username)"
            expires_at = (Get-Date).AddDays(1).ToString('yyyy-MM-dd')
            scopes = @('api', 'read_user')
        }
    }
    if ($PSCmdlet.ShouldProcess("$($User.Username)", "start impersonation")) {

        if ($global:GitlabUserImpersonationSession) {
            Write-Error "Impersonation session already started by $($global:GitlabUserImpersonationSession.StartedBy).  Call 'Stop-GitlabUserImpersonation' before attempting a new session."
        }

        $Result = Invoke-GitlabApi @Parameters
        $global:GitlabUserImpersonationSession = @{
            Id       = $Result.id
            UserId   = $Result.user_id
            Username = $User.Username
            Token    = $Result.token
        }
    }
}

function Stop-GitlabUserImpersonation {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("Impersonation session for $($global:GitlabUserImpersonationSession.Username)", "stop")) {
        if ($global:GitlabUserImpersonationSession) {
            # https://docs.gitlab.com/ee/api/users.html#revoke-an-impersonation-token
            $Parameters = @{
                Method  = 'DELETE'
                Path    = "users/$($global:GitlabUserImpersonationSession.UserId)/impersonation_tokens/$($global:GitlabUserImpersonationSession.Id)"
            }
            # NOTE: important that we clear first as the revoke API requires admin
            $global:GitlabUserImpersonationSession = $null
            try {
                if (Invoke-GitlabApi @Parameters) {
                    Write-Host "Impersonation session ($($global:GitlabUserImpersonationSession.Username)) stopped"
                }
            }
            catch {
                switch ($ErrorActionPreference){
                    'Stop' { throw $_ }
                    default { Write-Warning "Error stopping impersonation session: $_"; return $null }
                }
            }
        }
        else {
            Write-Verbose "No impersonation session started.  Call 'Start-GitlabUserImpersonation' to start one."
        }
    }
}
