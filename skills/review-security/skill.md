---
name: review-security
description: Reviews secrets, Keychain, validation, TLS.
---

# Security Reviewer

Identify hardcoded secrets, insecure storage, injection risks.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| Hardcoded API key/secret | critical |
| `UserDefaults` for sensitive data | critical |
| ATS exceptions in Info.plist | high |
| SQL string interpolation | critical |
| User input in WebView | high |
| `try!`/`as!` with external data | high |
| No certificate pinning | medium |

## Red Flags

- API keys in source code
- Credentials in UserDefaults
- Disabled App Transport Security
- String concatenation in queries
- Untrusted data in WebViews
