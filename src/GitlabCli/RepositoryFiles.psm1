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

function Get-GitlabCiYml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

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

    Get-GitlabRepositoryYmlFileContent -ProjectId $ProjectId -FilePath '.gitlab-ci.yml' -Ref $Ref -SiteUrl $SiteUrl -WhatIf:$WhatIf
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
