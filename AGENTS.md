# EcoBrain

Point it at a codebase. It extracts, organizes, and recommends.

## Quick Start

1. Set `PROJECT_PATH` in `context/project.md` to your codebase path
2. Run the `analyze` skill — extracts tech stack, architecture, patterns, quality
3. Run the `recommend` skill — generates prioritized recommendations
4. Review `recommendations/index.md` for the action plan

## Structure

| Path | Purpose |
|------|---------|
| `context/` | Project identity, tech stack, file structure |
| `architecture/` | System design, components, data flow, API surface |
| `analysis/` | Patterns, code quality, security, testing |
| `decisions/` | Architectural Decision Records (ADRs) |
| `recommendations/` | Prioritized action items with effort/impact |
| `sessions/` | Analysis session logs |
| `resources/` | Templates and scripts |
| `.claude/skills/` | AI skills |
| `.claude/rules/` | Path-scoped AI rules |

## Workflow

```
codebase → analyze → [context, architecture, analysis]
                      ↓
                   recommend → [recommendations, decisions]
                      ↓
                    audit → (re-check, catch drift)
```

## Rules

- Read before answering. Write after acting.
- Never reorganize without approval.
- Use `[[wikilinks]]` for cross-references.
- Every note gets YAML frontmatter (`type`, `date`, `tags`).
- Analysis is observation, not opinion — back claims with file paths and line numbers.
- Recommendations include effort (S/M/L) and impact (Low/Med/High).

## Skills

| Skill | Purpose |
|-------|---------|
| `analyze` | Extract everything from a codebase |
| `recommend` | Generate prioritized recommendations from analysis |
| `audit` | Project health check (stale analysis, missing coverage) |
