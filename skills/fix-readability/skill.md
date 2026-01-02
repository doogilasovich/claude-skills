---
name: fix-readability
description: Fixes naming, decomposition, guard clauses, self-documenting code.
---

# Readability Fixer

Transform confusing code into clear, self-documenting implementations.

## Checklist

| Issue | Fix |
|-------|-----|
| Cryptic names | Descriptive names |
| Long functions | Decompose into focused functions |
| Deep nesting | Guard clauses for early exit |
| Boolean params | Named parameters |
| Magic numbers | Named constants/enums |

## Quick Fixes

### Naming
```swift
// FROM: let a = getData(); var flag = true
// TO:
let userProfile = fetchUserProfile()
var shouldShowWelcomeScreen = true // Booleans as questions
```

### Guard Clauses
```swift
guard let user = user else { return }
guard user.isActive else { return }
guard let data = user.data else { return }
doWork(data)
```

### Function Decomposition
```swift
func processOrder(_ order: Order) async throws -> ProcessedOrder {
    let validated = try validateOrder(order)
    let priced = calculatePricing(validated)
    let payment = try await processPayment(priced)
    return ProcessedOrder(order: priced, payment: payment)
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md`
