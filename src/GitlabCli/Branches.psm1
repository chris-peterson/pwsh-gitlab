function Get-GitlabBranch {
    [CmdletBinding(DefaultParameterSetName='Ref')]
    [OutputType('Gitlab.Branch')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='Search')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Search,

        [Parameter(Position=0, ParameterSetName='Ref')]
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

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/api/branches/#list-repository-branches
    $Request = @{
        HttpMethod = 'GET'
        Path       = "projects/$ProjectId/repository/branches"
        Query      = @{}
        MaxPages   = $MaxPages
    }
    if ($Ref) {
        # https://docs.gitlab.com/api/branches/#get-single-repository-branch
        $Request.Path += "/$((Resolve-GitlabBranch $Ref) | ConvertTo-UrlEncoded)"
    }
    elseif ($Search) {
        $Request.Query.search = $Search
    }

    Invoke-GitlabApi @Request |
        New-GitlabObject 'Gitlab.Branch' |
        Add-Member -NotePropertyMembers @{ ProjectId = $ProjectId } -PassThru |
        Sort-Object -Descending LastUpdated
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

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Request = @{
        HttpMethod = 'GET'
        Path       = "projects/$ProjectId/protected_branches"
    }

    if ($Name) {
        $Request.Path += "/$($Name | ConvertTo-UrlEncoded)"
    }

    $Branches = @()
    try {
        # https://docs.gitlab.com/ee/api/protected_branches.html#list-protected-branches
        $Branches = Invoke-GitlabApi @Request
            | New-GitlabObject 'Gitlab.ProtectedBranch'
            | Add-Member -PassThru -NotePropertyMembers @{
                ProjectId = $ProjectId
            }
    } catch {
        if ($_.Exception.Response.StatusCode.ToString() -eq 'NotFound') {
        } else {
            throw
        }
    }
    return $Branches
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

    $ProjectId = Resolve-GitlabProjectId -ProjectId $ProjectId
    $Request = @{
        HttpMethod = 'POST'
        Path       = "projects/$($ProjectId)/repository/branches"
        Body       = @{
            branch = $Branch
            ref    = $Ref
        }
    }

    if( $PSCmdlet.ShouldProcess("Project $($ProjectId)", "create branch $($Branch) from $($Ref) `nArguments:`n$($Request | ConvertTo-Json)") ) {
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

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Branch = Resolve-GitlabBranch $Branch

    if (Get-GitlabProtectedBranch -ProjectId $ProjectId | Where-Object Name -eq $Branch) {
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
        UnProtect-GitlabBranch -ProjectId $ProjectId -Branch $Branch | Out-Null
    }

    $Request = @{
        HttpMethod = 'POST'
        Path       = "projects/$ProjectId/protected_branches"
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

    if ($PSCmdlet.ShouldProcess("Project $ProjectId", "protect branch name $Branch with `nArguments:`n$($Request | ConvertTo-Json)")) {
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

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Name = Resolve-GitlabBranch $Name

    $Request = @{
        HttpMethod = 'DELETE'
        Path       = "projects/$ProjectId/protected_branches/$($Name | ConvertTo-UrlEncoded)"
    }

    if ($PSCmdlet.ShouldProcess("Project $ProjectId", "unprotect branch $($Name) with `nArguments:`n$($Request | ConvertTo-Json)")) {
        # https://docs.gitlab.com/ee/api/protected_branches.html#unprotect-repository-branches
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Unprotected branch '$Name'"
    }
}

function Remove-GitlabBranch {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High', DefaultParameterSetName='ByBranch')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ProjectId = '.',

        [Alias('Name')]
        [Parameter(Position=0, ValueFromPipelineByPropertyName, ParameterSetName='ByBranch')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Branch = '.',

        [switch]
        [Parameter(ParameterSetName='MergedBranches')]
        $MergedBranches,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId
    $Name = Resolve-GitlabBranch $Name
    $Request = @{
        HttpMethod = 'DELETE'
        Path       =  "projects/$ProjectId/repository"
    }
    $Label = ''

    if ($MergedBranches) {
        # https://docs.gitlab.com/ee/api/branches.html#delete-merged-branches
        $Request.Path = "projects/$ProjectId/repository/merged_branches"
        $Label = "'merged branches"
    } elseif ($Branch) {
        # https://docs.gitlab.com/ee/api/branches.html#delete-repository-branch
        $Request.Path = $Request.Path + "/branches/$($Branch | ConvertTo-UrlEncoded)"
        $Label = "branch '$Branch"
     } else {
        throw "Unsupported parameter combination"
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "delete $Label'")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Deleted $Label"
    }
}
