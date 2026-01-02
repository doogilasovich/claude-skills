---
name: project-switch
description: Set the active project context for subsequent commands.
---

# /project switch

Sets the active project context. Subsequent commands use this project when not in a project directory.

## Usage

```bash
/project switch CameraTest    # Switch to CameraTest
/project switch swift         # Partial name match
/project switch               # Show current project
```

## Args

| Arg | Required | Description |
|-----|----------|-------------|
| name | No | Project name or partial match. If omitted, shows current. |

## Resolution

Per `_reference.md#project-resolution-order`, plus:
- Supports partial name matching (case-insensitive)
- Errors on multiple matches (E06)

## Behavior

1. **If no name**: Show current active project
2. **Find project**: Exact match, then partial match
3. **Check initialization**: Verify `.claude/project.json` exists
4. **Update context**: Write to ~/.claude/projects/active.json
5. **Update index**: Set lastAccessed
6. **Change working directory**: `cd` to project path
7. **Confirm**: Show project summary with new working directory
8. **If not initialized**: Show setup suggestion

## Active Project File

```json
// ~/.claude/projects/active.json
{
  "name": "CameraTest",
  "path": "/Users/dmccoy/code/git-personal/CameraTest",
  "switchedAt": "2026-01-02T05:00:00Z"
}
```

## Context Priority

When commands need a project:
1. Explicit `--project=X` argument
2. Current directory has .claude/project.json
3. Active project from active.json
4. Prompt to select

## Output

### Show Current

```
📍 Active: FlipTalk (CameraTest)
   Path: ~/code/git-personal/CameraTest

   Available: CameraTest, echostack, swift-agents
   Switch: /project switch <name>
```

### Switch Success

```
✅ Switched to: FlipTalk (CameraTest)

   Features: 35 (3 in-progress)
   Audit: 8.5/10

   📂 Changed directory to: ~/code/git-personal/CameraTest
   Commands now target this project.
```

### Switch to Uninitialized Project

```
✅ Switched to: my-new-project

   ⚠️  No Claude session found (.claude/project.json missing)

   📂 Changed directory to: ~/code/my-new-project

   To initialize project management:
   ~/code/claude-skills/templates/project-init.sh .

   Or manually create .claude/project.json
```

## Working Directory

The switch command changes the current working directory to the project path:

```bash
# Before: ~/code/other-project
/project switch CameraTest
# After: ~/code/git-personal/CameraTest (cwd changed)
```

This ensures:
- Relative paths work correctly for the new project
- Git commands operate on the correct repo
- Build/test commands run in the right context

## Session Detection

A project is considered "initialized" if it has `.claude/project.json`. This file:
- Stores project metadata (name, displayName, status)
- Tracks feature statistics
- Records audit history
- Links to origin (app-idea reference)

Without this file, project management commands (`/feature-idea`, `/audit`, `/project view`) won't work properly.

### Initialization Check

On switch, the skill checks:
```bash
if [ ! -f "$PROJECT_PATH/.claude/project.json" ]; then
  # Show initialization suggestion
fi
```

### Quick Initialize

```bash
# From project directory
~/code/claude-skills/templates/project-init.sh .

# Creates:
# .claude/project.json
# .claude/features.json
# .claude/audit/cache/
# .claude/audit/reports/
# .github/workflows/feature-auto-ship.yml
# .github/workflows/scheduled-audit.yml
```

## Errors

E01, E06 - see `_reference.md#error-codes`
