function Get-GitLabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId
    )

    $Group = Invoke-GitlabApi GET "groups/$([System.Net.WebUtility]::UrlEncode($GroupId))" @{
        'with_projects' = 'false'
    }

    return $Group | New-WrapperObject -DisplayType 'GitLab.Group'
}

function New-GitLabGroup {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupName,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $ParentGroupName,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $ParentGroup = Get-GitLabGroup -GroupId $ParentGroupName
    $GroupId = Invoke-GitlabApi POST "groups" @{
        name = $GroupName
        path = $GroupName
        parent_id = $ParentGroup.Id
        visibility = $ParentGroup.Visibility
    } -WhatIf:$WhatIf | Select-Object -ExcludeProperty id
    if(-not $WhatIf) {
        return Get-GitLabGroup -GroupId $GroupId
    }
}


function Remove-GitLabGroup {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    $Group = Get-GitLabGroup -GroupId $GroupId

    Invoke-GitlabApi DELETE "groups/$($Group.Id)" -WhatIf:$WhatIf | Out-Null
}

function Copy-GitLabGroupToLocalFileSystem {
    [Alias("Clone-GitLabGroup")]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $GroupId,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf = $false
    )

    Push-Location

    $Group = Get-GitLabGroup $GroupId
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

    Get-GitLabProject -GroupId $GroupId |
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

function Update-LocalGitLabGroup {
    [Alias("Pull-GitLabGroup")]
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
