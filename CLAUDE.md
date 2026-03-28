@context/project.md

## Structure

| Path | Purpose |
|------|---------|
| `context/` | Project identity, tech stack, file structure |
| `architecture/` | System design, components, data flow, API surface |
| `analysis/` | Patterns, code quality, security, testing |
| `decisions/` | Architectural Decision Records |
| `recommendations/` | Prioritized action items |
| `sessions/` | Analysis session logs |
| `resources/` | Templates and scripts |

## Write-Back Targets

- Project metadata → `context/project.md`
- Tech stack changes → `context/tech-stack.md`
- Architecture findings → `architecture/overview.md`
- Pattern observations → `analysis/patterns.md`
- Quality issues → `analysis/quality.md`
- Action items → `recommendations/index.md`
- Decision records → `decisions/index.md`

## Behavior

- Analysis is observation, not opinion — every claim backed by file:line references
- Recommendations include effort estimate and impact rating
- Never modify the target codebase — this is read-only analysis
- Use `[[wikilinks]]` for connections
- No comments in code unless asked
