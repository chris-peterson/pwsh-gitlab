$global:GitlabGetProjectDefaultPages = 10

# Adapted from
# https://github.com/cloudbase/powershell-yaml/blob/master/Load-Assemblies.ps1

$Here = Split-Path -Parent $MyInvocation.MyCommand.Path

function Initialize-Assembly {
    $LibDir = Join-Path $Here "lib"

    return [Reflection.Assembly]::LoadFrom($(Join-Path $libDir "YamlDotNet.dll"))
}

function Initialize-Assemblies {
    $RequiredTypes = @(
        "Parser", "MergingParser", "YamlStream",
        "YamlMappingNode", "YamlSequenceNode",
        "YamlScalarNode", "ChainedEventEmitter",
        "Serializer", "Deserializer", "SerializerBuilder",
        "StaticTypeResolver"
    )

    $YamlDotNet = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -Match "YamlDotNet.dll"
    if (!$YamlDotNet) {
        return Initialize-Assembly
    }

    foreach ($i in $RequiredTypes){
        if ($i -notin $YamlDotNet.DefinedTypes.Name) {
            throw "YamlDotNet is loaded but missing required types ($i). Older version installed on system?"
        }
    }
}

Initialize-Assemblies | Out-Null
