---
type: documentation
date: 2026-03-27
tags: [documentation, architecture, how-it-works]
---

# EcoBrain — Architecture & How It Works

## What It Is

EcoBrain is a project analysis engine. You point it at a codebase and it extracts everything — tech stack, architecture, patterns, quality, security, testing — then generates prioritized recommendations. It's a knowledge base that grows with the project.

It's not an app. It's a structured markdown vault that AI tools (Claude Code, opencode, Cursor) read and write through skills.

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   USER                           │
│         sets project path, runs skills           │
└──────────────────────┬──────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │      AI TOOL LAYER      │
          │  (Claude Code / opencode)│
          │                         │
          │  reads:  AGENTS.md      │
          │          CLAUDE.md      │
          │          context/*.md   │
          │          .claude/rules/  │
          │          .claude/skills/ │
          └────────────┬────────────┘
                       │
          ┌────────────▼────────────┐
          │      SKILLS LAYER       │
          │                         │
          │  analyze ──► recommend  │
          │       \         /       │
          │        ◄── audit ◄      │
          └────────────┬────────────┘
                       │
        ┌──────────────▼──────────────┐
        │        VAULT LAYER          │
        │                             │
        │  context/   → what it is    │
        │  architecture/ → how built  │
        │  analysis/  → how good      │
        │  decisions/ → what was chosen│
        │  recommendations/ → what to do│
        │  sessions/  → what happened │
        └──────────────┬──────────────┘
                       │
          ┌────────────▼────────────┐
          │     TARGET CODEBASE     │
          │   (read-only, never      │
          │    modified by EcoBrain) │
          └─────────────────────────┘
```

---

## Data Flow

```
  CODEBASE
     │
     ▼
 ┌──────────┐     writes      ┌──────────────┐
 │  analyze  │───────────────►│  context/     │
 │  (skill)  │                │  architecture/│
 └──────────┘                 │  analysis/    │
     │                        └──────────────┘
     │ reads existing                    │
     ▼                                   │
 ┌──────────┐     writes      ┌──────────▼───┐
 │ recommend │───────────────►│ recommendations│
 │  (skill)  │                │  decisions/    │
 └──────────┘                 └───────────────┘
     │                               │
     │ re-checks            checks drift
     ▼                               ▼
 ┌──────────┐     updates    ┌──────────────┐
 │   audit   │──────────────►│  all files    │
 │  (skill)  │               └──────────────┘
 └──────────┘
```

### First Run (Full Mode)

```
1. User sets PROJECT_PATH in context/project.md
2. analyze skill scans the codebase
3. Phase 1: Extracts context (tech stack, file structure)
4. Phase 2: Maps architecture (components, data flow, API surface)
5. Phase 3: Runs analysis (patterns, quality, security, testing)
6. Writes 11 structured files to the vault
7. User runs recommend skill
8. recommend cross-references all findings
9. Generates prioritized action plan with effort/impact ratings
10. Proposes ADRs for architectural decisions
```

### Update Run (Consolidation Mode)

```
1. User runs analyze again (days/weeks later)
2. analyze detects "Last Analyzed" date → switches to Update mode
3. Re-scans codebase, diffs against existing vault
4. New findings → appended to existing files
5. Resolved issues → marked [resolved YYYY-MM-DD]
6. Adds "Changes Since YYYY-MM-DD" changelog at top
7. recommend re-checks open items, marks done ones [x]
8. New findings → new recommendations added
9. Nothing deleted — brain accumulates knowledge
```

---

## File Map

### Context Layer — "What it is"

| File | Purpose | Who writes |
|------|---------|-----------|
| `context/project.md` | Project identity, path, quick stats | User + analyze |
| `context/tech-stack.md` | Languages, frameworks, deps, versions | analyze |
| `context/structure.md` | Directory tree with purpose annotations | analyze |

### Architecture Layer — "How it's built"

| File | Purpose | Who writes |
|------|---------|-----------|
| `architecture/overview.md` | Pattern, data flow diagram, integrations | analyze |
| `architecture/components.md` | Module map, hierarchy, shared utils | analyze |
| `architecture/data-flow.md` | Request lifecycle, data stores, state | analyze |
| `architecture/api-surface.md` | REST endpoints, GraphQL, public exports | analyze |

### Analysis Layer — "How good it is"

| File | Purpose | Who writes |
|------|---------|-----------|
| `analysis/patterns.md` | Design patterns, anti-patterns, conventions | analyze |
| `analysis/quality.md` | Hot spots, tech debt, dead code, complexity | analyze |
| `analysis/security.md` | Auth, secrets, CVEs, input validation | analyze |
| `analysis/testing.md` | Coverage, strategy, gaps, test quality | analyze |

### Action Layer — "What to do"

| File | Purpose | Who writes |
|------|---------|-----------|
| `recommendations/index.md` | Prioritized action plan with effort/impact | recommend |
| `decisions/index.md` | Architectural Decision Records | recommend |

### Operational Layer

| File | Purpose | Who writes |
|------|---------|-----------|
| `sessions/` | Analysis session logs | AI tool (manual) |
| `resources/templates/` | Note templates for each file type | static |
| `resources/scripts/` | session_start.sh, extract-stats.sh, verify_orphans.sh | static |

---

## Skills Deep Dive

### analyze

The extraction engine. Three phases, 11 output files.

```
INPUT:  PROJECT_PATH from context/project.md
PHASE 1: Context     → 3 files  (tech stack, structure, project stats)
PHASE 2: Architecture → 4 files (overview, components, data flow, API)
PHASE 3: Analysis    → 4 files  (patterns, quality, security, testing)
OUTPUT: summary printed to console
```

**Full mode** (no previous analysis): Writes everything from scratch.

**Update mode** (existing analysis found):
- Replaces: tech stack tables, file structure, quality metrics, API surface
- Merges: patterns, anti-patterns, tech debt, security findings, test gaps
- Appends: new findings, resolved markers, changelog header

Pre-scan available: `bash resources/scripts/extract-stats.sh $PROJECT_PATH` gives a quick overview before deep analysis.

### recommend

The action generator. Reads everything analyze produced, cross-references findings, outputs a plan.

```
INPUT:  All files in context/, architecture/, analysis/
PROCESS: Cross-reference findings across files
         Connect anti-patterns → affected components
         Connect tech debt → architecture decisions that caused it
         Connect security findings → exposed endpoints
         Connect test gaps → untested data flows
OUTPUT: recommendations/index.md (sorted by impact/effort)
        decisions/index.md (ADRs for implied decisions)
```

**Quick wins** (High impact + S effort) float to top.
Every recommendation traces back to at least one finding.

### audit

The health check. Verifies the brain is fresh and complete.

```
CHECKS:
  1. Analysis freshness — is codebase newer than last analysis?
  2. Coverage gaps — which files are still template stubs?
  3. Broken wikilinks — do all [[links]] resolve?
  4. Orphan notes — any disconnected files?
  5. Stale recommendations — items that might be done?
  6. Missing frontmatter — any files without YAML?
  7. Codebase drift — new files/deps not in context?
```

---

## Hooks

Hooks run automatically in Claude Code. They inject context so every session starts informed.

| Hook | When | What it does |
|------|------|-------------|
| `SessionStart` | New session opens | Runs `session_start.sh` — prints project path, last analyzed date, recommendation count, analysis status per file |
| `PostCompact` | Context window compressed | Same as SessionStart — re-injects context that was lost |
| `Stop` | Session ends | Shows git status of uncommitted vault changes |

### session_start.sh output

```
=== EcoBrain ===

Project: ~/Desktop/MyApp
Last Analyzed: 2026-03-27

--- Recommendations ---
  12 recommendation rows

--- Analysis Status ---
  analysis/patterns: populated (18 rows)
  analysis/quality: populated (24 rows)
  analysis/security: populated (15 rows)
  analysis/testing: needs extraction
  architecture/api-surface: populated (32 rows)
  architecture/components: populated (14 rows)
  ...

=== Ready ===
```

---

## Rules

Path-scoped rules that apply automatically when AI tools read/write matching files.

| Rule | Path | Key Constraints |
|------|------|----------------|
| `context.md` | `context/**/*.md` | Source of truth, append-only, every claim needs file path |
| `architecture.md` | `architecture/**/*.md` | Describe what IS, not what should be. Changes go to recommendations |
| `analysis.md` | `analysis/**/*.md` | Every finding needs file:line. Evidence only, no opinions |
| `recommendations.md` | `recommendations/**/*.md` | Every rec traces to a finding. Effort + impact required |
| `decisions.md` | `decisions/**/*.md` | ADR format. Numbered. Never deleted, only superseded |
| `sessions.md` | `sessions/**/*.md` | Date-stamped. Quick ref above separator, raw log below |
| `resources.md` | `resources/**/*.md` | Templates use `{{placeholders}}`. One per type |

---

## Configuration Files

| File | Tool | Purpose |
|------|------|---------|
| `AGENTS.md` | All AI tools | Project overview, structure, rules, skill list |
| `CLAUDE.md` | Claude Code | Behavior rules, write-back targets. Includes `@context/project.md` |
| `opencode.json` | opencode | Instruction files, MCP vault server config |
| `.claude/settings.json` | Claude Code | Permissions, hooks, allowed/denied commands |
| `.claude/rules/*.md` | Claude Code | Path-scoped rules that activate per-file |
| `.claude/skills/*/SKILL.md` | Claude Code | Skill definitions with allowed-tools |

---

## Typical Usage

```
# 1. First time — point at a project
Edit context/project.md → set Path

# 2. Run full analysis
/analyze

# 3. Get recommendations
/recommend

# 4. Weeks later, project has grown
/analyze          # update mode — consolidates, preserves history

# 5. Check brain health
/audit            # flags stale analysis, drift, gaps

# 6. Periodic refresh
/analyze          # repeat — brain gets smarter each time
/recommend        # updated plan reflecting new state
```

---

## Design Principles

1. **Read-only on the target** — EcoBrain never modifies the codebase it's analyzing
2. **Accumulate, don't replace** — update mode preserves history, marks resolved items
3. **Evidence over opinion** — every finding references file paths and line numbers
4. **Actionable output** — recommendations have effort estimates and impact ratings
5. **Tool-agnostic** — works with any AI that reads markdown (Claude Code, opencode, Cursor)
6. **Zero config** — set one path, run analyze. That's it
