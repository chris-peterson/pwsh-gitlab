# Planning

## Gap Analysis Dimensions

### 1. GitLab REST API Coverage

The primary measure of completeness — how much of the ~144 [GitLab REST API](https://docs.gitlab.com/ee/api/rest/) resource areas does pwsh-gitlab cover?

**Current coverage: ~35 resource areas**

#### Coverage by Category

**Full or Strong Coverage** — these areas have mature, multi-operation support:

| API Resource | pwsh-gitlab Coverage | Notes |
|---|---|---|
| Projects | Full CRUD + fork, archive, transfer, share, delete | 15+ cmdlets |
| Groups | Full CRUD + subgroups, descendants, transfer, share | 10+ cmdlets |
| Merge Requests | List, create, merge, approve + approval rules/config | Global, project, group scopes |
| Issues | List, create + notes | Global, project, group scopes |
| Pipelines | List, get, create, cancel, delete, variables, bridges | |
| Jobs | List, get, trace | Project + pipeline scopes |
| Branches | List, get, create, protect, unprotect | |
| Protected Branches | List, get, create, delete | |
| Commits | List, get | |
| Repository Files | Get, create, update + tree | |
| Repository Tree | List | |
| Runners | List, get, update, delete + jobs | |
| Members | Full CRUD at project + group level | |
| Variables | Full CRUD at project + group level | |
| Access Tokens | List, create, delete at project + group level | |
| Personal Access Tokens | List, get, get self | |
| Project Hooks | Full CRUD | |
| Integrations | Get, update, delete | |
| Environments | List, get, stop | |
| Deployments | List, get | |
| Snippets | Full CRUD + raw content | Personal snippets |
| Topics | Full CRUD | |
| Milestones | Full CRUD (project + group) | |
| Releases | Create, update, delete | Asset links not covered |
| Labels | Full CRUD (project + group) | |
| Tags | List, get, create, delete | |
| Pipeline Schedules | Full CRUD + variables, enable/disable | |
| Deploy Keys | Full CRUD at project + user level | |
| Service Accounts | Full CRUD | |
| CI Lint | Validate a pipeline definition | `Test-GitlabPipelineDefinition` |
| Job Artifacts | Download (whole archive or one path) | Keep/delete not covered |
| Audit Events | List, get at instance/group/project | |
| Todos | List, mark done, mark all done | |
| Search | Global, group, project scopes | |
| Users | List, get, get current, events | |
| Events | Project + user events | |
| Version / Metadata | Get | |
| GraphQL | Direct query support | Not a REST resource, but notable |

#### Gap Analysis — Missing API Resources

Categorized by relevance to pwsh-gitlab's identity as an **API-first automation tool**.

**High Value — Common automation workflows:**

| # | API Resource | Key Operations | Why It Matters |
|---|---|---|---|
| 1 | **Release asset links** | Add, update, delete links on a release | The one part of release automation still missing. |
| 2 | **Job Artifacts** (lifecycle) | List files, keep, delete | Download already ships; the rest does not. |
| 3 | **Issue Links** | List, create, delete | No coverage. Useful for cross-referencing. |
| 4 | **Discussions** (threaded comments) | List, create, resolve on MRs/issues | Only have flat notes today. Tracked by #111. |
| 5 | **MR Approvals** (unapprove) | Unapprove / revoke | Already have approve. Missing the inverse. |
| 6 | **MR notes** (write) | `New-GitlabMergeRequestNote` | Blocks ForgeCli's `New-ChangeRequestComment`. Tracked by #111. |

**Medium Value — Useful for specific workflows:**

| # | API Resource | Key Operations | Why It Matters |
|---|---|---|---|
| 7 | **Container Registry** | List repos, list/delete tags | Relevant for CI/CD image management. |
| 8 | **Packages** (generic) | List, get, delete (project + group) | Package management visibility. |
| 9 | **Wikis** (project + group) | List, get, create, update, delete | Documentation automation. |
| 10 | **Deploy Tokens** | List, create, delete (project + group) | CI/CD credential management. |
| 11 | **Protected Tags** | List, get, create, delete | Complement to protected branches. |
| 12 | **Protected Environments** | List, get, create, update, delete | Deployment safety controls. |
| 13 | **Freeze Periods** | CRUD | Deployment freeze management. |
| 14 | **Merge Trains** | List, get status, add to train | GitLab CI merge queue support. |
| 15 | **Remote Mirrors** | CRUD + force sync | Repository mirroring. |
| 16 | **Changelog** | Get/create from repo API | Release notes generation. |
| 17 | **Badges** (project + group) | CRUD | Project/group branding. |
| 18 | **Invitations** | CRUD (project + group) | Access management automation. |
| 19 | **Notification Settings** | Get, update | Preference management. |
| 20 | **Project Import/Export** | Export, download, import | Migration automation. |
| 21 | **Suggestions** (code suggestions in MRs) | Apply, batch apply | Code review automation. |

**Low Value — Niche or admin-only:**

| # | API Resource | Notes |
|---|---|---|
| 22 | Broadcast Messages | Admin-only |
| 23 | Application Settings | Admin-only |
| 24 | License | Admin-only |
| 25 | Sidekiq Metrics | Admin-only |
| 26 | System Hooks | Admin-only |
| 27 | Feature Flags (admin) | Admin-only |
| 28 | Plan Limits | Admin-only |
| 29 | Appearance | Admin-only |
| 30 | Vulnerabilities / Findings | Security-specific |
| 31 | Dependencies | Security-specific |
| 32 | Error Tracking | Niche |
| 33 | Geo Nodes/Sites | Enterprise/HA-specific |
| 34 | Cluster Agents (K8s) | Infrastructure-specific |
| 35 | Custom Attributes | Niche |
| 36 | Namespaces | Low-level; usually access groups/projects directly |
| 37 | Resource Label Events | Audit/history |
| 38 | External Status Checks | Niche |
| 39 | Feature Flags (project) | Niche |
| 40 | Draft Notes (MR) | Niche |
| 41 | Emoji Reactions | Niche |
| 42 | Epics (deprecated) | Being replaced by Work Items |
| 43 | Member Roles | Premium/custom roles |
| 44 | Repository Submodules | Niche |
| 45 | Model Registry | ML-specific |
| 46 | Markdown render | Niche |

**Out of Scope — Package manager protocol endpoints:**

Composer, Conan, Debian, Go Proxy, Helm, Maven, npm, NuGet, PyPI, RubyGems, Terraform Modules — these are package-manager protocol implementations, not management APIs.

### 2. glab CLI Parity

A secondary measure — where does [glab](https://gitlab.com/gitlab-org/cli) have capabilities that pwsh-gitlab lacks?

pwsh-gitlab is **broader and deeper than glab** in most API-management areas (groups, approvals, tokens, webhooks, integrations, audit, admin). glab excels in developer-workflow UX (checkout, rebase, interactive views, stacked diffs).

## Prioritized Backlog

### Tier 1 — High Impact, Common Workflows

| # | Feature | Scope | Rationale |
|---|---------|-------|-----------|
| 1 | **Release asset links** | Add, update, delete asset links on a release | The remaining half of release automation. |
| 2 | **Job Artifacts (lifecycle)** | List files, keep, delete | `Get-GitlabJobArtifact` downloads; nothing manages them. |
| 3 | **MR notes (write)** | `New-GitlabMergeRequestNote` | Blocks ForgeCli's `New-ChangeRequestComment`. Tracked by #111. |

### Tier 2 — Medium Impact, Developer Workflow

| # | Feature | Scope | Rationale |
|---|---------|-------|-----------|
| 4 | **MR unapprove** | `Revoke-GitlabMergeRequestApproval` | Already have `Approve-GitlabMergeRequest`. Natural complement. |
| 5 | **Discussions** | Threaded comment support on MRs/issues | Currently only flat notes. Discussions are the richer model. Tracked by #111. |
| 6 | **Issue Links** | `Get-GitlabIssueLink`, `New-GitlabIssueLink`, `Remove-GitlabIssueLink` | Cross-referencing issues. |
| 7 | **Changelog** | `New-GitlabChangelog` | GitLab's changelog API generates notes from MR metadata. |
| 8 | **Container Registry** | `Get-GitlabContainerRegistry`, `Remove-GitlabContainerRegistryTag` | Image management in CI/CD. |
| 9 | **Packages** | `Get-GitlabPackage`, `Remove-GitlabPackage` | Package visibility and cleanup. |
| 10 | **Deploy Tokens** | CRUD at project + group level | CI/CD credential management. |
| 11 | **Protected Tags** | `Protect-GitlabTag`, `UnProtect-GitlabTag` | Complement to protected branches. |
| 12 | **Wikis** | CRUD for project + group wikis | Documentation automation. |
| 13 | **SSH key management (write)** | `New-GitlabKey`, `Remove-GitlabKey` | Already have `Get-GitlabKey`. Completing CRUD is small. |

### Tier 3 — Low Impact / Niche

| # | Feature | Scope | Rationale |
|---|---------|-------|-----------|
| 14 | **Protected Environments** | CRUD | Deployment safety controls. |
| 15 | **Freeze Periods** | CRUD | Deployment freeze management. |
| 16 | **Merge Trains** | List, get status | Merge queue visibility. |
| 17 | **Badges** | CRUD (project + group) | Branding/status badges. |
| 18 | **Remote Mirrors** | CRUD + force sync | Repository mirroring. |
| 19 | **Project Import/Export** | Export, download, import | Migration automation. |
| 20 | **Invitations** | CRUD (project + group) | Access management. |
| 21 | **GPG keys** | CRUD | One-time setup. Low frequency. |
| 22 | **Iterations** | Read-only | Agile-shop feature. |
| 23 | **Secure files** | CRUD | CI/CD secure file management. |

### Won't Do (or defer indefinitely)

| Feature | Reason |
|---|---|
| **Package manager protocols** (npm, NuGet, etc.) | Protocol endpoints, not management APIs |
| **Stacked diffs** (`glab stack`) | Heavy git-workflow UX; better served by glab itself |
| **MR checkout / rebase** | Git operations, not API — users already have git |
| **Duo AI / Code Suggestions** | Proprietary GitLab feature |
| **Epics** | Deprecated, being replaced by Work Items |
| **Kubernetes agents / Clusters** | Infrastructure-specific |
| **Vulnerabilities / Security** | Security-scanner-specific |
| **Admin-only settings** | Application settings, broadcast messages, Sidekiq, etc. |
| **Work Items** | Still early/evolving in GitLab |

## Milestone Plan

Milestone 1 (labels, tags, releases, milestones, pipeline cancel) and most of Milestone 2
(pipeline schedules, CI lint, artifact download) have shipped. What remains is regrouped below.

### Milestone A — Finish CI/CD

| Feature | Scope | Status |
|---------|-------|--------|
| Pipeline Triggers | List, get, create, update, delete | Tracked by #165 |
| Job Artifacts (lifecycle) | List files, keep, delete | Download already ships |
| Changelog | Generate from the repository API | |

### Milestone B — Collaboration Depth

| Feature | Scope | Status |
|---------|-------|--------|
| Notes (write) | `New-GitlabMergeRequestNote`; `-Since`/`-All` on issue notes | Tracked by #111 |
| Discussions | Threaded comments on MRs/issues; create, resolve | Tracked by #111 |
| Issue Links | List, create, delete | |
| MR unapprove | Revoke an approval | |
| Release asset links | Add, update, delete | |

### Milestone C — Registry and Access

| Feature | Scope |
|---------|-------|
| Container Registry | List repos, list/delete tags |
| Packages | List, get, delete (project + group) |
| Deploy Tokens | CRUD at project + group level |
| Protected Tags | List, get, create, delete |
| Wikis | CRUD for project + group wikis |
| SSH keys (write) | `New-GitlabKey`, `Remove-GitlabKey` — `Get-GitlabKey` already ships |

## Next Up

- [ ] **Pipeline Triggers** — #165
- [ ] **Notes and Discussions** — #111
- [ ] **Release asset links**
