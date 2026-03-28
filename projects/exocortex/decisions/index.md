---
tags: [decisions, journal, exocortex]
created: 2026-03-28
---

# Decision Journal

Time-indexed decisions and failed approaches. Entries are never deleted — supersede with a new dated entry.

---

### 2026-03-28: Initial architecture decisions (pre-scaffold)

**Context:** 8 rounds of specification development. All major architectural decisions made before writing any code.

**Decisions locked (do not re-litigate):**
- Electron for v1 (node-pty requires Node.js; Tauri migration path via `src/platform/`)
- Tailwind CSS v4 (no `config.ts`; all tokens in CSS `@theme` block)
- `@xterm/xterm` + `@xterm/addon-webgl` (NOT legacy `xterm` package)
- `react-arborist` from Phase 0 (virtualized; 10k file target)
- Agent SDK V1 `query()` (NOT V2 preview `createSession()`)
- `settingSources: ['user', 'project']` on every SDK call
- WebSocket for TelemetryBus (NOT IPC; contextBridge saturates at high frequency)
- No auto-reject on approval queue (escalating urgency instead)
- IndexerService in main process (worker_threads only if Phase 1 load testing shows blocking)

**Why these are locked:** Each was evaluated with alternatives during spec rounds. Re-opening them costs time with no new information. If new information surfaces (e.g., Agent SDK V2 stabilizes), record a new entry.

---

### 2026-03-28: EcoBrain integration approach

**Context:** Needed persistent knowledge base for cross-project failure knowledge.

**Tried:** Considered vault-per-project (multiple createServer instances). Rejected — cross-project knowledge has no home, managing N+1 servers is overhead.

**Chose:** Single vault, filesystem namespacing. `_global/` for cross-project knowledge, `projects/<name>/` per project. One `createServer()` call serves everything.

**Why:** `@bitbonsai/mcpvault` takes a single vault path. The `createServer()` factory (shipped v0.10.0) means Exocortex can import it as a library rather than spawning a child process.
