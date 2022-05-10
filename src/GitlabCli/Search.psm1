$global:GitlabSearchResultsDefaultLimit = 100

function Search-Gitlab {
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet('blobs', 'merge_requests', 'projects')]
        [string]
        $Scope = 'blobs',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $Search,

        [Parameter(Mandatory=$false)]
        [uint]
        $MaxResults = $global:GitlabSearchResultsDefaultLimit,

        [Parameter(Mandatory=$false)]
        [switch]
        $All,

        [Parameter(Mandatory=$false)]
        [string]
        $Select,

        [Parameter(Mandatory=$false)]
        [switch]
        $OpenInBrowser,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if ($All) {
        if ($MaxResults -ne $global:GitlabSearchResultsDefaultLimit) {
            Write-Warning -Message "Ignoring -MaxResults in favor of -All"
        }
        $MaxResults = [int]::MaxValue
    }

    $PageSize = 20
    $MaxPages = [Math]::Max(1, $MaxResults / $PageSize)
    $Query = @{
        scope = $Scope
        per_page = $PageSize
        search = $Search
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

    $Results = Invoke-GitlabApi GET 'search' $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject $DisplayType

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

# https://docs.gitlab.com/ee/api/search.html#project-search-api
function Search-GitlabProject {
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
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
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
    Invoke-GitlabApi GET $Resource $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.SearchResult.Blob' |
        Add-Member -MemberType 'NoteProperty' -Name 'Project' -Value $Project -PassThru
}
