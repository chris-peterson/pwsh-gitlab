function Search-GitLab {
    param(
        [Parameter(Position=0,Mandatory=$true)]
        [string]
        $Search,

        [Parameter(Mandatory=$false)]
        [switch]
        $Blobs,

        [Parameter(Mandatory=$false)]
        [switch]
        $MergeRequests,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    if($Blobs) {
        if($WhatIf) {
            Invoke-GitLabSearch "blobs" $Search -Whatif
        } 
        else {
            Invoke-GitLabSearch "blobs" $Search | Get-GitLabApiPagedResults -All | Foreach-Object { New-WrapperObject $_ -DisplayType 'GitLab.Blob' }
        }
    }

    if($MergeRequests) {
        if($WhatIf) {
            Invoke-GitLabSearch "merge_requests" $Search -Whatif
        } 
        else {
            Invoke-GitLabSearch "merge_requests" $Search | Get-GitLabApiPagedResults -All | Foreach-Object { New-WrapperObject $_ -DisplayType 'GitLab.MergeRequest' }
        }
    }
}

Function Invoke-GitLabSearch {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("blobs","merge_requests")]
        [string]
        $Scope,

        [Parameter(Mandatory=$true)]
        [string]
        $Search,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $gitlabConfig = Get-GitLabCliConfig

    $requestParameters = @{
        Method="GET"
        Uri= "$($gitlabConfig.Url)/api/v$($gitlabConfig.ApiVersion)/search"
        Headers=@{ "PRIVATE-TOKEN"=$gitlabConfig.Token }
    }

    $requestParameters.Uri += "?scope=$Scope&search=" + [System.Web.HttpUtility]::UrlEncode($Search)

    $requestResults = Invoke-WebRequest @requestParameters

    if($requestResults.StatusCode -gt 399) {
        throw "$($initialResult.StatusCode) $($initialResult.StatusDescription)"
    }

    return $requestResults
}

function Get-GitLabApiPagedResults {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object] $gitlabResponse,

        [Parameter(Mandatory=$false)]
        [switch]
        $All
    )

    $gitlabConfig = Get-GitLabCliConfig
    $baseSearchRequestParameters = @{
        Method="GET"
        Headers=@{ "PRIVATE-TOKEN"=$gitlabConfig.Token }
    }

    [object[]] $projects = $gitlabResponse.Content | ConvertFrom-Json
    try {
        while($null -ne $gitlabResponse.RelationLink.next) {
            Write-Verbose "Getting Next Page $($gitlabResponse.RelationLink.next)"
            $loopParams = $baseSearchRequestParameters + @{
                Uri = $gitlabResponse.RelationLink.next
            }
            $gitlabResponse = Invoke-WebRequest @loopParams
            $gitlabResponse.Content | ConvertFrom-Json
        }  
    }
    catch {
        throw
    }
    
}
function Get-GitLabCliConfig {
    $captures = (Get-Content '~/.python-gitlab.cfg' | Select-String -Pattern 'private_token = (?<Token>.*)','url = (?<Url>.*)','ap_version = (?<ApiVersion>.*)' -AllMatches).Matches.Groups | Where-Object -Property Name -ne "0" 
    $result = New-Object psobject
    foreach($capture in $captures) {
        $result | Add-Member -NotePropertyName $capture.Name -NotePropertyValue $capture.Value.TrimEnd()
    }

    return $result
}