---
tags: [chokidar, fs-watcher, electron]
verified: 2026-03-28
re-verify-after: 2026-06-26
---

# chokidar

**Current safe version:** 4 (pin exact major, not ^4 or >=4)
**v5 status:** ESM-only since Nov 2025, incompatible with Electron CommonJS main
**Glob support:** Dropped in v4. Use `node:fs/promises.glob()` to expand, then pass explicit paths.
**Debounce:** 300ms recommended before triggering indexer updates
