---
type: documentation
date: 2026-03-28
tags: [documentation, architecture, how-it-works]
---

# EcoBrain — Architecture & How It Works

## What It Is

EcoBrain is a persistent knowledge base. You point it at codebases and it extracts structured analysis that compounds over time. Cross-project knowledge (failure patterns, package gotchas) persists and transfers between projects.

It's not an app. It's a structured markdown vault that Claude Code reads and writes through skills.

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
          │      (Claude Code)      │
          │                         │
          │  reads:  AGENTS.md      │
          │          CLAUDE.md      │
          │          vault.md       │
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
        │  _global/                   │
        │    failures/  → stack traps │
        │    verified/  → pkg status  │
        │                             │
        │  projects/<name>/           │
        │    context/   → what it is  │
        │    analysis/  → how good    │
        │    decisions/ → what chosen │
        │    failures/  → proj traps  │
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
 ┌──────────┐     writes      ┌────────────────────┐
 │  analyze  │───────────────►│  projects/<name>/   │
 │  (skill)  │                │    context/         │
 └──────────┘                 │    analysis/        │
     │                        └────────────────────┘
     │ also writes                         │
     ▼                                     │
 ┌──────────────┐                          │
 │  _global/     │                          │
 │  failures/    │◄── stack failures found  │
 │  verified/    │◄── pkg versions checked  │
 └──────────────┘                          │
                                           │
 ┌──────────┐     writes      ┌────────────▼───────┐
 │ recommend │───────────────►│  projects/<name>/   │
 │  (skill)  │   reads both   │    decisions/       │
 └──────────┘   project +     └────────────────────┘
     │          _global/               │
     │                        checks drift
     ▼                                 ▼
 ┌──────────┐     updates    ┌────────────────────┐
 │   audit   │──────────────►│  all files          │
 │  (skill)  │               │  + staleness check  │
 └──────────┘               └────────────────────┘
```

### First Run (Full Mode)

```
1. User runs /analyze
2. Skill asks for project name and codebase path
3. Creates projects/<name>/ with subdirectories
4. Phase 1: Extracts context (tech stack, file structure)
5. Phase 2: Maps architecture (components, data flow, API surface)
6. Phase 3: Runs analysis (patterns, quality, security, testing)
7. Writes structured files to projects/<name>/
8. Discovers stack failures → appends to _global/failures/
9. User runs /recommend to generate action plan
```

### Update Run (Consolidation Mode)

```
1. User runs /analyze again (days/weeks later)
2. Detects existing "Last Analyzed" date → Update mode
3. Re-scans codebase, diffs against existing vault
4. New findings appended, resolved items marked [resolved YYYY-MM-DD]
5. "Changes Since YYYY-MM-DD" changelog at top of updated files
6. Session log written to projects/<name>/analysis/sessions/
7. Nothing deleted — brain accumulates knowledge
```

---

## File Map

### Global Layer — Cross-project knowledge

| File | Purpose | Who writes |
|------|---------|-----------|
| `_global/failures/<stack>.md` | Stack failure patterns | analyze, manual |
| `_global/verified-as-of/<pkg>.md` | Timestamped package status | analyze, manual |
| `_global/preferences/` | Dev preferences | manual |
| `vault.md` | Index: projects, coverage, status | analyze, audit |

### Project Layer — `projects/<name>/`

| File | Purpose | Who writes |
|------|---------|-----------|
| `context/project.md` | Project identity, path, stats | User + analyze |
| `context/tech-stack.md` | Languages, frameworks, deps | analyze |
| `context/structure.md` | Directory tree with annotations | analyze |
| `context/architecture-overview.md` | Pattern, data flow, integrations | analyze |
| `context/architecture-components.md` | Module map, hierarchy | analyze |
| `context/architecture-data-flow.md` | Request lifecycle, state | analyze |
| `context/architecture-api-surface.md` | Endpoints, exports, webhooks | analyze |
| `analysis/patterns.md` | Design patterns, anti-patterns | analyze |
| `analysis/quality.md` | Hot spots, tech debt, complexity | analyze |
| `analysis/security.md` | Auth, secrets, CVEs, validation | analyze |
| `analysis/testing.md` | Coverage, strategy, gaps | analyze |
| `analysis/sessions/YYYY-MM-DD.md` | Session logs (4 fields) | analyze |
| `decisions/index.md` | Decision journal | recommend, manual |
| `decisions/recommendations.md` | Prioritized action plan | recommend |
| `failures/` | Project-specific failure patterns | manual |

---

## Skills

### analyze

The extraction engine. Three phases, project-namespaced output.

```
INPUT:  Project name + codebase path
PHASE 1: Context      → 3 files  (tech stack, structure, project stats)
PHASE 2: Architecture → 4 files  (overview, components, data flow, API)
PHASE 3: Analysis     → 4 files  (patterns, quality, security, testing)
SIDE:    _global/     → failures and verified-as-of entries
OUTPUT:  summary + session log
```

### recommend

Reads project analysis + `_global/` knowledge, generates prioritized plan.

### query

Ask the brain a question. Classifies intent (failure, architecture, package safety, etc.), routes to the right files, checks staleness, synthesizes an answer with citations and confidence level.

### audit

Health check: freshness, coverage gaps, broken links, stale verified-as-of entries, codebase drift.

---

## Hooks

| Hook | When | What it does |
|------|------|-------------|
| `SessionStart` | New session | Runs `session_start.sh` — prints all projects, analysis status, stale entries |
| `PostCompact` | Context compressed | Same — re-injects context |
| `Stop` | Session ends | Shows git status of uncommitted vault changes |

---

## Design Principles

1. **Read-only on targets** — EcoBrain never modifies analyzed codebases
2. **Read-write on itself** — Tools and projects can write failure entries to the vault
3. **Accumulate, don't replace** — update mode preserves history, marks resolved items
4. **Evidence over opinion** — every finding references file paths and line numbers
5. **Knowledge depreciates** — package entries have re-verify dates, staleness is flagged
6. **Built for Claude Code** — not locked to it, but hooks/skills/rules are Claude Code-specific
