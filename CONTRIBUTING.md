# Contributing to pwsh-gitlab

Thanks for your interest in contributing! This document outlines how to set up your development environment and the tools we use.

## Prerequisites

### Required

| Tool | Version | Installation |
|------|---------|--------------|
| [PowerShell](https://github.com/PowerShell/PowerShell) | 7.1+ | `brew install powershell` (macOS) |
| [just](https://just.systems) | latest | `brew install just` (macOS) |

### Optional

| Tool | Purpose |
|------|---------|
| [Docker](https://www.docker.com/) | Run the module in a container |

## Development Workflow

We use [just](https://just.systems) as a task runner.

The default task is to run everything

```sh
just
```

<img src="https://media1.tenor.com/m/wSGnuU9TOFgAAAAC/all-the-things-hyperbole-and-a-half.gif" width=256 />

## Tooling

### Testing — [Pester](https://pester.dev/)

Tests are located in the `tests/` directory. We use Pester v5+ for unit testing.

```sh
just test
```

### Documentation — [PlatyPS](https://github.com/PowerShell/platyps)

Cmdlet documentation is generated from code comments using PlatyPS and published to GitHub Pages.

```sh
just help-update
```

Documentation lives in `docs/`.

Run `just help-update` after adding or renaming parameters — it syncs structural metadata (types, parameter sets, aliases) while preserving hand-written descriptions. CI enforces docs are in sync.

Changes not handled by PlatyPS may require manual updates to specific markdown files.

### Security Analysis

We use two tools for security and code quality:

| Tool | Purpose | When |
|------|---------|------|
| [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) | PowerShell linting & best practices | Local + CI |
| [CodeQL](https://codeql.github.com/) | Security vulnerability scanning | CI only |

```sh
just lint   # Run PSScriptAnalyzer locally
```

Configuration is in `PSScriptAnalyzerSettings.ps1`.

## Releasing

`CHANGELOG.md` keeps an `## [Unreleased]` section at the top, and that section is where release notes come from. Appending to it as you work is welcome but not required; whoever cuts the release reviews it and backfills whatever is missing.

Releases are driven by [GitHub Releases](https://github.com/chris-peterson/pwsh-gitlab/releases). Publishing a release is the trigger; the tag carries the version:

- The **tag** is the version, `v`-prefixed (e.g. `v1.173.0`). CI strips the `v` for both `ModuleVersion` and the image tag, so both read `1.173.0`.
- The **notes** are whatever `Unreleased` holds at that moment. The release body you type is replaced with them, so leaving it blank is fine.

On publish, the `release` job:

1. Promotes `Unreleased` into a dated `## [<version>]` section, leaves a fresh empty `Unreleased` behind, and writes that same text into `GitlabCli.psd1` `ModuleVersion` and `ReleaseNotes`.
2. Publishes the module to the PowerShell Gallery and the image to GHCR, tagged with the version and `latest`.
3. Sets the GitHub Release body to the promoted notes, so the releases page reads the same as the changelog.
4. Commits the manifest and changelog back to `main`.

Dispatching a release with an empty `Unreleased` fails the job, so record what changed before publishing.

The commit-back runs last so that a failed publish leaves `main` without a commit claiming a release that never shipped.

To preview the manifest and changelog edits a release will make, run the script locally with `-WhatIf`:

```powershell
./build/Update-ReleaseArtifacts.ps1 -Version v1.173.0 -WhatIf
```

Cut releases from a tag at `main`'s HEAD. The test, security, and docs gates run against the tag, but the `release` job checks out `main` (it has to, to commit the version bump back), so a tag behind `main` publishes `main`'s code rather than the code the gates checked.

The commit-back uses the built-in `GITHUB_TOKEN`. If `main` becomes a protected branch, that token needs permission to push to it.

## Making Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Run `just check` to verify tests pass and no lint errors
5. Run `just help-update` if you added/modified cmdlets
6. Add a line under `## [Unreleased]` in `CHANGELOG.md` if the change is worth a release note
7. Commit your changes
8. Open a Pull Request

## Code Style

- Follow [PowerShell Best Practices](https://poshcode.gitbook.io/powershell-practice-and-style/)
- Use approved verbs for cmdlet names (`Get-Verb` to see the list)
- Add tests for new functionality
- Avoid inline commenting (except when necessary); instead, prefer
  intention-revealing code.  Often a well-named function removes
  the need for a comment.
