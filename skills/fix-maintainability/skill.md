---
name: fix-maintainability
description: Fixes dependency injection, protocols, separation of concerns.
---

# Maintainability Fixer

Implement clean architecture patterns for easy modification and extension.

## Checklist

| Issue | Fix |
|-------|-----|
| Hardcoded dependencies | Constructor injection |
| Concrete type coupling | Protocol abstraction |
| God object (30+ methods) | Single responsibility classes |
| Growing switch statements | Strategy pattern |

## Quick Fixes

### Dependency Injection
```swift
class UserService {
    private let network: NetworkClientProtocol
    init(network: NetworkClientProtocol) { self.network = network }
}
```

### Breaking Up God Objects
```swift
class AuthService { func login(), logout() }
class UserRepository { func fetch(), save() }
class AnalyticsService { func track() }
```

### Strategy Pattern
```swift
protocol PaymentStrategy { func process(amount: Decimal) async throws }
class PaymentProcessor {
    private var strategies: [PaymentType: PaymentStrategy] = [:]
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (DI-001 through DI-004)
