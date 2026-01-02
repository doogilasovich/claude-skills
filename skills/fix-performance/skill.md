---
name: fix-performance
description: Fixes algorithms, caching, lazy loading, data structures.
---

# Performance Fixer

Optimize algorithms and data structures for responsiveness.

## Checklist

| Issue | Fix |
|-------|-----|
| O(n²) nested contains | Set lookup |
| Formatter in loop | lazy cached property |
| filter().first | first(where:) |
| String += in loop | Array + joined() |

## Quick Fixes

### Set for Lookups
```swift
let otherSet = Set(others) // O(1) lookup
for item in items { if otherSet.contains(item) { } }
```

### Lazy Formatter
```swift
private lazy var formatter: DateFormatter = {
    let f = DateFormatter(); f.dateStyle = .medium; return f
}()
```

### String Building
```swift
let result = strings.joined(separator: "") // O(n) vs O(n²)
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Severity: `_shared/severity.md`
Patterns: `_shared/code-patterns.md` (PERF-001, PERF-002, PERF-003)
