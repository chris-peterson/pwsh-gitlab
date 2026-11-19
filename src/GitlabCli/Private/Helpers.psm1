foreach ($File in Get-ChildItem "$PSScriptRoot/Functions" -Filter *.ps1) {
    . $File.FullName
}
Export-ModuleMember -Function *
