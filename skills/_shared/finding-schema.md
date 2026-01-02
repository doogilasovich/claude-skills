# Finding Schema

Canonical JSON format for all inter-skill communication.

## Single Finding

```json
{
  "id": "memory-001",
  "category": "memory",
  "severity": "high",
  "title": "Retain cycle in closure",
  "file": "ViewModel.swift",
  "line": 34,
  "code": "onComplete = { self.data = $0 }",
  "impact": "Memory leak on each view load",
  "recommendation": "Use [weak self] capture list"
}
```

## Review Output (from review-* skills)

```json
{
  "category": "memory",
  "filesScanned": 12,
  "issues": [/* array of findings */]
}
```

## Consolidated Report (from comprehensive-code-audit)

```json
{
  "timestamp": "2025-12-30T10:30:00Z",
  "summary": {"total": 23, "critical": 2, "high": 5, "medium": 12, "low": 4},
  "findings": [/* array of findings, sorted by severity */]
}
```

## Fix Result (from fix-* skills)

```json
{
  "id": "memory-001",
  "status": "fixed",
  "changes": [{"file": "ViewModel.swift", "line": 34, "diff": "..."}]
}
```

## State File (~/.claude/audit-state.json)

```json
{
  "lastSync": "2025-12-30T10:30:00Z",
  "issues": [{
    "localId": "memory-001",
    "githubNumber": 45,
    "status": "open",
    "fixed": false,
    "fixedAt": null,
    "fixPR": null
  }]
}
```
