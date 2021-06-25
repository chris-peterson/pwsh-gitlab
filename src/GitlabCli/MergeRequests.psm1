function Get-GitLabMergeRequest {
    [CmdletBinding(DefaultParameterSetName="ByGroupId")]
    param(
        [Parameter(Position=0,Mandatory=$true,ParameterSetName="ByGroupId")]
        [string]
        $GroupId,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName="ByProjectId")]
        [Parameter(Position=0, Mandatory=$true, ParameterSetName="MergeRequestIID")]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true, ParameterSetName="MergeRequestIID")]
        [string]
        $MergeRequestIID,

        [Parameter(Mandatory=$false, ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [ValidateSet("closed","opened","merged")]
        [string]
        $State,

        [Parameter(Mandatory=$False,ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $CreatedAfter,

        [Parameter(Mandatory=$False,ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [string]
        $CreatedBefore,

        [Parameter(Mandatory=$False,ParameterSetName="ByGroupId")]
        [Parameter(Mandatory=$false, ParameterSetName="ByProjectId")]
        [ValidateSet("yes","no")]
        [string]
        $Wip,

        [Parameter(Mandatory=$false)]
        [switch]
        $Whatif
    )

    function IsNullOrEmpty([string] $value) { [String]::IsNullOrEmpty($value)}
    
    $cmdToExecute = "gitlab -o json"

    if(IsNullOrEmpty $ProjectId) {
        $cmdToExecute = "$cmdToExecute group-merge-request list --group-id $GroupId --all"
    } elseif (IsNullOrEmpty $MergeRequestIID) {
        $cmdToExecute = "$cmdToExecute project-merge-request list --project-id $ProjectId --all"   
    } else {
        $cmdToExecute="$cmdToExecute project-merge-request get --project-id $ProjectId --iid $MergeRequestIID"
    }

    if($State) {
        $cmdToExecute = "$cmdToExecute --state $State"
    }

    if(-not (IsNullOrEmpty $CreatedBefore)) {
        $cmdToExecute = "$cmdToExecute --created-before $CreatedBefore"
    }

    if(-not (IsNullOrEmpty $CreatedAfter)) {
        $cmdToExecute = "$cmdToExecute --created-after $CreatedAfter"
    }

    if(-not (IsNullOrEmpty $Wip)) {
        $cmdToExecute = "$cmdToExecute --wip $Wip"
    }
    
    if($Whatif) {
        Write-Host "Whatif: $cmdToExecute"
    } else {
        $MergeRequests = Invoke-Expression $cmdToExecute | ConvertFrom-Json
        return $MergeRequests | ForEach-Object { New-WrapperObject $_ -DisplayType 'Gitlab.MergeRequest' }
    }
}

function Remove-GitlabMergeRequest {
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $MergeRequestIID,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $cmdToExecute = "gitlab project-merge-request delete --project-id $ProjectId --iid $MergeRequestIID"

    if ($WhatIf) {
        Write-Host "Whatif: $cmdToExecute"
    } else {
        Invoke-Expression $cmdToExecute
    }
}

function Update-GitlabMergeRequest {
    [CmdletBinding(DefaultParameterSetName="Update")]
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $MergeRequestIID,

        [Parameter(Mandatory=$false)]
        [string]
        $Title,

        [Parameter(Mandatory=$false)]
        [string]
        $Description,

        [Parameter(Mandatory=$false,ParameterSetName="Close")]
        [switch]
        $Close,

        [Parameter(Mandatory=$false,ParameterSetName="Reopen")]
        [switch]
        $Reopen,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $cmdToExecute="gitlab -o json project-merge-request update --project-id $($ProjectId) --iid $($MergeRequestIID)"

    if($Close) {
        $cmdToExecute="$cmdToExecute --state-event close"
    }

    if($Reopen) {
        $cmdToExecute="$cmdToExecute --stat-event reopen"
    }
    
    if(-not [String]::IsNullOrEmpty($Title)) {
        $cmdToExecute = "$cmdToExecute --title $($Title)"
    }

    if(-not [String]::IsNullOrEmpty($Description)) {
        $cmdToExecute = "$cmdToExecute --description $($Description)"
    }

    if($WhatIf) {
        Write-Host "Whatif: $cmdToExecute"
    } else {
        Invoke-Expression $cmdToExecute | ConvertFrom-Json | ForEach-Object { New-WrapperObject $_ -DisplayType 'Gitlab.MergeRequest' }
    }
}
