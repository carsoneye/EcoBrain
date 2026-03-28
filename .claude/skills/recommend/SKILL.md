---
name: recommend
description: Generate prioritized recommendations from analysis files for a specific project. Cross-references with _global/ knowledge.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls *)
---

# Recommend

Generate prioritized recommendations from existing analysis of a project.

## Prerequisites

- `projects/<name>/context/project.md` must have a path set
- At least Phase 1 (Context) of `analyze` must have been run
- Read all files in `projects/<name>/` before generating

## Workflow

### Step 1: Read Everything

Read all populated files for the target project:
- `projects/<name>/context/*.md`
- `projects/<name>/analysis/*.md`

Also read cross-project knowledge:
- `_global/failures/*.md` — known stack failure patterns
- `_global/verified-as-of/*.md` — check for stale package knowledge

### Step 2: Cross-Reference

Connect findings across files:
- Anti-patterns in `analysis/patterns.md` → which components are affected?
- Tech debt in `analysis/quality.md` → which architecture decisions caused it?
- Security findings → which API endpoints are exposed?
- Test gaps → which data flows are untested?
- Stack failures in `_global/failures/` → does this project use affected packages?
- Verified-as-of entries → are any packages past their re-verify date?

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

Sort by impact (High to Low), then effort (S to L) within each impact tier.

### Step 5: Write

1. Read existing `projects/<name>/decisions/recommendations.md`
2. Preserve completed `[x]` recommendations
3. Re-check open `[ ]` items against current analysis
4. Add new recommendations for new findings
5. Re-sort by impact/effort (completed items go to bottom)
6. For architectural decisions, add entries to `projects/<name>/decisions/index.md`
7. Update `vault.md` coverage table

### Step 6: Present Summary

```
 RECOMMENDATIONS — <name>

 Total:      X recommendations
 High Impact: X (S: X  M: X  L: X)
 Med Impact:  X (S: X  M: X  L: X)
 Low Impact:  X (S: X  M: X  L: X)

 Quick Wins (High Impact, Small Effort):
 - [rec 1]
 - [rec 2]

 Stale Package Knowledge:
 - [package past re-verify date]
```

## Rules

- Never recommend anything not backed by evidence in the analysis files
- Every recommendation traces back to at least one specific finding
- Quick wins (High impact + S effort) always float to the top
- Don't recommend tooling changes unless the current setup is actively harmful
- If analysis files are empty, tell the user to run `analyze` first
- Check `_global/verified-as-of/` for stale entries and flag them
