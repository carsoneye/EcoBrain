---
tags: [context, tech-stack, exocortex]
created: 2026-03-28
---

# Tech Stack

## Languages

| Language | Role | % of Codebase |
|----------|------|---------------|
| TypeScript | All application code (main, renderer, shared) | ~90% (planned) |
| SQL | SQLite FTS5 queries for indexing | ~2% |
| CSS | Tailwind CSS 4 `@theme` tokens (OKLCH) | ~5% |
| Markdown | Vault content, specs, config | ~3% |

## Framework & Runtime

| Tool | Version | Purpose |
|------|---------|---------|
| Electron | Pin at scaffold (41+ breaks better-sqlite3) | Desktop shell, PTY, native modules |
| electron-vite | Latest | Dev server + bundler |
| React | 19 | UI framework |
| Tailwind CSS | 4 (no config.ts; `@theme` in globals.css) | Styling with design tokens |
| CodeMirror | 6 | Markdown editor |
| `@xterm/xterm` | 5 (NOT legacy `xterm`) | Terminal rendering |
| `@xterm/addon-webgl` | Latest | 60fps WebGL renderer |
| Zustand | Latest | State management (3 stores) |
| Zod | 4 (mandatory; Agent SDK requires) | IPC/input validation |

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `node-pty` | Latest | PTY spawning (not thread-safe, needs chmod +x) |
| `better-sqlite3` | `>=12.8.0` | SQLite (V8 API break floor) |
| `chokidar` | `4` (pin exact; v5 ESM-only) | FS watcher (no globs, 300ms debounce) |
| `@anthropic-ai/claude-agent-sdk` | Latest | Agent SDK (V1 `query()`, not V2 preview) |
| `react-arborist` | Latest | Virtualized file tree (10k target) |
| `react-resizable-panels` | Latest | Split-pane layout |
| `pdf-parse` | Latest | PDF extraction (Auto-Deposit) |
| `@mozilla/readability` + `linkedom` | Latest | URL content extraction |
| `@bitbonsai/mcpvault` | `>=0.10.0` | MCP vault server (createServer import) |

## Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `@electron/rebuild` | Latest | Rebuild native modules per Electron version |
| `playwright` | Latest | E2E testing for Electron |
| ESLint | Latest | Linting (auto via PostToolUse hook) |

## Tooling

| Tool | Purpose |
|------|---------|
| `npm run dev` | electron-vite dev server (HMR) |
| `npm run build` | Production build (ASAR, code signing) |
| `npm run typecheck` | TypeScript strict validation |
| `npm run lint` | ESLint |
| `npm test` | Test runner |
| `electron-rebuild` | Native module rebuild |

## Infrastructure

| Service | Purpose |
|---------|---------|
| SQLite (better-sqlite3) | FTS5 indexing, vault search cache |
| chokidar v4 | File watching (300ms debounce, explicit paths) |
| WebSocket (127.0.0.1) | TelemetryBus streaming (16ms batch, auth token) |
| IPC preload bridge | Renderer ↔ main communication |
| Native git | Version control backbone |
| Composio (Phase 2) | 1,000+ service connectors |
