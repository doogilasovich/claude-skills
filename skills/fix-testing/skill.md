---
name: fix-testing
description: Fixes behavior tests, flaky tests, mocking, edge case coverage.
---

# Testing Fixer

Implement comprehensive, reliable tests that verify behavior.

## Checklist

| Issue | Fix |
|-------|-----|
| New code without tests | Behavior-focused tests |
| Tests verify implementation | Test outcomes, not journey |
| Timing-dependent flaky tests | async/await |
| Tests depend on each other | Independent setup/teardown |
| Only happy path tested | Edge cases + errors |

## Quick Fixes

### Behavior vs Implementation
```swift
// FROM: XCTAssertTrue(mock.getCalled)
// TO: Test outcome
let users = try await service.fetchUsers()
XCTAssertEqual(users.count, 2)
```

### Fixing Flaky Tests
```swift
func test_asyncOp() async {
    await service.doAsync() // Implicitly waits
}
```

### Test Naming
```swift
func test_login_withValidCredentials_returnsUser() { }
func test_login_withInvalidEmail_throwsValidationError() { }
```

### Independent Tests
```swift
override func setUp() {
    mockDB = MockDatabase()
    service = UserService(database: mockDB)
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md`
