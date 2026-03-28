---
tags: [analysis, patterns, exocortex]
created: 2026-03-28
---

# Patterns

Pre-scaffold analysis — patterns are specified, not yet implemented.

## Patterns Specified

| Pattern | Where | Purpose |
|---------|-------|---------|
| Hybrid AI Runtime | Terminal + Orchestrator | PTY for user interaction, Agent SDK for system automation |
| Event-Driven Push | TelemetryBus + chokidar + WebSocket | No polling; all state changes pushed |
| Cache-Aside (SQLite) | IndexerService | SQLite is read cache; vault files are source of truth |
| Platform Abstraction | `src/platform/` | Enable Electron → Tauri migration |
| Discriminated Unions | `TelemetryEvent` type | Type-safe event routing without runtime parsing |
| Preload Bridge | contextBridge | Only IPC surface between main and renderer |
| Sidecar Auth Token | All IPC/WebSocket | 256-bit token, 127.0.0.1 only |
| Warm Process Pool | OrchestratorService | Agent SDK spawned once, reused (12s startup cost) |
| Escalating Urgency | Approval queue | Badge → amber → notification → modal (never auto-reject) |
| TDD | All new features | Tests written before implementation |

## Anti-Patterns Explicitly Forbidden

| Anti-Pattern | Rule Source | Why |
|--------------|-----------|-----|
| `any` types | `.claude/rules/coding-style.md` | Use `unknown` and narrow |
| `console.log` | `AGENTS.md` non-negotiables | Remove before commit |
| Hardcoded colors | `AGENTS.md` non-negotiables | Use design tokens |
| Polling for updates | `AGENTS.md` non-negotiables | Use WebSocket/Zustand |
| Direct FS in renderer | `AGENTS.md` non-negotiables | Use SQLite via IPC |
| Parsing terminal output | `AGENTS.md` non-negotiables | Use Agent SDK |
| `require('electron')` in renderer | `.claude/rules/electron-patterns.md` | Use `src/platform/` |
| `nodeIntegration: true` | `.claude/rules/electron-patterns.md` | Security violation |
| PTY in worker_threads | `.claude/rules/electron-patterns.md` | node-pty not thread-safe |
| Zod on telemetry stream | `.claude/rules/electron-patterns.md` | Performance (compile-time types only) |
| Empty `catch {}` | `.claude/rules/coding-style.md` | Never swallow errors |

## Conventions

| Convention | Enforced? | How |
|------------|-----------|-----|
| Named exports for components | Yes | Code review agent |
| Default exports for pages only | Yes | Code review agent |
| `className` prop via `cn()` on all components | Yes | Design review agent |
| Exhaustive hook dependency arrays | Yes | ESLint + TypeScript review |
| Zod validation at system boundaries | Yes | Security review agent |
| `const` by default, `let` when needed, never `var` | Yes | ESLint + coding-style rule |
| `readonly` on interface properties | Yes | TypeScript strict |
| Imports: external → internal → relative → types | Yes | Code review agent |

## Code Style

| Aspect | Convention | Tooling |
|--------|------------|---------|
| Naming | camelCase vars, PascalCase types/components, UPPER_SNAKE constants | ESLint |
| Booleans | Prefix: `is`, `has`, `should`, `can` | Code review agent |
| Handlers | `handle` (component) / `on` (prop) | Code review agent |
| File org | One component per file, filename matches export | Code review agent |
| Barrel exports | Only if 5+ exports in directory | Manual |
