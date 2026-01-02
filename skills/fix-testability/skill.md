---
name: fix-testability
description: Implements DI, protocol abstractions, architectural refactoring for testing.
---

# Testability Fixer

Refactor code to enable comprehensive unit testing.

## Checklist

| Issue | Fix |
|-------|-----|
| Hidden dependency | Constructor injection |
| Direct singleton | Protocol wrapper |
| Static method | Instance via protocol |
| Direct Date()/UUID() | Provider protocol |
| Logic in VC | Extract to testable type |

## Quick Fixes

### Extract Business Logic
```swift
struct Calculator {
    func calculate(items: [Item]) -> Result { /* pure logic */ }
}
```

### Add Protocol + Init
```swift
protocol ServiceProtocol { func fetch() async throws -> Data }
class MyClass {
    private let service: ServiceProtocol
    init(service: ServiceProtocol) { self.service = service }
}
```

### Mock Template
```swift
class MockService: ServiceProtocol {
    var mockResult: Data?
    var shouldFail = false
    func fetch() async throws -> Data {
        if shouldFail { throw TestError.mock }
        return mockResult ?? Data()
    }
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Severity: `_shared/severity.md`
Patterns: `_shared/code-patterns.md` (DI-001 through DI-004)
