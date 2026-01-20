function Get-GitlabRepositoryFileContent {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Path")]
        [string]
        $FilePath,

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $File = Get-GitlabRepositoryFile -ProjectId $ProjectId -FilePath $FilePath -Ref $Ref

    if ($File -and $File.Encoding -eq 'base64') {
        return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($File.Content))
    }
}

function Get-GitlabRepositoryFile {
    [CmdletBinding()]
    [OutputType('Gitlab.RepositoryFile')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Path")]
        [string]
        $FilePath,

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $SiteUrl
    )


    if ($FilePath.StartsWith('./')) {
        $FilePath = $FilePath.Substring(2);
    }
    $Project = Get-GitlabProject $ProjectId
    if (-not $Ref) {
        $Ref = $Project.DefaultBranch
    }
    $RefName = $(Get-GitlabBranch -ProjectId $ProjectId -Ref $Ref).Name

    try {
        # https://docs.gitlab.com/api/repository_files/#get-file-from-repository
        return Invoke-GitlabApi GET "projects/$($Project.Id)/repository/files/$($FilePath | ConvertTo-UrlEncoded)?ref=$RefName" |
            New-GitlabObject 'Gitlab.RepositoryFile'
    }
    catch {
        $Ex = $_
        switch ($ErrorActionPreference){
            'Stop' { throw $Ex }
            default { Write-Warning "File $FilePath not found in $($Project.Name) ($RefName)"; return $null }
        }
    }
}

function New-GitlabRepositoryFile {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
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

        [TrueOrFalse()][bool]
        [Parameter(Mandatory=$false)]
        $SkipCi = $true,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
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
    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)/$FilePath ($Branch)", "create file")) {
        if (Invoke-GitlabApi POST "projects/$($Project.Id)/repository/files/$($FilePath | ConvertTo-UrlEncoded)" -Body $Body) {
            Write-Host "Created $FilePath in $($Project.Name) ($Branch)"
        }
    }
}

# https://docs.gitlab.com/ee/api/repository_files.html#update-existing-file-in-repository
function Update-GitlabRepositoryFile {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
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

        [TrueOrFalse()][bool]
        [Parameter(Mandatory=$false)]
        $SkipCi = $true,

        [switch]
        [Parameter(Mandatory=$false)]
        $SkipEqualityCheck = $false,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
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
    if (-not $SkipEqualityCheck) {
        $CurrentContent = Get-GitlabRepositoryFileContent -ProjectId $Project.Id -Ref $Branch -FilePath $FilePath
        if ($CurrentContent -eq $Content) {
            Write-Host "$FilePath contents is identical, skipping update"
            return
        }
    }
    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)/$FilePath ($Branch)", "update file")) {
        if (Invoke-GitlabApi PUT "projects/$($Project.Id)/repository/files/$($FilePath | ConvertTo-UrlEncoded)" -Body $Body) {
            Write-Host "Updated $FilePath in $($Project.Name) ($Branch)"
        }
    }
}

function Get-GitlabRepositoryTree {
    [CmdletBinding()]
    [OutputType('Gitlab.RepositoryTree')]
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
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId
    if (-not $Ref) {
        $Ref = $Project.DefaultBranch
    }
    $RefName = $(Get-GitlabBranch -ProjectId $ProjectId -Ref $Ref).Name

    Invoke-GitlabApi GET "projects/$($Project.Id)/repository/tree?ref=$RefName&path=$Path&recursive=$($Recurse.ToString().ToLower())" -MaxPages 10 |
        New-GitlabObject 'Gitlab.RepositoryTree'
}

function Get-GitlabRepositoryYmlFileContent {
    [Obsolete("Use 'Get-GitlabRepositoryFileContent | ConvertFrom-Yaml' instead")]
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter()]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory)]
        [string]
        $FilePath,

        [Parameter()]
        [Alias("Branch")]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $SiteUrl
    )

    Get-GitlabRepositoryFileContent -ProjectId $ProjectId -Ref $Ref -FilePath $FilePath |
        ConvertFrom-Yaml
}
