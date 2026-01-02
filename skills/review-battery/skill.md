---
name: review-battery
description: Reviews GPS, sensors, polling, background tasks.
---

# Battery Reviewer

Identify power-draining patterns causing user churn.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| `CLLocationManager` always on | critical |
| Timer <1s interval | high |
| Sensor started, never stopped | high |
| Polling instead of push | high |
| Background fetch <15 min | medium |
| `AVAudioSession` always active | high |

## Red Flags

- `kCLLocationAccuracyBest` always
- Sensors not stopped
- Timers without invalidation
- Network polling when push works
