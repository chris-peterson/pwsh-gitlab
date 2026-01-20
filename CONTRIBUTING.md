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

Documentation files are in `docs/` and should not be edited manually—they're generated from the module's comment-based help.

### Security Analysis

We use two tools for security and code quality:

| Tool | Purpose | When |
|------|---------|------|
| [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) | PowerShell linting & best practices | Local + CI |
| [CodeQL](https://codeql.github.com/) | Security vulnerability scanning | CI only |

```sh
just lint           # Run PSScriptAnalyzer locally
just lint-verbose   # Show detailed results
```

Configuration is in `PSScriptAnalyzerSettings.ps1`.

## Making Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Run `just check` to verify tests pass and no lint errors
5. Run `just help-update` if you added/modified cmdlets
6. Commit your changes
7. Open a Pull Request

## Code Style

- Follow [PowerShell Best Practices](https://poshcode.gitbook.io/powershell-practice-and-style/)
- Use approved verbs for cmdlet names (`Get-Verb` to see the list)
- Add tests for new functionality
- Avoid inline commenting (except when necessary); instead, prefer
  intention-revealing code.  Often a well-named function removes
  the need for a comment.
