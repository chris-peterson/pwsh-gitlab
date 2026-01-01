# https://docs.gitlab.com/ee/api/personal_access_tokens.html

function Get-GitlabPersonalAccessToken {
    [CmdletBinding(DefaultParameterSetName='Default')]
    [OutputType('Gitlab.PersonalAccessToken')]
    param(
        [Parameter(Position=0, ParameterSetName='Default')]
        [Alias('Id')]
        [string]
        $TokenId,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='Default')]
        [Alias('Username')]
        [Alias('EmailAddress')]
        [string]
        $UserId,

        [Parameter(ParameterSetName='Mine')]
        [switch]
        $Mine,

        [Parameter(ParameterSetName='Token')]
        [string]
        $Token,

        [Parameter(ParameterSetName='Self')]
        [switch]
        $Self,

        [Parameter(ParameterSetName='Default')]
        [GitlabDate()][string]
        $CreatedAfter,

        [Parameter(ParameterSetName='Default')]
        [GitlabDate()][string]
        $CreatedBefore,

        [Parameter(ParameterSetName='Default')]
        [GitlabDate()][string]
        $LastUsedAfter,

        [Parameter(ParameterSetName='Default')]
        [GitlabDate()][string]
        $LastUsedBefore,

        [Parameter(ParameterSetName='Default')]
        [string]
        [ValidateSet($null, 'active', 'inactive')]
        $State = 'active',

        [Parameter(ParameterSetName='Default')]
        [TrueOrFalse()][bool]
        $Revoked = $false,

        [Parameter()]
        [switch]
        $FetchUsers,

        [Parameter()]
        [switch]
        $ForExport,

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

    # https://docs.gitlab.com/ee/api/personal_access_tokens.html#list-personal-access-tokens
    $Request = @{
        Method   = 'GET'
        Path     = "personal_access_tokens"
        Query    = @{
            state = $State
            revoked = $Revoked
        }
        MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    }

    if ($TokenId) {
        # https://docs.gitlab.com/ee/api/personal_access_tokens.html#get-single-personal-access-token
        $Request.Path += "/$TokenId"
    }
    elseif ($Token -or $Self) {
        $Request.Path += "/self" # https://docs.gitlab.com/ee/api/personal_access_tokens.html#using-a-request-header
        if ($Token) {
            $Request.AccessToken  = $Token
        }
    }
    if ($Mine) {
        $UserId = Get-GitlabUser -Me | Select-Object -ExpandProperty Id
    }
    if ($UserId) {
        $User = Get-GitlabUser $UserId
        $Request.Query.user_id = $User.Id
    }
    if ($CreatedAfter) {
        $Request.Query.created_after = $CreatedAfter
    }
    if ($CreatedBefore) {
        $Request.Query.created_before = $CreatedBefore
    }
    if ($LastUsedAfter) {
        $Request.Query.last_used_after = $LastUsedAfter
    }
    if ($LastUsedBefore) {
        $Request.Query.last_used_before = $LastUsedBefore
    }
    $Results = Invoke-GitlabApi @Request |
        New-GitlabObject 'Gitlab.PersonalAccessToken' |
        Sort-Object LastUsedAt -Descending

    if ($FetchUsers) {
        $Users = @{}
        foreach ($Id in $Results | Where-Object { $_.UserId } | Select-Object -ExpandProperty UserId -Unique) {
            $Users[$Id] = Get-GitlabUser -Id $Id
        }
        $Results | ForEach-Object {
            if ($_.UserId -and $Users.ContainsKey($_.UserId)) {
                $_ | Add-Member -NotePropertyName 'User' -NotePropertyValue $Users[$_.UserId]
            }
        }
    }

    if ($ForExport) {
        return $Results |
            ForEach-Object {
                [pscustomobject]@{
                    Id          = $_.Id
                    Name        = $_.Name
                    Description = $_.Description
                    User        = $_.Username ?? $_.UserId
                    Scopes      = $_.ScopesDisplay
                    Active      = $_.Active
                    CreatedAt   = $_.CreatedAt.ToString('yyyy-MM-dd')
                    LastUsedAt  = $_.LastUsedAt ? $_.LastUsedAt.ToString('yyyy-MM-dd') : $null
                    ExpiresAt   = $_.ExpiresAt ? $_.ExpiresAt.ToString('yyyy-MM-dd') : $null
                }
            } |
            Sort-Object -Descending LastUsedAt
    }

    $Results
}

function New-GitlabPersonalAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.NewPersonalAccessToken')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [ValidateSet('api', 'read_user', 'read_api', 'read_repository', 'write_repository', 'read_registry', 'write_registry', 'sudo', 'admin_mode', 'create_runner', 'manage_runner', 'ai_features', 'k8s_proxy', 'read_service_ping')]
        [string []]
        $Scope,

        [Parameter()]
        [GitlabDate()][string]
        $ExpiresAt,

        [Parameter()]
        [uint]
        $ExpireInMonths,

        [switch]
        [Parameter()]
        $CopyToClipboard,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($UserId) {
        $User = Get-GitlabUser $UserId
    } else {
        $User = Get-GitlabUser -Me
    }

    $Request = @{
        # https://docs.gitlab.com/ee/api/users.html#create-a-personal-access-token
        Method   = 'POST'
        Path     = "users/$($User.Id)/personal_access_tokens"
        Body     = @{
            name   = $Name
            scopes = $Scope
        }
    }
    if ($ExpireInMonths) {
        $Request.Body.expires_at = (Get-Date).AddMonths($ExpireInMonths).ToString('yyyy-MM-dd')
    }
    elseif ($ExpiresAt) {
        $Request.Body.expires_at = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess("$($Request.Path)", "create personal access token $($Request | ConvertTo-Json)")) {
        $Response = Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.NewPersonalAccessToken'
        if ($CopyToClipboard) {
            $Response.Token | Set-Clipboard
        } else {
            $Response
        }
    }
}

function Invoke-GitlabPersonalAccessTokenRotation {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.NewPersonalAccessToken')]
    [Alias('Rotate-GitlabPersonalAccessToken')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [Alias('Id')]
        [string]
        $TokenId,

        [Parameter()]
        [GitlabDate()][string]
        $ExpiresAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Request = @{
        # https://docs.gitlab.com/api/personal_access_tokens/#rotate-a-personal-access-token
        Method  = 'POST'
        Path    = "personal_access_tokens/$($TokenId)/rotate"
        Body    = @{}
    }
    if ($ExpiresAt) {
        $Request.Body.expires_at = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess("$($Request.Path)", "rotate personal access token")) {
        $Response = Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.NewPersonalAccessToken'
        Set-Clipboard -Value $Response.Token
        Write-Warning "Updated personal access token copied to clipboard"
        $Response
    }
}

function Revoke-GitlabPersonalAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    [Alias('Remove-GitlabPersonalAccessToken')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [Alias('Id')]
        [string]
        $TokenId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Request = @{
        # https://docs.gitlab.com/ee/api/personal_access_tokens.html#revoke-a-personal-access-token
        Method  = 'DELETE'
        Path    = "personal_access_tokens/$($TokenId)"
    }

    if ($PSCmdlet.ShouldProcess("$($Request.Path)", "revoke personal access token")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Revoked personal access token $TokenId"
    }
}
