---
name: feature-idea
description: Feature tracker. Commands: list, log, view, status, edit, search, sync, implement, pr, ship, board, archive, bulk, deps, offline, undo, export, all.
user_invocable: true
---

# /feature-idea

Router for feature tracking commands. See `_reference.md` for shared schemas and validation rules.

## Commands

| Cmd | Args | Action |
|-----|------|--------|
| list | [--status=X] [--label=X] | Show features table |
| log | \<title\> [--desc] [--labels] | Create feature |
| view | \<id\> | Show detail |
| status | \<id\> \<status\> | Change status |
| edit | \<id\> [--title] [--desc] [--labels] [--note] | Modify |
| search | \<query\> [--status] [--label] | Find features |
| sync | [--push\|--pull] [--dry-run] | GitHub sync |
| pipeline | \<id\> [--auto] [--watch] | Full lifecycle (implement → pr → ship) |
| implement | \<id\> | Branch + plan + context |
| pr | \<id\> | Create PR |
| ship | \<id\> | Mark shipped post-merge |
| board | [--create\|--sync\|--status] | Project board |
| archive | \<id\> [--restore] [--purge] | Archive/restore |
| bulk | [filters] --set-X | Batch operations |
| deps | \<id\> [--needs\|--graph\|--ready] | Dependencies |
| offline | [--queue\|--retry] | Offline queue |
| undo | [--list\|--id=X] | Undo recent operations |
| export | [--file\|--format\|backup\|import] | Export/backup/import |
| all | [--status\|--stats] | Cross-project view |

## Validation

Before any operation, validate per `_reference.md#Validation`:
- Feature ID format: `feat-NNN`
- Status is valid enum
- Status transition is allowed
- Feature exists (for mutations)
- Title length 3-200 chars

On validation failure, show error and suggestion.

## Routing

Parse first arg as command, delegate to `feature-idea-{cmd}` skill behavior.

No args or `help` → show this table.
