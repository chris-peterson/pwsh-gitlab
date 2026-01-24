function Get-GitlabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(Position=0, ParameterSetName='ById', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroup', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(ParameterSetName='ByUser')]
        [string]
        $UserId,

        [Parameter(ParameterSetName='ByUser')]
        [switch]
        $Mine,

        [Parameter(Position=0, Mandatory, ParameterSetName='ByTopics')]
        [string []]
        $Topics,

        [Parameter(ParameterSetName='ByGroup')]
        [Alias('r')]
        [switch]
        $Recurse,

        [Parameter(Position=0, Mandatory, ParameterSetName='ByUrl')]
        [string]
        $Url,

        [Parameter()]
        [string]
        $Select,

        [switch]
        [Parameter(ParameterSetName='ByGroup')]
        $IncludeArchived = $false,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = $ProjectId.TrimEnd('/')

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All -Recurse:$Recurse
    $Projects = @()
    switch ($PSCmdlet.ParameterSetName) {
        ById {
            if ($ProjectId -eq '.') {
                $ProjectId = $(Get-LocalGitContext).Project
                if (-not $ProjectId) {
                    throw "Could not infer project based on current directory ($(Get-Location))"
                }
            }
            $Projects = Invoke-GitlabApi GET "projects/$($ProjectId | ConvertTo-UrlEncoded)"
        }
        ByGroup {
            $Group = Get-GitlabGroup $GroupId
            $Query = @{
                'include_subgroups' = $Recurse ? 'true' : 'false'
            }
            if (-not $IncludeArchived) {
                $Query['archived'] = 'false'
            }
            $Projects = Invoke-GitlabApi GET "groups/$($Group.Id)/projects" $Query -MaxPages $MaxPages |
                Where-Object { $($_.path_with_namespace).StartsWith($Group.FullPath) } |
                Sort-Object -Property 'Name'
        }
        ByUser {
            if ($Mine) {
                if ($UserId) {
                    Write-Warning "Ignoring '-UserId $UserId' parameter since -Mine was also provided"
                }
                $UserId = Get-GitlabUser -Me | Select-Object -ExpandProperty Username
            }
            # https://docs.gitlab.com/ee/api/projects.html#list-user-projects
            $Projects = Invoke-GitlabApi GET "users/$UserId/projects"
        }
        ByTopics {
            $Projects = Invoke-GitlabApi GET "projects" -Query @{
                topic = $Topics -join ','
            } -MaxPages $MaxPages
        }
        ByUrl {
            $Match = $Url | Get-GitlabResourceFromUrl
            if ($Match) {
                Get-GitlabProject -ProjectId $Match.ProjectId
            } else {
                throw "Url didn't match expected format"
            }
        }
    }

    $Projects |
        New-GitlabObject 'Gitlab.Project' |
        Save-ProjectToCache |
        Get-FilteredObject $Select
}

function ConvertTo-GitlabTriggerYaml {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [Parameter()]
        [ValidateSet('depend')]
        [string]
        $Strategy,

        [Parameter()]
        [string]
        $StageName = 'trigger'
    )
    Begin {
        $Yaml = @"
stages:
  - $StageName
"@
        $Projects = @()
        if ([string]::IsNullOrWhiteSpace($Strategy)) {
            $StrategyYaml = ''
        } else {
            $StrategyYaml = "`n    strategy: $Strategy"
        }
    }
    Process {
        foreach ($Object in $InputObject) {
            if ($Projects.Contains($Object.ProjectId)) {
                continue
            }
            $Projects += $Object.ProjectId
            $Yaml += @"


$($Object.Name):
  stage: $StageName
  trigger:
    project: $($Object.PathWithNamespace)$StrategyYaml
"@
        }
    }
    End {
        $Yaml
    }
}

# https://docs.gitlab.com/ee/api/projects.html#transfer-a-project-to-a-new-namespace
function Move-GitlabProject {
    [Alias("Transfer-GitlabProject")]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory)]
        [string]
        $DestinationGroup,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    if ($PSCmdlet.ShouldProcess("group $($Group.FullName)", "transfer '$($SourceProject.PathWithNamespace)'")) {
        Invoke-GitlabApi PUT "projects/$($SourceProject.Id)/transfer" @{
            namespace = $Group.Id
        } -WhatIf:$WhatIfPreference | New-GitlabObject 'Gitlab.Project'
    }
}

function Rename-GitlabProject {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $NewName,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("$ProjectId", "rename to '$NewName'")) {
        Update-GitlabProject -ProjectId $ProjectId -Name $NewName -Path $NewName
    }
}

# https://docs.gitlab.com/ee/api/projects.html#fork-project
function Copy-GitlabProject {
    [Alias("Fork-GitlabProject")]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $DestinationGroup,

        [Parameter(Mandatory=$false)]
        [string]
        $DestinationProjectName,


        # https://docs.gitlab.com/ee/api/projects.html#delete-an-existing-forked-from-relationship
        [TrueOrFalse()][bool]
        [Parameter(Mandatory=$false)]
        $PreserveForkRelationship = $true,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    if ($PSCmdlet.ShouldProcess("$($Group.FullPath)", "$($PreserveForkRelationship ? "fork" : "copy") $($SourceProject.Path)")) {
        $NewProject = Invoke-GitlabApi POST "projects/$($SourceProject.Id)/fork" @{
            namespace_id           = $Group.Id
            name                   = $DestinationProjectName ?? $SourceProject.Name
            path                   = $DestinationProjectName ?? $SourceProject.Name
            mr_default_target_self = 'true'
        } -WhatIf:$WhatIfPreference

        if (-not $PreserveForkRelationship) {
            $NewProject | Remove-GitlabProjectForkRelationship
        }
    }
}

function Remove-GitlabProjectForkRelationship {
    [Alias("Remove-GitlabProjectFork")]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId
    if (-not $Project.ForkedFromProjectId) {
        throw "Project $($Project.PathWithNamespace) does not have a fork"
    }
    $ForkedFromProject = Get-GitlabProject -ProjectId $Project.ForkedFromProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "remove fork relationship to $($ForkedFromProject.PathWithNamespace)")) {
        # https://docs.gitlab.com/api/project_forks/#delete-a-fork-relationship-between-projects
        Invoke-GitlabApi DELETE "projects/$($ProjectId)/fork" | Out-Null
        Write-Host "Removed fork relationship from $($Project.PathWithNamespace) (was $($ForkedFromProject.PathWithNamespace))"
    }
}

function New-GitlabProject {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(Position=0, Mandatory)]
        [Alias('Name')]
        [string]
        $ProjectName,

        [Parameter(ValueFromPipelineByPropertyName, ParameterSetName='Group')]
        [Alias('Group')]
        [string]
        $DestinationGroup,

        [Parameter(ParameterSetName = 'Personal')]
        [switch]
        $Personal,

        [Parameter()]
        [ValidateSet([VisibilityLevel])]
        [string]
        $Visibility = 'internal',

        [Parameter()]
        [uint]
        $BuildTimeout = 0,

        [switch]
        [Parameter()]
        $CloneNow,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($DestinationGroup) {
        $Group = Get-GitlabGroup -GroupId $DestinationGroup
        if(-not $Group) {
            throw "DestinationGroup '$DestinationGroup' not found"
        }
        $NamespaceId = $Group.Id
    }
    if ($Personal) {
        $NamespaceId = $null # defaults to current user
    }

    $Request = @{
        name = $ProjectName
        namespace_id = $NamespaceId
        visibility = $Visibility
    }
    if ($BuildTimeout -gt 0) {
        $Request.build_timeout = $BuildTimeout
    }

    if ($PSCmdlet.ShouldProcess($NamespaceId, "create new project '$ProjectName' $($Request | ConvertTo-Json)" )) {
        # https://docs.gitlab.com/ee/api/projects.html#create-project
        $Project = Invoke-GitlabApi POST "projects" -Body $Request | New-GitlabObject 'Gitlab.Project'

        if ($CloneNow) {
            git clone $Project.SshUrlToRepo
            Set-Location $ProjectName
        } else {
            $Project
        }
    }
}

# https://docs.gitlab.com/ee/api/projects.html#edit-project
function Update-GitlabProject {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [ValidateSet([VisibilityLevel])]
        [string]
        $Visibility,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Path,

        [Parameter()]
        [string]
        $DefaultBranch,

        [Parameter()]
        [string []]
        $Topics,

        [Parameter()]
        [ValidateSet('fetch', 'clone')]
        [string]
        $BuildGitStrategy,

        [Parameter()]
        [uint]
        $CiDefaultGitDepth,

        [Parameter()]
        [TrueOrFalse()][bool]
        $CiForwardDeployment,

        [Parameter()]
        [uint]
        $BuildTimeout = 0,

        [Parameter()]
        [ValidateSet('disabled', 'private', 'enabled')]
        [string]
        $RepositoryAccessLevel,

        [Parameter()]
        [ValidateSet('disabled', 'private', 'enabled')]
        [string]
        $BuildsAccessLevel,

        [Parameter()]
        [TrueOrFalse()][bool]
        $OnlyAllowMergeIfAllDiscussionsAreResolved,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Request = @{}

    if ($BuildsAccessLevel) {
        $Request.builds_access_level = $BuildsAccessLevel
    }
    if ($BuildGitStrategy) {
        $Request.build_git_strategy = $BuildGitStrategy
    }
    if ($BuildTimeout -gt 0) {
        $Request.build_timeout = $BuildTimeout
    }
    if ($CiDefaultGitDepth) {
        $Request.ci_default_git_depth = $CiDefaultGitDepth
    }
    if ($PSBoundParameters.ContainsKey('CiForwardDeployment')){
        $Request.ci_forward_deployment_enabled = $CiForwardDeployment
    }
    if ($DefaultBranch) {
        $Request.default_branch = $DefaultBranch
    }
    if ($Name) {
        $Request.name = $Name
    }
    if ($PSBoundParameters.ContainsKey('OnlyAllowMergeIfAllDiscussionsAreResolved')) {
        $Request.only_allow_merge_if_all_discussions_are_resolved = $OnlyAllowMergeIfAllDiscussionsAreResolved
    }
    if ($Path) {
        $Request.path = $Path
    }
    if ($RepositoryAccessLevel) {
        $Request.repository_access_level = $RepositoryAccessLevel
    }
    if($PSBoundParameters.ContainsKey('Topics')) {
        if ($Topics) {
            $Request.topics = $Topics -join ','
        } else {
            $Request.topics = ''
        }
    }
    if ($Visibility) {
        $Request.visibility = $Visibility
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "update project ($($Request | ConvertTo-Json))")) {
        Invoke-GitlabApi PUT "projects/$($Project.Id)" -Body $Request |
            New-GitlabObject 'Gitlab.Project'
    }
}

function Invoke-GitlabProjectArchival {
    [Alias('Archive-GitlabProject')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "archive")) {
        # https://docs.gitlab.com/ee/api/projects.html#archive-a-project
        Invoke-GitlabApi POST "projects/$($Project.Id)/archive" |
            New-GitlabObject 'Gitlab.Project'
    }
}

function Invoke-GitlabProjectUnarchival {
    [Alias('Unarchive-GitlabProject')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "unarchive")) {
        # https://docs.gitlab.com/ee/api/projects.html#unarchive-a-project
        Invoke-GitlabApi POST "projects/$($Project.Id)/unarchive" |
            New-GitlabObject 'Gitlab.Project'
    }
}

function Get-GitlabProjectVariable {
    [CmdletBinding()]
    [OutputType('Gitlab.Variable')]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [string]
        $Key,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($Key) {
        # https://docs.gitlab.com/ee/api/project_level_variables.html#get-a-single-variable
        Invoke-GitlabApi GET "projects/$ProjectId/variables/$Key" | New-GitlabObject 'Gitlab.Variable'
    }
    else {
        # https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
        Invoke-GitlabApi GET "projects/$ProjectId/variables" -MaxPages $MaxPages | New-GitlabObject 'Gitlab.Variable'
    }
}

function Set-GitlabProjectVariable {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    [OutputType('Gitlab.Variable')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $Key,

        [Parameter(Mandatory, Position=1, ValueFromPipelineByPropertyName)]
        [string]
        $Value,

        [TrueOrFalse()][bool]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Protect,

        [TrueOrFalse()][bool]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Mask,

        [TrueOrFalse()][bool]
        [Parameter(ValueFromPipelineByPropertyName)]
        $ExpandVariables = $true,

        [switch]
        [Parameter()]
        $NoExpand,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($NoExpand) {
        $ExpandVariables = $false
    }

    $Request = @{
        value = $Value
        raw   = -not $ExpandVariables
    }
    if ($PSBoundParameters.ContainsKey('Protect')) {
        $Request.protected = $Protect
    }
    if ($PSBoundParameters.ContainsKey('Mask')) {
        $Request.masked = $Mask
    }

    $Project = Get-GitlabProject $ProjectId

    try {
        Get-GitlabProjectVariable -ProjectId $($Project.Id) -Key $Key | Out-Null
        $IsExistingVariable = $true
    }
    catch {
        $IsExistingVariable = $false
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "set $($IsExistingVariable ? 'existing' : 'new') project variable ($Key) $(($Request | ConvertTo-Json))")) {
        if ($IsExistingVariable) {
            # https://docs.gitlab.com/ee/api/project_level_variables.html#update-variable
            Invoke-GitlabApi PUT "projects/$($Project.Id)/variables/$Key" -Body $Request | New-GitlabObject 'Gitlab.Variable'
        }
        else {
            $Request.key = $Key
            # https://docs.gitlab.com/ee/api/project_level_variables.html#create-a-variable
            Invoke-GitlabApi POST "projects/$($Project.Id)/variables" -Body $Request | New-GitlabObject 'Gitlab.Variable'
        }
    }
}

# https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
function Remove-GitlabProjectVariable {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "delete variable '$Key'")) {
        Invoke-GitlabApi DELETE "projects/$($Project.Id)/variables/$Key" | Out-Null
    }
}


function Rename-GitlabProjectDefaultBranch {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $NewDefaultBranch,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId '.'
    if (-not $Project) {
        throw "This cmdlet requires being run from within a gitlab project"
    }

    if ($Project.DefaultBranch -ieq $NewDefaultBranch) {
        throw "Default branch for $($Project.Name) is already $($Project.DefaultBranch)"
    }
    $OldDefaultBranch = $Project.DefaultBranch

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "change default branch from $OldDefaultBranch to $NewDefaultBranch")) {
        git checkout $OldDefaultBranch | Out-Null
        git pull -p | Out-Null
        git branch -m $OldDefaultBranch $NewDefaultBranch | Out-Null
        git push -u origin $NewDefaultBranch -o ci.skip | Out-Null
        Update-GitlabProject -DefaultBranch $NewDefaultBranch | Out-Null
        try {
            UnProtect-GitlabBranch -Name $OldDefaultBranch | Out-Null
        }
        catch {
            Write-Debug "UnProtect-GitlabBranch failed for '$OldDefaultBranch': $_"
        }
        Protect-GitlabBranch -Name $NewDefaultBranch | Out-Null
        git push --delete origin $OldDefaultBranch | Out-Null
        git remote set-head origin -a | Out-Null

        Get-GitlabProject -ProjectId $Project.Id
    }
}

function Get-GitlabProjectEvent {

    [CmdletBinding()]
    [OutputType('Gitlab.Event')]
    param (
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$False)]
        [GitlabDate()][string]
        $Before,

        [Parameter(Mandatory=$False)]
        [GitlabDate()][string]
        $After,

        [Parameter(Mandatory=$False)]
        [ValidateSet([SortDirection])]
        [string]
        $Sort,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Query = @{}
    if($Before) {
        $Query.before = $Before
    }
    if($After) {
        $Query.after = $After
    }
    if($Sort) {
        $Query.sort = $Sort
    }

    Invoke-GitlabApi GET "projects/$ProjectId/events" `
        -Query $Query -MaxPages $MaxPages -SiteUrl |
        New-GitlabObject 'Gitlab.Event'
}

function New-GitlabGroupToProjectShare {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('Share-GitlabProjectWithGroup')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Access')]
        [AccessLevel()]
        [string]
        $GroupAccess,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $AccessLiteral = Get-GitlabMemberAccessLevel $GroupAccess

    # https://docs.gitlab.com/api/projects/#share-a-project-with-a-group
    $Request = @{
        Method = 'POST'
        Path = "projects/$(Resolve-GitlabProjectId $ProjectId)/share"
        Body = @{
            group_id     = Resolve-GitlabGroupId $GroupId
            group_access = $AccessLiteral
        }
    }

    if ($PSCmdlet.ShouldProcess($ProjectId, "share project with group '$GroupId'")) {
        if (Invoke-GitlabApi @Request | Out-Null) {
            Write-Host "Successfully shared $ProjectId with $GroupId"
        }
    }
}

function Remove-GitlabGroupToProjectShare {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=1)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "remove sharing with group '$GroupId'")) {
        # https://docs.gitlab.com/api/projects/#delete-a-shared-project-link-in-a-grou
        if (Invoke-GitlabApi DELETE "projects/$(Resolve-GitlabProjectId $ProjectId)/share/$(Resolve-GitlabGroupId $GroupId)" | Out-Null) {
            Write-Host "Removed sharing with $GroupId from project $ProjectId"
        }
    }
}

function Remove-GitlabProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "remove project")) {
        # https://docs.gitlab.com/ee/api/projects.html#delete-project
        Invoke-GitlabApi DELETE "projects/$($ProjectId)" | Out-Null
        Write-Host "Removed $($Project.PathWithNamespace)"
    }
}

function Add-GitlabProjectTopic {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0)]
        [string[]]
        $Topic
    )

    $Project        = Get-GitlabProject $ProjectId
    $ExistingTopics = @($Project.Topics)
    $NewTopics      = $ExistingTopics + $Topic | Select-Object -Unique

    if ($NewTopics.Count -eq $ExistingTopics.Count) {
        Write-Verbose "No new topics to add to $($Project.PathWithNamespace)"
        return
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "add topic ($($Topic -join ', '))")) {
        Update-GitlabProject -ProjectId $Project.Id -Topics $NewTopics
    }
}

function Remove-GitlabProjectTopic {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType('Gitlab.Project')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0)]
        [string[]]
        $Topic
    )

    $Project        = Get-GitlabProject $ProjectId
    $ExistingTopics = @($Project.Topics)
    $NewTopics      = $ExistingTopics | Where-Object { $Topic -notcontains $_ } | Select-Object -Unique

    if ($NewTopics.Count -eq $ExistingTopics.Count) {
        Write-Verbose "No topics to remove from $($Project.PathWithNamespace)"
        return
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "remove topic ($($Topic -join ', '))")) {
        Update-GitlabProject -ProjectId $Project.Id -Topics $NewTopics
    }
}

function Copy-GitlabProjectToLocalFileSystem {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        $Project
    )

    process {
        $LocalPath = (Get-Location).Path
        $TargetPath = "$LocalPath/$($Project.Group)"
        if ($PSCmdlet.ShouldProcess("local file system ($TargetPath)", "clone project '$($Project.PathWithNamespace)'")) {
            if (-not $(Test-Path $TargetPath)) {
                New-Item -ItemType Directory -Path $TargetPath | Out-Null
            }

            Set-Location $TargetPath
            git clone $Project.SshUrlToRepo
            $TargetPath
        }
    }
}
