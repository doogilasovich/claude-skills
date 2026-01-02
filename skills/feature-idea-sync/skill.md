---
name: feature-idea-sync
description: Sync with GitHub Issues.
user_invocable: true
---

# /feature-idea sync

Bidirectional GitHub sync. See `_reference.md` for gh commands and label setup.

## Args

| Flag | Action |
|------|--------|
| --push | Local → GitHub only |
| --pull | GitHub → local only |
| --dry-run | Preview only |
| --process-queue | Queue only |
| --retry-failed | Retry failed ops |
| --setup-labels | Create labels only |

## Behavior

1. Check `gh auth status`
2. **First sync: Create labels** (see `_reference.md#GitHub Labels Setup`)
   - Check config.json for `labelsCreated`
   - If false/missing, run all `gh label create` commands
   - Set `labelsCreated: true` in config.json
3. Load local features
4. Fetch remote: `gh issue list --label "feature-idea" --state all --json ...`
5. **Sync logic (last-write-wins):**
   - dirty=true, no issue → create issue
   - dirty=true, has issue → push update
   - remote newer than syncedAt → pull update
   - remote not in local → import
6. Update dirty=false, syncedAt
7. Process offline queue if exists
8. **Auto-backup before destructive sync** (if pulling would overwrite local)

## Label Creation

First sync creates these labels (idempotent via `2>/dev/null || true`):
- `feature-idea` (blue) - core tracking label
- `status:idea`, `status:exploring`, `status:designing`, `status:ready`, `status:in-progress`, `status:shipped`, `status:archived`
- `p0`, `p1`, `p2`, `p3` - priority labels

## Offline Queue

Network failure → queue to `offline-queue.json`, keep dirty=true.
Next sync → process queue first, handle conflicts (prompt L/R/S).

## Output

```
🔄 Syncing...
  🏷️ Labels created (first sync)
  ↑ feat-001 → #322
  ↓ feat-003 ← #325
  + feat-004 (imported)
✅ Complete: 1 pushed, 1 pulled, 1 imported
```
