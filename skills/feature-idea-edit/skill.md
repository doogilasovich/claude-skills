---
name: feature-idea-edit
description: Modify feature details.
user_invocable: true
---

# /feature-idea edit

Modify feature fields. See `_reference.md` for schemas.

## Args

```
edit <id> [flags]
```

| Flag | Action |
|------|--------|
| --title "X" | Set title |
| --description "X" | Set description |
| --labels a,b | Replace labels |
| --add-label X | Add label |
| --remove-label X | Remove label |
| --priority p0-p3 | Set priority |
| --note "X" | Add timestamped note |
| --depends feat-X | Add dependency |
| --add-file path | Add related file |

No flags → interactive menu.

## Behavior

1. Load feature by ID
2. Apply changes (interactive or flags)
3. Validate: title required, deps must exist
4. Update updatedAt, set dirty=true
5. Save to features.json
6. Sync to GitHub if has issue: `gh issue edit N --title --body`
7. Set dirty=false

## Output

```
✅ Updated feat-001
   Changed: title, labels
   Synced to GitHub #322
```
