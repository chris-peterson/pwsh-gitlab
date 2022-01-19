function Get-GitlabUser {
    param (
        [Parameter(ParameterSetName='ByUserId', Mandatory=$false)]
        [Alias("Username")]
        [string]
        $UserId,

        [Parameter(ParameterSetName='ByEmail', Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter(ParameterSetName='ByMe', Mandatory=$False)]
        [switch]
        $Me,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if ($UserId) {
        if (-not [uint]::TryParse($UserId, [ref] $null)) {
            $UserId = Invoke-GitlabApi GET "users" @{
                username = $UserId
            } | Select-Object -First 1 -ExpandProperty id
        }
        Invoke-GitlabApi GET "users/$UserId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
    if ($EmailAddress) {
        $UserId = Invoke-GitlabApi GET "search" @{
            scope = 'users'
            search = $EmailAddress
        } -SiteUrl $SiteUrl -WhatIf:$WhatIf | Select-Object -First 1 -ExpandProperty id
        Invoke-GitlabApi GET "users/$UserId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
    if ($Me) {
        Invoke-GitlabApi GET 'user' -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
}

function Get-GitlabCurrentUser {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Get-GitlabUser -Me -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
