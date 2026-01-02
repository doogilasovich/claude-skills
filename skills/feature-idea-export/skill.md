---
name: feature-idea-export
description: Export, backup, and import features.
user_invocable: true
---

# /feature-idea export

Export and backup features. See `_reference.md` for schemas.

## Args

```
export                          # Export current project to stdout
export --file=path.json         # Export to file
export --format=md              # Export as markdown
export --all                    # Export all projects

backup                          # Create timestamped backup
backup --list                   # List backups
backup --restore=file.json      # Restore from backup

import file.json                # Import features from file
import --url=gist-url           # Import from GitHub gist
```

## Backup Location

`~/.claude/features/backups/{project}-{YYYYMMDD-HHMMSS}.json`

## Behavior

**Export:**
1. Load project features.json
2. Format as JSON (default) or markdown
3. Output to stdout or file

**Backup:**
1. Create backups/ directory if needed
2. Copy features.json with timestamp
3. Keep last 10 backups per project, prune older

**Auto-backup:** Before destructive operations (bulk archive, purge), auto-backup is created.

**Restore:**
1. Verify backup file exists
2. Confirm with user (shows diff summary)
3. Replace features.json
4. Mark all as dirty for GitHub resync

**Import:**
1. Parse source file
2. Merge or replace (prompt user)
3. Assign new IDs if conflicts
4. Mark as dirty for sync

## Export Formats

**JSON (default):**
```json
{
  "exportedAt": "ISO",
  "project": "CameraTest",
  "version": "1.0",
  "features": [...]
}
```

**Markdown:**
```markdown
# CameraTest Features

## feat-001: Phoneme scoring
- Status: idea
- Labels: audio, ml
- Description: ...

## feat-002: Comparison screen
...
```

## Flags

| Flag | Description |
|------|-------------|
| `--file=X` | Output to file |
| `--format=json/md` | Output format |
| `--all` | All projects |
| `--list` | List backups |
| `--restore=X` | Restore backup |
| `--merge` | Merge on import (vs replace) |

## Output

```
💾 Backup created
   File: ~/.claude/features/backups/CameraTest-20260101-120000.json
   Features: 5
   Size: 12KB

   Backups kept: 3 (oldest auto-pruned)
```
