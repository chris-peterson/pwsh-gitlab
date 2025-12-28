function Get-GitlabAuditEvent {

    [CmdletBinding()]
    [OutputType('Gitlab.AuditEvent')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId,

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $AuditEventId,

        [Parameter()]
        [ValidateSet('User', 'Group', 'Project', IgnoreCase=$false)]
        [string]
        $EntityType,

        [Parameter()]
        [string]
        $EntityId,

        [switch]
        [Parameter()]
        $FetchAuthors,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Alias('Until')]
        [Parameter()]
        [ValidateScript({Test-GitlabDate $_})]
        [string]
        $Before,

        [Alias('Since')]
        [Parameter()]
        [ValidateScript({Test-GitlabDate $_})]
        [string]
        $After,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $Group = Get-GitlabGroup $GroupId
        $Resource = "groups/$($Group.Id)/audit_events"
    } elseif ($ProjectId) {
        $ResolvedProjectId = Resolve-GitlabProjectId $ProjectId
        $Resource = "projects/$ResolvedProjectId/audit_events"
    } else {
        $Resource = 'audit_events'
    }
    if ($AuditEventId){
        $Resource += "/$AuditEventId"
    }

    $Query = @{}
    if ($EntityId) {
        if (-not $EntityType) {
            throw "Requires -EntityType to also be provided"
        }
        $Query.entity_id = $EntityId
    }
    if ($EntityType) {
        $Query.entity_type = $EntityType
    }
    if ($Before) {
        $Query.created_before = $Before
    }
    if ($After) {
        $Query.created_after = $After
    }
    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    # https://docs.gitlab.com/ee/api/audit_events.html
    $Results = Invoke-GitlabApi GET $Resource -Query $Query -MaxPages $MaxPages | New-GitlabObject 'Gitlab.AuditEvent'

    if ($FetchAuthors) {
        $Authors = $Results.AuthorId | Select-Object -Unique | Where-Object { $_ -ne '-1' } | ForEach-Object {
            try {
                $User = Get-GitlabUser $_
            }
            catch {
                $User = $null
            }
            @{Id=$_; User=$User }
        }
        $Results | ForEach-Object {
            $_ | Add-Member -MemberType 'NoteProperty' -Name 'Author' -Value $($Authors | Where-Object Id -eq $_.AuthorId | Select-Object -ExpandProperty User)
        }
    }
    $Results
}
