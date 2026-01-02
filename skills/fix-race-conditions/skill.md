---
name: fix-race-conditions
description: Fixes atomic operations, synchronization, ordering guarantees.
---

# Race Condition Fixer

Eliminate timing-dependent bugs with proper synchronization.

## Checklist

| Issue | Fix |
|-------|-----|
| Check-then-act | Atomic via actor |
| TOCTOU file check | Handle error instead |
| count += 1 race | actor isolation |
| Bool flag race | actor state machine |

## Quick Fixes

### Atomic Check-and-Set
```swift
actor Cache {
    func getOrCreate(_ key: String) -> Value {
        if let v = cache[key] { return v }
        let v = compute(); cache[key] = v; return v
    }
}
```

### Eliminate TOCTOU
```swift
// Just try, handle error
do { let data = try Data(contentsOf: url) }
catch { /* handle missing file */ }
```

### State Machine
```swift
actor StateMachine {
    enum State { case idle, loading, loaded(Data), error(Error) }
    private(set) var state: State = .idle
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (CONC-001)
