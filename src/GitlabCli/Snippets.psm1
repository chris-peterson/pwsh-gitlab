function Get-GitlabSnippet {
    [CmdletBinding(DefaultParameterSetName='Mine')]
    param (
        [Parameter(Position=0, ParameterSetName='ById', Mandatory)]
        [int]
        $SnippetId,

        [Parameter(ParameterSetName='ByAuthor')]
        [string]
        $AuthorUsername,

        [Parameter(ParameterSetName='Mine')]
        [switch]
        $Mine,

        [Parameter()]
        [ValidateScript({-not $_ -or (Test-GitlabDate $_)})]
        [string]
        $CreatedAfter,

        [Parameter()]
        [ValidateScript({-not $_ -or (Test-GitlabDate $_)})]
        [string]
        $CreatedBefore,

        [Parameter()]
        [switch]
        $IncludeContent,

        [Parameter()]
        [uint]
        $MaxPages,

        [Parameter()]
        [switch]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $MaxPages = Get-GitlabMaxPages -All:$All -MaxPages:$MaxPages

    $Query = @{}

    if ($CreatedAfter) {
        $Query.created_after = $CreatedAfter
    }
    if ($CreatedBefore) {
        $Query.created_before = $CreatedBefore
    }

    $Snippet = $null;
    switch ($PSCmdlet.ParameterSetName) {
        ById {
            # https://docs.gitlab.com/api/snippets/#get-a-single-snippet
            $Snippet = Invoke-GitlabApi GET "snippets/$SnippetId" -SiteUrl $SiteUrl
        }
        ByAuthor {
            try {
                Start-GitlabUserImpersonation -UserId $AuthorUsername -SiteUrl $SiteUrl
                return Get-GitlabSnippet -Mine -CreatedAfter:$CreatedAfter -CreatedBefore:$CreatedBefore -IncludeContent:$IncludeContent -MaxPages:$MaxPages -SiteUrl:$SiteUrl
            }
            finally {
                Stop-GitlabUserImpersonation -SiteUrl $SiteUrl
            }
        }
        Mine {
            # https://docs.gitlab.com/api/snippets/#list-all-snippets-for-current-user
            $Snippet = Invoke-GitlabApi GET "snippets" -Query $Query -MaxPages $MaxPages -SiteUrl $SiteUrl
        }
    }

    if ($IncludeContent) {
        $Snippet | ForEach-Object {
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'content' -Value $(Get-GitlabSnippetContent -SnippetId $_.id -SiteUrl $SiteUrl)
        }
    }

    $Snippet | New-WrapperObject 'Gitlab.Snippet'
}

function Get-GitlabSnippetContent {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $SnippetId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    # https://docs.gitlab.com/api/snippets/#single-snippet-contents
    Invoke-GitlabApi GET "snippets/$SnippetId/raw" -SiteUrl $SiteUrl
}

function New-GitlabSnippet {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $Title,

        [Parameter()]
        [string]
        $Description,

        [Parameter(Mandatory, ParameterSetName='SingleFile')]
        [string]
        $FileName,

        [Parameter(Mandatory, ParameterSetName='SingleFile')]
        [string]
        $Content,

        [Parameter(Mandatory, ParameterSetName='MultipleFiles')]
        [hashtable[]]
        $Files,

        [Parameter()]
        [ValidateSet('public', 'private', 'internal')]
        [string]
        $Visibility = 'private',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Body = @{
        title      = $Title
        visibility = $Visibility
    }

    if ($Description) {
        $Body.description = $Description
    }

    if ($PSCmdlet.ParameterSetName -eq 'SingleFile') {
        $Body.files = @(
            @{
                file_path = $FileName
                content   = $Content
            }
        )
    }
    else {
        $Body.files = $Files | ForEach-Object {
            @{
                file_path = $_.file_path
                content   = $_.content
            }
        }
    }

    if ($PSCmdlet.ShouldProcess($Title, "create snippet")) {
        # https://docs.gitlab.com/api/snippets/#create-new-snippet
        Invoke-GitlabApi POST "snippets" -Body $Body -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Snippet'
    }
}

function Update-GitlabSnippet {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $SnippetId,

        [Parameter()]
        [string]
        $Title,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [ValidateSet('public', 'private', 'internal')]
        [string]
        $Visibility,

        [Parameter()]
        [hashtable[]]
        $Files,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Body = @{}

    if ($Title) {
        $Body.title = $Title
    }
    if ($Description) {
        $Body.description = $Description
    }
    if ($Visibility) {
        $Body.visibility = $Visibility
    }
    if ($Files) {
        $Body.files = $Files | ForEach-Object {
            $File = @{
                action = $_.action
            }
            if ($_.file_path) {
                $File.file_path = $_.file_path
            }
            if ($_.content) {
                $File.content = $_.content
            }
            if ($_.previous_path) {
                $File.previous_path = $_.previous_path
            }
            $File
        }
    }

    if ($PSCmdlet.ShouldProcess("snippet $SnippetId", "update")) {
        # https://docs.gitlab.com/api/snippets/#update-snippet
        Invoke-GitlabApi PUT "snippets/$SnippetId" -Body $Body -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Snippet'
    }
}

function Remove-GitlabSnippet {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $SnippetId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("snippet $SnippetId", "delete")) {
        # https://docs.gitlab.com/api/snippets/#delete-snippet
        Invoke-GitlabApi DELETE "snippets/$SnippetId" -SiteUrl $SiteUrl | Out-Null
        Write-Host "Snippet $SnippetId deleted"
    }
}
