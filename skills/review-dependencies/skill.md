---
name: review-dependencies
description: Reviews unnecessary libs, versions, abandoned packages, licenses.
---

# Dependency Reviewer

Identify dependency issues that add risk and bloat.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| Package not updated 2+ years | high |
| Using lib for simple task | medium |
| No version pinning | high |
| GPL dependency in closed app | critical |
| Multiple libs for same thing | medium |
| Deprecated/archived package | high |

## Red Flags

- Dependencies with known CVEs
- No lockfile committed
- Mixing package managers (SPM + CocoaPods)
- Dependencies without clear ownership
