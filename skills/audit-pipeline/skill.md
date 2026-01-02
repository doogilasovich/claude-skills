---
name: audit-pipeline
description: Run full audit lifecycle (review → sync → fix → verify → cleanup) with smart pauses.
user_invocable: true
---

# /audit pipeline

Runs the complete audit lifecycle with automatic stage advancement and smart pauses for triage.

## Args

```
pipeline                         # Full pipeline with pauses
pipeline --auto                  # No pauses, fix all findings
pipeline --scope=ux              # UX audit pipeline (default: code)
pipeline --scope=all             # Both code and UX
pipeline --to=sync               # Stop after GitHub sync
pipeline --resume                # Resume from last stage
pipeline --skip=verify           # Skip verification stage
```

## Pipeline Stages

```
┌────────┐    ┌──────┐    ┌─────┐    ┌────────┐    ┌─────────┐
│ review │───▶│ sync │───▶│ fix │───▶│ verify │───▶│ cleanup │
└────────┘    └──────┘    └─────┘    └────────┘    └─────────┘
     │            │           │           │             │
     ▼            ▼           ▼           ▼             ▼
  Findings    GitHub      Worktrees   Confirm       Prune
  Cached      Issues      PRs Made    Fixed         Branches
```

## Behavior

### 1. Review Phase
- Run all reviewers (17 code or 10 UX categories)
- Cache findings in `.claude/audit/cache/`
- Categorize by severity (critical, high, medium, low)
- Output: Findings summary

### 2. Sync Phase
- Create GitHub issues for findings
- Bidirectional sync (update existing issues)
- Open browser to GitHub issues page
- **PAUSE**: User triages issues (close won't-fix, prioritize)

### 3. Fix Phase
- Pull latest main
- For each unfixed finding:
  - **Low/Medium**: Fix directly on main
  - **High/Critical**: Create worktree + branch + PR
- Run max 3 worktrees in parallel
- Enable auto-merge on PRs

### 4. Verify Phase
- Pull latest main (after PRs merge)
- Re-run reviewers on fixed files
- Confirm findings resolved
- Close GitHub issues
- Update audit score

### 5. Cleanup Phase
- Remove merged worktrees
- Prune local branches
- Archive audit report
- Update project.json stats

## Smart Pauses

Pipeline automatically pauses at key decision points:

```
┌─────────────────────────────────────────────────────────────────┐
│ PAUSE POINT: After Sync                                         │
│                                                                 │
│ 12 findings synced to GitHub:                                   │
│   • 2 critical → worktree PRs                                   │
│   • 3 high → worktree PRs                                       │
│   • 4 medium → direct fix                                       │
│   • 3 low → direct fix                                          │
│                                                                 │
│ ⏸️  Review issues on GitHub, close any you won't fix.           │
│                                                                 │
│ When ready: /audit pipeline --resume                            │
│ Or fix now: /audit pipeline --resume --auto                     │
└─────────────────────────────────────────────────────────────────┘
```

## Output

```
🔄 Audit Pipeline

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 1: REVIEW                                           [Running]

Running 17 code reviewers in parallel...

✅ Review complete
   • Critical: 1
   • High: 3
   • Medium: 6
   • Low: 4
   • Score: 7.2/10

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 2: SYNC                                             [Running]

Creating GitHub issues...
Opening browser...

✅ Sync complete
   • 14 issues created/updated
   • URL: https://github.com/.../issues?q=label:audit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏸️  PAUSED: Triage issues on GitHub

   Close any issues you won't fix, then:
   /audit pipeline --resume

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[After --resume]

PHASE 3: FIX                                              [Running]

Remaining issues: 12 (2 closed by user)

Creating worktree for critical-001...
Creating worktree for high-001...
Creating worktree for high-002...

Fixing medium issues directly...

✅ Fix phase complete
   • 3 PRs created (high/critical)
   • 7 direct fixes applied
   • 2 skipped (user closed)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⏳ Waiting for PR merges...

   PR #327: pending CI
   PR #328: pending CI
   PR #329: pending CI

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[After PRs merge]

PHASE 4: VERIFY                                           [Running]

Pulling latest main...
Re-running affected reviewers...

✅ Verify complete
   • 12/12 findings resolved
   • New score: 9.1/10 (+1.9)
   • Issues closed: 12

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 5: CLEANUP                                          [Running]

Removing worktrees...
Pruning branches...
Archiving report...

✅ Cleanup complete

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PIPELINE COMPLETE

  Before: 7.2/10  →  After: 9.1/10  (+1.9)
  Fixed: 12 issues
  Duration: 45 minutes

  Report archived: .claude/audit/reports/2026-01-02.json

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## State Persistence

Pipeline state stored in `.claude/audit/pipeline-state.json`:

```json
{
  "startedAt": "2026-01-02T10:00:00Z",
  "currentPhase": "fix",
  "completedPhases": ["review", "sync"],
  "scope": "code",
  "findings": [...],
  "worktrees": [
    {"path": "/path/to/worktree", "branch": "audit/fix-critical-001", "pr": 327}
  ]
}
```

## Scheduled Runs

Can be triggered by GitHub Action (see `.github/workflows/scheduled-audit.yml`):
- Weekly: `--scope=code --min-severity=high`
- Pre-release: `--scope=all`
