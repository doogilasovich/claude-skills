---
name: app-idea-edit
description: Modify app idea with staleness detection.
user_invocable: true
---

# /app-idea edit

Modify app idea details with workflow reset prompts. See `_reference.md` for schema and staleness rules.

## Args

```
edit <id>                              # Interactive edit
edit <id> --title="New Title"
edit <id> --problem="Refined problem"
edit <id> --oneliner="Better pitch"
edit <id> --concept="New core loop"
edit <id> --add-inspiration="https://..."
edit <id> --force                      # Skip reset prompts
```

## Staleness Detection

Some edits invalidate later workflow stages:

| Field | Makes Stale |
|-------|-------------|
| `problem` | research → analysis → design → score |
| `concept` | research → analysis → design → score |
| `targetAudience` | research → analysis → design |
| `monetization` | analysis → design |
| `title`, `oneLiner`, `inspirations` | (none - cosmetic) |

## Behavior

1. Load idea
2. Apply changes
3. **Detect stale stages** (if field affects later stages AND current status is past that stage)
4. **Prompt for reset** (if stale stages detected)
5. Update/clear data based on choice
6. Save to ideas.json

## Reset Prompt

```
⚠️ This edit may invalidate completed work:

   Changed: problem, concept
   Current status: 📊 analysis

   Stale stages:
   • 🔍 research (completed 2 days ago)
   • 📊 analysis (completed 1 day ago)

   Options:
   [R] Reset to 🔍 research (clear analysis data, redo research)
   [K] Keep status, mark as "needs review"
   [S] Skip - no reset needed

   > _
```

## Reset Behavior

### [R] Reset
- Status → earliest stale stage
- Clear data for all stages after reset point
- Add statusHistory entry with reason

```json
{
  "from": "analysis",
  "to": "research",
  "at": "2026-01-01T...",
  "reason": "Reset after editing: problem, concept"
}
```

### [K] Keep + Mark
- Status unchanged
- Add `needsReview` flag to stale stages

```json
"research": {
  ...existing data...,
  "needsReview": true,
  "staleReason": "problem changed",
  "markedStaleAt": "2026-01-01T..."
}
```

### [S] Skip
- No changes to status or data
- User takes responsibility for validity

## Output

### With Reset

```
✏️ Updated: app-001 "Accent Showdown"

   Changed:
   - problem: "No objective feedback..." → "No fun, competitive way..."
   - concept: added core loop, social mechanics

   ⚠️ Reset triggered:
   - Status: 📊 analysis → 🔍 research
   - Cleared: analysis data
   - Kept: research data (will re-run)

   Next: /app-idea research app-001
```

### With Needs Review

```
✏️ Updated: app-001 "Accent Showdown"

   Changed:
   - problem: "No objective feedback..." → "No fun, competitive way..."

   ⚠️ Marked for review:
   - 🔍 research: needs review
   - 📊 analysis: needs review

   Run /app-idea research app-001 --refresh to update
```

### Cosmetic (No Reset)

```
✏️ Updated: app-001 "Accent Showdown"

   Changed:
   - title: "Accent Coach" → "Accent Showdown"
   - oneliner: updated

   (No workflow reset needed)

   /app-idea view app-001
```
