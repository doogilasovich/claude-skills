---
name: review-concurrency
description: Reviews threading, actors, Sendable, synchronization.
---

# Concurrency Reviewer

Identify unsafe threading, missing synchronization, Swift 6 issues.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `var` accessed from multiple queues | critical |
| Class without actor/lock | high |
| `@Published` modified off main | high |
| Non-Sendable across actor boundary | high |
| `DispatchQueue.sync` nested | critical |
| Closure captures mutable state | high |
| No `@MainActor` on ViewModel | medium |

## Red Flags

- Mutable `var` in class without actor/lock
- `@Published` from background
- Non-Sendable crossing isolation
- Nested `sync` calls
- Missing `[weak self]` with mutable captures
