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
        [Parameter(Position=0, Mandatory=$false, ParameterSetName='ById')]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ParameterSetName='ByGroup', ValueFromPipelineByPropertyName=$true)]
        [string]
        $GroupId,

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

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 10,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

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

function ConvertTo-Triggers {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,

        [Parameter(Mandatory=$false)]
        [ValidateSet('', 'depend')]
        [string]
        $Strategy = 'depend'
    )
    Begin {
        $Yaml = @"
stages:
  - trigger
"@
        $Projects = @()
    }
    Process {
        foreach ($Object in $InputObject) {
            if ($Projects.Contains($Object.ProjectId)) {
                continue
            }
            $Projects += $Object.ProjectId
            $Yaml += @"


$($Object.Name):
  stage: trigger
  trigger:
    project: $($Object.PathWithNamespace)
"@
            if ($Strategy) {
                $Yaml += @"

    strategy: $Strategy
"@
            }
        }
    }
    End {
        $Yaml
    }
}

function Move-GitlabProject {
    [Alias("Transfer-GitlabProject")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true)]
        [string]
        $DestinationGroup,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    Invoke-GitlabApi PUT "projects/$($SourceProject.Id)/transfer" @{
        namespace = $Group.Id
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Project'
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

function Copy-GitlabProject {
    [Alias("Fork-GitlabProject")]
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $DestinationGroup,

        [bool]
        [Parameter(Mandatory=$false)]
        $PreserveForkRelationship = $true,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $SourceProject = Get-GitlabProject -ProjectId $ProjectId
    $Group = Get-GitlabGroup -GroupId $DestinationGroup

    if ($WhatIf) {
        Write-Host "WhatIf: forking '$($SourceProject.Name)' (project id: $($SourceProject.Id)) to '$($Group.FullPath)' (group id: $($Group.Id))"
    } else {
        $NewProject = Invoke-GitlabApi POST "projects/$($SourceProject.Id)/fork" @{
            namespace_id = $Group.Id
        } -SiteUrl $SiteUrl -WhatIf:$WhatIf
    }

    if (-not $PreserveForkRelationship) {
        Invoke-GitlabApi DELETE "projects/$($NewProject.id)/fork" -SiteUrl $SiteUrl -WhatIf:$WhatIf
    }
}
function New-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]
        $ProjectName,

        [Parameter(Position=1, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('GroupId')]
        [string]
        $DestinationGroup,

        [Parameter(Mandatory=$false)]
        [ValidateSet('private', 'internal', 'public')]
        [string]
        $Visibility = 'internal',

        [switch]
        [Parameter(Mandatory=$false)]
        $CloneNow,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Group = Get-GitlabGroup -GroupId $DestinationGroup
    if(-not $Group) {
        throw "DestinationGroup '$DestinationGroup' not found"
    }

    $Project = Invoke-GitlabApi POST "projects" @{
        name = $ProjectName
        namespace_id = $Group.Id
        visibility = $Visibility
    } -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Project'
    
    if ($CloneNow) {
        git clone $Project.SshUrlToRepo
        Set-Location $ProjectName
    } else {
        $Project
    }
}

# https://docs.gitlab.com/ee/api/projects.html#edit-project
function Update-GitlabProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
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

        [Parameter(Mandatory=$false)]
        [bool]
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
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    $Query = @{}

    if($PSBoundParameters.ContainsKey("CiForwardDeployment")){
        $Query.ci_forward_deployment_enabled = $CiForwardDeployment.ToString().ToLower()
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

    Invoke-GitlabApi PUT "projects/$($Project.Id)" $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Project'
}

# https://docs.gitlab.com/ee/api/projects.html#archive-a-project
function Invoke-GitlabProjectArchival {
    [Alias('Archive-GitlabProject')]
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = $(Get-GitlabProject -ProjectId $ProjectId)
    
    Invoke-GitlabApi POST "projects/$($Project.Id)/archive" -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Project'
}

# https://docs.gitlab.com/ee/api/projects.html#unarchive-a-project
function Invoke-GitlabProjectUnarchival {
    [Alias('Unarchive-GitlabProject')]
    [CmdletBinding()]
    param (
        [Parameter(Position=0)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = $(Get-GitlabProject -ProjectId $ProjectId)
    
    Invoke-GitlabApi POST "projects/$($Project.Id)/unarchive" -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Project'
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

# https://docs.gitlab.com/ee/api/project_level_variables.html#update-variable
function Set-GitlabProjectVariable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$true, Position=1)]
        [string]
        $Value,

        [switch]
        [Parameter(Mandatory=$false)]
        $Protect,

        [switch]
        [Parameter(Mandatory=$false)]
        $Mask,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Query = @{
        value = $Value
    }
    if ($Protect) {
        $Query['protected'] = 'true'
    }
    if ($Mask) {
        $Query['masked'] = 'true'
    }

    $ProjectId = $(Get-GitlabProject $ProjectId).Id

    try {
        Get-GitlabProjectVariable $ProjectId $Key
        $IsExistingVariable = $True
    }
    catch {
        $IsExistingVariable = $False
    }

    if ($IsExistingVariable) {
        Invoke-GitlabApi PUT "projects/$($ProjectId)/variables/$Key" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
    }
    else {
        $Query.Add('key', $Key)
        Invoke-GitlabApi POST "projects/$($ProjectId)/variables" -Query $Query -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Variable'
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

    git checkout $OldDefaultBranch
    git pull -p
    git branch -m $OldDefaultBranch $NewDefaultBranch
    git push -u origin $NewDefaultBranch -o ci.skip
    Update-GitlabProject -DefaultBranch $NewDefaultBranch -SiteUrl $SiteUrl -WhatIf:$WhatIf
    try {
        UnProtect-GitlabBranch -Name $OldDefaultBranch -SiteUrl $SiteUrl -WhatIf:$WhatIf
    }
    catch {}
    Protect-GitlabBranch -Name $NewDefaultBranch -SiteUrl $SiteUrl -WhatIf:$WhatIf
    git push --delete origin $OldDefaultBranch
    git remote set-head origin -a
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