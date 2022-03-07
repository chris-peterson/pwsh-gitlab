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
        [string]
        $SiteUrl,

        [Parameter(Mandatory=$false)]
        [Alias('r')]
        [switch]
        $Recurse,

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

function New-GitlabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupName,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $ParentGroupName,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $ParentGroup = Get-GitlabGroup -GroupId $ParentGroupName
    $GroupId = Invoke-GitlabApi POST "groups" @{
        name = $GroupName
        path = $GroupName
        parent_id = $ParentGroup.Id
        visibility = $ParentGroup.Visibility
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf | Select-Object -ExpandProperty id
    if(-not $WhatIf) {
        return Get-GitlabGroup -GroupId $GroupId
    }
}

function Remove-GitlabGroup {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Group = Get-GitlabGroup -GroupId $GroupId

    Invoke-GitlabApi DELETE "groups/$($Group.Id)" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
}

function Copy-GitlabGroupToLocalFileSystem {
    [Alias("Clone-GitlabGroup")]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Push-Location

    $Group = Get-GitlabGroup $GroupId
    $GroupSplit = $Group.FullPath -split '/'

    $LocalPath = $(Get-Location).Path
    for ($i = 0; $i -lt $GroupSplit.Count; $i++)
    {
        $ToMatch = $($GroupSplit | Select-Object -First $($GroupSplit.Count - $i)) -join '/'
        if ($LocalPath -imatch "$ToMatch$") {
            $LocalPath = $LocalPath.Replace($ToMatch, "").TrimEnd('/')
            break;
        }
    }

    if ($WhatIf) {
        Write-Host "WhatIf: setting local directory to '$LocalPath'"
    }

    Get-GitlabProject -GroupId $GroupId -Recurse -MaxPages 100 |
        ForEach-Object {
            $Path="$LocalPath/$($_.Group)"

            if ($WhatIf) {
                Write-Host "WhatIf: cloning $($_.SshUrlToRepo) to $Path"
            } else {
                if (-not $(Test-Path $Path)) {
                    New-Item $Path -Type Directory | Out-Null
                }
                Push-Location
                Set-Location $Path
                git clone $_.SshUrlToRepo
                Pop-Location
            }
        }

    Pop-Location

    if ($WhatIf) {
        Write-Host "WhatIf: setting directory to $LocalPath"
    } else {
        Set-Location $LocalPath
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

        [switch]
        [Parameter(Mandatory=$false)]
        $Protect,

        [switch]
        [Parameter(Mandatory=$false)]
        $Mask,

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
    if ($Mask) {
        $Query['masked'] = 'true'
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
