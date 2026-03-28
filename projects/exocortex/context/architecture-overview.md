---
tags: [architecture, overview, exocortex]
created: 2026-03-28
---

# Architecture Overview

## Pattern

Hybrid-runtime, event-driven Electron desktop app. Local-first, single window, three panes. Two AI runtimes coexist: user-facing (Claude Code CLI via PTY) and system-facing (Agent SDK for programmatic operations).

## Diagram

```
┌─ USER ───────────────────────────────────────────────┐
│  Terminal Input → Claude Code CLI (PTY)              │
│       │                    │                         │
│       ├─→ File writes → vault files ←→ chokidar     │
│       │                              ↓               │
│       │                       SQLite Index (FTS5)    │
│       │                              ↓               │
│  Glass Box ←── TelemetryBus (EventEmitter, 16ms)    │
│                       ↑                              │
│  File Tree / Editor ←─ WebSocket ←─ IndexerService  │
└──────────────────────────────────────────────────────┘

Intent → AI execution → vault write → chokidar detect →
  indexer update → WebSocket push → React re-render
  Target: <500ms end-to-end
```

## Key Decisions

| Decision | Rationale |
|----------|-----------|
| Electron for v1 | node-pty hard Node.js dependency; Tauri migration path via `src/platform/` |
| Hybrid AI runtime | PTY for user interaction, Agent SDK for system automation; both feed TelemetryBus |
| SQLite is a cache | Vault files on disk are canonical; index.db rebuilds from files |
| Event-driven, never polling | chokidar → WebSocket, TelemetryBus, Zustand subscriptions |
| WebSocket for telemetry | IPC via contextBridge saturates at high frequency; WebSocket handles backpressure |
| Agent SDK V1 `query()` | V2 preview unstable; V1 is production-ready |
| `settingSources: ['user', 'project']` | Required on every SDK call or skills/CLAUDE.md don't load |
| No auto-reject on approvals | GSD waves take 2-5 min; agents wait indefinitely with escalating urgency |

## External Integrations

| Service | Direction | Purpose | Phase |
|---------|-----------|---------|-------|
| Claude Code CLI | Bidirectional (PTY) | User-facing AI | 0 |
| Claude Agent SDK | Outbound | System automation, Auto-Deposit | 1 |
| MCPVault | Bidirectional | Vault CRUD for agents | 1 |
| Composio | Outbound | 1,000+ app connectors (GitHub, Slack, etc.) | 2 |
| Brave Search MCP | Outbound | Web research | 2 |
| CLI-Anything | Outbound | Desktop app bridge (GIMP, Blender, etc.) | 2 |

## Environment

| Env | Purpose |
|-----|---------|
| Local | Electron app on macOS/Windows/Linux |
| Packaged | `.app` / `.exe` / `.AppImage` via electron-builder |
| Mobile (Phase 3) | Cloudflare tunnel + PWA (read-only vault) |
