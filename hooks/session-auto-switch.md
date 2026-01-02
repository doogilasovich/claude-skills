# Session Auto-Switch Hook

Automatically switches active project to match the current working directory when Claude starts.

## Trigger

- Event: `SessionStart`
- Runs: Once when Claude Code session begins

## Purpose

Eliminates manual `/project switch` commands. When you `cd` to a project and run `claude`, the hook automatically sets that project as active.

## Output

When switching occurs:
```
┌─ Auto-Switched Project ──────────────────────────────────────┐
│
│  Detected: FlipTalk
│  Path: /Users/you/code/CameraTest
│
│  (was: EchoStack)
│
│  Active project now matches working directory.
│
└───────────────────────────────────────────────────────────────┘
```

Silent when:
- Not in a managed project (no `.claude/project.json`)
- Already matched (cwd = active project path)

## Configuration

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/session-auto-switch.sh"
          }
        ]
      }
    ]
  }
}
```

## Behavior

1. Check if `.claude/project.json` exists in cwd
2. Read current project name from that file
3. Compare with active project in `~/.claude/projects/active.json`
4. If different:
   - Update `active.json` with cwd project
   - Update `index.json` activeProject field
   - Show notification

## Workflow

```bash
# Terminal
cd ~/code/my-project
claude

# Claude starts, hook runs:
# "Auto-Switched Project: MyProject"
# No mismatch warnings, ready to work
```

## Related

- `project-mismatch-check.sh` - Warns on mismatch (fallback, runs on each command)
- `/project switch` - Manual switching (rarely needed now)
- `project-init.sh` - Initialize new projects
