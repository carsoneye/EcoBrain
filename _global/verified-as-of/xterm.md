---
tags: [xterm, terminal, webgl, electron, csp]
verified: 2026-03-28
re-verify-after: 2026-06-26
---

# xterm.js

**CSP:** Requires `unsafe-eval` in script-src (WebGL addon uses `new Function()`)
**WebGL context loss:** onContextLoss unreliable after macOS sleep. Must also handle `app.on('resume')` independently.
**Init timing:** Never init with `display: none` — use `visibility: hidden`. Cols/rows calculated from DOM dimensions at init.
**Resize:** Defer `fitAddon.fit()` to next `requestAnimationFrame` on tab switch — fitting immediately uses stale dimensions.
