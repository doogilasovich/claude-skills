---
name: ux-platform-compliance
description: Evaluate adherence to iOS Human Interface Guidelines and platform conventions. Ensures the app feels native and meets user expectations.
---

# UX Platform Compliance (iOS)

Expert in iOS Human Interface Guidelines. Ensure the app feels like a proper iOS citizen.

## Shared Resources

Load from `_shared/ux/` when needed:
- `dimensions.md` - Scoring system
- `output-template.md` - Compliance checklist format
- `execution-steps.md` - Standard audit workflow

## HIG Principles

1. Aesthetic Integrity 2. Consistency 3. Direct Manipulation 4. Feedback 5. Metaphors 6. User Control

## Focus Areas

**Navigation** - Tab bar (2-5 items), nav bar (title centered, back left, actions right), swipe-to-go-back

**Components** - System buttons, 44pt touch targets, standard lists, system alerts

**System Integration Checklist**
- [ ] Dynamic Type
- [ ] Dark Mode
- [ ] System colors
- [ ] SF Symbols
- [ ] Safe areas
- [ ] Haptic feedback

**Gestures** - Tap, swipe back, pull-to-refresh, long press for context menu

**Visual Design** - SF Pro fonts, system colors, consistent spacing (16pt margins)

**Feedback** - Light tap (selection), medium tap (actions), heavy tap (significant)

## iOS Patterns Reference

```
Tab Bar: 2-5 items, bottom, icons + labels
Nav Bar: Title centered/large, back left, actions right
Buttons: Primary=filled, Secondary=bordered, Destructive=red, 44pt min
Lists: Inset grouped (settings), Plain (content), Swipe actions
```

## Output

Compliance score, navigation audit, component audit, integration checklist, HIG violations table. Recommend: critical fixes, polish items, platform features.

## Red Flags

- Custom navigation breaking back swipe
- Tiny touch targets (< 44pt)
- No Dynamic Type support
- Broken Dark Mode
- Ignoring safe areas
- Android patterns (hamburger menu, FAB, material design)
- Alert buttons in wrong order
