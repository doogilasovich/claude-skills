---
name: review-user-metrics
description: Reviews missing events, PII exposure, naming, incomplete funnels.
---

# User Metrics Reviewer

Identify gaps and issues in analytics tracking.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| No analytics on user action | high |
| `["email": user.email]` PII exposed | critical |
| Mixed naming `userLogin` vs `user_login` | medium |
| Only first/last funnel event | high |
| No tracking in catch block | medium |
| `analytics.track("purchase")` no value | critical |

## Red Flags

- **Never track raw PII**: email, phone, name, address, IP, device ID
- Inconsistent naming conventions
- Missing funnel steps
- Revenue events without value
