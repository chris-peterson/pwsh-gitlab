function Get-GitlabBranch {
    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    [OutputType('Gitlab.Branch')]
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
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $MaxPages = Resolve-GitlabMaxPages -MaxPages $MaxPages -All:$All

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($Ref -eq '.') {
        $Ref = $(Get-LocalGitContext).Branch
    }

    # https://docs.gitlab.com/api/branches/#list-repository-branches
    $Request = @{
        HttpMethod = 'GET'
        Path       = "projects/$($Project.Id)/repository/branches"
        Query      = @{}
        MaxPages   = $MaxPages
    }

    switch ($PSCmdlet.ParameterSetName) {
        ByProjectId {
            if($Search) {
                $Request.Query.search = $Search
            }
        }
        ByRef {
            $Request.Path += "/$($Ref | ConvertTo-UrlEncoded)"
        }
        default {
            throw "$($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    Invoke-GitlabApi @Request
        | New-GitlabObject 'Gitlab.Branch'
        | Add-Member -MemberType 'NoteProperty' -Name 'ProjectId' -Value $Project.Id -PassThru
        | Sort-Object -Descending LastUpdated
}

function Get-GitlabProtectedBranch {
    [CmdletBinding()]
    [OutputType('Gitlab.ProtectedBranch')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project  = Get-GitlabProject -ProjectId $ProjectId

    $Request = @{
        HttpMethod = 'GET'
        Path       = "projects/$($Project.Id)/protected_branches"
    }

    if ($Name) {
        $Request.Path += "/$($Name | ConvertTo-UrlEncoded)"
    }

    try {
        # https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches
        Invoke-GitlabApi @Request
            | New-GitlabObject 'Gitlab.ProtectedBranch'
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
    [OutputType('Gitlab.Branch')]
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
        $Ref,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    $Request = @{
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/repository/branches"
        Body       = @{
            branch = $Branch
            ref    = $Ref
        }
    }

    if( $PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "create branch $($Branch) from $($Ref) `nArguments:`n$($Request | ConvertTo-Json)") ) {
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Branch'
    }
}

function Protect-GitlabBranch {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.ProtectedBranch')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',
        
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Name')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Branch = '.',
        
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
        [TrueOrFalse()][bool]
        $AllowForcePush = $false,
        
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
        [TrueOrFalse()][bool]
        $CodeOwnerApprovalRequired = $false,
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($Branch -eq '.') {
        $Branch = $(Get-LocalGitContext).Branch
    }

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
        #     Invoke-GitlabApi PATCH "projects/$($Project.Id)/protected_branches/$Branch" -Body $Request | New-GitlabObject 'Gitlab.ProtectedBranch'
        # }
        # as a workaround, remove protection
        Remove-GitlabProtectedBranch -ProjectId $ProjectId -Branch $Branch | Out-Null
    }

    $Request = @{
        HttpMethod = 'POST'
        Path       = "projects/$($Project.Id)/protected_branches"
        Body       = @{
                        name = $Branch
                      }
    }

    if($PSBoundParameters.ContainsKey('PushAccessLevel')) {
        $Request.Body.push_access_level =  $(Get-GitlabProtectedBranchAccessLevel).$PushAccessLevel
    }
    if($PSBoundParameters.ContainsKey('MergeAccessLevel')) {
        $Request.Body.merge_access_level =  $(Get-GitlabProtectedBranchAccessLevel).$MergeAccessLevel
    }
    if($PSBoundParameters.ContainsKey('UnprotectAccessLevel')) {
        $Request.Body.unprotect_access_level =  $(Get-GitlabProtectedBranchAccessLevel).$UnprotectAccessLevel
    }
    if($PSBoundParameters.ContainsKey('AllowForcePush')) {
        $Request.Body.allow_force_push =  $AllowForcePush
    }
    if($PSBoundParameters.ContainsKey('CodeOwnerApprovalRequired')) {
        $Request.Body.code_owner_approval_required =  $CodeOwnerApprovalRequired
    }
    if($PSBoundParameters.ContainsKey('AllowedToPush')) {
        $Request.Body.allowed_to_push = @($AllowedToPush | ConvertTo-SnakeCase)
    }
    if($PSBoundParameters.ContainsKey('AllowedToMerge')) {
        $Request.Body.allowed_to_merge = @($AllowedToMerge | ConvertTo-SnakeCase)
    }
    if($PSBoundParameters.ContainsKey('AllowedToUnprotect')) {
        $Request.Body.allowed_to_unprotect = @($AllowedToUnprotect | ConvertTo-SnakeCase)
    }

    if ($PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "protect branch name $Branch with `nArguments:`n$($Request | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/protected_branches.html#protect-repository-branches
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.ProtectedBranch'
    }
}

function UnProtect-GitlabBranch {
    [Alias('Remove-GitlabProtectedBranch')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',
        
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias('Branch')]
        [string]
        $Name = '.',
        
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($Name -eq '.') {
        $Name = $(Get-LocalGitContext).Branch
    }

    $Request = @{
        HttpMethod = 'DELETE'
        Path       = "projects/$($Project.Id)/protected_branches/$($Name | ConvertTo-UrlEncoded)"
    }

    if ($PSCmdlet.ShouldProcess("Project $($Project.PathWithNamespace)", "unprotect branch $($Name) with `nArguments:`n$($Request | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Unprotected branch '$Name'"
    }
}

function Remove-GitlabBranch {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name = '.',

        [switch]
        [Parameter(ParameterSetName='MergedBranches')]
        $MergedBranches,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId
    if ($Name -eq '.') {
        $Name = $(Get-LocalGitContext).Branch
    }
    $Request = @{
        HttpMethod = 'DELETE'
        Path       =  "projects/$($Project.Id)/repository"
    }
    $Label = ''

    switch ($PSCmdlet.ParameterSetName) {
        MergedBranches {
            # https://docs.gitlab.com/ee/api/branches.html#delete-merged-branches
            $Request.Path = "projects/$($Project.Id)/repository/merged_branches"
            $Label = "'merged branches"
        }
        default {
            if ($Name) {
                # https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
                $Request.Path = $Request.Path + "/branches/$($Name | ConvertTo-UrlEncoded)"
                $Label = "branch '$Name"
            } else {
                throw "Unsupported parameter combination"
            }
        }
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "delete $Label'")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Deleted $Label"
    }
}