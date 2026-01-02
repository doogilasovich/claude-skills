---
name: project-view
description: Show project dashboard with features, audit, and metrics.
---

# /project view

Shows a comprehensive dashboard for a project.

## Usage

```bash
/project view              # Current directory project
/project view CameraTest   # Specific project by name
```

## Args

| Arg | Required | Description |
|-----|----------|-------------|
| name | No | Project name (default: detect from cwd) |

## Resolution

Per `_reference.md#project-resolution-order`.

## Behavior

1. Resolve project (see resolution order)
2. Load project.json, features.json, audit state
3. Calculate current metrics (velocity, feature counts)
4. Render dashboard per `_reference.md#output-templates`
5. Update index.json lastAccessed

## Data Sources

| Section | Source |
|---------|--------|
| Header | project.json: name, displayName, status |
| Origin | project.json: origin.* |
| Repo | project.json: repository.*, integrations.github.* |
| Features | features.json: count by status |
| Audit | project.json: audit.* (summary only) |
| Velocity | Calculated from shipped features |
| Milestones | project.json: milestones[] |

## Output

Renders dashboard template from `_reference.md#dashboard-project-view`.

Compact example:
```
┌ 🟢 FlipTalk (CameraTest) ─────────────────────────┐
│ Features: 35 (3 🚧)  │  Audit: 7.2/10 ↑ (12 open) │
│ Velocity: 2.5/wk     │  /project health → details │
└───────────────────────────────────────────────────┘
```

### Empty/New Project

```
┌ 🟢 MyNewProject ──────────────────────────────────┐
│ Features: 0          │  Audit: not run            │
│                                                   │
│ GET STARTED:                                      │
│ • /feature-idea log "First feature"              │
│ • /audit                                          │
└───────────────────────────────────────────────────┘
```

## Errors

E01, E02 - see `_reference.md#error-codes`
