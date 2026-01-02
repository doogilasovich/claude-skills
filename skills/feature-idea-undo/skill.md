---
name: feature-idea-undo
description: Undo recent operations.
user_invocable: true
---

# /feature-idea undo

Undo recent feature operations. See `_reference.md` for schemas.

## Args

```
undo                    # Undo last operation
undo --list             # Show undo history
undo --id=op-XXX        # Undo specific operation
undo feat-001           # Undo last op on feature
```

## Storage

`~/.claude/features/history.json` - keeps last 50 operations.

## Behavior

**Record (automatic):** Before any mutation (create, update, delete, status):
1. Generate op-UUID
2. Snapshot `before` state (null for create)
3. Perform operation
4. Snapshot `after` state
5. Append to history, trim to 50

**Undo:**
1. Find operation in history
2. Verify not already undone
3. Restore `before` state to features.json
4. If synced to GitHub, queue reverse operation
5. Mark operation as undone

**Limitations:**
- Cannot undo: purge (permanent), shipped→archived after PR merged
- GitHub sync best-effort (issue may have manual edits)

## Undoable Operations

| Type | Undo Action |
|------|-------------|
| create | Delete feature |
| delete | Restore feature |
| status | Restore previous status |
| edit | Restore previous values |
| archive | Restore + reopen issue |
| label | Restore previous labels |

## Flags

| Flag | Description |
|------|-------------|
| `--list` | Show recent operations |
| `--id=X` | Undo specific operation |
| `--force` | Skip confirmation |
| `--no-sync` | Don't sync undo to GitHub |

## Output

```
↩️ Undo: status change
   feat-001: in-progress → ready
   GitHub: #322 labels updated

   Redo not available (history is linear)
```

**List output:**
```
📜 Undo History (last 10)

  #  Time          Type     Feature    Change
  ────────────────────────────────────────────────
  1  2 min ago     status   feat-001   idea → exploring
  2  5 min ago     edit     feat-002   title changed
  3  1 hour ago    create   feat-003   (new feature)

  Undo: /feature-idea undo
  Undo specific: /feature-idea undo --id=op-XXX
```
