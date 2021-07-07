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
        [switch]
        $WhatIf
    )

    if($Blobs) {
        if($WhatIf) {
            Invoke-GitLabSearch "blobs" $Phrase -Whatif
        } 
        else {
            Invoke-GitLabSearch "blobs" $Phrase | Get-GitLabApiPagedResults -All |
                Foreach-Object { $_ | New-WrapperObject }
        }
    } elseif($MergeRequests) {
        if($WhatIf) {
            Invoke-GitLabSearch "merge_requests" $Phrase -WhatIf
        } 
        else {
            Invoke-GitLabSearch "merge_requests" $Phrase | Get-GitLabApiPagedResults -All |
                Foreach-Object { $_ | New-WrapperObject }
        }
    } else {
        throw "Must search either blobs OR merge requests"
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

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $GitlabConfig = Get-GitLabCliConfig

    $RequestParameters = @{
        Method="GET"
        Uri= "$($GitlabConfig.Url)/api/v$($GitlabConfig.ApiVersion)/search"
        Headers=@{ "PRIVATE-TOKEN"=$GitlabConfig.Token }
    }

    $RequestParameters.Uri += "?scope=$Scope&search=" + [System.Web.HttpUtility]::UrlEncode($Phrase)

    if ($WhatIf) {
        Write-Host "WhatIf: $($RequestParameters | ConvertTo-Json)"
    } else {
        $Results = Invoke-RestMethod @RequestParameters
    }
    $Results
}

function Get-GitLabApiPagedResults {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        $GitlabResponse,

        [Parameter(Mandatory=$false)]
        [switch]
        $All
    )

    $GitlabConfig = Get-GitLabCliConfig
    $BaseSearchRequestParameters = @{
        Method="GET"
        Headers=@{ "PRIVATE-TOKEN"=$GitlabConfig.Token }
    }

    while ($GitlabResponse.RelationLink.next) {
        Write-Verbose "Getting Next Page $($GitlabResponse.RelationLink.next)"
        $LoopParams = $BaseSearchRequestParameters + @{
            Uri = $GitlabResponse.RelationLink.next
        }
        $GitlabResponse = Invoke-RestMethod @LoopParams
        $GitlabResponse.Content | ConvertFrom-Json
    }  
}

function Get-GitLabCliConfig {
    $Captures = (Get-Content '~/.python-gitlab.cfg' |
        Select-String -Pattern 'private_token = (?<Token>.*)','url = (?<Url>.*)','api_version = (?<ApiVersion>.*)' -AllMatches).Matches.Groups | Where-Object -Property Name -ne "0" 
    $Result = New-Object PSObject
    $Captures | ForEach-Object {
        $Result | Add-Member -NotePropertyName $_.Name -NotePropertyValue $_.Value.TrimEnd()
    }

    $Result
}