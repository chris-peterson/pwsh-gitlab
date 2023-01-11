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
        [Parameter(ParameterSetName="ByProjectId", Mandatory=$false, ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName="ByRef", Mandatory=$false, ValueFromPipelineByPropertyName)]
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

# https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches
function Get-GitlabProtectedBranch {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project  = Get-GitlabProject -ProjectId $ProjectId
    $Resource = "projects/$($Project.Id)/protected_branches"

    if (-not [string]::IsNullOrWhiteSpace($Name)) {
        $Resource += "/$Name"
    }

    try {
        Invoke-GitlabApi GET $Resource -Query $Query -SiteUrl $SiteUrl
            | New-WrapperObject 'Gitlab.ProtectedBranch'
            | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $Project.Id -PassThru
    } catch {
        if ($_.Exception.Response.StatusCode.ToString() -eq 'NotFound') {
            @()
        } else {
            throw
        }
    }
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
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Name')]
        [string]
        $Branch,

        [Parameter()]
        [ValidateSet('noaccess','developer','maintainer','admin')]
        [string]
        $PushAccessLevel,

        [Parameter()]
        [ValidateSet('noaccess','developer','maintainer','admin')]
        [string]
        $MergeAccessLevel,

        [Parameter()]
        [ValidateSet('developer','maintainer','admin')]
        [string]
        $UnprotectAccessLevel,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $AllowForcePush = 'false',

        [Parameter()]
        [array]
        $AllowedToPush,

        [Parameter()]
        [array]
        $AllowedToMerge,

        [Parameter()]
        [array]
        $AllowedToUnprotect,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $CodeOwnerApprovalRequired = $false,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $Request = @{
        name = $Branch
        push_access_level = $(Get-GitlabProtectedBranchAccessLevel).$PushAccessLevel
        merge_access_level = $(Get-GitlabProtectedBranchAccessLevel).$MergeAccessLevel
        unprotect_access_level = $(Get-GitlabProtectedBranchAccessLevel).$UnprotectAccessLevel
        allow_force_push = $AllowForcePush
        allowed_to_push = @($AllowedToPush | ConvertTo-SnakeCase)
        allowed_to_merge = @($AllowedToMerge | ConvertTo-SnakeCase)
        allowed_to_unprotect = @($AllowedToUnprotect | ConvertTo-SnakeCase)
        code_owner_approval_required = $CodeOwnerApprovalRequired
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)/branches/$Branch", "protect branch $($Request | ConvertTo-Json)")) {
        Invoke-GitlabApi POST "projects/$($Project.Id)/protected_branches" -Body $Request | New-WrapperObject 'Gitlab.ProtectedBranch'
    }
}

# https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches
function UnProtect-GitlabBranch {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Branch')]
        [string]
        $Name,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)/branches/$($Name)", "unprotect branch $($Name)")) {
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/protected_branches/$($Name)" -SiteUrl $SiteUrl
    }
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