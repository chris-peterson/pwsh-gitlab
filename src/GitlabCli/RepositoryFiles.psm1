# Contains wrappers for
# https://docs.gitlab.com/ee/api/repository_files.html

# https://docs.gitlab.com/ee/api/repository_files.html#get-file-from-repository
function Get-GitlabRepositoryFileContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $FilePath,

        [Parameter(Mandatory=$false)]
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

    $File = Get-GitlabRepositoryFile -ProjectId $ProjectId -FilePath $FilePath -Ref $Ref -SiteUrl $SiteUrl -WhatIf:$WhatIf

    if ($File -and $File.Encoding -eq 'base64') {
        return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($File.Content))
    }
}

function Get-GitlabRepositoryFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $FilePath,

        [Parameter(Mandatory=$false)]
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

    $Project = Get-GitlabProject $ProjectId
    if (-not $Ref) {
        $Ref = $Project.DefaultBranch
    }
    $RefName = $(Get-GitlabBranch -ProjectId $ProjectId -Ref $Ref).Name

    return Invoke-GitlabApi GET "projects/$($Project.Id)/repository/files/$($FilePath | ConvertTo-UrlEncoded)?ref=$RefName" -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.RepositoryFile'
}

# https://docs.gitlab.com/ee/api/repository_files.html#update-existing-file-in-repository
function Update-GitlabRepositoryFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $Branch,

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $FilePath,

        [Parameter(Mandatory=$true)]
        [string]
        $Content,

        [Parameter(Mandatory=$true)]
        [string]
        $CommitMessage,

        [bool]
        [Parameter(Mandatory=$false)]
        $SkipCi = $true,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId
    if (-not $Branch) {
        $Branch = $Project.DefaultBranch
    }
    $Body = @{
        branch         = $Branch
        content        = $Content
        commit_message = $CommitMessage
    }
    if ($SkipCi) {
        $Body.commit_message += "`n[skip ci]"
    }

    if (Invoke-GitlabApi PUT "projects/$($Project.Id)/repository/files/$($FilePath | ConvertTo-UrlEncoded)" -Body $Body -SiteUrl $SiteUrl -WhatIf:$WhatIf) {
        Write-Host "Updated $FilePath in $($Project.Name) ($Branch)"
    }
}

function Get-GitlabRepositoryTree {
    param(
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $Path,

        [Parameter(Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref,

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

    $Project = Get-GitlabProject $ProjectId
    if (-not $Ref) {
        $Ref = $Project.DefaultBranch
    }
    $RefName = $(Get-GitlabBranch -ProjectId $ProjectId -Ref $Ref).Name

    Invoke-GitlabApi GET "projects/$($Project.Id)/repository/tree?ref=$RefName&path=$Path&recursive=$($Recurse.ToString().ToLower())" -MaxPages 10 -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.RepositoryTree'
}

function Get-GitlabRepositoryYmlFileContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $FilePath,

        [Parameter(Mandatory=$false)]
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

    $Yml = $(Get-GitlabRepositoryFileContent -ProjectId $ProjectId -Ref $Ref -FilePath $FilePath -SiteUrl $SiteUrl -WhatIf:$WhatIf)
    $Hash = $([YamlDotNet.Serialization.Deserializer].GetMethods() |
        Where-Object { $_.Name -eq 'Deserialize' -and $_.ReturnType.Name -eq 'T' -and $_.GetParameters().ParameterType.Name -eq 'String' }). `
        MakeGenericMethod(
            [object]). `
        Invoke($(New-Object 'YamlDotNet.Serialization.Deserializer'), $Yml)

    return $Hash | ConvertTo-Json -Depth 100 | ConvertFrom-Json # the JSON "double-tap" coerces HashTables into PSCustomObject (including nested children)
}
