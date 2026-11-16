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

Describe "Gitlab.Variable table view" {

    BeforeAll {
        $ModuleRoot = "$PSScriptRoot/../src/GitlabCli"
        $PowerShell = [powershell]::Create()
        $null = $PowerShell.AddScript({
            param($ModuleRoot)
            Update-TypeData   -AppendPath "$ModuleRoot/Types.ps1xml"
            Update-FormatData -AppendPath "$ModuleRoot/Formats.ps1xml"
            @(
                [PSCustomObject]@{ PSTypeName = 'Gitlab.Variable'; Key = 'SECRET'; Value = 'hunter2';   Masked = $true;  Protected = $false; Raw = $false }
                [PSCustomObject]@{ PSTypeName = 'Gitlab.Variable'; Key = 'REGION'; Value = 'us-west-2'; Masked = $false; Protected = $false; Raw = $false }
            ) | Format-Table | Out-String -Width 200
        }).AddArgument($ModuleRoot)
        $Rendered = $PowerShell.Invoke() -join ''
        $PowerShell.Dispose()
    }

    It "Should hide the value of a masked variable" {
        $Rendered | Should -Not -Match 'hunter2'
        $Rendered | Should -Match 'SECRET\s+\*{8}'
    }

    It "Should show the value of an unmasked variable" {
        $Rendered | Should -Match 'REGION\s+us-west-2'
    }
}
