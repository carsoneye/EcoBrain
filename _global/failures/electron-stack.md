---
tags: [electron, node-pty, better-sqlite3, xterm, chokidar, zod, tailwind, mcp]
last-updated: 2026-03-28
project-origin: exocortex
---

# Electron Stack — Failure Patterns

Failures discovered during Exocortex Phase 0 harness review. Each entry has a
root cause, a symptom (what you actually see), and the fix. Verified dates are
when the fix was confirmed working.

---

## node-pty: spawn-helper ships with 644 permissions on macOS

**Symptom:** PTY fails silently in packaged .app — terminal pane renders but
no output. Works fine in dev. Open bug since Dec 2025, no upstream ETA.
**Root cause:** npm extracts spawn-helper as non-executable. The binary can't
run.
**Fix:** Add to postinstall in package.json:
`electron-rebuild -f -w node-pty,better-sqlite3 && chmod +x node_modules/node-pty/prebuilds/darwin-*/spawn-helper`
**Verified:** 2026-03-28

---

## node-pty: not thread-safe, must never move to worker_threads

**Symptom:** Intermittent crashes, no useful stack trace, only under load.
**Root cause:** node-pty is explicitly not thread-safe. Moving it to a worker
context causes corruption.
**Fix:** Hard rule — node-pty stays in main process always. If IndexerService
migrates to worker_threads, that's an independent constraint. They don't share.
**Verified:** 2026-03-28

---

## better-sqlite3 <=12.7.x: silent runtime failure on Electron 41

**Symptom:** IndexerService dies at startup with no useful error. Works on
Electron 34-35, breaks on 41+.
**Root cause:** Electron 41 changed the V8 API — `This()` replaced by
`Holder()`. better-sqlite3 <=12.7.x uses the old call. v12.8.0 (published
~2026-03-15) has the explicit fix.
**Fix:** Pin `"better-sqlite3": ">=12.8.0"` in package.json. Also: pin
Electron version immediately after scaffold — don't let npm update drift it
to 41+ with an unpinned sqlite dep.
**Verified:** 2026-03-28

---

## chokidar v5: ESM-only, breaks Electron main process CommonJS

**Symptom:** Import error at startup. Cryptic, especially if you didn't
explicitly upgrade — npm may resolve v5 if unpinned.
**Root cause:** chokidar v5 (Nov 2025) is ESM-only. Electron main process
typically runs CommonJS with electron-vite defaults.
**Fix:** Pin `"chokidar": "4"` explicitly. Do not leave unpinned.
**Verified:** 2026-03-28

---

## chokidar v4: glob support dropped, watch() silently watches nothing

**Symptom:** File watcher appears to work (no error) but never fires events.
**Root cause:** chokidar v4 dropped glob support entirely. Passing a glob
pattern to `watch()` doesn't error — it just quietly does nothing.
**Fix:** Pass an array of explicit paths, or expand globs first with
`node:fs/promises glob`, then pass the result to chokidar.
**Verified:** 2026-03-28

---

## @anthropic-ai/claude-agent-sdk: Zod 4 requirement, silent conflict with Zod 3

**Symptom:** IPC validators fail at runtime in confusing ways. No clear error
pointing to Zod version mismatch.
**Root cause:** claude-agent-sdk 0.2.x requires Zod 4. If anything else in
the project pins Zod 3, npm may silently install both. They're runtime
incompatible.
**Fix:** Run `npm ls zod` immediately after scaffold. Enforce `"zod": "^4"`
project-wide in package.json. Don't let anything pull in Zod 3 transitively.
**Verified:** 2026-03-28

---

## xterm WebGL: onContextLoss doesn't fire after system sleep

**Symptom:** Terminal pane visually dead after laptop sleep. No error, no
callback, just frozen output.
**Root cause:** macOS kills the WebGL context on sleep. The `onContextLoss`
callback is supposed to handle this but reliably doesn't fire post-sleep.
**Fix:** Belt-and-suspenders — register `onContextLoss` for the normal case,
AND unconditionally re-initialize xterm on `app.on('resume')`. SDK crash and
WebGL context loss are two independent failures that can happen on the same
sleep cycle. Handle both separately.
**Verified:** 2026-03-28

---

## xterm: display:none during init silently breaks cols/rows

**Symptom:** Terminal renders with wrong dimensions — too narrow, wrong line
wrapping. Inconsistent, only sometimes.
**Root cause:** xterm calculates cols/rows from DOM dimensions at init time.
`display: none` means the container has zero size.
**Fix:** Use `visibility: hidden` instead of `display: none` during init.
Also: defer `fitAddon.fit()` to the next `requestAnimationFrame` on tab
switch — fitting immediately uses stale dimensions.
**Verified:** 2026-03-28

---

## ASAR: native modules must be excluded or they fail silently in .app

**Symptom:** Works in dev, breaks in packaged build. No useful error — just
silent failure of the module.
**Root cause:** ASAR packs everything by default. Native .node files and
child-process spawners can't execute from inside an ASAR archive.
**Fix:** Add to electron-builder.yml asarUnpack:
`["node_modules/node-pty/**", "node_modules/better-sqlite3/**", "**/*.node"]`
Add to rollupOptions.external: `['node-pty', 'better-sqlite3']`
Run `@electron/rebuild` postinstall. Test the packaged .app before calling
any phase done — dev mode hides all ASAR failures.
**Verified:** 2026-03-28
