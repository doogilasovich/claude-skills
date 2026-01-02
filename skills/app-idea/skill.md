---
name: app-idea
description: App idea pipeline. Commands: log, inbox, list, view, edit, research, analyze, design, score, compare, launch, kill, park, transcribe.
user_invocable: true
---

# /app-idea

Router for app idea pipeline. See `_reference.md` for schemas and scoring rubric.

## Lifecycle

```
💭 spark → 🔍 research → 📊 analysis → 📐 design → ✅ validated → 🚀 launched
     ↓          ↓            ↓            ↓
   💤 parked ←──────────────────────────────
     ↓
   ☠️ killed
```

## Commands

| Cmd | Args | Action |
|-----|------|--------|
| log | \<title\> [--problem] [--oneliner] [--quick] | Capture idea (auto-runs pipeline) |
| pipeline | \<id\> [--auto] [--to=X] | Run full evaluation pipeline |
| inbox | [--source=reminders\|notes\|voice\|github] | Import from mobile sources |
| transcribe | [--file=X] | Transcribe voice memos |
| list | [--status=X] [--score-min=N] | View all ideas |
| view | \<id\> | Full detail view |
| edit | \<id\> [--title] [--problem] [--oneliner] | Modify idea |
| research | \<id\> [--auto] | Competitor/market research |
| analyze | \<id\> | Market sizing, viability analysis |
| critique | \<id\> | Devil's advocate, risk scoring |
| design | \<id\> | Personas, MVP features, tech stack |
| score | \<id\> [--interactive] | Run scoring rubric |
| compare | \<id1\> \<id2\> | Side-by-side comparison |
| park | \<id\> [--until=date] [--reason] | Pause for later |
| kill | \<id\> --reason="X" | Mark as won't pursue |
| launch | \<id\> [--template=ios] | Create project, hand off |

## Quick Start

```bash
# Capture idea (auto-runs full pipeline)
/app-idea log "Shazam for birds" --problem "Can't identify bird calls"

# Or quick capture without pipeline
/app-idea log "Quick thought" --quick

# Run pipeline on existing idea
/app-idea pipeline app-001

# Import from phone
/app-idea inbox

# Individual phases (if not using pipeline)
/app-idea research app-001
/app-idea analyze app-001
/app-idea critique app-001
/app-idea design app-001

# Compare top candidates
/app-idea compare app-001 app-002

# Launch winner
/app-idea launch app-001
```

## Validation

Per `_reference.md#Validation`:
- ID format: `app-NNN`
- Status transitions enforced
- Score requires all dimensions

## Routing

Parse first arg as command, delegate to `app-idea-{cmd}` skill.
No args or `help` → show this table.
