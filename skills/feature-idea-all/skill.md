---
name: feature-idea-all
description: View features across all projects.
user_invocable: true
---

# /feature-idea all

View and search features across all projects. See `_reference.md` for schemas.

## Args

```
all                             # List all features, all projects
all --status=idea               # Filter by status
all --label=audio               # Filter by label
all --search="query"            # Search across all
all --stats                     # Show statistics
```

## Behavior

1. Scan `~/.claude/features/projects/*/features.json`
2. Aggregate all features with project context
3. Apply filters
4. Display grouped by project or flat

## Views

**Default (grouped):**
```
📁 All Features (12 total across 3 projects)

CameraTest (5 features)
  ID        Status       Title
  ────────────────────────────────────
  feat-001  💡 idea      Phoneme scoring
  feat-002  💡 idea      Comparison screen
  ...

MyOtherApp (4 features)
  feat-001  🚀 shipped   OAuth login
  feat-002  🚧 progress  Dark mode
  ...
```

**Flat (with --flat):**
```
Project      ID        Status       Title
─────────────────────────────────────────────────
CameraTest   feat-001  💡 idea      Phoneme scoring
CameraTest   feat-002  💡 idea      Comparison screen
MyOtherApp   feat-001  🚀 shipped   OAuth login
...
```

**Stats:**
```
📊 Feature Statistics

Projects: 3
Total features: 12

By Status:
  💡 idea:        5 (42%)
  🔍 exploring:   2 (17%)
  🚧 in-progress: 3 (25%)
  🚀 shipped:     2 (17%)

By Project:
  CameraTest:   5 features
  MyOtherApp:   4 features
  WebTool:      3 features

Oldest idea: feat-001 (CameraTest) - 30 days
Most active: MyOtherApp - 3 changes today
```

## Flags

| Flag | Description |
|------|-------------|
| `--status=X` | Filter by status |
| `--label=X` | Filter by label |
| `--search="X"` | Full-text search |
| `--flat` | Flat list (no grouping) |
| `--stats` | Show statistics |
| `--project=X` | Limit to project |
| `--sort=created/updated/status` | Sort order |

## Cross-Project Operations

For operations on specific features, use full path:
```
/feature-idea view CameraTest:feat-001
/feature-idea status MyOtherApp:feat-002 ready
```

Or cd to project directory and use normal commands.

## Output

Respects same output format as `/feature-idea list`.
