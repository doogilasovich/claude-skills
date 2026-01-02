---
name: feature-idea-status
description: Change feature status.
user_invocable: true
---

# /feature-idea status

Update lifecycle status. See `_reference.md` for valid statuses/transitions.

## Args

```
status <id> <new-status>
```

## Behavior

1. Load feature by ID
2. Validate transition allowed (see `_reference.md` transitions table)
3. Prompt: "Reason (optional):"
4. Update: status, statusHistory, updatedAt, dirty=true
5. Sync to GitHub if has issue:
   - `gh issue edit N --remove-label "status:{old}" --add-label "status:{new}"`
   - If archived: `gh issue close N`
   - If unarchived: `gh issue reopen N`
6. Move project board card if configured
7. Save, set dirty=false

## Output

```
📊 Status updated: feat-001
   💡 idea → 🔍 exploring
   Reason: Starting research
✅ Synced to GitHub #322
✅ Card moved to "Exploring"
```

Invalid transition → show allowed targets.
