# Feature Idea System Reference

Shared definitions for all feature-idea skills. Skills reference this file - do not duplicate.

## Paths

### Local-First (Preferred)

```
{repo}/.claude/
├── project.json                     # Project metadata (has features.stats)
└── features.json                    # Project features (source of truth)
```

### Global (Legacy/Fallback)

```
~/.claude/features/
├── config.json                      # Global config
├── offline-queue.json               # Pending operations
├── history.json                     # Undo history (last 50 ops)
├── backups/                         # Auto-backups
│   └── {project}-{timestamp}.json
└── projects/{project}/
    └── features.json                # Legacy location
```

## Path Resolution

When loading features, use local-first resolution:

```
1. If cwd has .claude/project.json:
   → Use {cwd}/.claude/features.json

2. Else if ~/.claude/projects/active.json exists:
   → Use {active.path}/.claude/features.json

3. Else fall back to global:
   → ~/.claude/features/projects/{name}/features.json

4. If none found:
   → Prompt to create project or use /project migrate
```

## Project Stats Update

After any feature mutation, update project.json:

```json
// In project.json
{
  "features": {
    "file": "features.json",
    "stats": {
      "total": 5,
      "byStatus": {
        "idea": 2,
        "in-progress": 1,
        "shipped": 2
      }
    },
    "lastUpdated": "2026-01-02T06:00:00Z"
  }
}
```

Update logic:
1. Count features by status
2. Update project.json.features.stats
3. Update project.json.features.lastUpdated
4. Update project.json.updatedAt

## Feature Schema

```json
{
  "id": "feat-NNN",
  "title": "string",
  "description": "string",
  "status": "status_enum",
  "statusHistory": [{"from": "status|null", "to": "status", "at": "ISO", "reason": "string?"}],
  "labels": ["string"],
  "dependencies": [{"id": "feat-X", "type": "needs|relates-to|supersedes", "addedAt": "ISO"}],
  "dependents": ["feat-X"],
  "relatedFiles": ["path"],
  "relatedFeatures": ["feat-X"],
  "conversationContext": {
    "capturedAt": "ISO",
    "summary": "string",
    "codeSnippets": [{"file": "path", "lines": "N-M", "purpose": "string"}],
    "decisions": ["string"],
    "alternatives": ["string"],
    "references": ["url"]
  },
  "notes": [{"text": "string", "at": "ISO"}],
  "branch": "string|null",
  "pullRequest": "url|null",
  "implementationPlan": "object|null",
  "createdAt": "ISO",
  "updatedAt": "ISO",
  "githubIssueNumber": "int|null",
  "githubIssueUrl": "url|null",
  "syncedAt": "ISO|null",
  "dirty": "bool"
}
```

## Validation

### Feature ID
- Format: `feat-NNN` (3+ digits, zero-padded)
- Regex: `^feat-\d{3,}$`
- Error: "Invalid feature ID. Use format: feat-001"

### Status
- Valid: idea, exploring, designing, ready, in-progress, shipped, archived
- Error: "Invalid status. Valid: idea, exploring, designing, ready, in-progress, shipped, archived"

### Transitions
Check allowed transitions before status change:
```
idea        → exploring, designing, ready, archived
exploring   → idea, designing, ready, archived
designing   → exploring, ready, archived
ready       → designing, in-progress, archived
in-progress → ready, shipped, archived
shipped     → archived
archived    → idea
```
Error: "Cannot transition from {from} to {to}. Allowed: {allowed}"

### Feature Exists
Before any operation on feat-ID, verify it exists in features.json.
Error: "Feature {id} not found"

### Title
- Min: 3 chars, Max: 200 chars
- Error: "Title must be 3-200 characters"

## Status

| Key | Emoji | Transitions To |
|-----|-------|----------------|
| idea | 💡 | exploring, designing, ready, archived |
| exploring | 🔍 | idea, designing, ready, archived |
| designing | 📐 | exploring, ready, archived |
| ready | ✅ | designing, in-progress, archived |
| in-progress | 🚧 | ready, shipped, archived |
| shipped | 🚀 | archived |
| archived | 📦 | idea |

## Priority Labels

p0=critical, p1=high, p2=medium, p3=low

## Label Keywords

```
ui: button, screen, view, layout, animation, modal, swiftui
ux: flow, onboarding, friction, delight, haptic
performance: slow, optimize, cache, memory, battery
audio: sound, voice, speech, phoneme, mic
video: camera, record, playback, frame, codec
ml: model, coreml, inference, ai
network: api, fetch, sync, offline
social: share, challenge, friend, viral
```

## Project Detection

| Files | Type |
|-------|------|
| .xcodeproj, .xcworkspace | ios |
| Package.swift | swift |
| package.json | node |
| Cargo.toml | rust |
| go.mod | go |
| pyproject.toml | python |

## GitHub Labels Setup

On first sync, create required labels:
```bash
# Core label
gh label create "feature-idea" --color "1D76DB" --description "Tracked feature idea" 2>/dev/null || true

# Status labels
gh label create "status:idea" --color "FBCA04" 2>/dev/null || true
gh label create "status:exploring" --color "D4C5F9" 2>/dev/null || true
gh label create "status:designing" --color "C5DEF5" 2>/dev/null || true
gh label create "status:ready" --color "0E8A16" 2>/dev/null || true
gh label create "status:in-progress" --color "006B75" 2>/dev/null || true
gh label create "status:shipped" --color "5319E7" 2>/dev/null || true
gh label create "status:archived" --color "EEEEEE" 2>/dev/null || true

# Priority labels
gh label create "p0" --color "B60205" --description "Critical" 2>/dev/null || true
gh label create "p1" --color "D93F0B" --description "High" 2>/dev/null || true
gh label create "p2" --color "FBCA04" --description "Medium" 2>/dev/null || true
gh label create "p3" --color "0E8A16" --description "Low" 2>/dev/null || true
```

Store in config.json: `{"labelsCreated": true, "labelsCreatedAt": "ISO"}`

## GitHub Commands

```bash
# Auth check
gh auth status

# Repo info
gh repo view --json nameWithOwner -q '.nameWithOwner'

# Issue ops
gh issue create --title "T" --body "B" --label "L"
gh issue edit N --title "T" --body "B"
gh issue edit N --add-label "L" --remove-label "L"
gh issue close N
gh issue reopen N
gh issue comment N --body "B"
gh issue list --label "feature-idea" --state all --json number,title,body,labels,state,updatedAt

# Labels
gh label create "name" --color "hex" 2>/dev/null || true

# Project board (requires: gh auth refresh -s project,read:project)
gh project list --owner O --format json
gh project create --owner O --title "Feature Backlog"
gh project item-add N --owner O --url "URL"
gh project item-edit --project-id P --id I --field-id F --single-select-option-id S
```

## Undo History Schema

```json
{
  "operations": [
    {
      "id": "op-UUID",
      "type": "create|update|delete|status",
      "featureId": "feat-X",
      "timestamp": "ISO",
      "before": { "...snapshot" },
      "after": { "...snapshot" },
      "undone": false
    }
  ],
  "maxHistory": 50
}
```

## Offline Queue Schema

```json
{
  "mode": "auto|force-offline|online",
  "lastOnline": "ISO",
  "pending": [{"id": "op-N", "type": "create|status|edit|label|close|reopen", "featureId": "feat-X", "data": {}, "queuedAt": "ISO", "retries": 0}],
  "failed": [{"id": "op-N", "type": "T", "featureId": "feat-X", "error": "string", "failedAt": "ISO", "retries": 3}]
}
```

## Output Formats

Use terse internal format. Only format for final user output:

```
# Success
✅ {action}: {id}
   {details}

# Error
❌ {error}
   {suggestion}

# Warning
⚠️ {warning}

# Info
ℹ️ {info}

# List table
ID        Status      Title                    Labels
──────────────────────────────────────────────────────
feat-001  💡 idea     Title here               label1, label2
```
