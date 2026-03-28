---
name: audit
description: Vault health check. Validates freshness, coverage, staleness, and drift across all projects and global knowledge.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls *) Bash(find *)
---

# Audit

Check if the vault is healthy and up to date.

## Checks

### 1. Analysis Freshness
For each project in `projects/`, compare `Last Analyzed` date with file modification times in the target codebase. Flag if codebase has changed significantly since last analysis.

### 2. Coverage Gaps
Check which files in `projects/*/context/`, `projects/*/analysis/` are still template stubs (contain empty table rows). Report per-project.

### 3. Broken Links
Search all `.md` files for `[[` wikilinks. For each link target, verify the file exists.

### 4. Orphan Notes
Find `.md` files not linked from `vault.md` or any other note.

### 5. Stale Recommendations
Check `projects/*/decisions/recommendations.md` for items that may have been addressed.

### 6. Verified-As-Of Staleness
Check `_global/verified-as-of/*.md` for entries past their `re-verify-after` date. Flag entries older than 90 days.

### 7. Codebase Drift
For each project with a populated analysis, quick scan the target codebase for:
- New files not in `context/structure.md`
- Dependency changes not in `context/tech-stack.md`
- New endpoints not in `context/architecture-api-surface.md`

### 8. Global Knowledge Gaps
Check if any project uses packages that don't have `_global/verified-as-of/` entries.

## Output

```
 VAULT AUDIT — YYYY-MM-DD

 Projects: X tracked

 Per-Project:
   <name>: X days stale, X gaps, X stale recs

 Global:
   Verified-As-Of: X current, X stale (>90 days)
   Failures Library: X entries across X stacks

 Actions:
 - [action 1]
 - [action 2]
```

Keep it actionable. Don't just report problems — suggest fixes.
