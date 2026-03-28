---
tags: [context, structure, exocortex]
created: 2026-03-28
---

# File Structure

Current state: pre-scaffold (specs only, no source code).

```
exocortex/
├── CLAUDE.md                     # Session intelligence (@imports AGENTS.md)
├── AGENTS.md                     # Project identity, stack, commands, non-negotiables
├── README.md                     # Quick start
├── BRIEFING.md                   # Phase 0 risks, consciousness transfer
├── .env.example                  # API key placeholders (ANTHROPIC, COMPOSIO, BRAVE)
│
├── .claude/
│   ├── settings.json             # Permissions, hooks, env vars
│   ├── rules/
│   │   ├── coding-style.md       # Immutability, Zod 4, naming, TS strict
│   │   └── electron-patterns.md  # IPC, ASAR, CSP, PTY, platform abstraction
│   ├── agents/                   # 10 agents (architect, code-reviewer, etc.)
│   └── skills/                   # 10 skills (design-system, tdd-workflow, etc.)
│
└── docs/
    ├── PRD.md                    # Problem, users, goals, v1 features, risks
    ├── ARCHITECTURE.md           # System design, data flows, ADRs
    ├── ROADMAP.md                # Phase 0-3 breakdown
    └── features/                 # 8 feature specs
        ├── terminal.md           # PTY + xterm.js, WebGL recovery
        ├── editor.md             # CodeMirror 6, wikilinks, YAML bar
        ├── file-tree.md          # SQLite-powered, virtualized, git status
        ├── glass-box.md          # Telemetry, approval queue, events
        ├── command-palette.md    # Cmd+K, fuzzy search, action registry
        ├── auto-deposit.md       # Drag-drop ingest, Claude digest
        ├── orchestrator.md       # Agent SDK, warm process, crash recovery
        └── integrations.md       # MCP, Composio, CLI-Anything
```

## Planned Source Layout (Phase 0)

```
src/
├── main/                         # Electron main process
│   ├── index.ts                  # Window creation, service init
│   ├── services/                 # 8 services (terminal, indexer, git, etc.)
│   └── ipc/                      # 4 handler modules
├── renderer/                     # React UI
│   ├── App.tsx
│   ├── components/               # 7 component directories
│   ├── stores/                   # 3 Zustand stores (vault, session, telemetry)
│   └── styles/globals.css        # Tailwind v4 @theme tokens
├── platform/                     # Abstraction layer (Electron → Tauri)
└── shared/                       # Types + IPC channel constants
```

## Key Entry Points

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Claude Code session context (loads AGENTS.md) |
| `docs/PRD.md` | What and why |
| `docs/ARCHITECTURE.md` | System design |
| `docs/ROADMAP.md` | Phased delivery plan |

## Config Files

| File | Purpose |
|------|---------|
| `.claude/settings.json` | Hooks (SessionStart, PostToolUse, Stop), permissions |
| `.env.example` | API key template |
