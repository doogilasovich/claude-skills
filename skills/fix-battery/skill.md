---
name: fix-battery
description: Fixes location tracking, batched operations, background tasks, sensors.
---

# Battery Fixer

Implement power-efficient patterns for location, networking, sensors.

## Checklist

| Issue | Fix |
|-------|-----|
| Continuous GPS | significantLocationChanges |
| Request per event | Batch requests |
| 60fps timer | Appropriate frequency + tolerance |
| Continuous background | BGTaskScheduler |
| Always-on sensors | Activity-based activation |

## Quick Fixes

### Location Optimization
```swift
locationManager.startMonitoringSignificantLocationChanges()
// Or reduced accuracy:
locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
```

### Request Batching
```swift
actor EventBatcher {
    private var pending: [Event] = []
    func track(_ event: Event) {
        pending.append(event)
        if pending.count >= 20 { flushNow() }
    }
}
```

### Timer Tolerance
```swift
timer.tolerance = 0.2 // Allows system to coalesce wake-ups
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Patterns: `_shared/code-patterns.md`
