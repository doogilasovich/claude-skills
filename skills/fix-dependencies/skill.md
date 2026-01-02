---
name: fix-dependencies
description: Removes unnecessary, pins versions, replaces abandoned, native alternatives.
---

# Dependencies Fixer

Minimize external dependencies and prefer native implementations.

## Checklist

| Issue | Fix |
|-------|-----|
| Alamofire for simple GET | Native URLSession |
| Third-party Keychain wrapper | Native Security framework |
| Date library for formatting | Native DateFormatter |
| SDWebImage for basic loading | AsyncImage |
| Loose version | Pin exact or narrow range |

## Quick Fixes

### Native URLSession
```swift
let (data, response) = try await URLSession.shared.data(from: url)
guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode)
else { throw NetworkError.invalidResponse }
```

### Native Date Formatting
```swift
extension Date {
    var formatted: String { formatted(date: .abbreviated, time: .omitted) }
    var relative: String { RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date()) }
}
```

### Version Pinning
```swift
.package(url: "...", exact: "1.2.3")        // Critical deps
.package(url: "...", "1.2.0"..<"1.3.0")     // Minor range
```

## License Guidelines
- **Safe**: MIT, Apache 2.0, BSD
- **Caution**: LGPL, MPL 2.0
- **Avoid**: GPL, AGPL, No License

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md` (SEC-001)
