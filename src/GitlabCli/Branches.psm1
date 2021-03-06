# https://docs.gitlab.com/ee/api/protected_branches.html
function Get-GitlabProtectedBranchAccessLevel {

    [PSCustomObject]@{
        NoAccess = 0
        Developer = 30
        Maintainer = 40
        Admin = 60
    }
}

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
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($Ref -eq '.') {
        $Ref = $(Get-LocalGitContext).Branch
    }

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
            $GitlabApiArguments.Path += "/$($Ref)"
        }
        default {
            throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf
        | New-WrapperObject 'Gitlab.Branch'
        | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $Project.Id -PassThru
        | Sort-Object -Descending LastUpdated
}

function Get-GitlabProtectedBranch {
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

function New-GitlabBranch {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $Branch,

        [Parameter(Position=2, Mandatory=$true)]
        [string]
        $Ref,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    Invoke-GitlabApi POST "projects/$ProjectId/repository/branches" @{
        branch = $Branch
        ref = $Ref
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Branch'
}

# https://docs.gitlab.com/ee/api/protected_branches.html#protect-repository-branches
function Protect-GitlabBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [ValidateSet('noaccess','developer','maintainer','admin')]
        [string]
        $PushAccessLevel,

        [Parameter(Mandatory=$false)]
        [ValidateSet('noaccess','developer','maintainer','admin')]
        [string]
        $MergeAccessLevel,

        [Parameter(Mandatory=$false)]
        [ValidateSet('noaccess','developer','maintainer','admin')]
        [string]
        $UnprotectAccessLevel,

        [Parameter(Mandatory=$false)]
        [bool]
        $AllowForcePush = $false,

        [Parameter(Mandatory=$false)]
        [array]
        $AllowedToPush,

        [Parameter(Mandatory=$false)]
        [array]
        $AllowedToMerge,

        [Parameter(Mandatory=$false)]
        [array]
        $AllowedToUnprotect,

        [Parameter(Mandatory=$false)]
        [bool]
        $CodeOwnerApprovalRequired = $false,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $Branch = Get-GitlabBranch -ProjectId $Project.Id -Branch $Name

    $GitlabApiArguments = @{
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/protected_branches"
        SiteUrl    = $SiteUrl
        Body      = @{
            name = $Branch.Name
            push_access_level = $(Get-GitlabProtectedBranchAccessLevel).$PushAccessLevel
            merge_access_level = $(Get-GitlabProtectedBranchAccessLevel).$MergeAccessLevel
            unprotect_access_level = $(Get-GitlabProtectedBranchAccessLevel).$UnprotectAccessLevel
            allow_force_push = $AllowForcePush
            allowed_to_push = @($AllowedToPush | ConvertTo-SnakeCase)
            allowed_to_merge = @($AllowedToMerge | ConvertTo-SnakeCase)
            allowed_to_unprotect = @($AllowedToUnprotect | ConvertTo-SnakeCase)
            code_owner_approval_required = $CodeOwnerApprovalRequired
        }
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProtectedBranch'
}

# https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches
function UnProtect-GitlabBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

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

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf
}

function Remove-GitlabBranch {
    [CmdletBinding(DefaultParameterSetName='ByName')]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByName', ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='MergedBranches')]
        $MergedBranches,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    switch ($PSCmdlet.ParameterSetName) {
        ByName {
            # https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
            Invoke-GitlabApi DELETE "projects/$($Project.Id)/repository/branches/$Name" -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        MergedBranches {
            # https://docs.gitlab.com/ee/api/branches.html#delete-merged-branches
            Invoke-GitlabApi DELETE "projects/$($Project.Id)/repository/merged_branches" -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        Default {
            throw "Unsupported parameter set $($PSCmdlet.ParameterSetName)"
        }
    }
}