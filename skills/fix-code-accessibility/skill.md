---
name: fix-code-accessibility
description: Fixes labels, VoiceOver, Dynamic Type, contrast, inclusive design.
---

# Code Accessibility Fixer

Make apps usable by everyone through proper assistive technology support.

## Checklist

| Issue | Fix |
|-------|-----|
| Button without label | accessibilityLabel + hint |
| Decorative image announced | accessibilityHidden(true) |
| Custom control inaccessible | accessibilityElement + adjustable |
| Fixed font sizes | Dynamic Type (.body) |
| Small touch targets | Minimum 44x44pt |

## Quick Fixes

### Accessibility Labels
```swift
Button(action: save) { Image(systemName: "square.and.arrow.down") }
    .accessibilityLabel("Save")
    .accessibilityHint("Saves your document")
```

### Custom Control
```swift
HStack { /* stars */ }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Rating")
    .accessibilityValue("\(rating) out of 5 stars")
    .accessibilityAdjustableAction { direction in rating += direction == .increment ? 1 : -1 }
```

### Dynamic Type
```swift
Text("Hello").font(.body)
@ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 24
```

## Testing Checklist
- VoiceOver enabled
- Largest accessibility text sizes
- 44pt touch targets
- 4.5:1 color contrast ratio

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md`
