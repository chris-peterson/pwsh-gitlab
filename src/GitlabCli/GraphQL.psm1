# https://docs.gitlab.com/ee/api/graphql/
function Invoke-GitlabGraphQL {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position=0, Mandatory)]
        [string]
        $Query,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Body = @{
        query = $Query
    }
    if ($PSCmdlet.ShouldProcess("graphql query", "$($Body | ConvertTo-Json -Depth 100)")) {
        $Result = Invoke-GitlabApi POST 'graphql' -Api '' -Body $Body
        if ($Result.data) {
            $Result.data | New-GitlabObject
        } else {
            throw "GraphQL query ($Query) failed, result: $($Result | ConvertTo-Json -Depth 100)"
        }
    }
}
