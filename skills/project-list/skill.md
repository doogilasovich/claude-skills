---
name: project-list
description: List all projects from the global index.
---

# /project list

Lists all projects from the global index.

## Usage

```bash
/project list
/project list --status=active
/project list --sort=health
/project list --format=json
```

## Args

| Arg | Default | Description |
|-----|---------|-------------|
| --status | all | Filter: active, maintenance, archived, sunset |
| --sort | recent | Sort: recent, name, features, health |
| --format | table | Output: table, json, compact |
| --refresh | false | Re-scan for projects before listing |

## Resolution

Reads from `~/.claude/projects/index.json`. No project context needed.

## Behavior

1. Load index.json (run discovery if missing or --refresh)
2. Validate each project path exists (mark missing with ⚠️)
3. Enrich with current stats from each project.json
4. Apply --status filter
5. Apply --sort order
6. Render in --format

## Discovery (if index missing)

Scans per `_reference.md#project-detection-weights`:
- ~/.claude/features/projects/*/
- ~/code/**/.claude/project.json (depth 2)

## Output

Per `_reference.md#list-project-list`.

```
NAME            STATUS    FEATURES    AUDIT   LAST ACTIVE
──────────────────────────────────────────────────────────
CameraTest      🟢 active    35 (3 🚧)   8.5    2 hours ago
echostack       🟢 active     5 (0 🚧)    —     just now
swift-agents    🟢 active     0           —     1 day ago

3 projects (3 active)
```

### Compact (--format=compact)

```
🟢 CameraTest (35 features, 8.5 health)
🟢 echostack (5 features)
🟢 swift-agents (no features)
```

### JSON (--format=json)

```json
{
  "projects": [{ "name": "CameraTest", "status": "active", ... }],
  "total": 3,
  "byStatus": { "active": 3 }
}
```

## Empty State

```
No projects found.

Create: /project create MyApp
Migrate: /project migrate --discover
```

## Errors

E05, E07 - see `_reference.md#error-codes`
