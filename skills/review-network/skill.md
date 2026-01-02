---
name: review-network
description: Reviews caching, deduplication, retries, offline.
---

# Network Reviewer

Identify inefficient patterns wasting data and battery.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| No URLCache config | high |
| Duplicate in-flight requests | high |
| Retry without backoff | high |
| Fetch all then filter | medium |
| No offline handling | high |
| Sync refresh on launch | high |

## Red Flags

- No caching headers honored
- Same URL requested simultaneously
- Immediate retry on failure
- Full dataset vs pagination
