---
name: review-testing
description: Reviews coverage gaps, flaky tests, missing edge cases.
---

# Testing Reviewer

Identify testing gaps that allow regressions.

**Output: JSON** per `_shared/finding-schema.md`

## Checklist

| Pattern | Severity |
|---------|----------|
| No tests for business logic | high |
| `XCTAssert(true)` meaningless assertion | high |
| Test uses real network | high |
| No edge case tests | medium |
| Test verifies implementation not behavior | medium |
| Shared mutable state in tests | high |

## Red Flags

- Public methods without corresponding tests
- Tests that pass when logic is broken
- Tests dependent on external services
- No async/error testing
