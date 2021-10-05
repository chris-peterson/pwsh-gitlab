function Search-Gitlab {
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $Phrase,

        [Parameter(Mandatory=$false, ParameterSetName="Blobs")]
        [switch]
        $Blobs,

        [Parameter(Mandatory=$false, ParameterSetName="MergeRequests")]
        [switch]
        $MergeRequests,

        [Parameter(Mandatory=$false)]
        [uint]
        $MaxResults = 100,

        [Parameter(Mandatory=$false)]
        [switch]
        $All,

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

    if ($Blobs) {
        $Query['scope'] = 'blobs'
        $DisplayType = 'Gitlab.BlobSearchResult'
    } elseif ($MergeRequests) {
        $Query['scope'] = 'merge_requests'
        $DisplayType = 'Gitlab.MergeRequestSearchResult'
    } else {
        throw "Must search either blobs OR merge requests"
    }

    Invoke-GitlabApi GET "search" $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject $DisplayType
}
