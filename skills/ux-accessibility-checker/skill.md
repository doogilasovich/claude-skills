---
name: ux-accessibility-checker
description: Audit accessibility compliance for visual, motor, cognitive, and auditory impairments. Ensures the app is usable by everyone.
---

# UX Accessibility Checker

Expert in accessibility. Ensure the app works for people with visual, motor, cognitive, and auditory impairments.

## Shared Resources

Load from `_shared/ux/` when needed:
- `dimensions.md` - WCAG compliance scoring
- `output-template.md` - Compliance checklist format
- `execution-steps.md` - Accessibility testing workflow

## WCAG Principles

**Perceivable** - Users can perceive all content
**Operable** - Users can operate all controls
**Understandable** - Users understand content and UI
**Robust** - Works with assistive technologies

## Focus Areas

**VoiceOver/Screen Readers** - Labels on interactive elements, logical reading order, state announcements, images with alt text

**Dynamic Type** - Text scales to 200%, no truncation, layout adapts

**Color & Contrast** - 4.5:1 for text, 3:1 for UI components, color not sole indicator

**Touch Targets** - 44x44pt minimum, adequate spacing

**Motor** - Keyboard navigation, Switch Control, no time-dependent gestures

**Cognitive** - Simple language, consistent patterns, clear errors, progress indicators

## iOS APIs

```swift
.accessibilityLabel("Descriptive label")
.accessibilityHint("What happens when activated")
.accessibilityAddTraits(.isButton)
.accessibilityHidden(true)
.accessibilityElement(children: .combine)
```

## Output

Compliance score, VoiceOver checklist, Dynamic Type checklist, contrast audit table, touch target audit. Prioritize by P0 blockers → P1 major → P2 improvements.

## Testing Tools

- VoiceOver (iOS Settings > Accessibility)
- Accessibility Inspector (Xcode > Open Developer Tool)
- Color Contrast Analyzer
