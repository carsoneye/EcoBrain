---
name: analyze
description: Extract everything from a codebase into a project namespace. Full extraction on first run, incremental consolidation on updates.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls *) Bash(find *) Bash(wc *) Bash(head *) Bash(cat *)
---

# Analyze

Point at a codebase and extract everything into `projects/<name>/`. Consolidates on repeat runs.

## Modes

| Mode | When | Behavior |
|------|------|----------|
| **Full** | Empty or template-stub files | Complete extraction, writes everything |
| **Update** | Previously populated files | Diff against existing analysis, merge new findings, preserve history |

## Setup

1. Read `vault.md` to see existing projects.
2. Ask which project to analyze (or detect from `projects/*/context/project.md`).
3. Read `projects/<name>/context/project.md` to get the `PROJECT_PATH`.
4. If path is empty or project doesn't exist, ask the user for:
   - Project name (used as directory name under `projects/`)
   - Codebase path
   - Create `projects/<name>/` with subdirectories: `context/`, `analysis/`, `decisions/`, `failures/`
5. Check mode:
   - If `Last Analyzed` is empty → **Full** mode
   - If `Last Analyzed` has a date → **Update** mode
6. **Optional pre-scan** — run `bash resources/scripts/extract-stats.sh $PROJECT_PATH`
7. Confirm: "`{Full|Update}` analysis of `{name}` at `{path}`."

## Output Paths

All output goes under `projects/<name>/`:

| Phase | File | Content |
|-------|------|---------|
| Context | `context/project.md` | Project identity, path, stats |
| Context | `context/tech-stack.md` | Languages, frameworks, deps |
| Context | `context/structure.md` | Directory tree with annotations |
| Architecture | `context/architecture-overview.md` | Pattern, data flow, integrations |
| Architecture | `context/architecture-components.md` | Module map, hierarchy |
| Architecture | `context/architecture-data-flow.md` | Request lifecycle, state |
| Architecture | `context/architecture-api-surface.md` | Endpoints, exports, webhooks |
| Analysis | `analysis/patterns.md` | Design patterns, anti-patterns |
| Analysis | `analysis/quality.md` | Hot spots, tech debt, complexity |
| Analysis | `analysis/security.md` | Auth, secrets, CVEs, validation |
| Analysis | `analysis/testing.md` | Coverage, strategy, gaps |

## Cross-Project Knowledge

During analysis, if you discover stack-level failures or package-specific knowledge:
- Append to `_global/failures/<stack>.md` (e.g., `electron-stack.md`)
- Create or update `_global/verified-as-of/<package>.md` with current status

These are shared across all projects.

## Update Mode: Consolidation Rules

When updating, the existing analysis IS the starting point. Don't wipe it.

### What gets replaced (current state)
- Tech stack tables — updated with current versions, new deps added, removed deps marked `removed`
- File structure tree — regenerated to match current codebase
- Code quality metrics — recalculated with current numbers
- API surface — rescanned, new endpoints added, removed ones flagged

### What gets merged (accumulates)
- Patterns — new patterns appended, existing ones kept. If no longer applies, mark `[resolved]`
- Anti-patterns — new findings appended. Previously flagged ones re-checked
- Tech debt — new items appended. Fixed items marked `[resolved YYYY-MM-DD]`
- Security findings — new vulns added. Fixed ones marked `[resolved YYYY-MM-DD]`
- Test gaps — re-assessed. Closed gaps marked `[resolved]`

### What gets added
- New section at top of updated files: `## Changes Since YYYY-MM-DD`
- Lists only what's new, changed, or resolved

### Session log
After each analysis run, write a session entry to `projects/<name>/analysis/sessions/`:
- Filename: `YYYY-MM-DD.md`
- Fields: commits since last analysis, files changed, metric deltas, notable (freeform)

## Extraction Pipeline

### Phase 1: Context

**Tech Stack** → `context/tech-stack.md`
- Identify languages from file extensions and their proportion
- Extract framework from package.json, Cargo.toml, pyproject.toml, go.mod, etc.
- Parse dependencies with versions and licenses
- Identify dev dependencies separately
- Detect tooling: linters, formatters, bundlers, CI
- Detect infrastructure: hosting, databases, caches, queues

**File Structure** → `context/structure.md`
- Generate directory tree (3 levels deep)
- Annotate each directory with its inferred purpose
- Identify entry points (main files, config roots)
- List all config files and their purposes

### Phase 2: Architecture

**Overview** → `context/architecture-overview.md`
- Determine architectural pattern (monolith, microservices, SPA+API, etc.)
- Draw a simple ASCII data flow diagram
- Identify external integrations (APIs, services, databases)
- Detect environments (local, staging, production)

**Components** → `context/architecture-components.md`
- Map all major modules/packages and their responsibilities
- Identify shared utilities and their consumers
- Map component hierarchy
- Identify cross-module dependencies

**Data Flow** → `context/architecture-data-flow.md`
- Trace request lifecycle from entry to response
- Identify all data stores (databases, caches, state)
- Map state management approach and scope
- Identify external data sources

**API Surface** → `context/architecture-api-surface.md`
- Extract all REST endpoints with method, path, purpose
- Extract GraphQL types/queries/mutations if applicable
- Map public exports from libraries/packages
- Identify webhooks

### Phase 3: Analysis

**Patterns** → `analysis/patterns.md`
- Identify design patterns in use
- Find anti-patterns (god objects, circular deps, leaky abstractions)
- Document coding conventions observed
- Note style enforcement (linters, formatters, pre-commit hooks)

**Code Quality** → `analysis/quality.md`
- Count files, calculate average/max file sizes
- Identify hot spots (large files, high complexity)
- Find code duplication patterns
- Detect dead code (unused exports, unreachable paths)
- Catalog tech debt items
- Check type coverage if applicable

**Security** → `analysis/security.md`
- Identify auth/authz mechanisms
- Find hardcoded secrets, credentials, API keys
- Check .env handling and gitignore coverage
- Audit dependency versions for known vulnerabilities
- Identify sensitive data flows
- Check input validation and sanitization

**Testing** → `analysis/testing.md`
- Identify test framework and runner
- Map test strategy (unit, integration, e2e)
- Estimate coverage per layer
- Check CI test execution
- Identify test gaps
- Assess test quality

## Rules

- Every claim must reference a specific file path (and line number where possible)
- Never modify the target codebase — read-only analysis
- If the codebase is large (>500 files), focus on the most important directories first
- Skip node_modules, .git, dist, build, vendor, lock files
- Update `projects/<name>/context/project.md` with `Last Analyzed` date
- In update mode, never delete resolved items — mark them so history is preserved
- Update `vault.md` coverage table after each run
