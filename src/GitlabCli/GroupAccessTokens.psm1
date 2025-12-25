
<#
.SYNOPSIS
Get the groups access tokens

.DESCRIPTION
When no tokenid is specificed, it will return all of the tokens for the group

.PARAMETER GroupId
 The ID or URL-encoded path of the group. 

.PARAMETER TokenId
  The ID of the access token to get details of.

.PARAMETER SiteUrl
  The URL of the Gitlab instance. If not provided, the default will be used.

.LINK
 https://docs.gitlab.com/ee/api/group_access_tokens.html
 https://docs.gitlab.com/ee/api/group_access_tokens.html#list-group-access-tokens
#>
function Get-GitlabGroupAccessToken {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $TokenId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Resource = "groups/$GroupId/access_tokens"
    if ($TokenId) {
        $Resource += "/$TokenId"
    }

    Invoke-GitlabApi GET $Resource | New-WrapperObject 'Gitlab.AccessToken'
}


<#
.SYNOPSIS
Creates a group access token

.DESCRIPTION
Create a group access token. You must have the Owner role for the group to create group access tokens.

.PARAMETER GroupId
The ID or URL-encoded path of the group. 

.PARAMETER Name
The name of the access token.

.PARAMETER Scope
The scopes of the access token. Values can be 'api', 'read_api', 'read_registry', 'write_registry', 'read_repository', 'write_repository'

.PARAMETER AccessLevel
The level of access the token will have. Values can be 'guest' , 'reporter', 'developer', 'maintainer', 'owner'
Default will be 'maintainer'

.PARAMETER ExpiresAt
The expiration date for the access token. Default will be 1 year from now. This can't be any longer than 1 year from now. The time component is ignored and only the year month and date are reflected

.PARAMETER CopyToClipboard
If this switch is enabled, the token will be copied to the clipboard.

.NOTES
This function is a wrapper around the Gitlab API endpoint POST /groups/:id/access_tokens

.LINK
https://docs.gitlab.com/ee/api/group_access_tokens.html#create-a-group-access-token
https://docs.gitlab.com/ee/api/rest/index.html#namespaced-path-encoding

#>
function New-GitlabGroupAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $GroupId,

        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [ValidateSet('api', 'read_api', 'read_registry', 'write_registry', 'read_repository', 'write_repository')]
        [string []]
        $Scope,

        [Parameter(Mandatory)]
        [string]
        [ValidateScript({Test-GitlabSettableAccessLevel $_})]
        $AccessLevel,

        [Parameter()]
        [System.DateTime]
        [ValidateScript({ $_ -le (Get-Date).AddYears(1)},ErrorMessage = "ExpiresAt can't be more than 1 year from now")]
        $ExpiresAt = $(Get-Date).AddYears(1),

        [switch]
        [Parameter()]
        $CopyToClipboard,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("Group '$GroupId'", "Create Access Token '$Name' with scopes '$($Scope -join ',')' and access level '$AccessLevel'")) {
        # https://docs.gitlab.com/ee/api/group_access_tokens.html#create-a-group-access-token
        $Response = Invoke-GitlabApi POST "groups/$GroupId/access_tokens" -Body @{
            name         = $Name
            scopes       = $Scope
            access_level = Get-GitlabMemberAccessLevel $AccessLevel
            expires_at   = $ExpiresAt.ToString('yyyy-MM-dd')
        }

        if ($CopyToClipboard) {
            $Response.token | Set-Clipboard
        } else {
            $Response
        }
    }
}

# https://docs.gitlab.com/ee/api/group_access_tokens.html#revoke-a-group-access-token
function Remove-GitlabGroupAccessToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [Alias('Revoke-GitlabGroupAccessToken')]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $TokenId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Resource = "groups/$GroupId/access_tokens/$TokenId"

    if ($PSCmdlet.ShouldProcess("Group '$GroupId' token #$TokenId", "revoke access token")) {
        try
        {
            Invoke-GitlabApi DELETE $Resource | Out-Null
            Write-Host "$TokenId revoked from $GroupId"
        }
        catch {
            Write-Error "Error revoking gitlab token from ${GroupId}: $_"
        }
    }
}
