---
name: fix-security
description: Fixes Keychain, cert pinning, input validation, secure auth.
---

# Security Fixer

Implement secure storage, authentication, and data handling.

## Checklist

| Issue | Fix |
|-------|-----|
| UserDefaults for secrets | Keychain |
| No cert validation | Certificate pinning |
| String interpolation SQL | Parameterized queries |
| Unvalidated input | Input validation |
| HTTP requests | HTTPS with ATS |
| Sensitive data logged | Redacted logging |

## Quick Fixes

### Input Validation
```swift
func process(_ email: String) throws {
    let sanitized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    guard sanitized.contains("@"), sanitized.contains(".") else { throw ValidationError.invalidEmail }
    sendEmail(to: sanitized)
}
```

### Redacted Logging
```swift
func redact(_ value: String, showLast: Int = 4) -> String {
    String(repeating: "*", count: max(0, value.count - showLast)) + value.suffix(showLast)
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (SEC-001, SEC-002, SEC-003)
