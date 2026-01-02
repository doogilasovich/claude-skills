---
name: feature-idea-board
description: Manage GitHub Project board.
user_invocable: true
---

# /feature-idea board

Project board management. See `_reference.md` for gh commands.

**Requires:** `gh auth refresh -s project,read:project`

## Args

| Flag | Action |
|------|--------|
| (none) | Open board in browser |
| --create | Create "Feature Backlog" board |
| --sync | Sync all features to board |
| --status | Show board statistics |

## Behavior

1. Get owner: `gh repo view --json owner -q '.owner.login'`
2. Find board: `gh project list --owner {o} --format json` (look for "Feature Backlog")

**--create:**
```bash
gh project create --owner {o} --title "Feature Backlog"
gh project field-create {n} --owner {o} --name "Status" --data-type "SINGLE_SELECT" \
  --single-select-options "Idea,Exploring,Designing,Ready,In Progress,Shipped,Archived"
```

**--sync:** For each feature with issue:
```bash
gh project item-add {n} --owner {o} --url "{issue-url}"
gh project item-edit --project-id {p} --id {i} --field-id {f} --single-select-option-id {s}
```

## Storage

Board info cached in features.json under `githubProject`:
```json
{"number": 5, "id": "PVT_...", "statusFieldId": "PVTSSF_...", "statusOptions": {...}}
```

## Output

```
✅ Created: Feature Backlog
   URL: https://github.com/users/.../projects/5
   Columns: Idea, Exploring, Designing, Ready, In Progress, Shipped, Archived
```
