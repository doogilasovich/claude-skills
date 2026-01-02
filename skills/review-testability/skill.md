---
name: review-testability
description: Reviews hidden dependencies, singletons, static methods, coupling.
---

# Testability Reviewer

Identify code patterns that resist unit testing.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `let x = SomeClass()` in method | high |
| `Singleton.shared.method()` | high |
| `StaticClass.method()` can't mock | medium |
| `Date()` or `UUID()` non-deterministic | medium |
| `UserDefaults.standard` global state | medium |
| Logic in ViewController | high |

## Red Flags

- Classes that create their own dependencies
- Direct singleton access without protocol wrapper
- Business logic embedded in UI layer
- File/network access without abstraction
