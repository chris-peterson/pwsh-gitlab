# https://docs.gitlab.com/ee/api/deployments.html#list-project-deployments
function Get-GitlabDeployment {
    [CmdletBinding(DefaultParameterSetName="Query")]
    [Alias('deploys')]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true, ParameterSetName="Query")]
        [string]
        $EnvironmentName,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [ValidateSet('created', 'running', 'success', 'failed', 'canceled', 'all')]
        [string]
        $Status = 'success',

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [switch]
        $Latest,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [string]
        $UpdatedBefore,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [string]
        $UpdatedAfter,

        [Parameter(Mandatory=$false, ParameterSetName="Query")]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$true, ParameterSetName="ById")]
        [Alias("Id")]
        [string]
        $DeploymentId,

        [Parameter(Mandatory=$false)]
        [switch]
        $Pipeline,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'GET'
        SiteUrl = $SiteUrl
    }
    switch($PSCmdlet.ParameterSetName) {
        Query {
            $GitlabApiArguments.Path = "projects/$($Project.Id)/deployments"
            $GitlabApiArguments.Query = @{
                sort='desc'
            }
            $GitlabApiArguments.MaxPages = $MaxPages
            if ($EnvironmentName) {
                $GitlabApiArguments.Query['environment'] = $EnvironmentName
            }
            if ($Status -and $Status -ne 'all') {
                $GitlabApiArguments.Query['status'] = $Status
            }
            if ($UpdatedBefore) {
                $GitlabApiArguments.Query['updated_before'] = $UpdatedBefore
            }
            if ($UpdatedAfter) {
                $GitlabApiArguments.Query['updated_after'] = $UpdatedAfter
            }
        }
        ById {
            $GitlabApiArguments.Path = "projects/$($Project.Id)/deployments/$DeploymentId"
        }
        default {
            throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    $Result = Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Deployment'

    if ($Latest) {
        $Result = $Result | Select-Object -First 1
    }
    if ($Pipeline) {
        $Result = $Result.Pipeline
    }

    $Result
}
