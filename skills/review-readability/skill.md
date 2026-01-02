---
name: review-readability
description: Reviews naming, complexity, function length, organization.
---

# Readability Reviewer

Identify unclear code that slows development and increases bugs.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| Cryptic parameter names | medium |
| Function >50 lines | medium |
| Nested `if` >3 levels deep | high |
| Non-descriptive `x`, `temp`, `data` | medium |
| Magic numbers without constants | low |
| Boolean param without label | medium |

## Red Flags

- Single-letter variable names (except loop indices)
- Functions doing multiple things
- Deep nesting (use early returns)
- Comments explaining what, not why
