function Get-GitlabGroupAccessToken {
    [CmdletBinding()]
    [OutputType('Gitlab.AccessToken')]
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

    Invoke-GitlabApi GET $Resource | New-GitlabObject 'Gitlab.AccessToken'
}


function New-GitlabGroupAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
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
    [OutputType([void])]
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
