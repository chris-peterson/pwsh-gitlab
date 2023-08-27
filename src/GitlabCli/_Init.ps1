$global:GitlabConfigurationPath = Join-Path $env:HOME "/.config/powershell/gitlab.config"
$global:GitlabConsoleColors     = @{
    Black       = '0;30'
    Blue        = '0;34'
    Cyan        = '0;36'
    DarkGray    = '1;30'
    Green       = '0;32'
    LightBlue   = '1;34'
    LightCyan   = '1;36'
    LightGray   = '0;37'
    LightGreen  = '1;32'
    LightPurple = '1;35'
    LightRed    = '1;31'
    Orange      = '0;33'
    Purple      = '0;35'
    Red         = '0;31'
    White       = '1;37'
    Yellow      = '1;33'
}
$global:GitlabGetProjectDefaultPages    = 10
# https://docs.gitlab.com/ee/api/#id-vs-iid
# TL;DR; it's a mess and we have to special-case specific entity types
$global:GitlabIdentityPropertyNameExemptions=@{
    'Gitlab.AuditEvent'                = 'Id'
    'Gitlab.AccessToken'               = 'Id'
    'Gitlab.BlobSearchResult'          = ''
    'Gitlab.Branch'                    = ''
    'Gitlab.Commit'                    = 'Id'
    'Gitlab.Configuration'             = ''
    'Gitlab.Environment'               = 'Id'
    'Gitlab.Event'                     = 'Id'
    'Gitlab.Group'                     = 'Id'
    'Gitlab.ProjectIntegration'        = 'Id'
    'Gitlab.Job'                       = 'Id'
    'Gitlab.Member'                    = 'Id'
    'Gitlab.MergeRequestApprovalRule'  = 'Id'
    'Gitlab.Note'                      = 'Id'
    'Gitlab.Pipeline'                  = 'Id'
    'Gitlab.PipelineBridge'            = 'Id'
    'Gitlab.PipelineDefinition'        = ''
    'Gitlab.PipelineVariable'          = ''
    'Gitlab.PipelineSchedule'          = 'Id'
    'Gitlab.PipelineScheduleVariable'  = ''
    'Gitlab.Project'                   = 'Id'
    'Gitlab.ProjectHook'               = 'Id'
    'Gitlab.ProtectedBranch'           = 'Id'
    'Gitlab.RepositoryFile'            = ''
    'Gitlab.RepositoryTree'            = ''
    'Gitlab.Runner'                    = 'Id'
    'Gitlab.RunnerJob'                 = 'Id'
    'Gitlab.SearchResult.Blob'         = ''
    'Gitlab.SearchResult.MergeRequest' = ''
    'Gitlab.SearchResult.Project'      = ''
    'Gitlab.Topic'                     = 'Id'
    'Gitlab.User'                      = 'Id'
    'Gitlab.UserMembership'            = ''
    'Gitlab.Variable'                  = ''
}
$global:GitlabJobLogSections            = New-Object 'Collections.Generic.Stack[string]'
$global:GitlabSearchResultsDefaultLimit = 100

# Remove the following as part of https://github.com/chris-peterson/pwsh-gitlab/issues/77
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
