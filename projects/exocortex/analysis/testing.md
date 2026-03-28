---
tags: [analysis, testing, exocortex]
created: 2026-03-28
---

# Testing

Pre-scaffold — testing strategy from specifications.

## Strategy

| Aspect | Approach |
|--------|----------|
| Unit Tests | TDD workflow (tests before implementation) |
| Integration Tests | Service-level testing (main process) |
| E2E Tests | Playwright for Electron |
| Framework | Playwright (E2E), framework TBD (unit) |
| Runner | `npm test` |
| Agent | `e2e-runner` agent manages E2E suite |

## E2E Critical User Journeys

| Journey | Priority | What to Verify |
|---------|----------|----------------|
| App launches | HIGH | File tree, editor, terminal all visible |
| Open file from tree | HIGH | Click → tab opens → content matches |
| Terminal accepts input | HIGH | Type command → output appears |
| Claude Code starts | HIGH | Type `claude` → prompt appears |
| Command palette | HIGH | Cmd+K → query → results → select fires action |
| Editor saves | HIGH | Edit → save → file content on disk changed |
| Auto-Deposit | MEDIUM | Drop file → preview card appears |
| Glass Box | MEDIUM | Trigger action → event appears in telemetry |

## Test Quality Standards

| Check | Requirement |
|-------|-------------|
| Locators | `data-testid` attributes (never CSS selectors) |
| Independence | Each test self-contained (no shared state) |
| Waits | `waitForSelector` (never `waitForTimeout`) |
| Failures | Screenshot capture on every failure |
| Flaky handling | `test.fixme(true, 'reason')` with issue link |
| Suite time | < 60 seconds |
| Flaky rate | < 5% |

## Coverage (Planned)

| Layer | Phase | Expectation |
|-------|-------|-------------|
| E2E critical paths | 0 | All HIGH journeys passing |
| Service unit tests | 1 | Core services tested |
| Component tests | 1 | Key UI interactions |
| Integration (IPC) | 1 | All handlers tested with Zod validation |
| Full E2E suite | 1 | HIGH + MEDIUM journeys |

## Gaps

| Gap | Priority | Notes |
|-----|----------|-------|
| No test framework chosen for unit tests | Medium | Need to decide at scaffold |
| No CI pipeline defined | Medium | Tests must run in CI |
| Performance testing approach undefined | Low | <500ms target not formally tested |
| Packaged build testing | HIGH | Dev mode masks ASAR failures — must test `.app` |

## Phase 0 Test Gate

Packaged build must pass E2E tests — not just dev mode. This is the single most important quality gate because dev mode masks all ASAR failures, permission issues, and native module loading problems.
