---
name: review-maintainability
description: Reviews coupling, separation of concerns, architecture.
---

# Maintainability Reviewer

Identify code that resists change and becomes technical debt.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| VC directly calls API | high |
| God class with 1000+ lines | high |
| Hardcoded strings everywhere | medium |
| No dependency injection | high |
| Copy-paste code blocks | medium |
| Singleton overuse | medium |

## Red Flags

- View controllers with business logic
- Classes with >10 dependencies
- No protocols for abstractions
- Circular dependencies
