# Project Mismatch Hook

Warns when the current working directory doesn't match the active project.

## Trigger

- Event: `UserPromptSubmit`
- Runs: Before each user prompt is processed

## Purpose

When you switch projects with `/project switch`, the active project is stored globally. If you later `cd` to a different directory (or open a new terminal), this hook warns you about the mismatch.

## Output

```
┌─ Project Mismatch ─────────────────────────────────────────┐
│
│  Active project: FlipTalk
│  Active path:    /Users/you/code/CameraTest
│
│  Current dir:    /Users/you/code/other-project
│  Current project: OtherProject
│
│  Options:
│  • /project switch <name>  - switch to current directory's project
│  • cd /Users/you/code/CameraTest
│
└────────────────────────────────────────────────────────────┘
```

## Configuration

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/project-mismatch-check.sh"
          }
        ]
      }
    ]
  }
}
```

## Behavior

1. Reads active project from `~/.claude/projects/active.json`
2. Compares active project path with current working directory
3. If mismatch detected:
   - Shows warning box with both paths
   - If cwd is a managed project, shows its name
   - Suggests fix options

## No-op Cases

The hook exits silently (no output) when:
- No active project file exists
- No active project is set
- Current directory matches active project path

## Related

- `/project switch` - Switch active project and cd to its directory
- `session-start.md` - Session startup checks
