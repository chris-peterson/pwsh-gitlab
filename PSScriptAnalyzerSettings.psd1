@{
    # PSScriptAnalyzer settings for pwsh-gitlab
    # https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/rules/readme

    ExcludeRules = @(
        # This module intentionally uses global variables for shared module state
        # (config path, API defaults, session state, etc.). $script: scope doesn't work
        # across module files, so $global: is the standard pattern.
        # All globals are namespaced with 'Gitlab' prefix to avoid collisions.
        'PSAvoidGlobalVars'

        # This is a CLI tool where Write-Host is intentionally used for user feedback
        # (confirmations, progress, colored output). These messages are distinct from
        # pipeline output and should not go to stdout.
        'PSAvoidUsingWriteHost'

        # Suggests putting $null on the left side of comparisons to avoid array coercion issues.
        # While technically valid, the right-side style ($var -eq $null) is more readable.
        'PSPossibleIncorrectComparisonWithNull'

        # The 'SiteUrl' parameter appears unused in many functions, but this is intentional.
        # It is read from the call stack via $PSBoundParameters in Resolve-GitlabSite
        # (src/GitlabCli/Private/Functions/ConfigurationHelpers.ps1).
        # This pattern allows multi-site GitLab support without explicit parameter passing.
        # Since PSScriptAnalyzer cannot suppress by parameter name, we exclude this rule entirely
        # and rely on code review for actual unused parameters.
        'PSReviewUnusedParameter'

        # Fires on functions with ValueFromPipelineByPropertyName but no process {} block.
        # While technically correct, most functions in this module are designed for single-object
        # pipeline input (e.g., Get-GitlabProject $proj | Remove-GitlabProject).
        # Adding process blocks would require significant refactoring and testing of ~50+ functions.
        'PSUseProcessBlockForPipelineCommand'
    )
}
