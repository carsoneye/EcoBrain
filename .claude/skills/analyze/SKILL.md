---
name: analyze
description: Extract everything from a codebase. Scans tech stack, architecture, patterns, quality, security, and testing. Populates all context, architecture, and analysis files.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls * find *)
---

# Analyze

Point at a codebase and extract everything.

## Setup

1. Read `context/project.md` to get the `PROJECT_PATH`.
2. If path is empty, ask the user for the codebase path and update the field.
3. Confirm: "Analyzing `{path}`. This may take a few minutes."

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

After extraction, print a summary:

```
════════════════════════════════════════════════
 PROJECT ANALYSIS COMPLETE
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

## Rules

- Every claim must reference a specific file path (and line number where possible)
- Never modify the target codebase — read-only analysis
- If the codebase is large (>500 files), focus on the most important directories first
- Skip `node_modules`, `.git`, `dist`, `build`, `vendor`, lock files
- Update `context/project.md` Quick Stats table with extracted metrics
