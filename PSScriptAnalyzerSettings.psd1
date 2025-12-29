@{
    # PSScriptAnalyzer settings for pwsh-gitlab
    # https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/rules/readme

    # NOTE: The 'SiteUrl' parameter appears unused in many functions, but this is intentional.
    # It is read from the call stack via $PSBoundParameters in Resolve-GitlabSite
    # (src/GitlabCli/Private/Functions/ConfigurationHelpers.ps1).
    # This pattern allows multi-site GitLab support without explicit parameter passing.
    # Since PSScriptAnalyzer cannot suppress by parameter name, we exclude this rule entirely
    # and rely on code review for actual unused parameters.

    # NOTE: PSUseProcessBlockForPipelineCommand fires on functions with ValueFromPipelineByPropertyName
    # but no process {} block. While technically correct, most functions in this module are designed
    # for single-object pipeline input (e.g., Get-GitlabProject $proj | Remove-GitlabProject).
    # Adding process blocks would require significant refactoring and testing of ~50+ functions.
    # Pipeline collection behavior is handled explicitly where needed.

    ExcludeRules = @(
        'PSReviewUnusedParameter'
        'PSUseProcessBlockForPipelineCommand'
    )
}
