---
name: feature-idea-offline
description: Manage offline queue and sync.
user_invocable: true
---

# /feature-idea offline

Manage offline queue. See `_reference.md` for schemas.

## Args

```
offline              # Status
offline --queue      # View pending/failed
offline --retry      # Retry failed
offline --clear-failed
offline --force      # Force offline mode
offline --online     # Resume online
```

## Queue Storage

`~/.claude/features/offline-queue.json`:
```json
{
  "mode": "auto",
  "lastOnline": "ISO",
  "pending": [{"id":"op-X","type":"create","featureId":"feat-X","data":{},"queuedAt":"ISO","retries":0}],
  "failed": [{"id":"op-Y","error":"msg","failedAt":"ISO","retries":3}]
}
```

## Operation Types

create, status, edit, label, close, reopen, comment, board

## Behavior

**Auto-queue:** All commands check connectivity. On failure:
1. Queue operation
2. Set `dirty: true`
3. Notify user

**Auto-sync on reconnect:**
1. Check `gh auth status`
2. Process queue in order
3. Handle conflicts (prompt L/R/S)
4. Report results

## Retry Policy

- Max retries: 3
- Backoff: 1s, 5s, 30s
- After 3 fails: move to failed queue

## Conflict Resolution

Last-write-wins default. If remote changed since lastSync, prompt:
- [L] Keep local
- [R] Keep remote
- [S] Skip

## Output

```
📴 Status: Offline
   Pending: 5 operations
   Failed: 2 operations
```
