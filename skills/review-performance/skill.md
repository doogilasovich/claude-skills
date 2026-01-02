---
name: review-performance
description: Reviews O(n²), allocations, caching, data structures.
---

# Performance Reviewer

Identify inefficient algorithms, excessive allocations, missing optimizations.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| Nested loop same collection | high |
| `.filter{}.first` vs `.first(where:)` | medium |
| `Array` for lookups (use Set) | medium |
| `DateFormatter()` in loop | high |
| String += in loop | medium |
| Large `Data(contentsOf:)` sync | high |
| No caching computed values | medium |

## Red Flags

- Nested loops over same collection
- Object creation in hot paths
- Array.contains() in loops
- Synchronous large data loading
- Missing lazy initialization
