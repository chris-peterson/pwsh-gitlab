# Contains wrappers for
# https://docs.gitlab.com/ee/api/repository_files.html

# https://docs.gitlab.com/ee/api/repository_files.html#get-file-from-repository
function Get-GitlabRepositoryFileContent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [Alias("Branch")]
        [string]
        $Ref = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $FilePath,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId
    $RefName = $(Get-GitlabBranch -ProjectId $ProjectId -Ref $Ref).Name

    $File = Invoke-GitlabApi GET "projects/$($Project.Id)/repository/files/$($FilePath)?ref=$RefName" -SiteUrl $SiteUrl -WhatIf:$WhatIf
    
    if ($File -and $File.encoding -eq 'base64') {
        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($File.content))
    }
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
        $Ref = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    New-Object 'psobject' -Property $(ConvertFrom-Yaml $(Get-GitlabRepositoryFileContent -ProjectId $ProjectId -Ref $Ref -FilePath '.gitlab-ci.yml' -SiteUrl $SiteUrl -WhatIf:$WhatIf))
}
