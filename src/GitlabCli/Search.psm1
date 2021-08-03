function Search-GitLab {
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
        [switch]
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
        $DisplayType = 'GitLab.BlobSearchResult'
    } elseif ($MergeRequests) {
        $Query['scope'] = 'merge_requests'
        $DisplayType = 'GitLab.MergeRequestSearchResult'
    } else {
        throw "Must search either blobs OR merge requests"
    }

    Invoke-GitlabApi GET "search" $Query -MaxPages $MaxPages -WhatIf:$WhatIf | 
        Foreach-Object {
            $_ | New-WrapperObject -DisplayType $DisplayType
        }
}