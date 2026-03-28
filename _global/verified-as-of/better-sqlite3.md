---
tags: [better-sqlite3, sqlite, electron, native-module]
verified: 2026-03-28
re-verify-after: 2026-06-26
---

# better-sqlite3

**Current safe version:** >=12.8.0
**Bundled SQLite:** 3.49.x
**Electron 41+ compat:** v12.8.0+ only (V8 API break in Electron 41)
**FTS5:** Available and stable in 3.49.x for all planned query patterns
**Note:** SQLite 3.52.0 was withdrawn (float index corruption) — not relevant
since better-sqlite3 bundles its own SQLite, but don't assume 3.52.x features.
