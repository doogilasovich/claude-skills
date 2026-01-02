---
name: project-migrate
description: Migrate existing features and audit data to unified project system.
---

# /project migrate

Migrates existing data from old system to unified project structure.

## Usage

```bash
/project migrate                # Migrate current directory
/project migrate --discover     # Scan and migrate all found
/project migrate --dry-run      # Preview without changes
/project migrate <name>         # Migrate specific project
```

## Args

| Arg | Default | Description |
|-----|---------|-------------|
| --discover | false | Scan known locations for projects |
| --dry-run | false | Preview changes without writing |
| --force | false | Overwrite existing project.json |
| --no-backup | false | Skip backup creation |

## Resolution

Discovery mode scans; otherwise uses current directory or named project.

## Behavior

### 1. Discovery (--discover)

Scan per `_reference.md#project-detection-weights`:
```
~/.claude/features/projects/*/     → 100% (must migrate)
~/code/**/.claude/audit/           → 80%  (should migrate)
~/code/**/.xcodeproj               → 40%  (candidate)
```

Skip if:
- .claude/project.json exists (already migrated)
- .git is a file (git worktree, not main repo)

### 2. Backup

```
~/.claude/projects/backups/{timestamp}-{name}/
├── features.json.bak
└── manifest.json
```

### 3. Migration Steps

For each project:
1. Detect type (iOS, Swift package, Node, etc.)
2. Detect git info (remote, branch)
3. Create project.json from schema
4. Copy features.json from global to local
5. Read audit scores into project.json
6. Add to index.json

### 4. Dry Run (--dry-run)

```
🔍 Found 3 projects:

1. CameraTest ~/code/git-personal/CameraTest
   Features: 3 (from ~/.claude/features/projects/)
   Audit: 8.5 (from .claude/audit/)
   Status: ready to migrate

2. swift-agents ~/code/git-personal/swift-agents-plugin
   Features: none
   Audit: none
   Status: ready (minimal)

Would create:
• 2 project.json files
• 1 features.json migration
• 1 backup

Run without --dry-run to proceed.
```

## Output

### Success

```
✅ Migration complete

   Migrated: 2 projects
   ├─ CameraTest (full)
   └─ swift-agents (minimal)

   Features: 3 migrated
   Backup: ~/.claude/projects/backups/2026-01-02/

   Next: /project list
```

### Already Migrated

```
⚠️ CameraTest already migrated
   Use --force to overwrite
```

## Rollback

```bash
/project migrate --rollback {backup-timestamp}
```

Restores from backup manifest.

## Errors

E05 - see `_reference.md#error-codes`

Additional:
```
❌ Backup failed: disk full
   Free space or use --no-backup (not recommended)
```
