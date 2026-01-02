---
name: review-error-handling
description: Reviews unhandled errors, force unwraps, messages.
---

# Error Handling Reviewer

Identify missing/poor error handling causing crashes or confusion.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `try!` with external data | critical |
| `as!` force cast | critical |
| Empty `catch { }` | high |
| `fatalError()` in prod path | critical |
| `print(error)` only | medium |
| Generic "Error occurred" | medium |

## Red Flags

- Force unwraps on external data
- Empty catch blocks
- Generic error messages
- No retry for recoverable errors
