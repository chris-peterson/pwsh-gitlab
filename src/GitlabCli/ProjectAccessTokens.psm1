<#
.SYNOPSIS
Get the projects access tokens

.DESCRIPTION
When no tokenid is specificed, it will return all of the tokens for the project

.PARAMETER ProjectId
 The ID or URL-encoded path of the project.

.PARAMETER TokenId
  The ID of the access token to get details of.

.PARAMETER CreatedAfter
  Return only tokens created after the given time.

.PARAMETER CreatedBefore
  Return only tokens created before the given time.

.PARAMETER ExpiresAfter
  Return only tokens that expire after the given time.

.PARAMETER ExpiresBefore
  Return only tokens that expire before the given time.

.PARAMETER LastUsedAfter
  Return only tokens last used after the given time.

.PARAMETER LastUsedBefore
  Return only tokens last used before the given time.

.PARAMETER Revoked
  Return only tokens that are revoked or not.

.PARAMETER Search
  Return only tokens with names matching the search criteria.

.PARAMETER Sort 
  Return tokens sorted by the specified criteria. Default is 'created_desc'.
  One of: created_asc, created_desc, expires_asc, expires_desc, last_used_asc, last_used_desc, name_asc, name_desc

.PARAMETER State
  Return only tokens with the specified state. One of: active, inactive

.PARAMETER SiteUrl
  The URL of the Gitlab instance. If not provided, the default will be used.

.LINK
 https://docs.gitlab.com/ee/api/project_access_tokens.html
 https://docs.gitlab.com/ee/api/project_access_tokens.html#list-project-access-tokens
#>
function Get-GitlabProjectAccessToken {
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='All')]
    [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='ByTokenId')]
    [string]
    $ProjectId,

    [Parameter(Mandatory=$true, ParameterSetName='ByTokenId')]
    [string]
    $TokenId,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [DateTime]
    $CreatedAfter,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [DateTime]
    $CreatedBefore,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [DateTime]
    $ExpiresAfter,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [DateTime]
    $ExpiresBefore,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [DateTime]
    $LastUsedAfter,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [DateTime]
    $LastUsedBefore,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [TrueOrFalse()][bool]
    $Revoked,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [string]
    $Search,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [ValidateSet('created_asc', 'created_desc', 'expires_asc', 'expires_desc', 'last_used_asc', 'last_used_desc', 'name_asc', 'name_desc')]
    [string]
    $Sort,

    [Parameter(Mandatory=$false, ParameterSetName='All')]
    [ValidateSet('active', 'inactive')]
    [string]
    $State,

    [Parameter(Mandatory=$false)]
    [string]
    $SiteUrl
  )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabAPIParams = @{
      Method  = 'GET'
      Path     = "projects/$($Project.Id)/access_tokens"
      Query   = @{}
    }

    if($TokenId) {
      $GitlabAPIParams.Path += "/$TokenId"
    }

    if($CreatedAfter) { $GitlabAPIParams.Query.created_after = $CreatedAfter.ToString('o') }
    if($CreatedBefore) { $GitlabAPIParams.Query.created_before = $CreatedBefore.ToString('o') }
    if($ExpiresAfter) { $GitlabAPIParams.Query.expires_after = $ExpiresAfter.ToString('o') }
    if($ExpiresBefore) { $GitlabAPIParams.Query.expires_before = $ExpiresBefore.ToString('o') }
    if($LastUsedAfter) { $GitlabAPIParams.Query.last_used_after = $LastUsedAfter.ToString('o') }
    if($LastUsedBefore) { $GitlabAPIParams.Query.last_used_before = $LastUsedBefore.ToString('o') }
    if($PSBoundParameters.ContainsKey('Revoked')) { $GitlabAPIParams.Query.revoked = $Revoked }
    if($Search) { $GitlabAPIParams.Query.search = $Search }
    if($Sort) { $GitlabAPIParams.Query.sort = $Sort }
    if($State) { $GitlabAPIParams.Query.state = $State }

    If($PSCmdlet.ShouldProcess($GitlabAPIParams.Path,"Get Project Access Tokens")) {
      Invoke-GitlabApi @GitlabAPIParams | New-GitlabObject 'Gitlab.AccessToken'
    }
}

<# 
.SYNOPSIS
Creates a project access token

.DESCRIPTION
Create a project access token. You must have the Maintainer role or higher to create project access tokens.

.PARAMETER ProjectId
The ID or URL-encoded path of the project.

.PARAMETER Name
The name of the access token.

.PARAMETER Description
A description for the access token.

.PARAMETER Scopes
The scopes that the access token will have. At least one scope must be provided. One or more of: 'api', 'read_api', 'read_repository', 'write_repository', 'read_registry', 'write_registry', 'create_runner', 'manage_runner', 'ai_features', 'k8s_proxy', 'self_rotate'.

.PARAMETER AccessLevel
The access level that the token will have. One of: 'guest', 'reporter', 'developer', 'maintainer', 'owner'. If not provided, the default is 'maintainer'.

.PARAMETER ExpiresAt
The date the token will expire. If not provided, the token will expire at the maximum allowable lifetime limit

.PARAMETER SiteUrl
The URL of the Gitlab instance. If not provided, the default will be used.

.LINK
 https://docs.gitlab.com/ee/api/project_access_tokens.html
 https://docs.gitlab.com/ee/api/project_access_tokens.html#create-a-project-access-token
 https://docs.gitlab.com/user/profile/personal_access_tokens/#access-token-expiration
#>
function New-GitlabProjectAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter(Mandatory)]
        [ValidateSet('api', 'read_api', 'read_repository', 'write_repository', 'read_registry', 'write_registry', 'create_runner', 'manage_runner', 'ai_features', 'k8s_proxy', 'self_rotate')]
        [string[]]
        $Scopes,

        [Parameter()]
        [ValidateSet('guest', 'planner', 'reporter', 'developer', 'maintainer', 'owner')]
        [string]
        $AccessLevel,

        [Parameter()]
        [DateTime]
        $ExpiresAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabAPIParams = @{
      Method  = 'POST'
      Path     = "projects/$($Project.Id)/access_tokens"
      Body   = @{
        name        = $Name
        scopes     = $Scopes
      }
    }

    if($Description) { $GitlabAPIParams.Body.description = $Description }
    if($AccessLevel) { $GitlabAPIParams.Body.access_level = (Get-gitlabMemberAccessLevel).$AccessLevel }
    if($ExpiresAt) { $GitlabAPIParams.Body.expires_at = $ExpiresAt.ToString('o') }

    If($PSCmdlet.ShouldProcess($GitlabAPIParams.Path,"Create Project Access Token")) {
      Invoke-GitlabApi @GitlabAPIParams | New-GitlabObject 'Gitlab.AccessToken'
    }
}

<#
.SYNOPSIS
Rotate a project access token

.DESCRIPTION
Rotate a project access token. This will invalidate the old token and create a new one with the same scopes and access level.

.PARAMETER ProjectId
The ID or URL-encoded path of the project.

.PARAMETER TokenId
The ID of the access token to rotate.

.PARAMETER ExpiresAt
The date the new token will expire. If not provided, the token will expire at the maximum allowable lifetime limit

.PARAMETER SiteUrl
The URL of the Gitlab instance. If not provided, the default will be used.

.LINK
 https://docs.gitlab.com/ee/api/project_access_tokens.html
 https://docs.gitlab.com/ee/api/project_access_tokens.html#rotate-a-project-access-token
 https://docs.gitlab.com/user/profile/personal_access_tokens/#access-token-expiration
#>
function Invoke-GitlabProjectAccessTokenRotation {
    [Alias('Rotate-GitlabProjectAccessToken')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true)]
        [string]
        $TokenId,

        [Parameter()]
        [DateTime]
        $ExpiresAt,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    $GitlabAPIParams = @{
      Method  = 'POST'
      Path     = "projects/$($Project.Id)/access_tokens/$TokenId/rotate"
    }

    if($ExpiresAt) { 
      $GitlabAPIParams.Body = @{ expires_at = $ExpiresAt.ToString('o') } 
    }
    
    if($PSCmdlet.ShouldProcess($GitlabAPIParams.Path,"Rotate Project Access Token")) {
      Invoke-GitlabApi @GitlabAPIParams | New-GitlabObject 'Gitlab.AccessToken'
    }
}

<# 
.SYNOPSIS
Revoke a project access token

.DESCRIPTION
Revoke a project access token. This will invalidate the token and it can no longer be used.

.PARAMETER ProjectId
The ID or URL-encoded path of the project.

.PARAMETER TokenId
The ID of the access token to revoke.

.PARAMETER SiteUrl
The URL of the Gitlab instance. If not provided, the default will be used.

.LINK
 https://docs.gitlab.com/ee/api/project_access_tokens.html
 https://docs.gitlab.com/ee/api/project_access_tokens.html#revoke-a-project-access-token
 https://docs.gitlab.com/user/profile/personal_access_tokens/#access-token-expiration
#>
function Remove-GitlabProjectAccessToken {
    [Alias('Revoke-GitlabProjectAccessToken')]
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true)]
        [string]
        $TokenId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabAPIParams = @{
      Method  = 'DELETE'
      Path     = "projects/$($Project.Id)/access_tokens/$TokenId"
    }

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    if($PSCmdlet.ShouldProcess($GitlabAPIParams.Path,"Revoke Project Access Token")) {
      Invoke-GitlabApi @GitlabAPIParams
    }
}