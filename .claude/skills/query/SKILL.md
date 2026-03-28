---
name: query
description: Ask EcoBrain a question. Routes to the right vault files based on intent, synthesizes an answer with citations.
disable-model-invocation: true
allowed-tools: Read Glob Grep Bash(ls *)
---

# Query

Ask the brain a question. Get an answer with citations from vault files.

## How It Works

1. Read the question
2. Classify intent (see routing table)
3. Pull the right files — use `read_multiple_notes` via MCP when available, otherwise sequential reads
4. Check staleness on any `_global/verified-as-of/` entries referenced
5. Synthesize answer with file:line citations
6. Flag confidence: HIGH (direct match in vault), MEDIUM (inferred from multiple sources), LOW (partial match, may need fresh analysis)

## Intent Routing

| If the question is about... | Pull these files |
|----------------------------|-----------------|
| **Why something broke / failure modes** | `_global/failures/*.md` → `projects/*/analysis/patterns.md` → `projects/*/analysis/sessions/*.md` (reverse chronological) |
| **Architecture / how something is built** | `projects/*/context/architecture-*.md` → `projects/*/context/structure.md` → `projects/*/decisions/index.md` |
| **Is a package/tool safe to use** | `_global/verified-as-of/<pkg>.md` (check re-verify date first) → `_global/failures/*.md` (grep for package name) → `projects/*/context/tech-stack.md` |
| **What changed recently** | `projects/*/analysis/sessions/*.md` (most recent first) |
| **Security concerns** | `projects/*/analysis/security.md` → `_global/failures/*.md` (grep for security/cve/vuln) |
| **Code quality / tech debt** | `projects/*/analysis/quality.md` → `projects/*/decisions/recommendations.md` |
| **What should I work on next** | `projects/*/decisions/recommendations.md` (quick wins first) → `projects/*/analysis/quality.md` |
| **Testing gaps** | `projects/*/analysis/testing.md` → `projects/*/analysis/quality.md` (hot spots) |
| **Cross-project patterns** | `_global/failures/*.md` → `_global/preferences/*.md` → multiple `projects/*/analysis/patterns.md` |
| **Decision history / why was X chosen** | `projects/*/decisions/index.md` → `projects/*/analysis/sessions/*.md` |

If the question doesn't clearly match a category, scan `vault.md` for coverage, then use `list_all_tags` (if MCP available) to find relevant tags, then grep across the vault for keywords.

## Staleness Check

Before surfacing any `_global/verified-as-of/` entry:

1. Read the `re-verify-after` frontmatter field
2. If today's date is past that date, prepend warning:
   `> This entry was verified on {date} and is overdue for re-verification.`
3. Still include the information — stale knowledge is better than no knowledge, as long as it's flagged

## Scoping

- If the question names a specific project, scope to `projects/<name>/`
- If the question is generic ("what do I know about SQLite"), search `_global/` first, then all projects
- If no project exists yet, say so and suggest running `/analyze`

## Answer Format

```
## Answer

{Direct answer to the question, 2-5 sentences}

### Sources

- `_global/failures/electron-stack.md` — node-pty spawn-helper permission issue
- `projects/exocortex/analysis/security.md:42` — CSP unsafe-eval requirement

### Confidence: {HIGH|MEDIUM|LOW}

{If LOW or MEDIUM: what would raise confidence — e.g., "Run /analyze to get fresh data"}
```

## Rules

- Never fabricate information not in the vault — if the vault doesn't know, say so
- Always cite the specific file (and line if possible) that backs each claim
- Check staleness before surfacing package-specific advice
- If multiple projects have relevant information, synthesize across them
- Prefer `_global/` entries over project-specific ones for stack-level questions
- If the vault is empty or mostly stubs, say "vault needs populating — run /analyze on your project first"
