---
name: feature-idea-pipeline
description: Run full feature lifecycle (implement → pr → ship) with auto-advancement.
user_invocable: true
---

# /feature-idea pipeline

Runs the complete feature implementation lifecycle with automatic status advancement.

## Args

```
pipeline <id>                    # Full pipeline with pauses
pipeline <id> --auto             # Auto-advance without confirmations
pipeline <id> --to=pr            # Stop after PR creation
pipeline <id> --watch            # Watch for PR merge, auto-ship
pipeline <id> --skip=implement   # Skip implementation planning (already coded)
```

## Pipeline Stages

```
┌───────────┐    ┌──────┐    ┌──────┐    ┌──────┐
│ implement │───▶│ code │───▶│  pr  │───▶│ ship │
└───────────┘    └──────┘    └──────┘    └──────┘
      │              │            │           │
      ▼              ▼            ▼           ▼
   Branch        [Manual]     PR Created   Status→shipped
   Plan          Coding       Issue Link   Issue Closed
   Context                    Auto-merge   Stats Updated
```

## Behavior

### 1. Implement Phase
- Create feature branch: `feat/<id>-<slug>`
- Generate implementation plan
- Gather codebase context
- Status: `idea` → `in-progress`
- Output: Branch created, plan ready

### 2. Code Phase (Manual)
- **This phase is manual** - you write the code
- Pipeline pauses for coding work
- Resume with `/feature-idea pipeline <id> --resume`

### 3. PR Phase
- Stage and commit changes
- Create pull request with:
  - Summary from feature description
  - Test plan checklist
  - Link to GitHub issue
- Enable auto-merge (if CI passes)
- Status remains `in-progress`

### 4. Ship Phase
- **Triggered by**: PR merge OR manual `/feature-idea ship`
- Update status: `in-progress` → `shipped`
- Close linked GitHub issue
- Update project stats
- Record in feature history

## Watch Mode

```bash
/feature-idea pipeline feat-001 --watch
```

Monitors PR status and auto-ships when merged:
- Polls PR status every 30 seconds
- Auto-advances to ship when PR merges
- Times out after 24 hours
- Can run in background

## Output

```
🔄 Pipeline: feat-001 "Challenge Friends viral sharing"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 1: IMPLEMENT                                        [Running]

Creating branch...
Generating implementation plan...
Gathering context...

✅ Implement complete
   • Branch: feat/feat-001-challenge-friends
   • Plan: 5 steps identified
   • Context: 8 relevant files

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 2: CODE                                             [Paused]

⏸️  Pipeline paused for manual coding.

When ready, either:
  • Continue: /feature-idea pipeline feat-001 --resume
  • Just PR:  /feature-idea pr feat-001

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[After coding complete and --resume]

PHASE 3: PR                                               [Running]

Staging changes...
Creating commit...
Pushing to remote...
Creating pull request...

✅ PR created
   • PR: #326
   • URL: https://github.com/.../pull/326
   • Auto-merge: enabled

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 4: SHIP                                             [Waiting]

⏳ Waiting for PR merge...

   PR Status: open → pending CI → merged

   To ship manually: /feature-idea ship feat-001

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[After PR merged]

✅ PIPELINE COMPLETE

  Status: idea → in-progress → shipped
  PR: #326 (merged)
  Issue: #325 (closed)

  Duration: 2h 15m (idea to shipped)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## State Persistence

Pipeline state stored in feature metadata:

```json
{
  "pipeline": {
    "startedAt": "2026-01-02T10:00:00Z",
    "currentPhase": "code",
    "completedPhases": ["implement"],
    "branch": "feat/feat-001-challenge-friends",
    "prNumber": null
  }
}
```

## Integration with GitHub Actions

When PR merges, GitHub Action can trigger auto-ship:
- See `.github/workflows/feature-auto-ship.yml`
- Updates features.json automatically
- No manual `/feature-idea ship` needed
