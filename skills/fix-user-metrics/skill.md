---
name: fix-user-metrics
description: Implements analytics events, funnel tracking, PII protection.
---

# User Metrics Fixer

Implement proper analytics tracking while protecting user privacy.

## Checklist

| Issue | Fix |
|-------|-----|
| Missing event | analytics.track() |
| Incomplete funnel | Add all steps |
| PII in events | Hash or remove |
| No error tracking | Error events |
| Inconsistent naming | snake_case noun_verb |

## Naming Convention

```
screen_viewed, button_tapped, purchase_completed, error_occurred
```

## PII Protection

```swift
// NEVER: email, phone, name, address, IP
// OK: user_id, email_domain, country, has_phone (bool)
// HASH if needed: SHA256(email) for dedup
```

## Funnel Template

```swift
analytics.track("step_1_viewed")
analytics.track("step_2_started")
analytics.track("step_3_completed", ["value": amount])
analytics.track("step_abandoned", ["at_step": step])
```

## Error Tracking

```swift
analytics.track("operation_failed", [
    "error_type": String(describing: type(of: error)),
    "context": context
])
```

## I/O

Input: JSON per `_shared/finding-schema.md`
Severity: `_shared/severity.md`
Patterns: `_shared/code-patterns.md` (ANAL-001, ANAL-002, ANAL-003)
