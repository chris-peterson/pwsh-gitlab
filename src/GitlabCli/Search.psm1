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

    if ($Blobs) {
        $Scope = 'blobs'
    } elseif ($MergeRequests) {
        $Scope = 'merge_requests'
    } else {
        throw "Must search either blobs OR merge requests"
    }

    if ($All) {
        if ($MaxResults) {
            Write-Warning -Message "Ignoring -MaxResults in favor of -All"
        }
        $MaxResults = [int]::MaxValue
    }

    if($WhatIf) {
        Invoke-GitLabSearch -Scope $Scope -Phrase $Phrase -MaxResults $MaxResults -WhatIf
    } 
    else {
        Invoke-GitLabSearch -Scope $Scope -Phrase $Phrase -MaxResults $MaxResults
    }
}

function Invoke-GitLabSearch {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("blobs", "merge_requests")]
        [string]
        $Scope,

        [Parameter(Mandatory=$true)]
        [string]
        $Phrase,

        [Parameter(Mandatory=$true)]
        [uint]
        $MaxResults,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    switch ($Scope) {
        blobs { $DisplayType = 'GitLab.BlobSearchResult' }
        merge_requests { $DisplayType = 'GitLab.MergeRequestSearchResult' }
    }
    $GitlabConfig = Get-GitLabCliConfig

    $RequestParameters = @{
        Method = "GET"
        Uri = "$($GitlabConfig.Url)/api/v$($GitlabConfig.ApiVersion)/search?per_page=$($GitlabConfig.PageSize)&scope=$Scope&search=$([System.Web.HttpUtility]::UrlEncode($Phrase))"
        Headers = @{ "PRIVATE-TOKEN" = $GitlabConfig.Token }
    }

    $MaxPages = [Math]::Max(1, $MaxResults / $GitlabConfig.PageSize)

    if ($WhatIf) {
        Write-Host "WhatIf: $($RequestParameters | ConvertTo-Json) -- up to $MaxPages pages of results"
    } else {
        Invoke-RestMethod -Uri $RequestParameters.Uri -Method $RequestParameters.Method -Headers $RequestParameters.Headers -FollowRelLink -MaximumFollowRelLink $MaxPages |
            ForEach-Object { # Page
                $_ | ForEach-Object { # Result
                    $_ | New-WrapperObject -DisplayType $DisplayType}
            }
    }
}

function Get-GitLabCliConfig {
    $Captures = (Get-Content '~/.python-gitlab.cfg' |
        Select-String -Pattern 'private_token = (?<Token>.*)','url = (?<Url>.*)','api_version = (?<ApiVersion>.*)','per_page = (?<PageSize>.*)' -AllMatches).Matches.Groups | Where-Object -Property Name -ne "0" 
    $Config = New-Object PSObject
    $Captures | ForEach-Object {
        $Config | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value
    }

    # perform any normalization / sanitization
    $Config.Url = $Config.Url.TrimEnd('/')
    if ([string]::IsNullOrWhiteSpace($Config.ApiVersion)) {
        Write-Debug -Message "Defaulting api_version to 4"
        $Config.ApiVersion = '4' # latest version of API
    }
    if ([string]::IsNullOrWhiteSpace($Config.PageSize)) {
        $Config.PageSize = '20' # this is the GitLab API default
    }

    $Config
}