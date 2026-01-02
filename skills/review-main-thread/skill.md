---
name: review-main-thread
description: Reviews I/O, computation on main thread.
---

# Main Thread Reviewer

Identify blocking operations causing UI freezes (>16ms = dropped frames).

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `Data(contentsOf:)` on main | high |
| Sync network call | critical |
| Large JSON parsing | high |
| `UIImage(data:)` large images | high |
| CoreData fetch on main | high |
| `DispatchQueue.main.sync` | critical |

## Red Flags

- Synchronous I/O in view lifecycle
- Network without async/await
- Image processing on main
- DB queries in cellForRowAt
