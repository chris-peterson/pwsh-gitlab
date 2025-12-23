function Get-GitlabResourceFromUrl {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $Url
    )

    $Match = $null
    Get-GitlabConfiguration | Select-Object -Expand sites | Select-Object -Expand Url | ForEach-Object {
        if ($Url -match "$_/(?<ProjectId>.+?)(?:/-/(?:(?<ResourceType>[a-zA-Z_]+)/(?<ResourceId>\d+))?)?/?$") {
            $Match = [PSCustomObject]@{
                ProjectId    = $Matches.ProjectId
                ResourceType = $Matches.ResourceType
                ResourceId   = $Matches.ResourceId
            }
        }
    }

    if (-not $Match) {
        throw "Could not extract a GitLab resource from '$Url'"
    }
    $Match
}
