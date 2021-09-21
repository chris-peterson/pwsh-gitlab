function Get-GitlabPipeline {

    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(ParameterSetName="ByProjectId", Position=0, Mandatory=$false)]
        [Parameter(ParameterSetName="ByPipelineId", Position=0, Mandatory=$false)]
        [string]
        $ProjectId=".",

        [Parameter(ParameterSetName="ByPipelineId", Position=1, Mandatory=$false)]
        [string]
        $PipelineId,

        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [ValidateSet('created', 'waiting_for_resource', 'preparing', 'pending', 'running', 'success', 'failed', 'canceled', 'skipped', 'manual', 'scheduled')]
        [string]
        $Status,

        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [string]
        $Username,

        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [switch]
        $Mine,

        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [switch]
        $All,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiParameters = @{
        "HttpMethod" = "GET"
        "Path" = "projects/$($Project.Id)/pipelines"
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByPipelineId {
            $GitlabApiParameters["Path"] += "/$PipelineId"
        }
        ByProjectId {
            $Query = @{}
            $MaxPages = 1
            if ($All) {
                $MaxPages = 10 #ok, not really all, but let's not DOS gitlab
            }

            if($Ref) {
                if($Ref -eq '.') {
                    $LocalContext = Get-LocalGitContext
                    $Ref = $LocalContext.Branch
                }
                $Query['ref'] = $Ref
            }
            if ($Status) {
                $Query['status'] = $Status
            }
            if ($Mine) {
                $Query['username'] = $(Get-GitlabUser -Me).Username
            } elseif ($Username) {
                $Query['username'] = $Username
            }
    
            $GitlabApiParameters["Query"] = $Query
            $GitlabApiParameters["MaxPages"] = $MaxPages

        }
        default {
            throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    if ($WhatIf) {
        $GitlabApiParameters["WhatIf"] = $True
    }
    Invoke-GitlabApi @GitlabApiParameters | New-WrapperObject 'Gitlab.Pipeline'
}

function Get-GitlabPipelineSchedule {

    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(Position=0,ParameterSetName="ByProjectId", Mandatory=$true)]
        [Parameter(Position=0,ParameterSetName="ByPipelineId",Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(ParameterSetName="ByPipelineId",Mandatory=$true,Position=1)]
        [Parameter(Position=1, Mandatory=$false)]
        [int]
        $PipelineId,

        [Parameter(Position=1,ParameterSetName="ByProjectId", Mandatory=$false)]
        [string]
        [ValidateSet("active","inactive")]
        $Scope
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipeline_schedules"
        Query=@{}
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByPipelineId { 
            $GitlabApiArguments["Path"] += "/$PipelineId" 
        }
        ByProjectId {
            if($Scope) {
                $GitlabApiArguments["Query"]["scope"] = $Scope
            }
        }
        default { throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"}
    }

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.PipelineSchedule'

}

function Get-GitlabPipelineJobs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true,Position=1)]
        [string]
        $PipelineId,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet("created","pending","running","failed","success","canceled","skipped","manual")]
        $Scope,

        [Parameter(Mandatory=$false)]
        [switch]
        $IncludeRetired,

        [Parameter(Mandatory=$false)]
        [switch]
        $ExcludeBridgeJobs = $false
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipelines/$PipelineId/jobs"
    }

    if($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }

    if($IncludeRetired) {
        $GitlabApiArguments['Query']['include_retired'] = $true
    }

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.PipelineJob'
}

function Get-GitlabPipelineBridges {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory=$true,Position=1)]
        [string]
        $PipelineId,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet("created","pending","running","failed","success","canceled","skipped","manual")]
        $Scope
    )
    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/pipelines/$PipelineId/bridges"
        Query=@{}
    }

    if($Scope) {
        $GitlabApiArguments['Query']['scope'] = $Scope
    }

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject "Gitlab.PipelineJobBridge"
}

function New-GitlabPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = ".",

        [Parameter(Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter(Mandatory=$false)]
        [switch]
        $Follow,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf = $false
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $ProjectId = $Project.Id

    if ($Ref) {
        if ($Ref -eq '.') {
            $Ref = $(Get-LocalGitContext).Branch
        }
    } else {
        $Ref = $Project.DefaultBranch
    }

    $GitlabApiArguments = @{
        HttpMethod="POST"
        Path="projects/$ProjectId/pipeline"
        Query=@{'ref' = $Ref}
        WhatIf=$WhatIf
    }

    $Pipeline = Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.Pipeline'

    if ($Follow) {
        Start-Process $Pipeline.WebUrl
    }

    $Pipeline
}