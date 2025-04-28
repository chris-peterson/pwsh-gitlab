# https://docs.gitlab.com/ee/api/personal_access_tokens.html

function Get-GitlabPersonalAccessToken {
    [CmdletBinding(DefaultParameterSetName='Default')]
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
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $CreatedAfter,

        [Parameter(ParameterSetName='Default')]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $CreatedBefore,

        [Parameter(ParameterSetName='Default')]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $LastUsedAfter,

        [Parameter(ParameterSetName='Default')]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $LastUsedBefore,

        [Parameter(ParameterSetName='Default')]
        [string]
        [ValidateSet($null, 'active', 'inactive')]
        $State = 'active',

        [Parameter(ParameterSetName='Default')]
        [ValidateSet($null, 'true', 'false')]
        [string]
        $Revoked = 'false',

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
        MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
        SiteUrl  = $SiteUrl
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
    Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.PersonalAccessToken' | ForEach-Object {
        if ($_.ExpiresAt) {
            $ExpiresAt = [datetime]::Parse($_.ExpiresAt)
            $_.PSObject.Properties.Remove('ExpiresAt')
            $_ | Add-Member -NotePropertyMembers @{
                ExpiresAt = $ExpiresAt
            }
        }
        $_
    } | Sort-Object LastUsedAtSortable -Descending
}

function New-GitlabPersonalAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Username')]
        [string]
        $UserId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('api', 'read_user', 'read_api', 'read_repository', 'write_repository', 'read_registry', 'write_registry', 'sudo', 'admin_mode', 'create_runner', 'manage_runner', 'ai_features', 'k8s_proxy', 'read_service_ping')]
        [string []]
        $Scope,

        [Parameter()]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
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
        SiteUrl  = $SiteUrl
    }
    if ($ExpireInMonths) {
        $Request.Body.expires_at = (Get-Date).AddMonths($ExpireInMonths).ToString('yyyy-MM-dd')
    }
    elseif ($ExpiresAt) {
        $Request.Body.expires_at = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess("$($Request.Path)", "create personal access token $($Request | ConvertTo-Json)")) {
        $Response = Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.NewPersonalAccessToken'
        if ($CopyToClipboard) {
            $Response.Token | Set-Clipboard
        } else {
            $Response
        }
    }
}

function Invoke-GitlabPersonalAccessTokenRotation {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('Rotate-GitlabPersonalAccessToken')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [Alias('Id')]
        [string]
        $TokenId,

        [Parameter()]
        [string]
        [ValidateScript({ValidateGitlabDateFormat $_})]
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
        SiteUrl = $SiteUrl
    }
    if ($ExpiresAt) {
        $Request.Body.expires_at = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess("$($Request.Path)", "rotate personal access token")) {
        $Response = Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.NewPersonalAccessToken'
        Set-Clipboard -Value $Response.Token
        Write-Warning "Updated personal access token copied to clipboard"
        $Response
    }
}

function Revoke-GitlabPersonalAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
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
        SiteUrl = $SiteUrl
    }

    if ($PSCmdlet.ShouldProcess("$($Request.Path)", "revoke personal access token")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Revoked personal access token $TokenId"
    }
}
