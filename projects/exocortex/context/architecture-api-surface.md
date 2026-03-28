---
tags: [architecture, api, exocortex]
created: 2026-03-28
---

# API Surface

No external HTTP endpoints. All communication is local.

## IPC Channels (Typed Constants)

### Terminal

| Channel | Direction | Signature |
|---------|-----------|-----------|
| `terminal_write` | renderer → main | `(data: string) → void` |
| `terminal_resize` | renderer → main | `(cols: number, rows: number) → void` |
| `terminal_output` | main → renderer (WebSocket) | PTY output stream |

### Filesystem

| Channel | Direction | Signature |
|---------|-----------|-----------|
| `fs_read` | renderer → main | `(path: string) → Promise<string>` |
| `fs_write` | renderer → main | `(path: string, content: string) → Promise<void>` |
| `fs_delete` | renderer → main | `(path: string) → Promise<void>` |
| `fs_exists` | renderer → main | `(path: string) → Promise<boolean>` |

### Git

| Channel | Direction | Signature |
|---------|-----------|-----------|
| `git_status` | renderer → main | `() → Promise<Record<string, GitStatus>>` |
| `git_commit` | renderer → main | `(message, files?) → Promise<{ sha }>` |
| `git_branch_current` | renderer → main | `() → Promise<string>` |
| `git_branch_list` | renderer → main | `() → Promise<string[]>` |
| `git_log` | renderer → main | `(limit?) → Promise<Commit[]>` |

### Ingest (Drop Portal)

| Channel | Direction | Signature |
|---------|-----------|-----------|
| `ingest_drop` | renderer → main | `(payload) → Promise<PreviewCard>` |
| `ingest_approve` | renderer → main | `(previewId) → Promise<{ path, committed }>` |
| `ingest_reject` | renderer → main | `(previewId) → Promise<void>` |

### Approvals (Glass Box)

| Channel | Direction | Signature |
|---------|-----------|-----------|
| `approval_respond` | renderer → main | `(id, decision) → Promise<void>` |
| `approval_pending` | renderer → main | `() → Promise<ApprovalQueue[]>` |

## WebSocket

Single authenticated connection per renderer:

```
ws://127.0.0.1:{random_port}/telemetry?token={auth_token}
```

Server pushes `TelemetryEvent[]` batched every 16ms (~60fps).

## MCP Tool Surface (MCPVault — 14 tools)

| Tool | Purpose |
|------|---------|
| `read_file` | Read vault file content |
| `write_file` | Write vault file |
| `delete_file` | Delete vault file |
| `list_files` | List directory contents |
| `search` | FTS5 full-text search |
| `get_frontmatter` | Read YAML frontmatter |
| `set_frontmatter` | Update frontmatter fields |
| `create_wikilink` | Add wikilink between files |
| `list_wikilinks` | Get links from a file |
| `get_graph_edges` | Graph view data (Phase 2) |
| `get_type_tags` | Filter files by YAML type |
| `batch_read` | Read multiple files in one call |
| `recent_files` | Recently modified files |
| `vault_stats` | File count, size, index metrics |

## Key Types (src/shared/types.ts)

```typescript
type TelemetryEvent =
  | { type: 'file_read'; path; agent_id }
  | { type: 'file_write'; path; diff; agent_id; requires_approval }
  | { type: 'plan_generated'; plan_id; waves; estimated_cost_usd }
  | { type: 'task_completed'; plan_id; commit_sha; cost_usd }
  | { type: 'budget_warning'; spent_usd; budget_usd; percent }
  | { type: 'approval_requested'; id; action; details }
  | { type: 'sdk_runtime'; status: 'cold'|'starting'|'warm'|'error' }
  // ~10 more discriminants

interface TreeNode { path, name, type, extension?, gitStatus?, frontmatter?, children? }
interface EditorTab { id, path, label, isDirty, type, scrollPosition?, cursorPosition? }
interface ApprovalRequest { id, type, action, details, timestamp }
interface PreviewCard { id, title, summary, tags, proposedPath, linkedNotes, sourceUrl? }
interface CostRecord { model, inputTokens, outputTokens, costUsd, timestamp, agentId? }
```
