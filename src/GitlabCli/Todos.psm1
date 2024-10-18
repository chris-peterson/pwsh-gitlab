function Get-GitlabTodo {
    [CmdletBinding()]
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
        MaxPages   = Get-GitlabMaxPages -MaxPages:$MaxPages -All:$All
        SiteUrl    = $SiteUrl
    }

    Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.Todo'
}

function Clear-GitlabTodo {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ById')]
    param (
        [Parameter(ParameterSetName='ById', Mandatory, Position=0)]
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
        SiteUrl    = $SiteUrl
    }
    
    switch ($PSCmdlet.ParameterSetName) {
        All {
            # https://docs.gitlab.com/ee/api/todos.html#mark-all-to-do-items-as-done
            $Request.Path = "todos/mark_as_done"
            if ($PSCmdlet.ShouldProcess("all todos", "$($Request | ConvertTo-Json)")) {
                Invoke-GitlabApi @Request | Out-Null
                Write-Host "All todos cleared"
            }
        }
        ById {
            # https://docs.gitlab.com/ee/api/todos.html#mark-a-to-do-item-as-done
            $Request.Path = "todos/$TodoId/mark_as_done"
            if ($PSCmdlet.ShouldProcess("todo #$TodoId", "$($Request | ConvertTo-Json)")) {
                Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.Todo'
            }    
        }
    }
}
