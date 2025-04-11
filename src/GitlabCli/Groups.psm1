function Get-PossibleGroupName {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $Path,

        [Parameter(Position=1, Mandatory=$false)]
        [uint]
        $Depth = 1
    )

    $Split = $(Get-Location).Path -split '/'
    $($Split | Select-Object -Last $Depth) -join '/'
}

# https://docs.gitlab.com/ee/api/groups.html#details-of-a-group
function Get-GitlabGroup {
    [CmdletBinding(DefaultParameterSetName='ByGroupId')]
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

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    if($GroupId) {
        if ($GroupId -eq '.') {
            $LocalPath = Get-Location | Select-Object -ExpandProperty Path
            $MaxDepth = 3
            for ($i = 1; $i -le $MaxDepth; $i++) {
                $PossibleGroupName = Get-PossibleGroupName $LocalPath $i
                try {
                    $Group = Get-GitlabGroup $PossibleGroupName -SiteUrl $SiteUrl
                    if ($Group) {
                        return $Group
                    }
                }
                catch {
                }
                Write-Verbose "Didn't find a group named '$PossibleGroupName'"
            }
        } else {
            # https://docs.gitlab.com/ee/api/groups.html#details-of-a-group
            $Group = Invoke-GitlabApi GET "groups/$($GroupId | ConvertTo-UrlEncoded)" @{
                'with_projects' = 'false'
            } -SiteUrl $SiteUrl
        }
    }
    elseif($ParentGroupId) {
        $SubgroupOperation = $Recurse ?
            'descendant_groups' # https://docs.gitlab.com/ee/api/groups.html#list-a-groups-descendant-groups
            :
            'subgroups' # https://docs.gitlab.com/ee/api/groups.html#list-a-groups-subgroups
        $Group = Invoke-GitlabApi GET "groups/$($ParentGroupId | ConvertTo-UrlEncoded)/$SubgroupOperation" `
          -SiteUrl $SiteUrl -MaxPages $MaxPages
    }
    else {
        # https://docs.gitlab.com/ee/api/groups.html#list-groups
        $Group = Invoke-GitlabApi GET "groups" @{
            'top_level_only' = (-not $Recurse).ToString().ToLower()
        } -MaxPages $MaxPages -SiteUrl $SiteUrl
    }

    return $Group |
        Where-Object -Not marked_for_deletion_on |
        New-WrapperObject 'Gitlab.Group'
}

# https://docs.gitlab.com/ee/api/groups.html#new-group
function New-GitlabGroup {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [Alias('Name')]
        [string]
        $GroupName,

        [Parameter()]
        [string]
        $ParentGroupName,

        [Parameter()]
        [ValidateSet('private', 'internal', 'public')]
        [string]
        $Visibility = 'internal',

        [Parameter()]
        [string]
        $SiteUrl
    )
    $Query = @{
        name       = $GroupName
        path       = $GroupName
        visibility = $Visibility
    }

    if ($ParentGroupName) {
        $ParentGroup = Get-GitlabGroup -GroupId $ParentGroupName
        $Query.parent_id = $ParentGroup.Id
    }

    if ($PSCmdlet.ShouldProcess($GroupName, "create new $Visibility group '$GroupName'" )) {
        Invoke-GitlabApi POST "groups" $Query -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference |
            New-WrapperObject 'Gitlab.Group'
    }
}

# https://docs.gitlab.com/ee/api/groups.html#remove-group
function Remove-GitlabGroup {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Group = Get-GitlabGroup -GroupId $GroupId

    if ($PSCmdlet.ShouldProcess($Group.FullPath, "delete group")) {
        Invoke-GitlabApi DELETE "groups/$($Group.Id)" -SiteUrl $SiteUrl | Out-Null
        Write-Host "$($Group.FullPath) deleted"
    }
}

function Copy-GitlabGroupToLocalFileSystem {
    [Alias("Clone-GitlabGroup")]
    [CmdletBinding(SupportsShouldProcess)]
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
    [CmdletBinding()]
    param (
        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    Get-ChildItem -Recurse -Hidden -Directory |
        Where-Object Name -match '.git$' |
        ForEach-Object {
            Push-Location

            if ($WhatIf) {
                Write-Host "WhatIf: git pull -p '$_'"
            } else {
                Set-Location -Path "$_/.."
                git pull -p
            }
            Pop-Location
    }
}

function Get-GitlabGroupVariable {

    [CmdletBinding()]
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

    $MaxPages = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    if ($Key) {
        # https://docs.gitlab.com/ee/api/group_level_variables.html#show-variable-details
        Invoke-GitlabApi GET "groups/$GroupId/variables/$Key" -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        # https://docs.gitlab.com/ee/api/group_level_variables.html#list-group-variables
        Invoke-GitlabApi GET "groups/$GroupId/variables" -SiteUrl $SiteUrl -MaxPages $MaxPages | New-WrapperObject 'Gitlab.Variable'
    }
}

function Set-GitlabGroupVariable {

    [CmdletBinding(SupportsShouldProcess)]
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

        [switch]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Protect,

        [switch]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Mask,

        [ValidateSet($null, 'true', 'false')]
        [Parameter(ValueFromPipelineByPropertyName)]
        $ExpandVariables = 'true',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Group = Get-GitlabGroup $GroupId

    $Request = @{
        value = $Value
        raw   = $ExpandVariables -eq 'true' ? 'false' : 'true'
    }
    if ($Protect) {
        $Request.protected = 'true'
    }
    if ($Mask) {
        $Request.masked = 'true'
    }

    try {
        Get-GitlabGroupVariable $GroupId $Key | Out-Null
        $IsExistingVariable = $True
    }
    catch {
        $IsExistingVariable = $False
    }

    if ($PSCmdlet.ShouldProcess("$($Group.FullName)", "set $($IsExistingVariable ? 'existing' : 'new') variable $Key to $Value")) {
        if ($IsExistingVariable) {
            # https://docs.gitlab.com/ee/api/group_level_variables.html#update-variable
            Invoke-GitlabApi PUT "groups/$($Group.Id)/variables/$Key" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
        }
        else {
            $Request.key = $Key
            # https://docs.gitlab.com/ee/api/group_level_variables.html#create-variable
            Invoke-GitlabApi POST "groups/$($Group.Id)/variables" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
        }
    }
}

function Remove-GitlabGroupVariable {

    [CmdletBinding(SupportsShouldProcess)]
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

    $Group = Get-GitlabGroup $GroupId

    if ($PSCmdlet.ShouldProcess("$($Group.FullPath)", "remove variable $Key")) {
        # https://docs.gitlab.com/ee/api/group_level_variables.html#remove-variable
        Invoke-GitlabApi DELETE "groups/$($Group.Id)/variables/$Key" -SiteUrl $SiteUrl | Out-Null
        Write-Host "Removed $Key from $($Group.FullPath)"
    }
}

# https://docs.gitlab.com/ee/api/groups.html#update-group
function Update-GitlabGroup {

    [CmdletBinding(SupportsShouldProcess)]
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
        [ValidateSet('private', 'internal', 'public')]
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
        Invoke-GitlabApi PUT "groups/$GroupId" -Body $Body -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Group'
    }
}

function Rename-GitlabGroup {
    [CmdletBinding(SupportsShouldProcess)]
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
        Update-GitlabGroup $GroupId -Name $NewName -Path $NewName -SiteUrl $SiteUrl
    }
}

function Move-GitlabGroup {
    [Alias("Transfer-GitlabGroup")]
    [CmdletBinding(SupportsShouldProcess)]
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
        $Request.group_id = Get-GitlabGroup $DestinationGroupId | Select-Object -ExpandProperty Id
        $DestinationLabel = "group $DestinationGroupId"
    } else {
        $DestinationLabel = "top level group"
    }

    if ($PSCmdlet.ShouldProcess("group $GroupId", "transfer to $DestinationLabel")) {
        Invoke-GitlabApi POST "groups/$($GroupId)/transfer" $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Group'
    }
}


function New-GitlabGroupShareLink {
    [Alias('Share-GitlabGroupWithGroup')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0)]
        [string]
        $GroupId,

        [Alias('ShareWith')]
        [Parameter(Position=1)]
        [string]
        $GroupShareId,

        [Parameter(Position=2)]
        [ValidateSet('noaccess','minimalaccess','guest','reporter','developer','maintainer','owner')]
        [string]
        $AccessLevel,

        [Parameter()]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $ExpiresAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Group            = Get-GitlabGroup $GroupId
    $GroupToShareWith = Get-GitlabGroup $GroupShareId

    $Body = @{
        group_id     = $GroupToShareWith.Id
        group_access = Get-GitlabMemberAccessLevel $AccessLevel
        expires_at   = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess("$($Group.FullPath)", "share with group '$($GroupToShareWith.FullPath)'")) {
        # https://docs.gitlab.com/ee/api/groups.html#share-groups-with-groups
        Invoke-GitlabApi POST "groups/$GroupId/share" -Body $Body -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Group'
    }
}

# https://docs.gitlab.com/ee/api/groups.html#delete-link-sharing-group-with-another-group
function Remove-GitlabGroupShareLink {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $GroupShareId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    Invoke-GitlabApi DELETE "groups/$GroupId/share/$GroupShareId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
}
