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
        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ByGroupId')]
        [string]
        $GroupId,

        [Parameter(Mandatory=$true, ParameterSetName='ByParentGroup')]
        [string]
        $ParentGroupId,

        [Parameter(Mandatory=$false)]
        [Alias('r')]
        [switch]
        $Recurse,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $MaxPages = 10
    if($GroupId) {
        if ($GroupId -eq '.') {
            $LocalPath = Get-Location | Select-Object -ExpandProperty Path
            $MaxDepth = 3
            for ($i = 1; $i -le $MaxDepth; $i++) {
                $PossibleGroupName = Get-PossibleGroupName $LocalPath $i
                try {
                    $Group = Get-GitlabGroup $PossibleGroupName -SiteUrl $SiteUrl -WhatIf:$false
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
            } -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
    }
    elseif($ParentGroupId) {
        $SubgroupOperation = $Recurse ?
            'descendant_groups' # https://docs.gitlab.com/ee/api/groups.html#list-a-groups-descendant-groups
            :
            'subgroups' # https://docs.gitlab.com/ee/api/groups.html#list-a-groups-subgroups
        $Group = Invoke-GitlabApi GET "groups/$($ParentGroupId | ConvertTo-UrlEncoded)/$SubgroupOperation" `
          -SiteUrl $SiteUrl -WhatIf:$WhatIf -MaxPages $MaxPages
    }
    else {
        # https://docs.gitlab.com/ee/api/groups.html#list-groups
        $Group = Invoke-GitlabApi GET "groups" @{
            'top_level_only' = (-not $Recurse).ToString().ToLower()
        } -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf
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
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Group = Get-GitlabGroup $GroupId

    if ($PSCmdlet.ShouldProcess($Group.FullPath, "clone group" )) {
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

        Get-GitlabProject -GroupId $GroupId -Recurse -MaxPages 100 |
            ForEach-Object {
                $Path="$LocalPath/$($_.Group)"

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

# https://docs.gitlab.com/ee/api/group_level_variables.html#list-group-variables
function Get-GitlabGroupVariable {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    if ($Key) {
        Invoke-GitlabApi GET "groups/$GroupId/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        Invoke-GitlabApi GET "groups/$GroupId/variables" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
}

# https://docs.gitlab.com/ee/api/group_level_variables.html#update-variable
function Set-GitlabGroupVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $Key,

        [Parameter(Mandatory=$true, Position=2)]
        [string]
        $Value,

        [bool]
        [Parameter(Mandatory=$false)]
        $Protect = $false,

        [bool]
        [Parameter(Mandatory=$false)]
        $Mask = $false,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    $Query = @{
        value = $Value
    }

    if ($Protect) {
        $Query['protected'] = 'true'
    }
    else {
        $Query['protected'] = 'false'
    }
    if ($Mask) {
        $Query['masked'] = 'true'
    }
    else {
        $Query['masked'] = 'false'
    }

    try {
        Get-GitlabGroupVariable $GroupId $Key | Out-Null
        $IsExistingVariable = $True
    }
    catch {
        $IsExistingVariable = $False
    }

    if ($IsExistingVariable) {
        Invoke-GitlabApi PUT "groups/$GroupId/variables/$Key" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        $Query.Add('key', $Key)
        Invoke-GitlabApi POST "groups/$GroupId/variables" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
}

# https://docs.gitlab.com/ee/api/group_level_variables.html#remove-variable
function Remove-GitlabGroupVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    Invoke-GitlabApi DELETE "groups/$GroupId/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
}


# https://docs.gitlab.com/ee/api/groups.html#update-group
function Update-GitlabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $Path,

        [Parameter(Mandatory=$false)]
        [ValidateSet('private', 'internal', 'public')]
        [string]
        $Visibility,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
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

    Invoke-GitlabApi PUT "groups/$GroupId" -Body $Body -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Group'
}

function Rename-GitlabGroup {
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $NewName,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Update-GitlabGroup $GroupId -Name $NewName -Path $NewName -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

# https://docs.gitlab.com/ee/api/groups.html#create-a-link-to-share-a-group-with-another-group
function New-GitlabGroupShareLink {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $GroupShareId,

        [Parameter(Position=2, Mandatory=$true)]
        [ValidateSet('noaccess','minimalaccess','guest','reporter','developer','maintainer','owner')]
        [string]
        $AccessLevel,

        [Parameter(Mandatory=$false)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $ExpiresAt,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $GroupId = $GroupId | ConvertTo-UrlEncoded

    $Body = @{

        group_id = $GroupShareId
        group_access = Get-GitlabMemberAccessLevel $AccessLevel
        expires_at = $ExpiresAt
    }

    Invoke-GitlabApi POST "groups/$GroupId/share" -Body $Body -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Group'
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
