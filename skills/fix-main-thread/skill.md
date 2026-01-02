---
name: fix-main-thread
description: Fixes async/await, background processing, proper dispatch.
---

# Main Thread Fixer

Move heavy work off UI thread to maintain 60fps.

## Checklist

| Issue | Fix |
|-------|-----|
| Sync file read | Task { } |
| Sync network | async/await |
| JSON parse on main | Task.detached |
| Image decode on main | background + MainActor |
| Heavy loop in viewDidLoad | Task |

## Quick Fixes

### Async File Read
```swift
Task {
    let data = try Data(contentsOf: url)
    await MainActor.run { self.data = data }
}
```

### Async JSON Decode
```swift
Task.detached {
    let items = try JSONDecoder().decode([Item].self, from: data)
    await MainActor.run { self.items = items }
}
```

### MainActor Pattern
```swift
@MainActor class ViewModel: ObservableObject {
    func load() async {
        let data = await fetchInBackground()
        self.items = data // Safe
    }
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (CONC-002)
