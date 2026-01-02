---
name: review-platform-guidelines
description: Reviews HIG compliance, system settings, deprecated APIs.
---

# Platform Guidelines Reviewer

Identify iOS convention violations that create user friction.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| Custom back button, no swipe | high |
| Ignoring `preferredContentSizeCategory` | high |
| Hardcoded colors, no dark mode | high |
| Using deprecated API | medium |
| Ignoring `accessibilityReduceMotion` | medium |
| Custom alert instead of `UIAlertController` | low |

## Red Flags

- `isInteractivePopGestureEnabled = false`
- Fixed font sizes instead of text styles
- No `@Environment(\.colorScheme)`
- Using old APIs without availability check
