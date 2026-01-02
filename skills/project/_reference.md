# Project System Reference

Shared definitions for all project skills. Skills reference this file - do not duplicate.

## Paths

```
~/.claude/projects/
├── index.json                    # Global project registry (cache)
├── active.json                   # Current project context
└── backups/                      # Migration backups

{repo}/.claude/
├── project.json                  # Project metadata (source of truth)
├── features.json                 # Features (local-first)
└── audit/                        # Audit data
    ├── state.json
    ├── cache/
    ├── reports/
    └── history.json
```

## Project Schema

```json
{
  "version": "1.0",
  "name": "string",
  "displayName": "string",
  "description": "string|null",

  "origin": {
    "type": "app-idea|manual|import",
    "appIdeaId": "app-NNN|null",
    "createdAt": "ISO",
    "snapshot": "object|null"
  },

  "status": "active|maintenance|archived|sunset",
  "statusHistory": [{ "from": "status|null", "to": "status", "at": "ISO", "reason": "string?" }],

  "repository": {
    "type": "git|none",
    "remote": "string|null",
    "url": "string|null",
    "defaultBranch": "string"
  },

  "features": {
    "file": "features.json",
    "stats": { "total": "int", "byStatus": { "status": "int" } },
    "lastUpdated": "ISO|null"
  },

  "audit": {
    "lastRun": "ISO|null",
    "lastScope": "code|ux|all|null",
    "score": { "code": "float|null", "ux": "float|null" },
    "openIssues": "int",
    "trend": "improving|stable|degrading|null"
  },

  "milestones": [{
    "id": "ms-NNN",
    "name": "string",
    "status": "planned|active|completed|cancelled",
    "target": "ISO|null",
    "features": ["feat-NNN"],
    "progress": "float"
  }],

  "metrics": {
    "velocity": { "current": "float|null", "trend": ["float"] },
    "cycleTime": { "avg": "float|null", "p90": "float|null" }
  },

  "integrations": {
    "github": { "owner": "string|null", "repo": "string|null", "project": "string|null" },
    "revenuecat": { "projectId": "string|null" }
  },

  "createdAt": "ISO",
  "updatedAt": "ISO"
}
```

## Index Schema

```json
{
  "version": "1.0",
  "projects": [{
    "name": "string",
    "displayName": "string",
    "path": "absolute_path",
    "status": "status_enum",
    "lastAccessed": "ISO",
    "origin": { "type": "string", "ref": "string|null" },
    "quickStats": {
      "features": { "open": "int", "shipped": "int" },
      "auditScore": "float|null"
    }
  }],
  "lastScan": "ISO"
}
```

## Status Transitions

| Status | Emoji | Transitions To |
|--------|-------|----------------|
| active | 🟢 | maintenance, archived, sunset |
| maintenance | 🟡 | active, archived, sunset |
| archived | 📦 | active |
| sunset | 🌅 | (terminal) |

## Project Resolution Order

All project commands resolve context using this priority:

```
1. Explicit argument    → --project=Name or positional arg
2. Current directory    → .claude/project.json exists in cwd
3. Active project       → ~/.claude/projects/active.json
4. Single project       → If only one in index, use it
5. Prompt user          → Ask to select or create
```

Skills may extend with: partial matching, discovery mode, etc.

## Update Protocols

### After Feature Mutation

When any feature-idea command changes features.json:

```
1. Load features.json
2. Count by status:
   stats = { total: N, byStatus: { idea: X, shipped: Y, ... } }
3. Update project.json:
   - features.stats = stats
   - features.lastUpdated = now
   - updatedAt = now
4. Update index.json quickStats:
   - features.open = total - shipped - archived
   - features.shipped = shipped count
```

### After Audit Completion

When /audit finishes:

```
1. Read audit results (code score, ux score, open issues)
2. Calculate trend from history:
   - Load .claude/audit/history.json
   - prev = last run score, current = (code + ux) / 2
   - if current > prev + 0.2: trend = "improving"
   - if current < prev - 0.2: trend = "degrading"
   - else: trend = "stable"
3. Update project.json:
   - audit.lastRun = now
   - audit.lastScope = scope
   - audit.score = { code, ux }
   - audit.openIssues = count
   - audit.trend = trend
   - updatedAt = now
4. Update index.json quickStats.auditScore
```

## Project Detection Weights

For discovery/migration:

| Indicator | Weight | Action |
|-----------|--------|--------|
| `.claude/project.json` | 100% | Already a project |
| `~/.claude/features/projects/{name}/` | 100% | Must migrate |
| `.claude/audit/state.json` | 80% | Should migrate |
| `.claude/` directory | 60% | Good candidate |
| `.xcodeproj` / `.xcworkspace` | 40% | iOS project |
| `Package.swift` | 40% | Swift package |
| `.git` directory | 20% | Version controlled |

Auto-migrate at weight >= 60%. List as "possible" at 20-59%.

## Git Integration

```bash
# Detect remote
git remote get-url origin 2>/dev/null

# Parse owner/repo from URL
# git@github.com:owner/repo.git → owner, repo
# https://github.com/owner/repo.git → owner, repo

# Current branch
git branch --show-current
```

## Error Codes

| Code | Message | Used By |
|------|---------|---------|
| E01 | Project not found: {name} | view, health, switch |
| E02 | Not in a project directory | view, health |
| E03 | Project already exists | create |
| E04 | App-idea not found: {id} | create |
| E05 | No projects found | list, migrate |
| E06 | Multiple projects match: {pattern} | switch |
| E07 | Index outdated | list, sync |

Standard format:
```
❌ {message}
   {suggestion or available options}
```

## Output Templates

### Dashboard (project-view)

```
┌─────────────────────────────────────────────────────────────┐
│ {emoji} {displayName} ({name})                     {status} │
│ {description}                                               │
├─────────────────────────────────────────────────────────────┤
│ ORIGIN: {origin.type} {origin.appIdeaId}                    │
│ REPO:   {repository.url} ({defaultBranch})                  │
├─────────────────────────────────────────────────────────────┤
│ FEATURES                      │ AUDIT                       │
│ 💡 idea: N      🚧 in-prog: N │ {score.code} code / {ux} ux │
│ 🔍 exploring: N 🚀 shipped: N │ {openIssues} issues {trend} │
│ Total: N                      │ /project health for details │
├─────────────────────────────────────────────────────────────┤
│ VELOCITY: {current} features/week                           │
│ MILESTONES: {active milestone summary}                      │
└─────────────────────────────────────────────────────────────┘
```

### Health (project-health)

```
┌─────────────────────────────────────────────────────────────┐
│ PROJECT HEALTH: {displayName}                               │
├─────────────────────────────────────────────────────────────┤
│ OVERALL: {score}% ({combined}/10)                           │
├─────────────────────────────────────────────────────────────┤
│ CODE ({code}/10)              │ UX ({ux}/10)                │
│ ├─ Memory:      X/10          │ ├─ Friction:     X/10       │
│ ├─ Concurrency: X/10          │ ├─ Onboarding:   X/10       │
│ └─ Security:    X/10          │ └─ Accessibility: X/10      │
├─────────────────────────────────────────────────────────────┤
│ OPEN ISSUES: N (critical: X, high: Y)                       │
│ VELOCITY: {trend chart}                                     │
├─────────────────────────────────────────────────────────────┤
│ RECOMMENDATIONS                                             │
│ 1. {action} - {impact}                                      │
└─────────────────────────────────────────────────────────────┘
```

### List (project-list)

```
NAME          STATUS    FEATURES    AUDIT   LAST ACTIVE
────────────────────────────────────────────────────────
{name}        {emoji}   N (X 🚧)    X.X     {relative time}

{count} projects ({active} active)
```
