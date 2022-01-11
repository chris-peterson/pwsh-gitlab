function Get-GitlabRunner {
    [CmdletBinding(DefaultParameterSetName='ListAll')]
    param (
        [Parameter(Mandatory=$true, Position=0, ParameterSetName='RunnerId')]
        [string]
        $RunnerId,

        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('instance_type', 'group_type', 'project_type')]
        [string]
        $Type,

        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [ValidateSet('active', 'paused', 'online', 'offline')]
        [string]
        $Status,

        [Parameter(Mandatory=$false, ParameterSetName='ListAll')]
        [string []]
        $Tags,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Params = @{
        HttpMethod = 'GET'
        Query = @{}
        MaxPages = $MaxPages
        SiteUrl = $SiteUrl
        WhatIf = $WhatIf
    }

    switch ($PSCmdlet.ParameterSetName) {
        # https://docs.gitlab.com/ee/api/runners.html#get-runners-details
        RunnerId { 
            $Params.Path = "runners/$RunnerId"
        }
        # https://docs.gitlab.com/ee/api/runners.html#list-all-runners
        ListAll {
            $Params.Path = 'runners/all'
            $Params.Query.type = $Type
            $Params.Query.status = $Status
            $Params.Query.tag_list = $Tags -join ','
        }
        Default { throw "Unsupported parameter combination" }
    }

    Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.Runner'
}

# https://docs.gitlab.com/ee/api/runners.html#list-runners-jobs
function Get-GitlabRunnerJobs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $RunnerId,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Params = @{
        HttpMethod = 'GET'
        Path = "runners/$RunnerId/jobs"
        MaxPages = $MaxPages
        SiteUrl = $SiteUrl
        WhatIf = $WhatIf
    }

    Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.RunnerJob'
}

# https://docs.gitlab.com/ee/api/runners.html#update-runners-details
function Update-GitlabRunner {
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $RunnerId,

        [Parameter(Mandatory=$false)]
        [string]
        $Id,

        [Parameter(Mandatory=$false)]
        [string]
        $Description,

        [Parameter(Mandatory=$false)]
        [object]
        [ValidateSet($null, $true, $false)]
        $Active,

        [Parameter(Mandatory=$false)]
        [string]
        $Tags,

        [Parameter(Mandatory=$false)]
        [object]
        [ValidateSet($null, $true, $false)]
        $RunUntaggedJobs,

        [Parameter(Mandatory=$false)]
        [object]
        [ValidateSet($null, $true, $false)]
        $Locked,

        [Parameter(Mandatory=$false)]
        [string]
        [ValidateSet('not_protected', 'ref_protected')]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [uint]
        $MaximumTimeoutMinutes,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Params = @{
        HttpMethod = 'PUT'
        Path = "runners/$RunnerId"
        Query = @{
            id = $Id
            description = $Description
            tag_list = $Tags
            access_level = $AccessLevel
        }
        SiteUrl = $SiteUrl
        WhatIf = $WhatIf
    }
    if ($MaximumTimeoutMinutes) {
        if ($MaximumTimeoutMinutes -lt 10) {
            throw "maximum_timeout must be >= 10"
        }
        if ($MaximumTimeoutMinutes -gt [int]::MaxValue) {
            throw "maximum_timeout must be <= $([int]::MaxValue)"
        }
        $Params.Query.maximum_timeout = $MaximumTimeoutMinutes
    }

    if ($Active -ne $null) {
        $Params.Query.active = $Active.ToString().ToLower()
    }
    if ($RunUntaggedJobs -ne $null) {
        $Params.Query.run_untagged = $RunUntaggedJobs.ToString().ToLower()
    }
    if ($Locked -ne $null) {
        $Params.Query.locked = $Locked.ToString().ToLower()
    }

    Invoke-GitlabApi @Params | New-WrapperObject 'Gitlab.Runner'
}

function Suspend-GitlabRunner {
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $RunnerId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Update-GitlabRunner $RunnerId -Active $false -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

function Resume-GitlabRunner {
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $RunnerId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Update-GitlabRunner $RunnerId -Active $true -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
