# https://docs.gitlab.com/ee/api/topics.html#list-topics
function Get-GitlabTopic {
    [CmdletBinding(DefaultParameterSetName='Search')]
    param (
        [Parameter(Mandatory, ParameterSetName='Id')]
        [Alias('Id')]
        [string]
        $TopicId,

        [Parameter(ParameterSetName='Search', Position=0)]
        [string]
        $Search,

        [Parameter(ParameterSetName='Search')]
        [switch]
        $WithoutProjects,

        [Parameter(ParameterSetName='Search')]
        [uint]
        $MaxPages,

        [Parameter(ParameterSetName='Search')]
        [switch]
        $All,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    if ($All) {
        if ($MaxPages) {
            Write-Warning -Message "Ignoring -MaxPages in favor of -All"
        }
        $MaxPages = [uint]::MaxValue
    }

    $Query = @{}
    switch ($PSCmdlet.ParameterSetName) {
        Search  { $Url = 'topics'  }
        Id      { $Url = "topics/$TopicId" }
        Default { throw "$($PSCmdlet.ParameterSetName) is not supported"}
    }
    if ($Search) {
        $Query.search = $Search
    }
    if ($WithoutProjects) {
        $Query.without_projects = 'true'
    }

    Invoke-GitlabApi GET $Url $Query -MaxPages $MaxPages -SiteUrl $SiteUrl |
        New-WrapperObject 'Gitlab.Topic' |
        Sort-Object Name
}

# https://docs.gitlab.com/ee/api/topics.html#delete-a-project-topic
function Remove-GitlabTopic {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [string]
        $TopicId
    )
    
    if ($PSCmdlet.ShouldProcess("topic $TopicId", "delete")) {
        if (Invoke-GitlabApi DELETE "topics/$TopicId" -SiteUrl $SiteUrl) {
            Write-Host "Topic $TopicId deleted"
        }
    }
}
