function Search-Gitlab {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter()]
        [ValidateSet('blobs', 'merge_requests', 'projects')]
        [string]
        $Scope = 'blobs',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $Filename,

        [Parameter(Position=0, Mandatory)]
        [string]
        $Search,

        [Parameter()]
        [uint]
        $MaxResults = $global:GitlabSearchResultsDefaultLimit,

        [Parameter()]
        [switch]
        $All,

        [Parameter()]
        [string]
        $Select,

        [Parameter()]
        [switch]
        $OpenInBrowser,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($All) {
        if ($MaxResults -ne $global:GitlabSearchResultsDefaultLimit) {
            Write-Warning -Message "Ignoring -MaxResults in favor of -All"
        }
        $MaxResults = [uint]::MaxValue
    }

    $PageSize = 20
    $MaxPages = [Math]::Max(1, $MaxResults / $PageSize)
    $Request = @{
        HttpMethod = 'GET'
        Path   = 'search'
        Query      = @{
            scope    = $Scope
            per_page = $PageSize
            search   = $Search
        }
        MaxPages = $MaxPages
    }

    switch ($Scope) {
        blobs {
            $DisplayType = 'Gitlab.SearchResult.Blob'
        }
        merge_requests {
            $DisplayType = 'Gitlab.SearchResult.MergeRequest'
        }
        projects {
            $DisplayType = 'Gitlab.SearchResult.Project'
        }
    }

    if ($GroupId) {
        $Request.Path = "groups/$($GroupId)/search"
    }

    if ($Filename) {
        $Request.Query.search = "filename:$Filename $($Request.Query.search)"
    }

    if ($PSCmdlet.ShouldProcess("search", "$($Request | ConvertTo-Json)")) {
        $Results = Invoke-GitlabApi @Request | New-GitlabObject $DisplayType

        if ($Scope -eq 'blobs') {
            # the response object is too anemic to be useful.  enrich with project data
            $Projects = $Results.ProjectId | Select-Object -Unique | ForEach-Object { @{Id=$_; Project=Get-GitlabProject $_ } }
            $Results | ForEach-Object {
                $_ | Add-Member -MemberType 'NoteProperty' -Name 'Project' -Value $($Projects | Where-Object Id -eq $_.ProjectId | Select-Object -ExpandProperty Project)
            }
        }

        if ($OpenInBrowser) {
            $Results | Where-Object Url | ForEach-Object {
                $_ | Open-InBrowser
            }
        }

        $Results | Get-FilteredObject $Select | Sort-Object ProjectPath
    }
}

# https://docs.gitlab.com/ee/api/search.html#project-search-api
function Search-GitlabProject {
    [CmdletBinding()]
    [OutputType('Gitlab.SearchResult.Blob')]
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $Search,

        [Parameter(Mandatory=$false)]
        [string]
        $Filename,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Query = @{
        scope = 'blobs'
    }

    $Project = Get-GitlabProject $ProjectId

    if ($Filename) {
        $Query.search = "filename:$Filename"
    } else {
        $Query.search = $Search
    }

    $Resource = "projects/$($ProjectId | ConvertTo-UrlEncoded)/search"
    Invoke-GitlabApi GET $Resource $Query |
        New-GitlabObject 'Gitlab.SearchResult.Blob' |
        Add-Member -MemberType 'NoteProperty' -Name 'Project' -Value $Project -PassThru
}
