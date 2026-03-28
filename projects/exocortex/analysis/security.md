---
tags: [analysis, security, exocortex]
created: 2026-03-28
---

# Security

Pre-scaffold — security posture from specifications.

## Authentication & Authorization

| Mechanism | Implementation | Scope |
|-----------|---------------|-------|
| Sidecar auth token | `crypto.randomBytes(32)` at startup | All IPC + WebSocket |
| Token transport | Query param on WebSocket, header on IPC | 127.0.0.1 only |
| Claude API auth | `ANTHROPIC_API_KEY` env var | Agent SDK + PTY |
| MCP auth | Inherits sidecar token | MCPVault, Composio |
| Composio OAuth | Managed by Composio service | External service access (Phase 2) |

## Content Security Policy

```
default-src 'self';
script-src 'self' 'unsafe-eval';
style-src 'self' 'unsafe-inline';
connect-src 'self' ws://127.0.0.1:*;
img-src 'self' data:;
font-src 'self';
```

| Directive | Exception | Reason | Acceptable? |
|-----------|-----------|--------|-------------|
| `script-src` | `unsafe-eval` | xterm.js WebGL uses `new Function()` | Yes — documented upstream constraint |
| `style-src` | `unsafe-inline` | CodeMirror injects dynamic styles | Yes — cannot avoid without forking |

**Not allowed:** External origins, `*` wildcards, `http:` in connect-src.

## Electron Security Constraints

| Setting | Required Value | Why |
|---------|---------------|-----|
| `nodeIntegration` | `false` | Never allow Node.js in renderer |
| `contextIsolation` | `true` | Enforce preload bridge boundary |
| Preload bridge | Only specific methods via `contextBridge` | No blanket API access |
| IPC validation | Zod on all inbound handlers | Trust boundary enforcement |
| Error serialization | `{ message, stack }` only | Never pass raw Error objects |
| Native modules | Main process only | Never import in renderer |

## IPC Trust Boundary

| Direction | Validation | Notes |
|-----------|-----------|-------|
| Renderer → Main | Zod schema on every handler | This IS the trust boundary |
| Main → Renderer | TypeScript discriminated unions only | No Zod (performance on 16ms batches) |
| WebSocket | Auth token required on handshake | 127.0.0.1 binding |

## Environment & Secrets

| Check | Status |
|-------|--------|
| Secrets in code | `.env.example` uses placeholders only |
| .env in gitignore | Must be configured at scaffold |
| Hardcoded credentials | None in specs |
| Environment validation | Zod at startup planned |

## Agent SDK Security

| Constraint | Enforcement |
|-----------|-------------|
| `permissionMode` | `default` (read-only) or `acceptEdits` per agent |
| `allowedTools` | Scoped minimally per agent configuration |
| `canUseTool` callback | Approval gate for sensitive tools |
| `settingSources` | `['user', 'project']` required on every call |
| Budget | 80% warning, 100% circuit breaker |

## Dependencies Audit

| Package | Known Issues | Action |
|---------|-------------|--------|
| `@bitbonsai/mcpvault` | Symlink traversal (patched v0.9.1) | Pin `>=0.10.0` |
| `better-sqlite3` | V8 API break on Electron 41 | Pin `>=12.8.0` |
| `node-pty` | spawn-helper 644 permissions (macOS) | chmod +x in postinstall |
| `chokidar` | v5 ESM-only (Electron incompatible) | Pin to `4` |
| `zod` | v3/v4 mixing causes silent failures | Enforce `4` project-wide |
