---
name: code-fix-orchestrator
description: Dispatches findings to fix specialists, tracks progress.
---

# Code Fix Orchestrator

Coordinates fixes from review findings. Routes to 17 fix specialists (see `_shared/categories.md`).

**Default I/O: JSON** (see `_shared/output-formats.md`)

## Input

JSON array of findings per `_shared/finding-schema.md`:

```json
{"findings": [{"category": "memory", "severity": "high", "file": "X.swift", "line": 45, ...}]}
```

## Process

1. **Sort** by severity: critical → high → medium → low
2. **Group** by file to minimize conflicts
3. **Dispatch** to `/fix-{category}` with finding JSON
4. **Track** result: fixed | skipped | failed
5. **Output** summary JSON

## Dispatch

```
For each finding:
  /fix-{category} <<< {"finding": {...}}
  → {"status": "fixed", "changes": [...]}
```

## Conflict Resolution

- Higher severity first
- Same file: process sequentially
- Dependent fixes: prerequisites first (e.g., memory before performance)

## Output

```json
{
  "fixed": 18,
  "skipped": 3,
  "failed": 2,
  "byCategory": {"memory": 5, "performance": 4},
  "filesModified": ["NetworkManager.swift", "SearchService.swift"]
}
```

## Integration

Invoked by `/comprehensive-code-audit` after consolidation phase.
