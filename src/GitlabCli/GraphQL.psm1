# https://docs.gitlab.com/ee/api/graphql/
function Invoke-GitlabGraphQL {
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $Query,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $WhatIf
    )

    $Body = @{
        query = $Query
    }

    Invoke-GitlabApi POST 'graphql' -Api '' -Body $Body -SiteUrl $SiteUrl -WhatIf:$WhatIf | Select-Object -ExpandProperty data | New-WrapperObject
}
