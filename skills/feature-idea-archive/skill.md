---
name: feature-idea-archive
description: Archive/restore features.
user_invocable: true
---

# /feature-idea archive

Archive or restore features. See `_reference.md` for schemas.

## Args

```
archive <id...> [--reason "X"]
archive --status=X --older-than=Nd
archive --restore <id>
archive --list
archive --purge <id>
```

## Filters

| Filter | Description |
|--------|-------------|
| `--older-than=Nd/w/m` | Age threshold |
| `--status=X` | Status filter |
| `--label=X` | Label filter |
| `--no-activity=Nd` | Stale filter |

## Behavior

**Archive:**
1. Verify not already archived
2. Prompt reason (optional)
3. Update status=archived, add to statusHistory
4. Sync: add label, close issue, comment

**Restore:**
1. Verify is archived
2. Prompt new status (idea/exploring/ready)
3. Sync: remove archived label, add new label, reopen

**Purge:**
1. Verify archived
2. Require "DELETE" confirmation
3. Remove from features.json

## Output

```
📦 Archived: feat-001
   Reason: Superseded by newer approach
   GitHub: #142 (closed)

   Restore: /feature-idea archive --restore feat-001
```
