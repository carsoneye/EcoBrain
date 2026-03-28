---
name: recommend
description: Generate prioritized recommendations from analysis files. Reads context, architecture, and analysis to produce an actionable plan.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls *)
---

# Recommend

Generate prioritized recommendations from existing analysis.

## Prerequisites

- `context/project.md` must have a path set
- At least Phase 1 (Context) of `analyze` must have been run
- Read all files in `context/`, `architecture/`, `analysis/` before generating

## Workflow

### Step 1: Read Everything

Read all populated files:
- `context/project.md`, `context/tech-stack.md`, `context/structure.md`
- `architecture/overview.md`, `architecture/components.md`, `architecture/data-flow.md`, `architecture/api-surface.md`
- `analysis/patterns.md`, `analysis/quality.md`, `analysis/security.md`, `analysis/testing.md`

### Step 2: Cross-Reference

Connect findings across files:
- Anti-patterns in `analysis/patterns.md` → which components in `architecture/components.md` are affected?
- Tech debt in `analysis/quality.md` → which architecture decisions in `architecture/overview.md` caused it?
- Security findings → which API endpoints in `architecture/api-surface.md` are exposed?
- Test gaps → which data flows in `architecture/data-flow.md` are untested?

### Step 3: Generate Recommendations

For each finding, create a recommendation:

| Field | Description |
|-------|-------------|
| Recommendation | What to do (one line) |
| Category | Architecture / Quality / Security / Testing / Performance / DX |
| Effort | S (< 1hr) / M (1-4hr) / L (4+hr) |
| Impact | Low / Med / High |
| Source | File path(s) that triggered this recommendation |

### Step 4: Prioritize

Sort by impact (High → Low), then effort (S → L) within each impact tier.

### Step 5: Write

1. Read existing `recommendations/index.md` first
2. Preserve completed `[x]` recommendations — they're a record of progress
3. Re-check open `[ ]` recommendations against current analysis:
   - Finding resolved → mark `[x] done YYYY-MM-DD`
   - Still valid → keep, update effort/impact if needed
4. Add new recommendations for new findings
5. Re-sort the full list by impact/effort (completed items go to bottom)
6. For each architectural decision implied, add an ADR to `decisions/index.md`
7. Update `context/project.md` with "Last Analyzed" date

### Step 6: Present Summary

```
════════════════════════════════════════════════
 RECOMMENDATIONS GENERATED
════════════════════════════════════════════════

 Total:      X recommendations
 High Impact: X (S: X  M: X  L: X)
 Med Impact:  X (S: X  M: X  L: X)
 Low Impact:  X (S: X  M: X  L: X)

 Quick Wins (High Impact, Small Effort):
 - [rec 1]
 - [rec 2]

 Big Bets (High Impact, Large Effort):
 - [rec 1]

 ADRs Proposed: X

════════════════════════════════════════════════
```

## Rules

- Never recommend anything not backed by evidence in the analysis files
- Every recommendation traces back to at least one specific finding
- Quick wins (High impact + S effort) always float to the top
- Don't recommend tooling changes unless the current setup is actively harmful
- If analysis files are empty, tell the user to run `analyze` first
