# EcoBrain

Persistent knowledge base. Point it at codebases. It extracts, organizes, and compounds knowledge over time.

## Quick Start

1. Run the `analyze` skill — it asks for project name and path, then extracts everything
2. Run the `recommend` skill — generates prioritized recommendations
3. Review `projects/<name>/decisions/recommendations.md` for the action plan

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
| `.claude/skills/` | AI skills |
| `.claude/rules/` | Path-scoped AI rules |
| `vault.md` | Index: what's here, coverage, last analyzed |

## Workflow

```
codebase → analyze → projects/<name>/[context, analysis]
                      ↓
                   recommend → projects/<name>/decisions/
                      ↓                ↑
                    audit → (re-check, catch drift, check _global/ staleness)
```

## Rules

- Read before answering. Write after acting.
- Never reorganize without approval.
- Every finding backed by file paths and line numbers.
- Recommendations include effort (S/M/L) and impact (Low/Med/High).
- EcoBrain is read-only on target codebases, read-write on itself.
- Built for Claude Code. Not locked to it, but hooks/skills/rules are Claude Code-specific.

## Skills

| Skill | Purpose |
|-------|---------|
| `analyze` | Extract everything from a codebase into `projects/<name>/` |
| `recommend` | Generate prioritized recommendations, cross-reference with `_global/` |
| `audit` | Vault health check (staleness, coverage, drift, verified-as-of expiry) |
| `query` | Ask the brain a question — routes to right files, synthesizes answer with citations |
