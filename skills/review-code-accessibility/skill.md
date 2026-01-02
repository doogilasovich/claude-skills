---
name: review-code-accessibility
description: Reviews VoiceOver labels, Dynamic Type, contrast, keyboard nav.
---

# Code Accessibility Reviewer

Identify accessibility gaps that exclude users.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| Image without `.accessibilityLabel` | high |
| Button with icon only, no label | high |
| Fixed font size `.system(size: 16)` | high |
| Low contrast text on background | high |
| Custom gesture only, no alternative | medium |
| Decorative image not hidden | low |

## Red Flags

- Interactive elements without labels
- Text that doesn't scale with system settings
- Color as only indicator (red = error)
- No keyboard/switch control support
