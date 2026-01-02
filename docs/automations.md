# Project Management Automations

Complete guide to automated workflows in the project management system.

## Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        AUTOMATION ARCHITECTURE                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐                   │
│  │  PIPELINES  │     │    HOOKS    │     │   ACTIONS   │                   │
│  │  (Skills)   │     │ (Claude)    │     │  (GitHub)   │                   │
│  └──────┬──────┘     └──────┬──────┘     └──────┬──────┘                   │
│         │                   │                   │                          │
│         ▼                   ▼                   ▼                          │
│  Chain commands      Trigger on events    CI/CD automation                 │
│  Auto-advance        Sync checks          PR merge → ship                  │
│  Smart pauses        Audit gates          Scheduled audits                 │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Pipeline Skills

### `/app-idea pipeline`

Runs full evaluation in one command: **research → analyze → critique**

```bash
/app-idea log "My Idea"              # Auto-runs pipeline (default)
/app-idea log "My Idea" --quick      # Skip pipeline
/app-idea pipeline app-001           # Run on existing idea
/app-idea pipeline app-001 --auto    # No pauses
/app-idea pipeline app-001 --to=research  # Stop early
```

**Behavior:**
- Default: pauses after each phase for review
- `--auto`: runs all phases without pauses
- `--to=X`: stops after specified phase
- Status auto-advances: `spark` → `research` → `analysis`

### `/feature-idea pipeline`

Runs full lifecycle: **implement → [code] → pr → ship**

```bash
/feature-idea pipeline feat-001          # Full lifecycle
/feature-idea pipeline feat-001 --watch  # Auto-ship on PR merge
/feature-idea pipeline feat-001 --resume # Continue after coding
```

**Behavior:**
- Creates branch, generates plan
- Pauses for manual coding
- Creates PR with auto-merge enabled
- Auto-ships when PR merges (with `--watch`)

### `/audit pipeline`

Runs full audit: **review → sync → fix → verify → cleanup**

```bash
/audit pipeline                    # Full pipeline
/audit pipeline --scope=ux         # UX audit
/audit pipeline --scope=all        # Both code + UX
/audit pipeline --resume           # Continue from last stage
```

**Behavior:**
- Runs all reviewers in parallel
- Syncs findings to GitHub issues
- Pauses for triage
- Creates worktrees for high/critical fixes
- Verifies fixes and closes issues

---

## 2. Claude Code Hooks

### Session Start Hook

**Location:** `~/.claude/hooks/session-start.md`

**Triggers:** When session starts in a managed project

**Actions:**
- Check for dirty features → prompt to sync
- Check audit age → suggest re-run if stale
- Display project health summary

**Output:**
```
┌─ FlipTalk Session Start ─────────────────────────────┐
│  Features: 9 open, 0 shipped                        │
│  Audit: 8.5/10 (7 days ago)                         │
│  ⚠️  7 features need sync                           │
└─────────────────────────────────────────────────────┘
```

### Pre-PR Hook

**Location:** `~/.claude/hooks/pre-pr.md`

**Triggers:** Before creating a pull request

**Actions:**
- Run quick audit (critical issues only)
- Check branch linked to feature
- Verify working tree clean
- Block if critical issues found

**Bypass:**
```bash
/feature-idea pr feat-001 --force
```

---

## 3. GitHub Actions

### Feature Auto-Ship

**File:** `.github/workflows/feature-auto-ship.yml`

**Triggers:** PR merged to main

**Actions:**
1. Extract feature ID from branch name (`feat/feat-XXX-slug`)
2. Update features.json status → shipped
3. Update project.json stats
4. Close linked GitHub issue
5. Commit changes

**No manual action required** - features auto-ship when PRs merge.

### Scheduled Audit

**File:** `.github/workflows/scheduled-audit.yml`

**Triggers:**
- Weekly (Monday 9am UTC)
- Manual dispatch

**Actions:**
1. Run SwiftLint
2. Analyze build warnings
3. Generate audit report
4. Update project audit score
5. Create GitHub issue if critical findings
6. Commit report

**Manual trigger:**
```bash
gh workflow run scheduled-audit.yml --field scope=code --field min_severity=high
```

---

## 4. Automation Flow Diagrams

### App Idea Flow (Automated)

```
User: /app-idea log "My Idea"
         │
         ▼
    ┌────────────┐
    │   Capture  │ Generate ID, save to ideas.json
    └─────┬──────┘
          │
          ▼
    ┌────────────┐
    │  Research  │ Web searches, competitors, market
    └─────┬──────┘
          │ [auto-advance]
          ▼
    ┌────────────┐
    │  Analyze   │ TAM/SAM/SOM, revenue, viability
    └─────┬──────┘
          │ [auto-advance]
          ▼
    ┌────────────┐
    │  Critique  │ Hard questions, risk score
    └─────┬──────┘
          │
          ▼
      COMPLETE
```

### Feature Flow (Automated)

```
User: /feature-idea pipeline feat-001
         │
         ▼
    ┌────────────┐
    │ Implement  │ Create branch, generate plan
    └─────┬──────┘
          │
          ▼
    ┌────────────┐
    │   [Code]   │ Manual coding (paused)
    └─────┬──────┘
          │ [--resume]
          ▼
    ┌────────────┐
    │    PR      │ Create PR, enable auto-merge
    └─────┬──────┘
          │
          ▼
    ┌────────────┐
    │  [Merge]   │ CI passes, PR auto-merges
    └─────┬──────┘
          │ [GitHub Action]
          ▼
    ┌────────────┐
    │   Ship     │ Auto-update status, close issue
    └────────────┘
```

### Audit Flow (Automated)

```
User: /audit pipeline
         │
         ▼
    ┌────────────┐
    │   Review   │ Run 17 reviewers in parallel
    └─────┬──────┘
          │
          ▼
    ┌────────────┐
    │    Sync    │ Create GitHub issues
    └─────┬──────┘
          │ [pause for triage]
          ▼
    ┌────────────┐
    │    Fix     │ Worktrees for high+, direct for low
    └─────┬──────┘
          │ [wait for PR merges]
          ▼
    ┌────────────┐
    │   Verify   │ Re-run reviewers, close issues
    └─────┬──────┘
          │
          ▼
    ┌────────────┐
    │  Cleanup   │ Remove worktrees, prune branches
    └────────────┘
```

---

## 5. Configuration

### Enable Hooks

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "session_start": {
      "enabled": true,
      "script": "~/.claude/hooks/session-start.sh"
    },
    "pre_pr_create": {
      "enabled": true,
      "script": "~/.claude/hooks/pre-pr.sh",
      "blocking": true
    }
  }
}
```

### Disable Auto-Pipeline

To disable auto-pipeline for `/app-idea log`:

```json
{
  "skills": {
    "app-idea-log": {
      "auto_pipeline": false
    }
  }
}
```

Or use `--quick` flag per-invocation.

---

## 6. Pain Points Solved

| Before | After |
|--------|-------|
| Run 4 commands for idea evaluation | One command: `/app-idea log` |
| Manually ship after PR merge | Auto-ship via GitHub Action |
| Forget to sync dirty features | Session-start hook reminds you |
| Manual audit scheduling | Weekly GitHub Action |
| Remember to run audit before PR | Pre-PR hook blocks if issues |
| Track feature status manually | Auto-updates on PR merge |

---

## 7. Quick Reference

```bash
# Pipelines
/app-idea log "Name"                    # Log + full evaluation
/app-idea log "Name" --quick            # Just capture
/app-idea pipeline app-001              # Evaluate existing
/feature-idea pipeline feat-001         # Full feature lifecycle
/audit pipeline                         # Full audit lifecycle

# Control
--auto          # No pauses
--to=X          # Stop after phase
--resume        # Continue from pause
--watch         # Auto-advance on events
--quick         # Skip pipeline (log only)

# Bypass
--force         # Skip pre-PR checks
```
