---
name: app-idea-launch
description: Launch an app-idea as a new project, creating project structure and importing MVP features.
user_invocable: true
---

# /app-idea launch

Launches an app-idea by creating a project via `/project create --from=<id>` and transitioning the idea to "launched" status.

## Usage

```bash
/app-idea launch app-002                           # Launch in ~/code/git-personal/
/app-idea launch app-002 --name=FlipTalk           # Custom project name
/app-idea launch app-002 --path=~/code/MyApp       # Custom location
/app-idea launch app-002 --template=ios            # Use iOS template
/app-idea launch app-002 --dry-run                 # Preview without creating
```

## Args

| Arg | Required | Description |
|-----|----------|-------------|
| id | Yes | App-idea ID (e.g., app-002) |
| --name | No | Project directory name (default: derived from idea title) |
| --path | No | Parent directory (default: ~/code/git-personal/) |
| --template | No | Project template: ios, swift-package, none |
| --force | No | Skip validation checks |
| --dry-run | No | Preview without creating |

## Prerequisites

- Status should be validated or design (or use --force)
- Score should be 36+ (or use --force)

## Behavior

### 1. Validation Check

```
Checking launch readiness...

✅ Status: validated
✅ Score: 42/60 (Promising)
✅ Research: Complete (5 competitors)
✅ Design: Complete (2 personas, 5 MVP features)
⚠️ Risks: 2 high-severity identified

Proceed with launch? [Y/n]
```

### 2. Create Project (via /project create)

```bash
# Creates project structure
/project create {name} --from=app-002 --display-name="EchoStack"
```

This creates:
```
{name}/
├── .claude/
│   ├── project.json         # Links to app-idea
│   └── features.json        # MVP features imported
├── .git/
└── README.md
```

### 3. project.json with App-Idea Link

```json
{
  "version": "1.0",
  "name": "echostack",
  "displayName": "EchoStack",
  "description": "Record once, generate layered vocal harmonies",

  "origin": {
    "type": "app-idea",
    "appIdeaId": "app-002",
    "createdAt": "2026-01-02T06:00:00Z",
    "snapshot": {
      "title": "EchoStack",
      "problem": "Creating layered vocals requires multiple takes...",
      "oneLiner": "One voice. Infinite harmonies.",
      "score": { "overall": 42, "dimensions": {...} },
      "snapshotAt": "2026-01-02T06:00:00Z"
    }
  },
  ...
}
```

### 4. Import MVP Features

If app-idea has `design.mvpFeatures`:

```json
// Creates features.json with imported MVP
{
  "features": [
    {
      "id": "feat-001",
      "title": "Single-take recording",
      "status": "idea",
      "labels": ["mvp", "must"],
      "origin": { "type": "app-idea", "ref": "app-002", "field": "mvpFeatures" }
    },
    ...
  ]
}
```

### 5. Update App-Idea Status

```json
// In ~/.claude/app-ideas/ideas.json
{
  "id": "app-002",
  "status": "launched",
  "launchedProject": {
    "name": "echostack",
    "path": "/Users/dmccoy/code/git-personal/echostack",
    "launchedAt": "2026-01-02T06:00:00Z"
  }
}
```

### 6. Update Project Index

Adds project to ~/.claude/projects/index.json

## Output

```
🚀 Launching: app-002 "EchoStack"

┌─ Pre-flight Check ────────────────────────────────────┐
│ ✅ Score: 42/60 (Promising)                          │
│ ✅ Research: 3 competitors analyzed                  │
│ ✅ Design: 2 personas, 5 MVP features                │
│ ⚠️ Risks: ML accuracy (high)                        │
└───────────────────────────────────────────────────────┘

Creating project...
✅ Directory: ~/code/git-personal/echostack/
✅ Git initialized
✅ project.json created (linked to app-002)
✅ 5 MVP features imported
✅ README.md generated
✅ Added to project index

App-idea: validated → 🚀 launched

┌─────────────────────────────────────────────────────────────────┐
│ 🟢 EchoStack                                                    │
│ One voice. Infinite harmonies.                                  │
├─────────────────────────────────────────────────────────────────┤
│ ORIGIN: app-002 (score: 42/60)                                  │
│ FEATURES: 5 MVP ideas imported                                  │
│ AUDIT: not run yet                                              │
└─────────────────────────────────────────────────────────────────┘

Next steps:
  cd ~/code/git-personal/echostack
  /feature-idea list              # See MVP backlog
  /feature-idea implement feat-001  # Start first feature
  /audit                           # Run initial audit
```

## Templates

### --template=ios

Scaffolds iOS app via XcodeBuildMCP:
```
{name}/
├── .claude/
├── {Name}.xcodeproj/
├── {Name}/
│   ├── App/{Name}App.swift
│   ├── Features/
│   └── Resources/
└── README.md
```

### --template=swift-package

Creates Swift package structure.

## Integration Points

This skill connects:
- **Input**: /app-idea (the idea being launched)
- **Output**: /project (the created project)
- **Side effect**: /feature-idea (imported MVP features)

```
/app-idea → /app-idea launch → /project create --from=app-NNN
                                    ↓
                              project.json (origin.appIdeaId)
                              features.json (MVP imported)
                                    ↓
                              /feature-idea, /audit work on project
```

## Errors

```
❌ App-idea not found: app-999
   Run /app-idea list to see available ideas

❌ App-idea not ready for launch
   Status: research (expected: validated or design)
   Score: 28/60 (expected: 36+)

   Complete validation first:
   /app-idea analyze app-002
   /app-idea score app-002

❌ Directory already exists: ~/code/git-personal/echostack
   Use --name=echostack2 or --path=~/projects/

❌ App-idea already launched
   app-002 was launched on 2026-01-02
   Project: /Users/dmccoy/code/git-personal/echostack

   View the project:
   /project view echostack
```
