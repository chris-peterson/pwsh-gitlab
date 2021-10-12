function Get-GitlabBranch {
    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false)]
        [Parameter(ParameterSetName="ByRef", Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [string]
        $Search,

        [Parameter(ParameterSetName="ByRef", Mandatory=$true)]
        [Alias("Ref")]
        [string]
        $Branch,

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
        Path       = "projects/$($Project.Id)/repository/branches"
        Query      = @{}
        SiteUrl    = $SiteUrl
    }

    switch($PSCmdlet.ParameterSetName) {
        ByProjectId {
            if($Search) {
                $GitlabApiArguments.Query["search"] = $Search
            }        
        }
        ByRef {
            $GitlabApiArguments.Path += "/$($Branch)"
        }
        default {
            throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Branch'
}

function Get-GitlabProtectedBranches {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod='GET'
        Path="projects/$($Project.Id)/protected_branches"
        SiteUrl=$SiteUrl
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProtectedBranch'
}

function Protect-GitlabBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [bool]
        [Parameter(Mandatory=$false)]
        $AllowForcePush = $false,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/protected_branches"
        SiteUrl    = $SiteUrl
        Query      = @{
            name = $Name
            allow_force_push = $AllowForcePush
        }
    }

    if ($AllowForcePush) {
        $GitlabApiArguments.Query[''] = $AllowForcePush
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProtectedBranch'
}

function UnProtect-GitlabBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true)]
        [string]
        $Name,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $Branch = Get-GitlabBranch -ProjectId $Project.Id -Branch $Name

    $GitlabApiArguments = @{
        HttpMethod = 'DELETE'
        Path       = "projects/$($Project.Id)/protected_branches/$($Branch.Name)"
        SiteUrl    = $SiteUrl
    }

    if ($AllowForcePush) {
        $GitlabApiArguments.Query[''] = $AllowForcePush
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf
}
