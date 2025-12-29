function Get-GitlabTodo {
    [CmdletBinding()]
    [OutputType('Gitlab.Todo')]
    param (
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

    # https://docs.gitlab.com/ee/api/todos.html#get-a-list-of-to-do-items
    $Request = @{
        HttpMethod = 'GET'
        Path       = 'todos'
        MaxPages   = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    }

    Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.Todo'
}

function Clear-GitlabTodo {
    [Alias('Mark-GitlabTodoDone')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ById')]
    [OutputType('Gitlab.Todo')]
    param (
        [Parameter(ParameterSetName='ById', Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        $TodoId,

        [Parameter(ParameterSetName='All')]
        [switch]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )
    $Request = @{
        HttpMethod = 'POST'
    }

    $Label = ''
    if ($All) {
        # https://docs.gitlab.com/ee/api/todos.html#mark-all-to-do-items-as-done
        $Request.Path = "todos/mark_as_done"
        $Label = "all todos"
    } else {
        # https://docs.gitlab.com/ee/api/todos.html#mark-a-to-do-item-as-done
        $Request.Path = "todos/$TodoId/mark_as_done"
        $Label = "todo #$TodoId"
    }

    if ($PSCmdlet.ShouldProcess($Label, "$($Request | ConvertTo-Json)")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Marked $Label as done"
    }
}
