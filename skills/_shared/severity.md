# Severity Levels

| Level | Code | Description | Examples |
|-------|------|-------------|----------|
| Critical | 4 | Blocking, crashes, data loss | Security vuln, memory corruption, fatalError |
| High | 3 | Significant UX/stability impact | Memory leaks, main thread blocking, data race |
| Medium | 2 | Noticeable degradation | Performance issues, missing error handling |
| Low | 1 | Minor improvements | Readability, code style, potential issues |

## Triage Rules

1. Security vulnerabilities → Critical
2. Data loss risk → Critical
3. Crash risk → Critical/High
4. Memory leaks → High
5. Main thread blocking → High
6. Performance under load → Medium
7. Code quality → Low

## JSON Encoding

```json
{"severity": "critical"}  // or "high", "medium", "low"
```
