---
name: feature-idea-ship
description: Mark shipped after PR merge.
user_invocable: true
---

# /feature-idea ship

Complete feature after merge. See `_reference.md` for schemas.

## Args

```
ship <id> [--force] [--keep-branch]
```

## Prerequisites

- Status: in-progress
- Has pullRequest
- PR merged (skip with --force)

## Behavior

1. Load feature, verify status/PR
2. Check PR merged: `gh pr view {url} --json state,mergedAt`
3. Update: status=shipped, branch=null
4. Sync:
   ```bash
   gh issue edit {n} --remove-label "status:in-progress" --add-label "status:shipped"
   gh issue close {n}
   gh issue comment {n} --body "🚀 Shipped in {pr}"
   ```
5. Cleanup (unless --keep-branch):
   ```bash
   git checkout main && git pull
   git branch -d {branch}
   ```

## Output

```
🚀 Shipped: feat-001
   PR: merged
   Issue: #322 (closed)
   Branch: cleaned up
```
