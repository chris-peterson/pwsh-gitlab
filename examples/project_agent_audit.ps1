param(
    [string[]]
    [Parameter(Mandatory, Position=0)]
    $GroupName,

    [string]
    [Parameter()]
    $OutputPath = 'report_agent_audit.md',

    [string]
    [Parameter()]
    $StatePath = 'report_agent_audit_state.json'
)

$AgentFilePatterns = @(
    'AGENTS.md'
    'CLAUDE.md'
    'COPILOT.md'
    '.cursorrules'
    '.cursor/rules'
    '.github/copilot-instructions.md'
    '.mcp.json'
    'mcp.json'
    '.mcp/config.json'
)
$AgentDirectoryPrefixes = @(
    '.claude/'
    '.github/agents/'
    '.github/instructions/'
)

# load prior state for incremental runs
$LastUpdated = $null
$PriorFindings = @{}
if (Test-Path $StatePath) {
    $State = Get-Content $StatePath | ConvertFrom-Json
    $LastUpdated = [datetime]$State.LastUpdated
    foreach ($entry in $State.Findings.PSObject.Properties) {
        $PriorFindings[$entry.Name] = $entry.Value
    }
    Write-Host "Resuming from last run: $LastUpdated"
}

# enumerate and dedup projects across all groups
$Projects = @()
foreach ($Group in $GroupName) {
    $Projects += Get-GitlabProject -GroupId $Group -Recurse
}
$Projects = $Projects | Sort-Object Id -Unique

Write-Host "Found $($Projects.Count) unique projects across $($GroupName.Count) group(s)"

# filter to projects modified since last run
if ($LastUpdated) {
    $Stale    = $Projects | Where-Object { $_.LastActivityAt -le $LastUpdated }
    $Projects = $Projects | Where-Object { $_.LastActivityAt -gt  $LastUpdated }
    Write-Host "$($Projects.Count) projects modified since $LastUpdated ($($Stale.Count) unchanged)"
}

$RunTimestamp = Get-Date
$Findings = @{}

# carry forward unchanged projects from prior run
foreach ($key in $PriorFindings.Keys) {
    $Findings[$key] = $PriorFindings[$key]
}

# audit each project for agent files
$i = 0
foreach ($Project in $Projects) {
    $i++
    $ProjectPath = $Project.PathWithNamespace
    Write-Host "[$i/$($Projects.Count)] Scanning $ProjectPath"

    try {
        $Tree = Get-GitlabRepositoryTree -ProjectId $ProjectPath -Recurse
    }
    catch {
        Write-Warning "  Could not read tree for $ProjectPath -- $_"
        continue
    }

    $FileMatches = @()
    foreach ($Pattern in $AgentFilePatterns) {
        $Hit = $Tree | Where-Object { $_.Path -eq $Pattern -or $_.Path -like "*/$Pattern" }
        if ($Hit) {
            foreach ($File in $Hit) {
                $FileMatches += [pscustomobject]@{
                    Path = $File.Path
                    Type = $File.Type
                }
            }
        }
    }
    foreach ($Prefix in $AgentDirectoryPrefixes) {
        $Hit = $Tree | Where-Object { $_.Path -like "$Prefix*" }
        if ($Hit) {
            foreach ($File in $Hit) {
                $FileMatches += [pscustomobject]@{
                    Path = $File.Path
                    Type = $File.Type
                }
            }
        }
    }

    if ($FileMatches.Count -gt 0) {
        $Findings[$ProjectPath] = $FileMatches
    }
    else {
        # clear stale entry if files were removed
        $Findings.Remove($ProjectPath)
    }
}

# classify files by tool
$ToolRules = [ordered]@{
    Claude  = @{ Files = @('AGENTS.md', 'CLAUDE.md');  Prefixes = @('.claude/') }
    Copilot = @{ Files = @('COPILOT.md', '.github/copilot-instructions.md'); Prefixes = @('.github/agents/', '.github/instructions/') }
    Cursor  = @{ Files = @('.cursorrules', '.cursor/rules'); Prefixes = @() }
    MCP     = @{ Files = @('.mcp.json', 'mcp.json'); Prefixes = @('.mcp/') }
}

function Get-Tool ($FilePath) {
    foreach ($Tool in $ToolRules.Keys) {
        $Rule = $ToolRules[$Tool]
        foreach ($f in $Rule.Files) {
            if ($FilePath -eq $f) { return $Tool }
        }
        foreach ($p in $Rule.Prefixes) {
            if ($FilePath -like "$p*") { return $Tool }
        }
    }
    return 'Other'
}

# build tool -> root group -> project -> files structure
$ByTool = [ordered]@{}
foreach ($Tool in $ToolRules.Keys) {
    $ByTool[$Tool] = @{}
}
$ByTool['Other'] = @{}

foreach ($ProjectPath in $Findings.Keys) {
    foreach ($File in $Findings[$ProjectPath]) {
        $Tool = Get-Tool $File.Path
        $RootGroup = ($ProjectPath -split '/')[0]
        if (-not $ByTool[$Tool][$RootGroup]) {
            $ByTool[$Tool][$RootGroup] = @{}
        }
        if (-not $ByTool[$Tool][$RootGroup][$ProjectPath]) {
            $ByTool[$Tool][$RootGroup][$ProjectPath] = @()
        }
        $ByTool[$Tool][$RootGroup][$ProjectPath] += $File.Path
    }
}

# build markdown report
$Md = [System.Text.StringBuilder]::new()
[void]$Md.AppendLine('# Agent File Audit')
[void]$Md.AppendLine()
[void]$Md.AppendLine("**Groups:** $($GroupName -join ', ')")
[void]$Md.AppendLine("**Generated:** $RunTimestamp")
if ($LastUpdated) {
    [void]$Md.AppendLine("**Incremental since:** $LastUpdated")
}
[void]$Md.AppendLine()

$HasFindings = $false
foreach ($Tool in $ByTool.Keys) {
    $Groups = $ByTool[$Tool]
    if ($Groups.Count -eq 0) { continue }
    $HasFindings = $true
    [void]$Md.AppendLine("## $Tool")
    [void]$Md.AppendLine()
    foreach ($RootGroup in $Groups.Keys | Sort-Object) {
        [void]$Md.AppendLine("### $RootGroup")
        [void]$Md.AppendLine()
        foreach ($ProjectPath in $Groups[$RootGroup].Keys | Sort-Object) {
            $Files = $Groups[$RootGroup][$ProjectPath] | ForEach-Object { "``$_``" }
            [void]$Md.AppendLine("- ${ProjectPath}: $($Files -join ', ')")
        }
        [void]$Md.AppendLine()
    }
}

if (-not $HasFindings) {
    [void]$Md.AppendLine('No agent files found.')
}

$Md.ToString() | Set-Content $OutputPath -Encoding utf8
Write-Host "Report written to $OutputPath"

# persist state for next incremental run
$StateObj = @{
    LastUpdated = $RunTimestamp.ToString('o')
    Findings    = $Findings
}
$StateObj | ConvertTo-Json -Depth 5 | Set-Content $StatePath -Encoding utf8
Write-Host "State saved to $StatePath"
