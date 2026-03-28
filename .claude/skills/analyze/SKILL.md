---
name: analyze
description: Extract everything from a codebase. Full extraction on first run, incremental consolidation on updates. Scans tech stack, architecture, patterns, quality, security, and testing.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls *) Bash(find *) Bash(wc *) Bash(head *) Bash(cat *)
---

# Analyze

Point at a codebase and extract everything. Consolidates on repeat runs — doesn't wipe previous analysis.

## Modes

| Mode | When | Behavior |
|------|------|----------|
| **Full** | Empty or template-stub files | Complete extraction, writes everything |
| **Update** | Previously populated files | Diff against existing analysis, merge new findings, preserve history |

## Setup

1. Read `context/project.md` to get the `PROJECT_PATH`.
2. If path is empty, ask the user for the codebase path and update the field.
3. Check mode:
   - If `Last Analyzed` is empty → **Full** mode
   - If `Last Analyzed` has a date → **Update** mode
4. **Optional pre-scan** — run `bash resources/scripts/extract-stats.sh $PROJECT_PATH` to get a quick codebase overview before deep analysis
5. Confirm: "`{Full|Update}` analysis of `{path}`. This may take a few minutes."

## Update Mode: Consolidation Rules

When updating, the existing analysis IS the starting point. Don't wipe it.

### What gets replaced (current state)
- Tech stack tables — updated with current versions, new deps added, removed deps marked `⚠️ removed`
- File structure tree — regenerated to match current codebase
- Code quality metrics — recalculated with current numbers
- API surface — rescanned, new endpoints added, removed ones flagged

### What gets merged (accumulates)
- Patterns — new patterns appended, existing ones kept. If a pattern no longer applies, mark `[resolved]`
- Anti-patterns — new findings appended. Previously flagged ones re-checked:
  - Still there → keep, increment observation count
  - Fixed → mark `[resolved YYYY-MM-DD]`
- Tech debt — new items appended. Existing items re-checked:
  - Still present → update file:line if moved, keep priority
  - Fixed → mark `[resolved YYYY-MM-DD]`
- Security findings — new vulns added. Old ones:
  - Still present → keep, note "still unresolved"
  - Fixed → mark `[resolved YYYY-MM-DD]`
- Test gaps — re-assessed. Closed gaps marked `[resolved]`
- ADRs — never modified. New ones appended.

### What gets added
- New section at top of updated files: `## Changes Since YYYY-MM-DD`
- Lists only what's new, changed, or resolved
- Acts as a changelog so you can see growth at a glance

### Recommendations handling
After updating analysis, read `recommendations/index.md`:
- Recommendations backed by `[resolved]` findings → mark `[x] done`
- New findings that warrant action → add to the table with source links
- Re-sort by impact/effort

## Extraction Pipeline

### Phase 1: Context

**Tech Stack** → `context/tech-stack.md`
- Identify languages from file extensions and their proportion
- Extract framework from `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, etc.
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

**Overview** → `architecture/overview.md`
- Determine architectural pattern (monolith, microservices, SPA+API, etc.)
- Draw a simple ASCII data flow diagram
- Identify external integrations (APIs, services, databases)
- Detect environments (local, staging, production)

**Components** → `architecture/components.md`
- Map all major modules/packages and their responsibilities
- Identify shared utilities and their consumers
- Map component hierarchy
- Identify cross-module dependencies

**Data Flow** → `architecture/data-flow.md`
- Trace request lifecycle from entry to response
- Identify all data stores (databases, caches, state)
- Map state management approach and scope
- Identify external data sources

**API Surface** → `architecture/api-surface.md`
- Extract all REST endpoints with method, path, purpose
- Extract GraphQL types/queries/mutations if applicable
- Map public exports from libraries/packages
- Identify webhooks

### Phase 3: Analysis

**Patterns** → `analysis/patterns.md`
- Identify design patterns in use (factory, observer, middleware, etc.)
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
- Identify test gaps (untested modules, missing edge cases)
- Assess test quality (meaningful assertions, consistent mocking)

## Output

### Full Mode
```
════════════════════════════════════════════════
 FULL ANALYSIS COMPLETE
════════════════════════════════════════════════

 Context:       X files written
 Architecture:  X files written
 Analysis:      X files written

 Key Findings:
 - [finding 1]
 - [finding 2]
 - [finding 3]

 Next: Run the `recommend` skill to generate
 an action plan from this analysis.

════════════════════════════════════════════════
```

### Update Mode
```
════════════════════════════════════════════════
 UPDATE COMPLETE — since YYYY-MM-DD
════════════════════════════════════════════════

 New Findings:      X
 Resolved:          X
 Still Present:     X
 Recommendations:   X updated, X new

 Changed:
 + [new finding 1]
 + [new finding 2]

 Resolved:
 ✓ [fixed item 1]
 ✓ [fixed item 2]

 Still Open:
 • [unresolved item]

════════════════════════════════════════════════
```

## Rules

- Every claim must reference a specific file path (and line number where possible)
- Never modify the target codebase — read-only analysis
- If the codebase is large (>500 files), focus on the most important directories first
- Skip `node_modules`, `.git`, `dist`, `build`, `vendor`, lock files
- Update `context/project.md` Quick Stats with extracted metrics and `Last Analyzed` date
- In update mode, never delete resolved items — mark them so history is preserved
- Accumulate, don't replace — the brain gets smarter over time
