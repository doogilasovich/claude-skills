---
name: fix-platform-guidelines
description: Fixes HIG compliance, system settings, accessibility, idioms.
---

# Platform Guidelines Fixer

Implement proper HIG compliance and respect user preferences.

## Checklist

| Issue | Fix |
|-------|-----|
| Fixed font sizes | Dynamic Type |
| Hardcoded colors | Semantic system colors |
| Animations always play | Respect reduceMotion |
| Content under notch | Safe area compliance |
| Small touch targets | Minimum 44pt |

## Quick Fixes

### Dynamic Type
```swift
Text("Hello").font(.body)
// UIKit: UIFont.preferredFont(forTextStyle: .body)
```

### Semantic Colors
```swift
view.backgroundColor = .systemBackground
label.textColor = .label
```

### Reduce Motion
```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion
withAnimation(reduceMotion ? .none : .spring()) { isExpanded.toggle() }
```

### Touch Targets
```swift
Button(action: close) {
    Image(systemName: "xmark")
        .frame(width: 44, height: 44)
        .contentShape(Rectangle())
}
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md`
