# Shared by tests that check what a user sees; dot-source from BeforeAll

# host output (including "What if:" lines, which no stream redirection captures) plus every stream
function global:Get-DisplayedText {
  param([scriptblock]$ScriptBlock)
  $Path = [IO.Path]::GetTempFileName()
  Start-Transcript -Path $Path -Force | Out-Null
  try {
    $Streams = & $ScriptBlock *>&1 | Out-String
  }
  finally {
    Stop-Transcript | Out-Null
  }
  $Text = (Get-Content $Path -Raw) + $Streams
  Remove-Item $Path
  $Text
}

# the exception Invoke-RestMethod throws for a non-success status
function global:New-HttpError {
  param([int]$Status)
  [Microsoft.PowerShell.Commands.HttpResponseException]::new("HTTP $Status", [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]$Status))
}
