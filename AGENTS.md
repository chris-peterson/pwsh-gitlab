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
- **Test mocking pattern** — mock `Invoke-GitlabApi`, `New-GitlabObject`, and resolver functions. Private helpers needed by the module under test (e.g. `Globals.ps1`, `PaginationHelpers.ps1`) must be included _inside_ the `New-Module` scriptblock, not dot-sourced outside it — modules only see their own scope and global. **Exception:** `Transformations.ps1` (which defines PowerShell classes used as parameter attributes like `[GitlabDate()]`) must be dot-sourced _outside_ the `New-Module` scriptblock — classes must be registered in the type system before `[scriptblock]::Create()` parses function signatures that reference them. See `tests/Get-GitlabMergeRequest.Tests.ps1` for the pattern.
- **Run `just` before finishing** — it runs tests, lint, and help-update in one shot. CI enforces all three.

## Coding Style

The style has evolved over time

An example, older-style code used hashtable indexing (e.g. `$Foo['bar']`).  We prefer the cleaner `$Foo.bar`; but don't mix and match
or increase scope -- instead -- match the "ambient" style
