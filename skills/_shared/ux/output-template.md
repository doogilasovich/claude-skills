# UX Audit Output Template

Standard format for UX audit reports.

## Issue Table

```markdown
| Location | Issue | Severity | Fix Effort | Priority |
|----------|-------|----------|------------|----------|
| ScreenName | Description | High/Med/Low | Hours/Days | P0-P3 |
```

## Checklist Format

```markdown
### [Category] Audit
- [ ] Item passes
- [x] Item checked and passed
- Issue: [Description of failure]
```

## Score Card

```markdown
### [Dimension] Score: X/10
[1-2 sentence justification]
```

## Recommendations Section

```markdown
### Quick Wins (< 1 day)
1. **[What]**: [Specific change] → [Expected impact]

### Strategic Improvements (> 1 week)
1. **[What]**: [Approach] → [Expected impact]
```

## Severity Definitions

| Severity | User Impact | Examples |
|----------|-------------|----------|
| Critical | Blocking/data loss | Crashes, security holes |
| High | Major functionality broken | Core flow blocked |
| Medium | Degraded experience | Confusing, slow |
| Low | Minor annoyance | Polish issues |
