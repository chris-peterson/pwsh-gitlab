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
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName="ByProjectId")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Search,

        [Parameter(ParameterSetName="ByRef", Position=0)]
        [Alias("Branch")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Ref,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
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
            $GitlabApiArguments.Path += "/$($Ref | ConvertTo-UrlEncoded)"
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
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName="ByName")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project  = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'GET'
        Path       = "projects/$($Project.Id)/protected_branches"
        SiteUrl    = $SiteUrl
    }

    if( $PSCmdlet.ParameterSetName -eq 'ByName' ) {
        $GitlabApiArguments.Path += "/$($Name | ConvertTo-UrlEncoded)"
    }

    try {
        # https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches
        Invoke-GitlabApi @GitlabApiArguments
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
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Branch,

        [Parameter(Position=2, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Ref
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $GitlabApiArguments = @{
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/repository/branches"
        Body       = @{
            branch = $Branch
            ref    = $Ref
        }
        SiteUrl    = $SiteUrl
    }

    if( $PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "create branch $($Branch) from $($Ref) `nArguments:`n$($GitlabApiArguments | ConvertTo-Json)") ) {
        Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.Branch'
    }
}

function Protect-GitlabBranch {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',
        
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Name')]
        [ValidateNotNullOrEmpty()]
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
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

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
        Remove-GitlabProtectedBranch -ProjectId $ProjectId -Branch $Branch -SiteUrl $SiteUrl | Out-Null
    }

    $GitlabApiArguments = @{
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/protected_branches"
        Body       = @{
                        name = $Branch
                      }
        SiteUrl    = $SiteUrl
    }

    if($PSBoundParameters.ContainsKey('PushAccessLevel')) {
        $GitlabApiArguments.Body.push_access_level =  $(Get-GitlabProtectedBranchAccessLevel).$PushAccessLevel
    }
    if($PSBoundParameters.ContainsKey('MergeAccessLevel')) {
        $GitlabApiArguments.Body.merge_access_level =  $(Get-GitlabProtectedBranchAccessLevel).$MergeAccessLevel
    }
    if($PSBoundParameters.ContainsKey('UnprotectAccessLevel')) {
        $GitlabApiArguments.Body.unprotect_access_level =  $(Get-GitlabProtectedBranchAccessLevel).$UnprotectAccessLevel
    }
    if($PSBoundParameters.ContainsKey('AllowForcePush')) {
        $GitlabApiArguments.Body.allow_force_push =  $AllowForcePush
    }
    if($PSBoundParameters.ContainsKey('CodeOwnerApprovalRequired')) {
        $GitlabApiArguments.Body.code_owner_approval_required =  $CodeOwnerApprovalRequired
    }
    if($PSBoundParameters.ContainsKey('AllowedToPush')) {
        $GitlabApiArguments.Body.allowed_to_push = @($AllowedToPush | ConvertTo-SnakeCase)
    }
    if($PSBoundParameters.ContainsKey('AllowedToMerge')) {
        $GitlabApiArguments.Body.allowed_to_merge = @($AllowedToMerge | ConvertTo-SnakeCase)
    }
    if($PSBoundParameters.ContainsKey('AllowedToUnprotect')) {
        $GitlabApiArguments.Body.allowed_to_unprotect = @($AllowedToUnprotect | ConvertTo-SnakeCase)
    }

    if ($PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "protect branch name $Branch with `nArguments:`n$($GitlabApiArguments | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/protected_branches.html#protect-repository-branches
        Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject 'Gitlab.ProtectedBranch'
    }
}

function UnProtect-GitlabBranch {
    [Alias('Remove-GitlabProtectedBranch')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',
        
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Branch')]
        [string]
        $Name,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'DELETE'
        Path       = "projects/$($Project.Id)/protected_branches/$($Name | ConvertTo-UrlEncoded)"
        SiteUrl    = $SiteUrl
    }

    if ($PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "unprotect branch $($Name) with `nArguments:`n$($GitlabApiArguments | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches
        Invoke-GitlabApi @GitlabApiArguments
    }
}

function Remove-GitlabBranch {
    [CmdletBinding(DefaultParameterSetName='ByName',SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByName', ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='MergedBranches')]
        $MergedBranches,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId
    $GitlabApiArguments = @{
        HttpMethod = 'DELETE'
        Path       =  "projects/$($Project.Id)/repository"
        SiteUrl    = $SiteUrl
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByName {
            # https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
            $GitlabApiArguments.Path = $GitlabApiArguments.Path + "/branches/$($Name | ConvertTo-UrlEncoded)"
        }
        MergedBranches {
            # https://docs.gitlab.com/ee/api/branches.html#delete-merged-branches
            $GitlabApiArguments.Path = $GitlabApiArguments.Path + "/merged_branches"
        }
        Default {
            throw "Unsupported parameter set $($PSCmdlet.ParameterSetName)"
        }
    }
    if ($PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "delete branch(es) with `nArguments:`n$($GitlabApiArguments | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
        Invoke-GitlabApi @GitlabApiArguments | Out-Null
    }
}