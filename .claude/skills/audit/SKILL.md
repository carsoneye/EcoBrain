---
name: audit
description: Project health check. Validates analysis freshness, identifies coverage gaps, and catches drift between the codebase and documented analysis.
disable-model-invocation: true
allowed-tools: Read Write Glob Grep Bash(ls * find *)
---

# Audit

Check if the project brain is healthy and up to date.

## Checks

### 1. Analysis Freshness
Compare `context/project.md` "Last Analyzed" date with file modification times in the target codebase. Flag if codebase has changed significantly since last analysis.

### 2. Coverage Gaps
Check which files in `context/`, `architecture/`, `analysis/` are still template stubs (contain empty table rows). Report what hasn't been extracted yet.

### 3. Broken Links
Search all `.md` files for `[[` wikilinks. For each link target, verify the file exists.

### 4. Orphan Notes
Find `.md` files not linked from any other note.

### 5. Stale Recommendations
Check `recommendations/index.md` for items that may have been addressed — compare against current codebase state if possible.

### 6. Missing Frontmatter
Find any `.md` files missing YAML frontmatter with `type`, `date`, `tags`.

### 7. Codebase Drift
Quick scan the target codebase for:
- New files not in `context/structure.md`
- Dependency changes not in `context/tech-stack.md`
- New endpoints not in `architecture/api-surface.md`

## Output

```
════════════════════════════════════════════════
 PROJECT AUDIT — YYYY-MM-DD
════════════════════════════════════════════════

 Analysis Freshness: X days stale
 Coverage Gaps:     X files incomplete
 Broken Links:      X
 Orphan Notes:      X
 Stale Recs:        X potentially done
 Missing Meta:      X
 Codebase Drift:    X changes detected

 RECOMMENDATIONS:
 - [action 1]
 - [action 2]

════════════════════════════════════════════════
```

Keep it actionable. Don't just report problems — suggest fixes.
