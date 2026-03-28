---
title: EcoBrain Vault Index
tags: [index, meta]
---

# EcoBrain

Persistent knowledge base. Structured analysis, failure knowledge, and decision journals across projects.

## Coverage

| Project | Last Analyzed | Status |
|---------|--------------|--------|
| exocortex | — | not yet analyzed |

## Global Knowledge

| Area | Files | Status |
|------|-------|--------|
| failures/ | [electron-stack.md](_global/failures/electron-stack.md) | 9 entries (migrated from Exocortex CLAUDE.md rules) |
| preferences/ | — | empty |
| verified-as-of/ | [better-sqlite3](_global/verified-as-of/better-sqlite3.md), [chokidar](_global/verified-as-of/chokidar.md), [mcpvault](_global/verified-as-of/mcpvault.md), [xterm](_global/verified-as-of/xterm.md) | 4 entries, all verified 2026-03-28 |

## Structure

```
_global/              Cross-project knowledge
  failures/           Stack failures (electron, zod, etc.)
  preferences/        Dev preferences, non-negotiables
  verified-as-of/     Timestamped package knowledge (90-day re-verify)

projects/<name>/      Per-project analysis
  context/            Architecture, tech stack, project identity
  analysis/           Quality, security, patterns, testing
  decisions/          Decision journal (time-indexed, not ADRs)
  failures/           Project-specific failures
```
