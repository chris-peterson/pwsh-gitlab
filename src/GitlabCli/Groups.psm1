function Get-GitlabGroup {
    [CmdletBinding(DefaultParameterSetName='ByGroupId')]
    [OutputType('Gitlab.Group')]
    param (
        [Parameter(Position=0, ParameterSetName='ByGroupId')]
        [string]
        $GroupId,

        [Parameter(Mandatory, ParameterSetName='ByParentGroup')]
        [string]
        $ParentGroupId,

        [Parameter(ParameterSetName='ByParentGroup')]
        [Alias('r')]
        [switch]
        $Recurse,

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

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All -Recurse:$Recurse
    if ($GroupId) {
        $GroupId = Resolve-LocalGroupPath -GroupId $GroupId
        # https://docs.gitlab.com/ee/api/groups.html#details-of-a-group
        $Group = Invoke-GitlabApi GET "groups/$($GroupId | ConvertTo-UrlEncoded)" @{
            'with_projects' = 'false'
        }
    }
    elseif ($ParentGroupId) {
        $SubgroupOperation = $Recurse ?
            'descendant_groups' # https://docs.gitlab.com/ee/api/groups.html#list-a-groups-descendant-groups
            :
            'subgroups' # https://docs.gitlab.com/ee/api/groups.html#list-a-groups-subgroups
        $Group = Invoke-GitlabApi GET "groups/$($ParentGroupId | ConvertTo-UrlEncoded)/$SubgroupOperation" `
          -MaxPages $MaxPages
    }
    else {
        # https://docs.gitlab.com/ee/api/groups.html#list-groups
        $Group = Invoke-GitlabApi GET "groups" @{
            'top_level_only' = (-not $Recurse).ToString().ToLower()
        } -MaxPages $MaxPages
    }

    return $Group |
        Where-Object -Not marked_for_deletion_on |
        New-GitlabObject 'Gitlab.Group' |
        Save-GroupToCache
}

function New-GitlabGroup {

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Group')]
    param (
        [Parameter(Position=0, Mandatory)]
        [Alias('Name')]
        [string]
        $GroupName,

        [Parameter()]
        [string]
        $ParentGroupName,

        [Parameter()]
        [ValidateSet([VisibilityLevel])]
        [string]
        $Visibility = 'internal',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Request = @{
          # https://docs.gitlab.com/ee/api/groups.html#new-group
        HttpMethod = "POST"
        Path       = "groups"
        Body       = @{
            name       = $GroupName
            path       = $GroupName
            visibility = $Visibility
        }
    }

    if ($ParentGroupName) {
        $Request.Body.parent_id = Resolve-GitlabGroupId $ParentGroupName
    }

    if ($PSCmdlet.ShouldProcess($GroupName, "create new $Visibility group '$GroupName'" )) {
        Invoke-GitlabApi @Request |
            New-GitlabObject 'Gitlab.Group'
    }
}

function Remove-GitlabGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(Position=0)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $GroupId = Resolve-GitlabGroupId $GroupId

    if ($PSCmdlet.ShouldProcess($GroupId, "delete group")) {
        # https://docs.gitlab.com/ee/api/groups.html#remove-group
        Invoke-GitlabApi DELETE "groups/$GroupId" | Out-Null
        Write-Host "$GroupId deleted"
    }
}

function Copy-GitlabGroupToLocalFileSystem {
    [Alias("Clone-GitlabGroup")]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $ProjectLike,

        [Parameter()]
        [string]
        $ProjectNotLike,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Group = Get-GitlabGroup $GroupId

    $GroupSplit = $Group.FullPath -split '/'

    $OriginalPath = $LocalPath = $(Get-Location).Path
    for ($i = 0; $i -lt $GroupSplit.Count; $i++)
    {
        $ToMatch = $($GroupSplit | Select-Object -First $($GroupSplit.Count - $i)) -join '/'
        if ($LocalPath -imatch "$ToMatch$") {
            $LocalPath = $LocalPath.Replace($ToMatch, "").TrimEnd('/')
            break;
        }
    }

    $Projects = Get-GitlabProject -GroupId $GroupId -Recurse -All

    if ($ProjectLike) {
        $Projects = $Projects | Where-Object PathWithNamespace -Match $ProjectLike
    }
    if ($ProjectNotLike) {
        $Projects = $Projects | Where-Object PathWithNamespace -NotMatch $ProjectNotLike
    }

    if ($PSCmdlet.ShouldProcess("local file system ($LocalPath/$($Group.FullPath))", "clone $($Projects.Length) projects from $($Group.FullPath)" )) {
        $Projects | ForEach-Object {
            $Path = "$LocalPath/$($_.Group)"

            if (-not $(Test-Path $Path)) {
                New-Item $Path -Type Directory | Out-Null
            }

            Set-Location $Path
            git clone $_.SshUrlToRepo
        }

        Set-Location $OriginalPath
    }
}

function Update-LocalGitlabGroup {
    [Alias("Pull-GitlabGroup")]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param (
    )

    Get-ChildItem -Recurse -Hidden -Directory |
        Where-Object Name -match '.git$' |
        ForEach-Object {
            Push-Location

            if ($PSCmdlet.ShouldProcess("$_", "git pull -p")) {
                Set-Location -Path "$_/.."
                git pull -p
            }
            Pop-Location
    }
}

function Get-GitlabGroupVariable {

    [CmdletBinding()]
    [OutputType('Gitlab.Variable')]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Position=1)]
        [string]
        $Key,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All
    )

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    if ($Key) {
        # https://docs.gitlab.com/ee/api/group_level_variables.html#show-variable-details
        Invoke-GitlabApi GET "groups/$GroupId/variables/$Key" | New-GitlabObject 'Gitlab.Variable'
    }
    else {
        # https://docs.gitlab.com/ee/api/group_level_variables.html#list-group-variables
        Invoke-GitlabApi GET "groups/$GroupId/variables" -MaxPages $MaxPages | New-GitlabObject 'Gitlab.Variable'
    }
}

function Set-GitlabGroupVariable {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    [OutputType('Gitlab.Variable')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory, Position=1)]
        [string]
        $Value,

        [TrueOrFalse()][bool]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Protect,

        [TrueOrFalse()][bool]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Mask,

        [TrueOrFalse()][bool]
        [Parameter(ValueFromPipelineByPropertyName)]
        $ExpandVariables = $true,

        [switch]
        [Parameter()]
        $NoExpand,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($NoExpand) {
        $ExpandVariables = $false
    }

    $GroupId = Resolve-GitlabGroupId $GroupId

    $Request = @{
        value = $Value
        raw   = -not $ExpandVariables
    }
    if ($PSBoundParameters.ContainsKey('Protect')) {
        $Request.protected = $Protect
    }
    if ($PSBoundParameters.ContainsKey('Mask')) {
        $Request.masked = $Mask
    }

    try {
        Get-GitlabGroupVariable $GroupId $Key | Out-Null
        $IsExistingVariable = $True
    }
    catch {
        $IsExistingVariable = $False
    }

    if ($PSCmdlet.ShouldProcess("group $GroupId", "set $($IsExistingVariable ? 'existing' : 'new') variable $Key to $Value")) {
        if ($IsExistingVariable) {
            # https://docs.gitlab.com/ee/api/group_level_variables.html#update-variable
            Invoke-GitlabApi PUT "groups/$GroupId/variables/$Key" -Body $Request | New-GitlabObject 'Gitlab.Variable'
        }
        else {
            $Request.key = $Key
            # https://docs.gitlab.com/ee/api/group_level_variables.html#create-variable
            Invoke-GitlabApi POST "groups/$GroupId/variables" -Body $Request | New-GitlabObject 'Gitlab.Variable'
        }
    }
}

function Remove-GitlabGroupVariable {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory, Position=0)]
        [string]
        $Key,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $GroupId = Resolve-GitlabGroupId $GroupId

    if ($PSCmdlet.ShouldProcess("group $GroupId", "remove variable $Key")) {
        # https://docs.gitlab.com/ee/api/group_level_variables.html#remove-variable
        Invoke-GitlabApi DELETE "groups/$GroupId/variables/$Key" | Out-Null
        Write-Host "Removed $Key from group $GroupId"
    }
}

# https://docs.gitlab.com/ee/api/groups.html#update-group
function Update-GitlabGroup {

    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Group')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [ValidateSet([VisibilityLevel])]
        [string]
        $Visibility,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    $Body = @{}

    if ($Name) {
        $Body.name = $Name
    }
    if ($Path) {
        $Body.path = $Path
    }
    if ($Visibility) {
        $Body.visibility = $Visibility
    }

    if ($PSCmdlet.ShouldProcess("group $GroupId", "update ($($Body | ConvertTo-Json))")) {
        Invoke-GitlabApi PUT "groups/$GroupId" -Body $Body | New-GitlabObject 'Gitlab.Group'
    }
}

function Rename-GitlabGroup {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Group')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $GroupId = '.',

        [Parameter(Position=0, Mandatory)]
        [string]
        $NewName,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("group $GroupId", "rename to $NewName")) {
        Update-GitlabGroup $GroupId -Name $NewName -Path $NewName
    }
}

function Move-GitlabGroup {
    [Alias("Transfer-GitlabGroup")]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Group')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $GroupId = '.',

        [Parameter()]
        [string]
        $DestinationGroupId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Request = @{}
    if ($DestinationGroupId) {
        $Request.group_id = Resolve-GitlabGroupId $DestinationGroupId
        $DestinationLabel = "group $DestinationGroupId"
    } else {
        $DestinationLabel = "top level group"
    }

    if ($PSCmdlet.ShouldProcess("group $GroupId", "transfer to $DestinationLabel")) {
        Invoke-GitlabApi POST "groups/$($GroupId)/transfer" $Request | New-GitlabObject 'Gitlab.Group'
    }
}


function New-GitlabGroupToGroupShare {
    [Alias('Share-GitlabGroupWithGroup')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Group')]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Alias('ShareWith')]
        [Parameter(Mandatory, Position=1)]
        [string]
        $GroupShareId,

        [Parameter(Mandatory, Position=2)]
        [ValidateSet('noaccess','minimalaccess','guest','reporter','developer','maintainer','owner')]
        [string]
        $AccessLevel,

        [Parameter()]
        [GitlabDate()][string]
        $ExpiresAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Body = @{
        group_id     = Resolve-GitlabGroupId $GroupShareId
        group_access = Get-GitlabMemberAccessLevel $AccessLevel
    }
    if ($ExpiresAt) {
        $Body.expires_at = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess($GroupId, "share with group '$GroupShareId' ($AccessLevel)")) {
        # https://docs.gitlab.com/ee/api/groups.html#share-groups-with-groups
        Invoke-GitlabApi POST "groups/$GroupId/share" -Body $Body | New-GitlabObject 'Gitlab.Group'
    }
}

function Remove-GitlabGroupToGroupShare {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory, Position=1)]
        [string]
        $GroupShareId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess($GroupId, "remove sharing with group '$GroupShareId'")) {
        # https://docs.gitlab.com/api/groups/#delete-the-link-that-shares-a-group-with-another-group
        if (Invoke-GitlabApi DELETE "groups/$GroupId/share/$(Resolve-GitlabGroupId $GroupShareId)" | Out-Null) {
            Write-Host "Removed sharing with $GroupShareId from $GroupId"
        }
    }
}
