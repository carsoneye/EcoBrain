---
tags: [architecture, data-flow, exocortex]
created: 2026-03-28
---

# Data Flow

## Primary Loop (Intent → Result)

```
User types intent in terminal
  → PTY output → IPC → xterm renders
  → Claude Code executes (hooks/skills active)
  → AI reads vault via MCP or FS
  → AI writes result to vault
  → chokidar detects change (300ms debounce)
  → IndexerService updates SQLite FTS5
  → TelemetryBus.emit('file_write', ...)
  → WebSocket broadcast (16ms batch, auth checked)
  → Zustand store updates → React re-renders
  → Glass Box shows activity

Target: <500ms from AI write to visible UI update
```

## Auto-Deposit Flow

```
User drags file over window
  → DropPortal overlay fades in
  → Drop → IngestService.detectType()
  → ContentExtractor (pdf-parse / readability / etc.)
  → ContextAssembler (active intent + project + open file)
  → ClaudeDigestor (Haiku 4.5: title, summary, tags, path, wikilinks)
  → Preview card in Glass Box [Accept] [Edit] [Reject]
  → On Accept: VaultWriter → markdown file + backlinks + git commit
  → Fallback (offline): queue to .exocortex/ingest-queue/
```

## Data Stores

| Store | Location | Purpose |
|-------|----------|---------|
| Vault files | `~/vault/` | Canonical source (markdown + YAML frontmatter) |
| SQLite index | `~/.exocortex/index.db` | FTS5 search, file metadata, wikilink graph |
| State machine | `~/.exocortex/state.json` | Crash recovery, active session, pending approvals |
| Cost log | `~/.exocortex/cost-log.jsonl` | Per-request cost tracking |
| Telemetry log | `~/.exocortex/telemetry.jsonl` | Session replay (Phase 3) |
| Ingest queue | `~/.exocortex/ingest-queue/` | Offline ingest buffer |
| Git history | `.git/` in vault | Versioning backbone |

## State Management (Zustand)

| Store | Scope | Persistence | Subscribers |
|-------|-------|-------------|-------------|
| `vaultStore` | File tree, index cache | WebSocket events (startup + live) | FileTree, Editor, CommandPalette |
| `sessionStore` | Active project, budget, cost | `state.json` (write-ahead) | StatusBar, GlassBox, Terminal |
| `telemetryStore` | Ring buffer (500 events) + approvals | In-memory only | GlassBox |

## External Data Sources

| Source | Type | Purpose |
|--------|------|---------|
| Claude Code CLI | PTY stream | User-facing AI interaction |
| Claude Agent SDK | API | System automation (Auto-Deposit, GSD waves) |
| MCPVault | MCP protocol | Vault CRUD for agents |
| Composio (Phase 2) | MCP protocol | External service connectors |
