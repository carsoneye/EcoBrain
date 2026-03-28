@vault.md

## Structure

| Path | Purpose |
|------|---------|
| `_global/failures/` | Cross-project stack failure patterns |
| `_global/preferences/` | Dev preferences, non-negotiables |
| `_global/verified-as-of/` | Timestamped package knowledge (90-day re-verify) |
| `projects/<name>/context/` | Project identity, tech stack, architecture |
| `projects/<name>/analysis/` | Patterns, code quality, security, testing |
| `projects/<name>/decisions/` | Decision journal + recommendations |
| `projects/<name>/failures/` | Project-specific failure patterns |
| `resources/` | Templates and scripts |

## Write-Back Targets

When analyzing project `<name>`:
- Project metadata → `projects/<name>/context/project.md`
- Tech stack → `projects/<name>/context/tech-stack.md`
- Architecture → `projects/<name>/context/architecture-overview.md`
- Patterns → `projects/<name>/analysis/patterns.md`
- Quality → `projects/<name>/analysis/quality.md`
- Recommendations → `projects/<name>/decisions/recommendations.md`
- Decision journal → `projects/<name>/decisions/index.md`

Cross-project knowledge:
- Stack failures → `_global/failures/<stack>.md`
- Package status → `_global/verified-as-of/<package>.md`

## Behavior

- Analysis is observation, not opinion — every claim backed by file:line references
- Recommendations include effort estimate and impact rating
- Never modify the target codebase — read-only analysis
- EcoBrain vault is read-write on itself — tools and projects can write failure entries
- Use `[[wikilinks]]` for connections
- Built for Claude Code. Not locked to it, but hooks/skills/rules are Claude Code-specific.
