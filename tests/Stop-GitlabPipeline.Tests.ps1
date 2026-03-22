BeforeAll {
    $TestModuleName = "Pipelines"
    Get-Module -Name $TestModuleName -All | Remove-Module -Force -ErrorAction SilentlyContinue

    . $PSScriptRoot/../src/GitlabCli/Private/Transformations.ps1

    Import-Module (New-Module -Name $TestModuleName -ScriptBlock ([scriptblock]::Create(
        @(
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Globals.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/PaginationHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Functions/BranchHelpers.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Private/Validations.ps1" -Raw
            Get-Content "$PSScriptRoot/../src/GitlabCli/Pipelines.psm1" -Raw
        ) -join "`n"))) -Force

    function global:Invoke-GitlabApi {
        param(
            [Parameter(Position=0)][string]$Method,
            [Parameter(Position=1)][string]$Path,
            [hashtable]$Query,
            [hashtable]$Body,
            [uint]$MaxPages
        )
        @()
    }
    function global:New-GitlabObject {
        param(
            [Parameter(ValueFromPipeline)]$InputObject,
            [Parameter(Position=0)][string]$DisplayType
        )
        process { $InputObject }
    }
    function global:Resolve-GitlabProjectId {
        param([Parameter(Position=0)][string]$ProjectId)
        return $ProjectId
    }
    function global:Resolve-GitlabBranch {
        param([Parameter(Position=0)][string]$Branch)
        return $Branch
    }
    function global:Get-GitlabUser {
        param([switch]$Me)
        [PSCustomObject]@{ Username = 'testuser'; Id = 1 }
    }
    function global:Get-GitlabProject {
        param([Parameter(Position=0)][string]$ProjectId)
        [PSCustomObject]@{ Id = $ProjectId; Name = 'test'; PathWithNamespace = 'group/test'; DefaultBranch = 'main' }
    }
    function global:Get-GitlabPipeline {
        param([string]$ProjectId, [string]$PipelineId)
        [PSCustomObject]@{ Id = $PipelineId; ProjectId = $ProjectId }
    }
    function global:Get-LocalGitContext {
        [PSCustomObject]@{ Project = 'group/test'; Branch = 'main' }
    }
    function global:Get-GitlabResourceFromUrl {
        param([Parameter(ValueFromPipeline)][string]$Url)
        [PSCustomObject]@{ ProjectId = '123'; ResourceId = '1' }
    }
    function global:Get-GitlabPipelineBridge {
        param([string]$ProjectId, [string]$PipelineId)
        @()
    }
    function global:Invoke-GitlabGraphQL {
        param([string]$Query)
        @{}
    }
    function global:ConvertTo-GitlabVariables {
        param([Parameter(ValueFromPipeline)]$InputObject, [string]$Type)
        process { $InputObject }
    }
}

Describe "Stop-GitlabPipeline" {
    BeforeEach {
        Mock -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -MockWith { @() }
    }

    It "Should POST to cancel endpoint" {
        Stop-GitlabPipeline -ProjectId '123' -PipelineId '456' -Confirm:$false

        Should -Invoke -CommandName Invoke-GitlabApi -ModuleName $TestModuleName -ParameterFilter {
            $Method -eq 'POST' -and $Path -eq 'projects/123/pipelines/456/cancel'
        }
    }
}
