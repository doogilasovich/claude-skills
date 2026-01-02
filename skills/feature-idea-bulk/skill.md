---
name: feature-idea-bulk
description: Bulk operations on features.
user_invocable: true
---

# /feature-idea bulk

Apply operations to multiple features. See `_reference.md` for schemas.

## Args

```
bulk <id,id,...> --set-status=X
bulk --status=X --set-status=Y
bulk --status=X --add-label=Y
bulk --dirty --sync
```

## Selection

| Filter | Description |
|--------|-------------|
| `--status=X` | By status |
| `--label=X` | By label |
| `--priority=X` | By priority |
| `--older-than=Nd` | By age |
| `--no-activity=Nd` | By staleness |
| `--dirty` | Pending sync |
| `--has-pr/--no-pr` | PR state |

## Operations

| Operation | Description |
|-----------|-------------|
| `--set-status=X` | Change status |
| `--add-label=X` | Add label |
| `--remove-label=X` | Remove label |
| `--set-priority=X` | Change priority |
| `--archive` | Archive features |
| `--sync` | Sync to GitHub |

## Behavior

1. Parse selection (IDs or filters)
2. Find matching features
3. Preview changes, confirm if >5
4. Apply operation to each
5. Sync to GitHub
6. Report results

## Flags

| Flag | Description |
|------|-------------|
| `--dry-run` | Preview only |
| `--force` | Skip confirmation |
| `--reason "X"` | Reason for changes |
| `--no-sync` | Skip GitHub sync |

## Output

```
✅ Bulk complete: add-label 'sprint-1'
   Updated: 7 features
   Synced: 7
```
