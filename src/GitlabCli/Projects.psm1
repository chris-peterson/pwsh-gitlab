<#
.SYNOPSIS
Get one or more Gitlab projects

.DESCRIPTION
Lookup metadata about Gitlab projects by one or more identifiers

.PARAMETER ProjectId
Project id - can be an integer, or a full path

.PARAMETER GroupId
Group id - can be an integer, or a full path

.PARAMETER Recurse
Whether or not to recurse specified group (default: false)
Alias: -r

.PARAMETER Url
Get a project by URL

.PARAMETER IncludeArchived
Whether or not to return archived projects (default: false)

.PARAMETER MaxPages
Maximum pages to return (default: 10)

.PARAMETER SiteUrl
Which Gitlab instance to query.  This is optional, if not provided, will
first attempt to use the remote associated with the local git context.
If there is no established context (or no matching configuration), the default
site is used.

.PARAMETER WhatIf
Preview Gitlab API requests

.EXAMPLE
Get-GitlabProject

Get a project from local git context

.EXAMPLE
Get-GitlabProject -ProjectId 'mygroup/myproject'
OR
PS > Get-GitlabProject 'mygroup/myproject'
OR 
PS > Get-GitlabProject 42

Get a single project by id

.EXAMPLE
Get-GitlabProject -GroupId 'mygroup' [-Recurse]

Get multiple projects by containing group

.EXAMPLE
Get-GitlabGroup 'mygroup' | Get-GitlabProject

Enumerate projects within a group

.LINK
https://github.com/chris-peterson/pwsh-gitlab#projects

.LINK
https://docs.gitlab.com/ee/api/projects.html
#>
$global:GitlabGetProjectDefaultPages = 10
function Get-GitlabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
    param (
        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ById', ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroup', ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

        [Parameter(Mandatory=$false, ParameterSetName='ByUser')]
        [string]
        $UserId,

        [Parameter(Mandatory=$false, ParameterSetName='ByUser')]
        [switch]
        $Mine,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByTopics')]
        [string []]
        $Topics,

        [Parameter(Mandatory=$false, ParameterSetName='ByGroup')]
        [Alias('r')]
        [switch]
        $Recurse,

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByUrl')]
        [string]
        $Url,

        [Parameter(Mandatory=$false)]
        [string]
        $Select,

        [switch]
        [Parameter(Mandatory=$false, ParameterSetName='ByGroup')]
        $IncludeArchived = $false,

        [switch]
        [Parameter(Mandatory=$false)]
        $All,

        [Parameter(Mandatory=$false)]
        [uint]
        $MaxPages = $global:GitlabGetProjectDefaultPages,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if ($All) {
        if ($MaxPages -ne $global:GitlabGetProjectDefaultPages) {
            Write-Warning -Message "Ignoring -MaxPages in favor of -All"
        }
        $MaxPages = [uint]::MaxValue
    }

    $Projects = @()
    switch ($PSCmdlet.ParameterSetName) {
        ById {
            if ($ProjectId -eq '.') {
                $ProjectId = $(Get-LocalGitContext).Project
                if (-not $ProjectId) {
                    throw "Could not infer project based on current directory ($(Get-Location))"
                }
            }
            $Projects = Invoke-GitlabApi GET "projects/$($ProjectId | ConvertTo-UrlEncoded)" -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        ByGroup {
            $Group = Get-GitlabGroup $GroupId
            $Query = @{
                'include_subgroups' = $Recurse ? 'true' : 'false'
            }
            if (-not $IncludeArchived) {
                $Query['archived'] = 'false'
            }
            $Projects = Invoke-GitlabApi GET "groups/$($Group.Id)/projects" $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
                Where-Object { $($_.path_with_namespace).StartsWith($Group.FullPath) } |
                Sort-Object -Property 'Name'
        }
        ByUser {
            # https://docs.gitlab.com/ee/api/projects.html#list-user-projects

            if ($Mine) {
                if ($UserId) {
                    Write-Warning "Ignoring '-UserId $UserId' parameter since -Mine was also provided"
                }
                $UserId = Get-GitlabUser -Me | Select-Object -ExpandProperty Username
            }

            $Projects = Invoke-GitlabApi GET "users/$UserId/projects"
        }
        ByTopics {
            $Projects = Invoke-GitlabApi GET "projects" -Query @{
                topic = $Topics -join ','
            } -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        ByUrl {
            $Url -match "$($(Get-DefaultGitlabSite).Url)/(?<ProjectId>.*)" | Out-Null
            if ($Matches) {
                $ProjectId = $Matches.ProjectId
                $ProjectId = $Matches.ProjectId
                Get-GitlabProject -ProjectId $ProjectId
            } else {
                throw "Url didn't match expected format"
            }
        }
    }

    $Projects |
        New-WrapperObject 'Gitlab.Project' |
        Get-FilteredObject $Select
}

function ConvertTo-GitlabTriggerYaml {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,

        [Parameter(Mandatory=$false)]
        [ValidateSet($null, 'depend')]
        [string]
        $Strategy = $null,

        [Parameter(Mandatory=$false)]
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
        } -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference | New-WrapperObject 'Gitlab.Project'
    }
}

function Rename-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $NewName,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Update-GitlabProject -ProjectId $ProjectId -Name $NewName -Path $NewName -SiteUrl $SiteUrl -WhatIf:$WhatIf
}

# https://docs.gitlab.com/ee/api/projects.html#fork-project
function Copy-GitlabProject {
    [Alias("Fork-GitlabProject")]
    [CmdletBinding(SupportsShouldProcess)]
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
        [bool]
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
        } -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference

        if (-not $PreserveForkRelationship) {
            Invoke-GitlabApi DELETE "projects/$($NewProject.id)/fork" -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference | Out-Null
            Write-Host "Removed fork relationship between $($SourceProject.Name) and $($NewProject.PathWithNamespace)"
        }
    }
}

# https://docs.gitlab.com/ee/api/projects.html#create-project
function New-GitlabProject {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $ProjectName,

        [Parameter(ValueFromPipelineByPropertyName=$true, ParameterSetName='Group')]
        [Alias('GroupId')]
        [string]
        $DestinationGroup,

        [Parameter(ParameterSetName = 'Personal')]
        [switch]
        $Personal,

        [Parameter()]
        [ValidateSet('private', 'internal', 'public')]
        [string]
        $Visibility = 'internal',

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

    if ($PSCmdlet.ShouldProcess($NamespaceId, "create new project '$ProjectName'" )) {
        $Project = Invoke-GitlabApi POST "projects" @{
            name = $ProjectName
            namespace_id = $NamespaceId
            visibility = $Visibility
        } -SiteUrl $SiteUrl -WhatIf:$WhatIfPreference | New-WrapperObject 'Gitlab.Project'
    
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
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [ValidateSet('private', 'internal', 'public')]
        [string]
        $Visibility,

        [Parameter(Mandatory=$false)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $Path,

        [Parameter(Mandatory=$false)]
        [string]
        $DefaultBranch,

        [Parameter(Mandatory=$false)]
        [string []]
        $Topics,

        [Parameter(Mandatory=$false)]
        [ValidateSet('fetch', 'clone')]
        [string]
        $BuildGitStrategy,

        [Parameter(Mandatory=$false)]
        [uint]
        $CiDefaultGitDepth,

        [Parameter()]
        [ValidateSet($null, 'true', 'false')]
        [object]
        $CiForwardDeployment,

        [Parameter(Mandatory=$false)]
        [ValidateSet('disabled', 'private', 'enabled')]
        [string]
        $RepositoryAccessLevel,

        [Parameter(Mandatory=$false)]
        [ValidateSet('disabled', 'private', 'enabled')]
        [string]
        $BuildsAccessLevel,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    $Query = @{}

    if($CiForwardDeployment){
        $Query.ci_forward_deployment_enabled = $CiForwardDeployment
    }
    if ($BuildGitStrategy) {
        $Query.build_git_strategy = $BuildGitStrategy
    }
    if ($CiDefaultGitDepth) {
        $Query.ci_default_git_depth = $CiDefaultGitDepth
    }
    if ($Visibility) {
        $Query.visibility = $Visibility
    }
    if ($Name) {
        $Query.name = $Name
    }
    if ($Path) {
        $Query.path = $Path
    }
    if ($DefaultBranch) {
        $Query.default_branch = $DefaultBranch
    }
    if ($Topics) {
        $Query.topics = $Topics -join ','
    }
    if ($RepositoryAccessLevel) {
        $Query.repository_access_level = $RepositoryAccessLevel
    }
    if ($BuildsAccessLevel) {
        $Query.builds_access_level = $BuildsAccessLevel
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "update project ($($Query | ConvertTo-Json))")) {
        Invoke-GitlabApi PUT "projects/$($Project.Id)" $Query -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Project'
    }
}

function Invoke-GitlabProjectArchival {
    [Alias('Archive-GitlabProject')]
    [CmdletBinding(SupportsShouldProcess)]
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
        Invoke-GitlabApi POST "projects/$($Project.Id)/archive" -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Project'
    }
}

function Invoke-GitlabProjectUnarchival {
    [Alias('Unarchive-GitlabProject')]
    [CmdletBinding(SupportsShouldProcess)]
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
        Invoke-GitlabApi POST "projects/$($Project.Id)/unarchive" -SiteUrl $SiteUrl |
            New-WrapperObject 'Gitlab.Project'
    }
}

# https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
function Get-GitlabProjectVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    if ($Key) {
        Invoke-GitlabApi GET "projects/$($Project.Id)/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        Invoke-GitlabApi GET "projects/$($Project.Id)/variables" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
}

function Set-GitlabProjectVariable {
    [CmdletBinding(SupportsShouldProcess)]
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

        [switch]
        [Parameter(, ValueFromPipelineByPropertyName)]
        $Protect,

        [switch]
        [Parameter(, ValueFromPipelineByPropertyName)]
        $Mask,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Query = @{
        value = $Value
    }
    if ($Protect) {
        $Query.protected = 'true'
    }
    if ($Mask) {
        $Query.masked = 'true'
    }

    $ProjectId = $(Get-GitlabProject $ProjectId).Id

    try {
        Get-GitlabProjectVariable -ProjectId $ProjectId -Key $Key | Out-Null
        $IsExistingVariable = $true
    }
    catch {
        $IsExistingVariable = $false
    }

    if ($PSCmdlet.ShouldProcess($ProjectId, "set $($IsExistingVariable ? 'existing' : 'new') project variable to '$Value'")) {
        if ($IsExistingVariable) {
            # https://docs.gitlab.com/ee/api/project_level_variables.html#update-variable
            Invoke-GitlabApi PUT "projects/$($ProjectId)/variables/$Key" -Query $Query -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
        }
        else {
            $Query.key = $Key
            # https://docs.gitlab.com/ee/api/project_level_variables.html#create-a-variable
            Invoke-GitlabApi POST "projects/$($ProjectId)/variables" -Query $Query -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
        }
    }
}

# https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
function Remove-GitlabProjectVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    Invoke-GitlabApi DELETE "projects/$($Project.Id)/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
}


function Rename-GitlabProjectDefaultBranch {
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $NewDefaultBranch,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId '.'
    if (-not $Project) {
        throw "This cmdlet requires being run from within a gitlab project"
    }

    if ($Project.DefaultBranch -ieq $NewDefaultBranch) {
        throw "Default branch for $($Project.Name) is already $($Project.DefaultBranch)"
    }
    $OldDefaultBranch = $Project.DefaultBranch

    if ($WhatIf) {
        Write-Host "WhatIf: would change default branch for $($Project.PathWithNamespace) from $OldDefaultBranch to $NewDefaultBranch"
        return
    }

    git checkout $OldDefaultBranch | Out-Null
    git pull -p | Out-Null
    git branch -m $OldDefaultBranch $NewDefaultBranch | Out-Null
    git push -u origin $NewDefaultBranch -o ci.skip | Out-Null
    Update-GitlabProject -DefaultBranch $NewDefaultBranch -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    try {
        UnProtect-GitlabBranch -Name $OldDefaultBranch -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    }
    catch {}
    Protect-GitlabBranch -Name $NewDefaultBranch -SiteUrl $SiteUrl -WhatIf:$WhatIf | Out-Null
    git push --delete origin $OldDefaultBranch | Out-Null
    git remote set-head origin -a | Out-Null

    Get-GitlabProject -ProjectId $Project.Id
}

function Get-GitlabProjectEvent {

    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$False)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $Before,

        [Parameter(Mandatory=$False)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $After,

        [Parameter(Mandatory=$False)]
        [ValidateSet("asc","desc")]
        [string]
        $Sort,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitLabProject $ProjectId

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

    Invoke-GitlabApi GET "projects/$($Project.Id)/events" `
        -Query $Query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf | 
        New-WrapperObject 'Gitlab.Event'
}
