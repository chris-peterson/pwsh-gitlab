# https://docs.gitlab.com/ee/api/group_access_tokens.html

# https://docs.gitlab.com/ee/api/group_access_tokens.html#list-group-access-tokens
function Get-GitlabGroupAccessToken {
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $TokenId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Resource = "groups/$GroupId/access_tokens"
    if ($TokenId) {
        $Resource += "/$TokenId"
    }

    Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.AccessToken'
}

# https://docs.gitlab.com/ee/api/group_access_tokens.html#create-a-group-access-token
function New-GitlabGroupAccessToken {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$true)]
        [ValidateSet('api', 'read_api', 'read_registry', 'write_registry', 'read_repository', 'write_repository')]
        [string []]
        $Scope,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer', 'owner')]
        $AccessLevel = 'maintainer',

        [switch]
        [Parameter(Mandatory=$false)]
        $CopyToClipboard,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Response = Invoke-GitlabApi POST "groups/$GroupId/access_tokens" -Body @{
        name = $Name
        scopes = $Scope
        access_level = $(Get-GitlabMemberAccessLevel).$AccessLevel
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf

    if ($CopyToClipboard) {
        $Response.token | Set-Clipboard
    } else {
        $Response.token
    }
}

# https://docs.gitlab.com/ee/api/group_access_tokens.html#revoke-a-group-access-token
function Remove-GitlabGroupAccessToken {
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
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Resource = "groups/$GroupId/access_tokens/$TokenId"

    try
    {
        Invoke-GitlabApi DELETE $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
        Write-Host "$TokenId revoked from $GroupId"
    }
    catch {
        Write-Error "Error revoking gitlab token from ${GroupId}: $_"
    }
}
