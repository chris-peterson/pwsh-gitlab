function Get-GitlabUser {
    [CmdletBinding(DefaultParameterSetName='Id')]
    param (
        [Parameter(ParameterSetName='Id', Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Alias('Username')]
        [Alias('EmailAddress')]
        [string]
        $UserId,

        [Parameter(ParameterSetName='Me')]
        [switch]
        $Me,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $Parameters = @{
        Method  = 'GET'
        Path    = 'users' # https://docs.gitlab.com/ee/api/users.html#for-non-administrator-users
        Query   = @{}
        SiteUrl = $SiteUrl
    }
    if ($Me) {
        $Parameters.Path = 'user' # https://docs.gitlab.com/ee/api/users.html#for-non-administrator-users
    }
    elseif ($UserId -match '@') {
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
    Invoke-GitlabApi @Parameters | New-WrapperObject 'Gitlab.User'
}

# https://docs.gitlab.com/ee/api/events.html#get-user-contribution-events
function Get-GitlabUserEvent {
    [CmdletBinding(DefaultParameterSetName='ByUserId')]
    param (
        [Parameter(ParameterSetName='ByUserId', Mandatory=$false)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(ParameterSetName='ByEmail', Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter(ParameterSetName='ByMe', Mandatory=$False)]
        [switch]
        $Me,

        [Parameter(Mandatory=$False)]
        [ValidateSet('approved', 'closed', 'commented', 'created', 'destroyed', 'expired', 'joined', 'left', 'merged', 'pushed', 'reopened', 'updated')]
        [string]
        $Action,

        [Parameter(Mandatory=$False)]
        [ValidateSet('issue', 'milestone', 'merge_request', 'note', 'project', 'snippet', 'user')]
        [string]
        $TargetType,

        [Parameter(Mandatory=$False)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $Before,

        [Parameter(Mandatory=$False)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $After,

        [Parameter(Mandatory=$False)]
        [ValidateSet('asc', 'desc')]
        [string]
        $Sort,

        [Parameter(Mandatory=$False)]
        [uint]
        $MaxPages = 1,

        [Parameter(Mandatory=$False)]
        [switch]
        $FetchProjects,

        [Parameter(Mandatory=$False)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GetUserParams = @{}
    
    if($PSCmdlet.ParameterSetName -eq 'ByUserId') {
        $GetUserParams.UserId = $UserId
    } 
    
    if ($PSCmdLet.ParameterSetName -eq 'ByEmail') {
        $GetUserParams.UserId = $EmailAddress
    }

    if($PSCmdlet.ParameterSetName -eq 'ByMe') {
        $GetUserParams.Me = $true
    }

    $User = Get-GitlabUser @GetUserParams -SiteUrl $SiteUrl

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
    if($Sort) {
        $Query.sort = $Sort
    }

    $Events = Invoke-GitlabApi GET "users/$($User.Id)/events" -Query $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Event'

    if ($FetchProjects) {
        $ProjectIds = $Events.ProjectId | Select-Object -Unique
        $Projects = $ProjectIds | ForEach-Object {
            try {
                Get-GitlabProject $_ -WhatIf:$WhatIf -SiteUrl $SiteUrl
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
    param (
        [Parameter()]
        [string]
        $SiteUrl
    )

    Get-GitlabUser -Me -SiteUrl $SiteUrl
}
