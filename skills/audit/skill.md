---
name: audit
description: Unified quality pipeline for code and UX review, fixing, and verification with extended thinking.
user_invocable: true
---

# /audit

Unified quality pipeline with **extended thinking (ultrathink)** at every decision point. Runs code review (17 categories), UX review (10 categories), or both.

## Design Principles

1. **Think deeply before acting** - Use extended thinking at every stage
2. **Git-first workflow** - All fixes go through branches and PRs
3. **Fail gracefully** - Cache partial results, continue on errors
4. **Respect existing patterns** - Detect already-mitigated issues
5. **Parallel by default** - Maximize throughput with Task agents

## Usage

```bash
/audit                         # Code review + fix (default)
/audit --scope=ux              # UX review + fix
/audit --scope=all             # Both code and UX (parallel)
/audit --review-only           # Review only, cache results
/audit --scope=all --sync      # Full audit with GitHub sync
/audit --preset=pr             # PR-optimized preset
```

## Scope

| Option | Categories | Description |
|--------|------------|-------------|
| `--scope=code` | 17 | Code quality (default) |
| `--scope=ux` | 10 | UX quality |
| `--scope=all` | 27 | Both in parallel |

See `_shared/categories/code.md` and `_shared/categories/ux.md`.

## Options

### Output

| Option | Description |
|--------|-------------|
| `--progress` | Human-readable output |
| `--quiet` | One-line output |
| `--verbose` | Full debug output |
| `--json` | JSON only (default) |

### Stage Control

| Option | Description |
|--------|-------------|
| `--stage=review` | Review only, cache results |
| `--stage=sync` | Sync to GitHub only |
| `--stage=fix` | Fix from cached review |
| `--stage=verify` | Verify fixes only |
| `--review-only` | Alias for --stage=review |
| `--fix-only` | Alias for --stage=fix |
| `--resume` | Continue from last stage |
| `--fresh` | Ignore cache |

### GitHub Sync

| Option | Description |
|--------|-------------|
| `--sync` | Full bidirectional sync |
| `--sync=push` | Push findings to GitHub |
| `--sync=pull` | Pull issue status |
| `--dry-run` | Preview without changes |
| `--no-close` | Don't auto-close issues |

### Filtering

| Option | Description |
|--------|-------------|
| `--categories=LIST` | Comma-separated (code + ux) |
| `--min-severity=X` | low, medium, high, critical |
| `--preset=X` | See `_shared/presets.md` |
| `--incremental` | Changed files only |
| `--since=REF` | Changes since git ref |

### Presets

| Preset | Scope | Categories | Severity |
|--------|-------|------------|----------|
| `quick` | code | memory, concurrency, security | critical |
| `quick-ux` | ux | friction, trust, accessibility | critical |
| `pr` | all | memory, security, friction, accessibility | medium+ |
| `release` | all | all | high+ |
| `nightly` | all | all | low+ |

### History

| Option | Description |
|--------|-------------|
| `--history` | Show trend over last 10 runs |
| `--compare=previous` | Diff against last run |

### Archive Management

| Option | Description |
|--------|-------------|
| `--clean` | Remove all archived reports |
| `--clean=old` | Keep latest 5 runs, delete older |
| `--list-reports` | List archived report files |

**Archive behavior:**
- Reports saved to `.claude/audit/reports/{timestamp}/` (gitignored)
- Each run creates timestamped subdirectory with all findings
- Auto-cleanup: keeps latest 5 runs by default
- Use `--clean` to remove all archived reports

---

## Extended Thinking Integration

**CRITICAL**: Use extended thinking (ultrathink) at EVERY decision point:

### Pre-flight Ultrathink

Before starting ANY stage, think deeply about:

```
<ultrathink>
1. CONTEXT ANALYSIS
   - What is the current git state? (clean/dirty/branch)
   - What files have changed since last audit?
   - Are there existing audit issues in GitHub?
   - What scope/categories are being requested?

2. STRATEGY SELECTION
   - Should I run full audit or incremental?
   - Which categories are most relevant to recent changes?
   - Are there dependencies between categories?
   - What's the optimal parallelization strategy?

3. RISK ASSESSMENT
   - Could any fixes conflict with uncommitted changes?
   - Are there patterns suggesting false positives?
   - Which findings might be already-mitigated?

4. EXECUTION PLAN
   - What's the exact sequence of operations?
   - Where should I checkpoint for resume capability?
   - What's my rollback strategy if fixes fail?
</ultrathink>
```

### Per-Phase Ultrathink

#### Phase 1 - Review

```
<ultrathink>
REVIEW ANALYSIS:
- Which 17 code / 10 UX categories apply to this codebase?
- What are the hot paths (frequently changed files)?
- What architectural patterns exist that affect analysis?
- Which categories can run in parallel without resource contention?

LAUNCH STRATEGY:
- Launch Task agents for each category in parallel
- Use haiku model for quick categories (readability, naming)
- Use sonnet/opus for complex categories (concurrency, security)
- Set appropriate timeouts per category complexity
</ultrathink>
```

#### Phase 2 - Consolidation

```
<ultrathink>
FINDING ANALYSIS:
For each finding, evaluate:
1. Is this already mitigated by existing code patterns?
   - @MainActor isolation prevents race conditions
   - Protocol abstraction already enables testing
   - Existing guards handle the edge case

2. Is this a false positive?
   - Test code flagged for production patterns
   - Generated code flagged for style issues
   - Intentional design decisions

3. What's the true severity?
   - Context-dependent (is this path hot?)
   - Exploitability assessment
   - User impact analysis

4. Are there duplicate/overlapping findings?
   - Same root cause, different symptoms
   - Related issues that should be fixed together

CATEGORIZATION:
- CRITICAL: Fix immediately, blocks release
- HIGH: Fix in this PR, significant impact
- MEDIUM: Fix soon, moderate impact
- LOW: Track for later, minor impact
- MITIGATED: Already handled, close with explanation
- FALSE_POSITIVE: Skip, document why
</ultrathink>
```

#### Phase 3 - GitHub Sync

```
<ultrathink>
SYNC STRATEGY:
1. For each finding, search existing issues:
   - Exact title match?
   - Similar description?
   - Same file/line reference?

2. Determine action:
   - CREATE: New finding, no existing issue
   - UPDATE: Finding changed, issue exists
   - CLOSE: Finding resolved or mitigated
   - SKIP: Issue already up-to-date

3. Label strategy:
   - audit (always)
   - category (e.g., security, concurrency)
   - severity (critical, high, medium, low)
   - mitigated (if already handled)

4. For MITIGATED findings:
   - Close issue with explanation
   - Document the mitigation pattern
   - Add to known-patterns for future audits
</ultrathink>
```

#### Phase 4 - Fix

```
<ultrathink>
FIX STRATEGY:
1. Git workflow planning:
   - Create branch: fix/audit-{scope}-{date}
   - Or per-category: fix/{category}-{date}
   - Determine if single PR or multiple PRs

2. Fix ordering:
   - Dependencies between fixes?
   - Which fixes might conflict?
   - Optimal merge order?

3. For each finding:
   - What's the minimal fix?
   - Does fix introduce new issues?
   - What tests validate the fix?
   - Is the fix backwards compatible?

4. Commit strategy:
   - Group related fixes in single commit
   - Reference issue numbers: "Closes #XXX"
   - Clear commit messages explaining why

5. PR strategy:
   - Single PR for related fixes
   - Separate PRs for independent categories
   - Include test plan in PR description
</ultrathink>
```

#### Phase 5 - Verify

```
<ultrathink>
VERIFICATION PLAN:
1. Build verification:
   - Does project still compile?
   - Any new warnings introduced?
   - All targets build successfully?

2. Test verification:
   - Run existing test suite
   - Any new test failures?
   - Coverage impact?

3. Runtime verification:
   - App launches successfully?
   - Key flows still work?
   - No crashes or hangs?

4. Accessibility verification (for UX fixes):
   - VoiceOver navigation works?
   - Dynamic type respects settings?
   - Contrast ratios acceptable?
</ultrathink>
```

---

## Pipeline Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                         /audit                                    │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│  │ ULTRATHINK  │───▶│   REVIEW    │───▶│ ULTRATHINK  │          │
│  │ Pre-flight  │    │  (parallel) │    │ Consolidate │          │
│  └─────────────┘    └─────────────┘    └─────────────┘          │
│                            │                   │                  │
│                            ▼                   ▼                  │
│                     ┌─────────────┐    ┌─────────────┐          │
│                     │   CACHE     │    │   FILTER    │          │
│                     │   Results   │    │  Mitigated  │          │
│                     └─────────────┘    └─────────────┘          │
│                                               │                  │
│                            ┌──────────────────┘                  │
│                            ▼                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│  │ ULTRATHINK  │───▶│    SYNC     │───▶│   UPDATE    │          │
│  │ Sync Plan   │    │  (GitHub)   │    │   State     │          │
│  └─────────────┘    └─────────────┘    └─────────────┘          │
│                                               │                  │
│                            ┌──────────────────┘                  │
│                            ▼                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│  │ ULTRATHINK  │───▶│    FIX      │───▶│   COMMIT    │          │
│  │ Fix Plan    │    │  (branch)   │    │    & PR     │          │
│  └─────────────┘    └─────────────┘    └─────────────┘          │
│                                               │                  │
│                            ┌──────────────────┘                  │
│                            ▼                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐          │
│  │ ULTRATHINK  │───▶│   VERIFY    │───▶│   REPORT    │          │
│  │ Test Plan   │    │  (build)    │    │   Summary   │          │
│  └─────────────┘    └─────────────┘    └─────────────┘          │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

---

## Execution Steps

### Step 1: Initialize

```bash
# Create cache directory for intermediate results
CACHE_DIR=".claude/audit/cache/$(date -u +%Y-%m-%dT%H%M%SZ)"
mkdir -p "$CACHE_DIR"
ln -sfn "$CACHE_DIR" .claude/audit/cache/latest

# Create archive directory for final reports (gitignored)
ARCHIVE_DIR=".claude/audit/reports/$(date -u +%Y-%m-%dT%H%M%SZ)"
mkdir -p "$ARCHIVE_DIR"
ln -sfn "$ARCHIVE_DIR" .claude/audit/reports/latest

# Auto-cleanup: keep only latest 5 report directories
ls -dt .claude/audit/reports/20* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true

# Check git state
git status --porcelain > "$CACHE_DIR/git-state.txt"
```

### Step 2: Review Phase

**ULTRATHINK**: Analyze scope, determine categories, plan parallelization.

Launch review agents via Task tool:

```javascript
// For --scope=code
Task({
  subagent_type: "general-purpose",
  prompt: "Run /review-{category} on the codebase. Output JSON per _shared/finding-schema.md",
  model: categoryComplexity[category] > 0.7 ? "opus" : "sonnet"
})

// For --scope=ux
Task({
  subagent_type: "general-purpose",
  prompt: "Run ux-{category}-analyst. Output UX findings with severity and score.",
  model: "sonnet"
})
```

**Parallel execution**: Launch all category agents simultaneously, collect results.

### Step 3: Consolidation

**ULTRATHINK**: For each finding, evaluate:
- Already mitigated? (check existing patterns)
- False positive? (context analysis)
- True severity? (impact assessment)
- Duplicates? (deduplication)

Output: Filtered findings with status annotations.

### Step 4: GitHub Sync

**ULTRATHINK**: Plan sync operations, handle conflicts.

```bash
# Create labels if missing
for label in audit critical high medium low security concurrency memory; do
  gh label create "$label" --force 2>/dev/null || true
done

# For each finding:
# - Search existing issues
# - Create/update/close as needed
# - Update .claude/audit/state.json
```

**Auto-close mitigated issues**:
```bash
gh issue close $ISSUE_NUM --comment "Already mitigated: $EXPLANATION"
```

### Step 5: Fix Phase

**ULTRATHINK**: Plan Git workflow, fix order, commit strategy.

```bash
# Create fix branch
BRANCH="fix/audit-$(date +%Y-%m-%d)"
git checkout -b "$BRANCH"

# For each category with findings:
#   Apply fix via /fix-{category} or dev-{category}
#   Stage changes
#   Commit with issue references

git add -A
git commit -m "$(cat <<'EOF'
Fix audit findings: {categories}

{summary of fixes}

Closes #{issue1}, closes #{issue2}, ...

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)"

# Push and create PR
git push -u origin "$BRANCH"
gh pr create --title "Fix audit findings" --body "..."
```

### Step 6: Verify Phase

**ULTRATHINK**: Plan verification, determine test scope.

```bash
# Build verification
xcodebuild build -scheme {scheme} -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Run tests (if available)
xcodebuild test -scheme {scheme} -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Accessibility verification (for UX fixes)
# - Launch app
# - Check UI hierarchy for accessibility labels
# - Verify VoiceOver navigation
```

### Step 7: Report

Generate summary and archive:
```bash
# Save final reports to archive
cp *.json *.md *.txt "$ARCHIVE_DIR/" 2>/dev/null || true
rm -f *.json *.md *.txt 2>/dev/null || true  # Clean project root
```

Summary includes:
- Total findings by severity
- Fixed vs remaining
- Issues created/closed
- PR link
- Next steps for remaining issues
- Archive location: `.claude/audit/reports/latest/`

---

## State Files

### `.claude/audit/state.json`

```json
{
  "lastSync": "2025-12-31T14:30:00Z",
  "lastReview": "2025-12-31T14:00:00Z",
  "sourceFile": "audit-review-{timestamp}.json",
  "summary": {
    "total": 90,
    "critical": 6,
    "high": 26,
    "medium": 37,
    "low": 21
  },
  "githubSync": {
    "created": 12,
    "updated": 0,
    "closed": 0
  },
  "issues": [
    {
      "localId": "security-001",
      "githubNumber": 273,
      "category": "security",
      "severity": "critical",
      "title": "Issue title",
      "file": "path/to/file.swift:29",
      "status": "open|closed|mitigated",
      "fixed": false,
      "mitigationReason": "Optional explanation if mitigated"
    }
  ],
  "syncHistory": [
    {
      "date": "2025-12-31T14:30:00Z",
      "created": 12,
      "updated": 0,
      "closed": 0
    }
  ]
}
```

### `.claude/audit/history.json`

```json
{
  "runs": [
    {
      "timestamp": "2025-12-31T14:00:00Z",
      "scope": "all",
      "findings": { "critical": 6, "high": 26, "medium": 37, "low": 21 },
      "fixed": { "critical": 2, "high": 8, "medium": 0, "low": 0 },
      "score": { "code": 7.2, "ux": 6.1 }
    }
  ]
}
```

---

## Known Mitigation Patterns

When evaluating findings, check for these already-mitigated patterns:

### Concurrency
- `@MainActor` class → race conditions mitigated
- `actor` isolation → thread safety ensured
- `@unchecked Sendable` on enum with only static methods → safe

### Memory
- `[weak self]` in closures → retain cycles prevented
- `deinit` with cleanup → resources released

### Security
- Environment variable lookup with DEBUG fallback → keys not in production binary
- Info.plist lookup → configuration externalized

### Accessibility
- `.accessibilityLabel()` present → VoiceOver supported
- `.accessibilityAction()` for gestures → alternatives provided

---

## Error Handling

1. **Review failure**: Cache partial results, continue with completed categories
2. **Sync failure**: Log error, continue without GitHub sync
3. **Fix failure**: Commit successful fixes, report failed categories
4. **Build failure**: Report error, suggest manual review
5. **Any failure**: Update cache with failure state for `--resume`

---

## Project Integration

When running in a project directory (has `.claude/project.json`), audit updates project metadata:

### After Audit Completion

Update `project.json.audit`:

```json
{
  "audit": {
    "lastRun": "2026-01-02T06:00:00Z",
    "lastScope": "all",
    "score": {
      "code": 8.5,
      "ux": 7.2
    },
    "openIssues": 2,
    "trend": "improving"
  }
}
```

### Trend Calculation

Compare to previous audit:
- `improving`: score increased by > 0.2
- `stable`: score within ± 0.2
- `degrading`: score decreased by > 0.2

### Index Update

Also update `~/.claude/projects/index.json`:

```json
{
  "quickStats": {
    "auditScore": 7.85
  }
}
```

### Integration Commands

After audit, these commands reflect updated data:
- `/project view` - Shows audit scores and trend
- `/project health` - Detailed breakdown by category
- `/project list` - Shows audit scores in table

---

## Aliases

| Alias | Equivalent |
|-------|------------|
| `/code-audit` | `/audit --scope=code` |
| `/comprehensive-code-audit` | `/audit --scope=code` |
| `/comprehensive-ux-audit` | `/audit --scope=ux` |
| `/ux-pipeline` | `/audit --scope=ux` |
