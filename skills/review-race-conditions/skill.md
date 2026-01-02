---
name: review-race-conditions
description: Reviews TOCTOU, check-then-act, async ordering.
---

# Race Conditions Reviewer

Identify check-then-act, TOCTOU, and async ordering issues.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `if x == nil { x = create() }` | high |
| `if file.exists { file.read }` | high |
| `count += 1` from multiple tasks | critical |
| Assuming async callback order | high |
| `isLoading` flag without sync | medium |

## Red Flags

- Read-modify-write without atomicity
- File existence check before operation
- Boolean flags for async state
- Assumptions about Task order
