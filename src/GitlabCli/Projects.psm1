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
function Get-GitlabProject {

    [CmdletBinding(DefaultParameterSetName='ById')]
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

    $MaxPages = Get-GitlabMaxPages -MaxPages $MaxPages -All:$All
    $Projects = @()
    switch ($PSCmdlet.ParameterSetName) {
        ById {
            if ($ProjectId -eq '.') {
                $ProjectId = $(Get-LocalGitContext).Project
                if (-not $ProjectId) {
                    throw "Could not infer project based on current directory ($(Get-Location))"
                }
            }
            $Projects = Invoke-GitlabApi GET "projects/$($ProjectId | ConvertTo-UrlEncoded)" -SiteUrl $SiteUrl
        }
        ByGroup {
            $Group = Get-GitlabGroup $GroupId
            $Query = @{
                'include_subgroups' = $Recurse ? 'true' : 'false'
            }
            if (-not $IncludeArchived) {
                $Query['archived'] = 'false'
            }
            $Projects = Invoke-GitlabApi GET "groups/$($Group.Id)/projects" $Query -MaxPages $MaxPages -SiteUrl $SiteUrl |
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
            } -MaxPages $MaxPages -SiteUrl $SiteUrl
        }
        ByUrl {
            $Url -match "$($(Get-DefaultGitlabSite).Url)/?(?<ProjectId>.*)" | Out-Null
            if ($Matches) {
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

function New-GitlabProject {
    [CmdletBinding(SupportsShouldProcess)]
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
        [ValidateSet('private', 'internal', 'public')]
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
        $Project = Invoke-GitlabApi POST "projects" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Project'
    
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

        [Parameter()]
        [ValidateSet('private', 'internal', 'public')]
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
        [ValidateSet($null, 'true', 'false')]
        [object]
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
        [ValidateSet($null, 'true', 'false')]
        [object]
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
    if ($CiForwardDeployment){
        $Request.ci_forward_deployment_enabled = $CiForwardDeployment
    }
    if ($DefaultBranch) {
        $Request.default_branch = $DefaultBranch
    }
    if ($Name) {
        $Request.name = $Name
    }
    if ($OnlyAllowMergeIfAllDiscussionsAreResolved) {
        $Request.only_allow_merge_if_all_discussions_are_resolved = $OnlyAllowMergeIfAllDiscussionsAreResolved
    }
    if ($Path) {
        $Request.path = $Path
    }
    if ($RepositoryAccessLevel) {
        $Request.repository_access_level = $RepositoryAccessLevel
    }
    if ($Topics) {
        $Request.topics = $Topics -join ','
    }
    if ($Visibility) {
        $Request.visibility = $Visibility
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "update project ($($Request | ConvertTo-Json))")) {
        Invoke-GitlabApi PUT "projects/$($Project.Id)" -Body $Request -SiteUrl $SiteUrl |
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

function Get-GitlabProjectVariable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [string]
        $Key,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject $ProjectId

    if ($Key) {
        # https://docs.gitlab.com/ee/api/project_level_variables.html#get-a-single-variable
        Invoke-GitlabApi GET "projects/$($Project.Id)/variables/$Key" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        # https://docs.gitlab.com/ee/api/project_level_variables.html#list-project-variables
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
        [Parameter(ValueFromPipelineByPropertyName)]
        $Protect,

        [switch]
        [Parameter(ValueFromPipelineByPropertyName)]
        $Mask,

        [ValidateSet($null, 'true', 'false')]
        [Parameter(ValueFromPipelineByPropertyName)]
        $ExpandVariables = 'true',

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Request = @{
        value = $Value
        raw   = $ExpandVariables -eq 'true' ? 'false' : 'true'
    }
    if ($Protect) {
        $Request.protected = 'true'
    }
    if ($Mask) {
        $Request.masked = 'true'
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
            Invoke-GitlabApi PUT "projects/$($Project.Id)/variables/$Key" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
        }
        else {
            $Request.key = $Key
            # https://docs.gitlab.com/ee/api/project_level_variables.html#create-a-variable
            Invoke-GitlabApi POST "projects/$($Project.Id)/variables" -Body $Request -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Variable'
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

function Add-GitlabGroupToProject {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('Share-GitlabProjectWithGroup')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Access')]
        [string]
        [ValidateSet('guest', 'reporter', 'developer', 'maintainer', 'owner')]
        $GroupAccess
    )

    $AccessLiteral = Get-GitlabMemberAccessLevel $GroupAccess
    $Project = Get-GitlabProject $ProjectId
    $Group = Get-GitlabGroup $GroupId

    # https://docs.gitlab.com/ee/api/projects.html#share-project-with-group
    $Request = @{
        Method = 'POST'
        Path = "projects/$($Project.Id)/share"
        Body = @{
            group_id     = $Group.Id
            group_access = $AccessLiteral
        }
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "share project with group ($($Request | ConvertTo-Json))")) {
        if (Invoke-GitlabApi @Request | Out-Null) {
            Write-Host "Successfully shared $($Project.PathWithNamespace) with $($Group.FullPath)"
        }
    }
}

function Remove-GitlabProject {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
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
        Invoke-GitlabApi DELETE "projects/$($ProjectId)" -SiteUrl $SiteUrl | Out-Null
        Write-Host "Removed $($Project.PathWithNamespace)"
    }
}
