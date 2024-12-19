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
        [Parameter(ParameterSetName="ByProjectId", ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName="ByRef", ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName="ByProjectId")]
        [string]
        $Search,

        [Parameter(ParameterSetName="ByRef", Mandatory, Position=0)]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $SiteUrl
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

    switch ($PSCmdlet.ParameterSetName) {
        ByProjectId {
            if($Search) {
                $GitlabApiArguments.Query["search"] = $Search
            }
        }
        ByRef {
            $GitlabApiArguments.Path += "/$($Ref)"
        }
        default {
            throw "$($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    Invoke-GitlabApi @GitlabApiArguments
        | New-WrapperObject 'Gitlab.Branch'
        | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $Project.Id -PassThru
        | Sort-Object -Descending LastUpdated
}

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
        # https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches
        Invoke-GitlabApi GET $Resource -Query $Query -SiteUrl $SiteUrl
            | New-WrapperObject 'Gitlab.ProtectedBranch'
            | Add-Member -PassThru -NotePropertyMembers @{
                ProjectId = $Project.Id
            }
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
    $PushAccessLevelLiteral = $(Get-GitlabProtectedBranchAccessLevel).$PushAccessLevel
    $MergeAccessLevelLiteral = $(Get-GitlabProtectedBranchAccessLevel).$MergeAccessLevel
    $UnprotectAccessLevelLiteral = $(Get-GitlabProtectedBranchAccessLevel).$UnprotectAccessLevel

    if ($Project | Get-GitlabProtectedBranch | Where-Object Name -eq $Branch) {
        # NOTE: the PATCH endpoint is crap (https://gitlab.com/gitlab-org/gitlab/-/issues/365520)
        # $Request = @{
        #     allow_force_push             = $AllowForcePush
        #     allowed_to_push              = @($AllowedToPush | ConvertTo-SnakeCase) +      @(@{access_level=$PushAccessLevelLiteral})
        #     allowed_to_merge             = @($AllowedToMerge | ConvertTo-SnakeCase) +     @(@{access_level=$MergeAccessLevelLiteral})
        #     allowed_to_unprotect         = @($AllowedToUnprotect | ConvertTo-SnakeCase) + @(@{access_level=$UnprotectAccessLevelLiteral})
        #     code_owner_approval_required = $CodeOwnerApprovalRequired
        # }
        # if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace) ($Branch)", "update protected branch $($Request | ConvertTo-Json)")) {
        #     # https://docs.gitlab.com/ee/api/protected_branches.html#update-a-protected-branch
        #     Invoke-GitlabApi PATCH "projects/$($Project.Id)/protected_branches/$Branch" -Body $Request | New-WrapperObject 'Gitlab.ProtectedBranch'
        # }
        # as a workaround, remove protection
        Remove-GitlabProtectedBranch -ProjectId $ProjectId -Branch $Branch -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference | Out-Null
    }

    $Request = @{
        name                         = $Branch
        push_access_level            = $PushAccessLevelLiteral
        merge_access_level           = $MergeAccessLevelLiteral
        unprotect_access_level       = $UnprotectAccessLevelLiteral
        allow_force_push             = $AllowForcePush
        allowed_to_push              = @($AllowedToPush | ConvertTo-SnakeCase)
        allowed_to_merge             = @($AllowedToMerge | ConvertTo-SnakeCase)
        allowed_to_unprotect         = @($AllowedToUnprotect | ConvertTo-SnakeCase)
        code_owner_approval_required = $CodeOwnerApprovalRequired
    }
    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace) ($Branch)", "protect branch $($Request | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/protected_branches.html#protect-repository-branches
        Invoke-GitlabApi POST "projects/$($Project.Id)/protected_branches" -Body $Request | New-WrapperObject 'Gitlab.ProtectedBranch'
    }
}

function UnProtect-GitlabBranch {
    [Alias('Remove-GitlabProtectedBranch')]
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
        # https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches
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