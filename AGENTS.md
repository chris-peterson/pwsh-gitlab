# AGENTS.md

Instructions for AI agents working on this codebase. See [CONTRIBUTING.md](CONTRIBUTING.md) for general development workflow, tooling, and code style.

## Project Layout

```text
src/GitlabCli/
  *.psm1              # Public cmdlet modules (one per domain, e.g. MergeRequests.psm1)
  Private/             # Internal helpers, validations, transformations
  GitlabCli.psd1       # Module manifest (version, exports)
tests/
  *.Tests.ps1          # Pester v5 unit tests
docs/
  <Category>/          # PlatyPS markdown docs (one folder per module)
```

## Things to Know

- **Documentation lives in `docs/`** — do not add comment-based help (`<# .SYNOPSIS #>`) to public cmdlets in `*.psm1` files. Edit `docs/<Category>/<Cmdlet>.md` directly. Private helpers in `Private/` _may_ use comment-based help.
- **`$SiteUrl` looks unused but isn't** — it is read from the call stack by `Resolve-GitlabSite`. Do not remove it from function signatures.
- **Test mocking pattern** — mock `Invoke-GitlabApi`, `New-GitlabObject`, and resolver functions. See `tests/GroupAccessToken.Tests.ps1` for the pattern. Source private helpers needed by the module under test (e.g. `Globals.ps1`, `PaginationHelpers.ps1`).
- **Run `just` before finishing** — it runs tests, lint, and help-update in one shot. CI enforces all three.
