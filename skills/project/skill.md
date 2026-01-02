---
name: project
description: Project orchestrator. Commands: list, create, view, health, switch, migrate.
user_invocable: true
---

# /project

Unified project management across app-ideas, features, and audits.

## Architecture

```
/project orchestrates:
├── /app-idea     → Origin (ideation)
├── /feature-idea → Execution (tracking)
└── /audit        → Quality (health)
```

## Commands

| Cmd | Args | Action |
|-----|------|--------|
| list | [--status] [--sort] | Show all projects |
| create | \<name\> [--from=app-NNN] | Create project |
| view | [name] | Dashboard (default: current) |
| health | [name] | Detailed audit/velocity metrics |
| switch | \<name\> | Set active project context |
| migrate | [--discover] [--dry-run] | Migrate from old system |

## Quick Start

```bash
/project list                    # See all projects
/project view                    # Current project dashboard
/project create App --from=app-002  # Launch from app-idea
/project health                  # Detailed health metrics
/project switch OtherProject     # Change context
```

## Data Locations

```
Source of truth:  {repo}/.claude/project.json
Global index:     ~/.claude/projects/index.json (cache)
Active context:   ~/.claude/projects/active.json
```

## Resolution

Per `_reference.md#project-resolution-order`.

## Routing

Parse first arg as command, delegate to `project-{cmd}` skill.
- No args → `/project view`
- `help` → show commands table
