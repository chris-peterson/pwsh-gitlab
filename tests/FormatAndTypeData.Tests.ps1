# Guards against .ps1xml mistakes that break `Import-Module GitlabCli` for users.
# The other tests load functions via New-Module, so they never see these files.

BeforeDiscovery {
    $ModuleRoot = "$PSScriptRoot/../src/GitlabCli"
    $Manifest = Import-PowerShellDataFile "$ModuleRoot/GitlabCli.psd1"

    $FormatFiles = @($Manifest.FormatsToProcess | ForEach-Object { @{ Name = $_; Path = "$ModuleRoot/$_" } })
    $TypeFiles   = @($Manifest.TypesToProcess   | ForEach-Object { @{ Name = $_; Path = "$ModuleRoot/$_" } })
}

BeforeAll {
    # Load into a fresh runspace so this session's type/format tables stay untouched
    function Get-LoadError {
        param([string]$Command, [string]$Path)

        $PowerShell = [powershell]::Create()
        try {
            $null = $PowerShell.AddScript({
                param($Command, $Path)
                try {
                    & $Command -AppendPath $Path -ErrorAction Stop
                } catch {
                    $_.Exception.Message
                }
            }).AddArgument($Command).AddArgument($Path)
            $PowerShell.Invoke()
        } finally {
            $PowerShell.Dispose()
        }
    }

    function Get-ScriptBlockSyntaxError {
        param([string]$Path)

        $Xml = [xml](Get-Content $Path -Raw)
        $Xml.SelectNodes('//ScriptBlock | //GetScriptBlock | //SetScriptBlock | //Script') | ForEach-Object {
            $Errors = $null
            $null = [System.Management.Automation.Language.Parser]::ParseInput($_.InnerText, [ref]$null, [ref]$Errors)
            if ($Errors) {
                "$($_.ParentNode.OuterXml): $($Errors[0].Message)"
            }
        }
    }
}

Describe "Format data <Name>" -ForEach $FormatFiles {

    It "Should be well-formed XML" {
        { [xml](Get-Content $Path -Raw) } | Should -Not -Throw
    }

    It "Should load with Update-FormatData" {
        Get-LoadError -Command 'Update-FormatData' -Path $Path | Should -BeNullOrEmpty
    }

    It "Should contain only valid PowerShell in script blocks" {
        Get-ScriptBlockSyntaxError -Path $Path | Should -BeNullOrEmpty
    }
}

Describe "Type data <Name>" -ForEach $TypeFiles {

    It "Should be well-formed XML" {
        { [xml](Get-Content $Path -Raw) } | Should -Not -Throw
    }

    It "Should load with Update-TypeData" {
        Get-LoadError -Command 'Update-TypeData' -Path $Path | Should -BeNullOrEmpty
    }

    It "Should contain only valid PowerShell in script blocks" {
        Get-ScriptBlockSyntaxError -Path $Path | Should -BeNullOrEmpty
    }
}

Describe "Variable table views" {

    BeforeAll {
        $ModuleRoot = "$PSScriptRoot/../src/GitlabCli"

        # Wrap API responses with New-GitlabObject, then render them through the
        # module's type and format data, in a fresh runspace
        function Format-InFreshRunspace {
            param([string]$DisplayType, [object[]]$Response)

            $PowerShell = [powershell]::Create()
            try {
                $null = $PowerShell.AddScript({
                    param($ModuleRoot, $DisplayType, $Response)
                    . "$ModuleRoot/Private/Functions/StringHelpers.ps1"
                    . "$ModuleRoot/Private/Globals.ps1"
                    . "$ModuleRoot/Private/Functions/ObjectHelpers.ps1"
                    . "$ModuleRoot/Private/Functions/SensitiveValueHelpers.ps1"
                    Update-TypeData   -AppendPath "$ModuleRoot/Types.ps1xml"
                    Update-FormatData -AppendPath "$ModuleRoot/Formats.ps1xml"
                    $Response | New-GitlabObject $DisplayType -WarningAction SilentlyContinue | Format-Table | Out-String -Width 200
                }).AddArgument($ModuleRoot).AddArgument($DisplayType).AddArgument($Response)
                $PowerShell.Invoke() -join ''
            } finally {
                $PowerShell.Dispose()
            }
        }
    }

    Context "Gitlab.Variable" {

        BeforeAll {
            $Rendered = Format-InFreshRunspace 'Gitlab.Variable' @(
                [PSCustomObject]@{ key = 'SECRET';     value = 'hunter2';   masked = $true;  hidden = $false; protected = $false; raw = $false }
                [PSCustomObject]@{ key = 'DEPLOY_PAT'; value = 'shh';       masked = $false; hidden = $true;  protected = $false; raw = $false }
                [PSCustomObject]@{ key = 'SOME_TOKEN'; value = 'glpat-123'; masked = $false; hidden = $false; protected = $false; raw = $false }
                [PSCustomObject]@{ key = 'REGION';     value = 'us-west-2'; masked = $false; hidden = $false; protected = $false; raw = $false }
            )
        }

        It "Should hide the value of a masked variable" {
            $Rendered | Should -Not -Match 'hunter2'
            $Rendered | Should -Match 'SECRET\s+\*{8}'
        }

        It "Should hide the value of a hidden variable" {
            $Rendered | Should -Not -Match 'shh'
            $Rendered | Should -Match 'DEPLOY_PAT\s+\*{8}'
        }

        It "Should hide the value of an unmasked variable whose key looks like a secret" {
            $Rendered | Should -Not -Match 'glpat-123'
            $Rendered | Should -Match 'SOME_TOKEN\s+\*{8}'
        }

        It "Should show the value of a non-sensitive variable" {
            $Rendered | Should -Match 'REGION\s+us-west-2'
        }
    }

    Context "<DisplayType>" -ForEach @(
        @{ DisplayType = 'Gitlab.PipelineVariable' }
        @{ DisplayType = 'Gitlab.PipelineScheduleVariable' }
    ) {

        BeforeAll {
            $Rendered = Format-InFreshRunspace $DisplayType @(
                [PSCustomObject]@{ key = 'DB_PASSWORD'; value = 'p@ss';      variable_type = 'env_var' }
                [PSCustomObject]@{ key = 'REGION';      value = 'us-west-2'; variable_type = 'env_var' }
            )
        }

        It "Should hide the value of a variable whose key looks like a secret" {
            $Rendered | Should -Not -Match 'p@ss'
            $Rendered | Should -Match 'DB_PASSWORD\s+\*{8}'
        }

        It "Should show the value of a non-sensitive variable" {
            $Rendered | Should -Match 'REGION\s+us-west-2'
        }
    }
}
