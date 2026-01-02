---
name: fix-concurrency
description: Fixes actors, Sendable, MainActor, async/await patterns.
---

# Concurrency Fixer

Implement thread-safe patterns with Swift concurrency.

## Checklist

| Issue | Fix |
|-------|-----|
| Unprotected shared state | actor |
| @Published off main | @MainActor |
| Non-Sendable crossing boundary | Sendable struct |
| Callback on wrong thread | async/await |

## Quick Fixes

### Actor for Shared State
```swift
actor Cache {
    private var items: [String: Data] = [:]
    func get(_ key: String) -> Data? { items[key] }
}
```

### MainActor for UI
```swift
@MainActor class ViewModel: ObservableObject {
    @Published var items: [Item] = []
}
```

### Sendable Compliance
```swift
struct Config: Sendable { let apiKey: String }
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (CONC-001, CONC-002, CONC-003)
