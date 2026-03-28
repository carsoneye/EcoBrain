---
tags: [mcpvault, mcp, vault, sidecar]
verified: 2026-03-28
re-verify-after: 2026-06-26
---

# @bitbonsai/mcpvault

**Current safe version:** >=0.10.0
**Node requirement:** 20+ (Node 18 dropped, EOL since April 2025)
**Rename:** Was `mcpvault`, now `@bitbonsai/mcpvault` (March 2026, Obsidian request)
**createServer:** Shipped in v0.10.0. Import directly for programmatic use.
**Security:** Symlink traversal in read_note patched in v0.9.1
**Key tools:** list_all_tags (frontmatter + inline, deduplicated by frequency), read_multiple_notes (batch read)
