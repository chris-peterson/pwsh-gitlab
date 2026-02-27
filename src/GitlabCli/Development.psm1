function Initialize-GitlabDevelopment {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('dev')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Issues,

        [Parameter(Mandatory)]
        [string]
        $BranchName,

        [Parameter()]
        [string]
        $SiteUrl
    )

    begin {
        $AllIssues = @()
    }

    process {
        $AllIssues += $Issues
    }

    end {
        $WorkingDir = Join-Path -Path (Get-Location).Path -ChildPath $BranchName

        if ($PSCmdlet.ShouldProcess("Initialize development '$BranchName' with $($AllIssues.Count) issues @ $($WorkingDir)")) {
            New-Item -ItemType Directory -Path $WorkingDir | Out-Null
            Set-Location $WorkingDir

            $Projects = $AllIssues | ForEach-Object { $_.ProjectId } | Select-Object -Unique | ForEach-Object {
                Get-GitlabProject -ProjectId $_ -SiteUrl $SiteUrl
            }
            $Directories = $Projects | Copy-GitlabProjectToLocalFileSystem

            $Directories | ForEach-Object {
                Set-Location $_
                git checkout -b $BranchName
            }

            Set-Location $WorkingDir
            code .

            Write-Host 'Development environment initialized successfully.  Do your work and press enter when done.'
            Read-Host
        }
    }
}
