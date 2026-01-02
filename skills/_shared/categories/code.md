# Code Review Categories

17 review/fix specialist pairs for code quality.

## Categories

| ID | Key | Review Focus | Fix Focus |
|----|-----|--------------|-----------|
| 1 | memory | Retain cycles, weak refs, observers | [weak self], delegates, deinit |
| 2 | concurrency | Actor isolation, Sendable, MainActor | Actor refactoring, @MainActor |
| 3 | performance | O(n²), formatters in loops, lazy init | Caching, algorithms |
| 4 | security | Hardcoded secrets, Keychain, validation | Keychain, pinning |
| 5 | race-conditions | TOCTOU, check-then-act, async ordering | Atomic ops, sync |
| 6 | main-thread | I/O on main, heavy computation | Background dispatch |
| 7 | battery | Location, sensors, polling, background | Batching, coalescing |
| 8 | network | Missing cache, retry, offline support | URLCache, retry logic |
| 9 | error-handling | Force unwraps, empty catch, user msgs | Typed errors, recovery |
| 10 | platform-guidelines | HIG, deprecated APIs, system settings | Compliance fixes |
| 11 | readability | Naming, function length, complexity | Extract, rename |
| 12 | maintainability | Coupling, god classes, DI | Protocols, DI |
| 13 | testing | Coverage gaps, flaky tests | Add tests, fix flaky |
| 14 | dependencies | Outdated, abandoned, duplicates | Update, replace |
| 15 | code-accessibility | VoiceOver, Dynamic Type, contrast | Labels, scaling |
| 16 | testability | Hidden deps, singletons, static | DI, protocols |
| 17 | user-metrics | Missing events, PII, broken funnels | Tracking, privacy |

## Skill Naming

- Review: `review-{category}` (e.g., `review-memory`)
- Fix: `fix-{category}` (e.g., `fix-memory`)

## All Categories (Copy/Paste)

```
memory,concurrency,performance,security,race-conditions,main-thread,battery,network,error-handling,platform-guidelines,readability,maintainability,testing,dependencies,code-accessibility,testability,user-metrics
```
