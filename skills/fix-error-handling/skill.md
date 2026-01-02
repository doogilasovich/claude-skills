---
name: fix-error-handling
description: Fixes typed errors, user messages, logging, recovery, graceful degradation.
---

# Error Handling Fixer

Implement structured error types, recovery patterns, and user-friendly feedback.

## Checklist

| Issue | Fix |
|-------|-----|
| Generic errors | LocalizedError |
| Force unwraps `!` | guard + safe unwrap |
| Empty catch blocks | Log + user feedback |
| Technical messages | User-friendly mapping |

## Quick Fixes

### Structured Errors
```swift
enum DataError: LocalizedError {
    case networkUnavailable, serverError(Int)
    var errorDescription: String? {
        switch self {
        case .networkUnavailable: return "No internet connection"
        case .serverError(let code): return "Server error (\(code))"
        }
    }
}
```

### Empty Catch Fix
```swift
do { try saveData() }
catch {
    Logger.error("Save failed: \(error)")
    showAlert("Could not save your data")
}
```

### Graceful Degradation
```swift
async let user = Result { try await fetchUser() }
async let stats = Result { try await fetchStats() }
state.user = try? await user.get() // Partial success OK
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (ERR-001, ERR-002, ERR-003)
