---
tags: [recommendations, exocortex]
created: 2026-03-28
---

# Recommendations

Generated from first analysis (pre-scaffold). Sorted by impact desc, effort asc.

## Priority Matrix

| # | Recommendation | Category | Effort | Impact | Source |
|---|---------------|----------|--------|--------|--------|
| 1 | [ ] Lock Electron version immediately after scaffold | Architecture | S | High | `analysis/security.md` — better-sqlite3 V8 API break |
| 2 | [ ] Pin better-sqlite3 >=12.8.0, chokidar@4, zod@4 before any code | Architecture | S | High | `_global/failures/electron-stack.md` |
| 3 | [ ] Configure ASAR unpack + electron-rebuild postinstall on day 1 | Architecture | S | High | `_global/failures/electron-stack.md` — ASAR section |
| 4 | [ ] Add chmod +x for node-pty spawn-helper in postinstall | Architecture | S | High | `_global/failures/electron-stack.md` — node-pty section |
| 5 | [ ] Set CSP with documented unsafe-eval/unsafe-inline exceptions | Security | S | High | `analysis/security.md` — CSP section |
| 6 | [ ] Run `npm ls zod` after scaffold to verify no Zod 3 transitive deps | Quality | S | High | `_global/failures/electron-stack.md` — Zod section |
| 7 | [ ] Test packaged build (`npm run build`) before declaring Phase 0 complete | Testing | M | High | `analysis/testing.md` — Phase 0 gate |
| 8 | [ ] Choose unit test framework at scaffold time | Testing | S | Medium | `analysis/testing.md` — gaps |
| 9 | [ ] Implement xterm belt-and-suspenders WebGL recovery + app.on('resume') | Architecture | M | Medium | `_global/failures/electron-stack.md` — xterm entries |
| 10 | [ ] Set up CI pipeline with test execution | DX | M | Medium | `analysis/testing.md` — gaps |
| 11 | [ ] Configure .env in .gitignore at scaffold | Security | S | Medium | `analysis/security.md` — environment |
