---
name: fix-memory
description: Fixes retain cycles, weak refs, cleanup, cache limits.
---

# Memory Fixer

Eliminate leaks and reduce memory footprint.

## Checklist

| Issue | Fix |
|-------|-----|
| Closure captures self | `[weak self]` |
| Strong delegate | `weak var delegate` |
| Observer not removed | deinit cleanup |
| Timer not invalidated | deinit cleanup |
| Unbounded cache | NSCache with limits |

## Quick Fixes

### Weak Self in Closure
```swift
// FROM
completion = { self.update($0) }
// TO
completion = { [weak self] in self?.update($0) }
```

### Weak Delegate
```swift
weak var delegate: MyDelegate?
```

### Observer/Timer Cleanup
```swift
deinit {
    observer.map { NotificationCenter.default.removeObserver($0) }
    timer?.invalidate()
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (MEM-001, MEM-002)
