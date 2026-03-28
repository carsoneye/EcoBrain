---
tags: [architecture, components, exocortex]
created: 2026-03-28
---

# Components

## Main Process Services

| Service | Responsibility | Key Technology |
|---------|---------------|---------------|
| TerminalService | Spawn/manage PTY, stream I/O | node-pty |
| FSWatcherService | Monitor vault, debounce 300ms, push events | chokidar v4 |
| IndexerService | Build/update SQLite FTS5 index, incremental | better-sqlite3 |
| GitService | Git commands, status, commit, branch | child_process |
| OrchestratorService | Agent SDK runtime (warm process), sub-agents | claude-agent-sdk |
| IngestService | Type detection, extraction, Claude digest | pdf-parse, readability |
| MCPBridgeService | Spawn MCP servers, lifecycle, health | mcpvault, composio |
| BudgetService | Cost tracking, 80% warning, circuit breaker | cost accounting |
| TelemetryBus | Central EventEmitter, batch 16ms → WebSocket | discriminated unions |

## Renderer Components

| Component | Responsibility |
|-----------|---------------|
| Layout | 3-pane grid: file-tree \| editor+glass-box \| terminal |
| FileTree | react-arborist virtualized tree, git status, type badges, fuzzy filter |
| Editor | CodeMirror 6 tabs + split view, wikilinks, YAML frontmatter bar |
| Terminal | xterm.js WebGL, quick-action toolbar, session cost |
| GlassBoxPanel | Telemetry feed (context, activity, approvals), collapsible sidebar |
| CommandPalette | Cmd+K modal, fuzzy search across files/skills/git/settings |
| DropPortal | Window-level drag-and-drop overlay, ingest preview |
| StatusBar | Git branch, modified count, task count, AI state, cost |

## Component Hierarchy

```
App
├── Layout
│   ├── FileTree (react-arborist)
│   ├── EditorPane
│   │   ├── TabBar → EditorTab[]
│   │   └── CodeMirror 6 (per pane)
│   │       ├── WikilinkExtension
│   │       └── YAMLFrontmatterWidget
│   ├── TerminalPane
│   │   ├── xterm.js container
│   │   └── QuickActionBar
│   ├── GlassBoxPanel (collapsible)
│   │   ├── CurrentContext
│   │   ├── ActivityFeed
│   │   └── ApprovalQueue
│   └── StatusBar
├── CommandPalette (modal, Cmd+K)
└── DropPortal (overlay)
```

## Shared Utilities

| Utility | Location | Used By |
|---------|----------|---------|
| Zod validators | IPC handlers | All inbound IPC |
| Design tokens | `globals.css` @theme | All renderer components |
| TelemetryEvent union | `src/shared/types.ts` | All services + Glass Box |
| IPC channel registry | `src/shared/ipc-channels.ts` | All IPC handlers |
| Platform abstraction | `src/platform/*.ts` | All renderer native calls |
