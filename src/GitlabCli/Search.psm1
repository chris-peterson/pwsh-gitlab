function Search-Gitlab {
    param(
        [Parameter(Position=0)]
        [string]
        $Phrase,

        [Parameter(Mandatory=$false)]
        [switch]
        $Blobs,

        [Parameter(Mandatory=$false)]
        [switch]
        $MergeRequests,

        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$false)]
        [string]
        $Filename,

        [Parameter(Mandatory=$false)]
        [uint]
        $MaxResults = 100,

        [Parameter(Mandatory=$false)]
        [switch]
        $All,

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
        if ($MaxResults) {
            Write-Warning -Message "Ignoring -MaxResults in favor of -All"
        }
        $MaxResults = [int]::MaxValue
    }

    $PageSize = 20
    $MaxPages = [Math]::Max(1, $MaxResults / $PageSize)
    $Query = @{
        'per_page' = $PageSize
        'search' = $Phrase
    }

    if ($Blobs -and $MergeRequests) {
        throw "Can't use blobs and merge request scopes at the same time"
    }
    elseif ($MergeRequests) {
        $Query['scope'] = 'merge_requests'
        $DisplayType = 'Gitlab.MergeRequestSearchResult'
    } else {
        $Query['scope'] = 'blobs'
        $DisplayType = 'Gitlab.BlobSearchResult'
    }

    $Resource = 'search'
    if ($ProjectId) {
        if ($ProjectId -eq '.') {
            $ProjectId = $(Get-LocalGitContext).Project
        }
        # https://docs.gitlab.com/ee/api/search.html#project-search-api
        $Resource = "projects/$($ProjectId | ConvertTo-UrlEncoded)/search"

        if ($Filename) {
            $Query.search = "filename:$Filename"
        }
    }

    $Results = Invoke-GitlabApi GET $Resource $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject $DisplayType

    if ($OpenInBrowser) {
        $Results | ForEach-Object {
            if ($_.Url) {
                $_ | Open-InBrowser
            } else {
                $Project = Get-GitlabProject $_.ProjectId
                "$($Project.Url)/-/blob/$($Project.DefaultBranch)/$($_.Path)#L$($_.LineNumber)" | Open-InBrowser
            }
        }
    } else {
        $Results
    }
}
