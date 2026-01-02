---
name: review-memory
description: Reviews retain cycles, weak refs, observers, cleanup.
---

# Memory Reviewer

Identify leaks from retain cycles, missing cleanup, unbounded growth.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `{ self.prop }` in stored closure | high |
| `var delegate: Delegate?` (not weak) | high |
| `NotificationCenter.addObserver` no remove | high |
| `Timer.scheduledTimer` no invalidate | high |
| `URLSession` no invalidate | medium |
| Cache without size limit | high |
| VC not deallocating | critical |

## Red Flags

- Closures stored as properties capturing `self`
- Strong delegate references
- Observers without `deinit` cleanup
- Timers without invalidation
- Parent-child both holding strong refs
