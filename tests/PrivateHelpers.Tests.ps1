Describe 'Private helpers' {

    BeforeAll {
        $Root = "$PSScriptRoot/../src/GitlabCli"
        $Manifest = Import-PowerShellDataFile "$Root/GitlabCli.psd1"
    }

    # ScriptsToProcess dot-sources into the importer's session state, so a function there is invisible to the
    # nested modules when another module (ForgeCli) imports GitlabCli. Helpers belong in Private/Helpers.psm1.
    It 'Should define no functions in ScriptsToProcess' {
        $Functions = foreach ($Script in $Manifest.ScriptsToProcess) {
            Select-String -Path (Join-Path $Root $Script) -Pattern '^function ' |
                ForEach-Object { "$($Script):$($_.LineNumber)" }
        }
        $Functions | Should -BeNullOrEmpty -Because 'helpers load from Private/Helpers.psm1, not ScriptsToProcess'
    }

    It 'Should import the helpers in every nested module' {
        $Missing = $Manifest.NestedModules |
            Where-Object { $_ -notlike 'Private/*' } |
            Where-Object { -not (Select-String -Path (Join-Path $Root $_) -Pattern 'Import-Module "\$PSScriptRoot/Private/Helpers.psm1"' -SimpleMatch:$false -Quiet) }
        $Missing | Should -BeNullOrEmpty -Because 'each nested module resolves the helpers only from its own session state'
    }
}
