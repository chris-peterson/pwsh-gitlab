Describe 'ScriptsToProcess helpers' {

    # ScriptsToProcess dot-sources into the importer's session state. Only a global function stays visible to the
    # nested modules and Types.ps1xml when another module (ForgeCli) does the importing.
    It 'Should declare every helper function global' {
        $Root = "$PSScriptRoot/../src/GitlabCli"
        $Scripts = (Import-PowerShellDataFile "$Root/GitlabCli.psd1").ScriptsToProcess
        $NotGlobal = foreach ($Script in $Scripts) {
            Select-String -Path (Join-Path $Root $Script) -Pattern '^function (?!global:)' |
                ForEach-Object { "$($Script):$($_.LineNumber)" }
        }
        $NotGlobal | Should -BeNullOrEmpty -Because 'a helper loaded by ScriptsToProcess must be declared "function global:<Name>"'
    }
}
