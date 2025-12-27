function Get-GitlabProjectAccessToken {
  [CmdletBinding(SupportsShouldProcess)]
  [OutputType('Gitlab.AccessToken')]
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

function New-GitlabProjectAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.AccessToken')]
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

function Invoke-GitlabProjectAccessTokenRotation {
    [Alias('Rotate-GitlabProjectAccessToken')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    [OutputType('Gitlab.AccessToken')]
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

function Remove-GitlabProjectAccessToken {
    [Alias('Revoke-GitlabProjectAccessToken')]
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    [OutputType([void])]
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