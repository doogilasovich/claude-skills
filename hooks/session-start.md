# Session Start Hook

Runs automatically when a Claude Code session starts in a project directory.

## Trigger

- Event: `session_start`
- Condition: Working directory contains `.claude/project.json`

## Actions

### 1. Sync Check

Check for dirty features that need GitHub sync:

```bash
# Pseudo-code for hook logic
dirty_features=$(jq '.features[] | select(.dirty == true)' .claude/features.json)
if [ -n "$dirty_features" ]; then
  echo "⚠️  Dirty features found. Run /feature-idea sync to push to GitHub."
fi
```

### 2. Stale Audit Check

Check if audit is stale (>7 days old):

```bash
last_audit=$(jq -r '.audit.lastRun' .claude/project.json)
days_since=$(( ($(date +%s) - $(date -d "$last_audit" +%s)) / 86400 ))
if [ $days_since -gt 7 ]; then
  echo "⚠️  Audit is $days_since days old. Run /audit for fresh results."
fi
```

### 3. Project Index Refresh

Update global project index cache:

```bash
# Update lastAccessed timestamp
jq --arg path "$PWD" '.projects |= map(if .path == $path then .lastAccessed = now else . end)' \
  ~/.claude/projects/index.json > tmp && mv tmp ~/.claude/projects/index.json
```

### 4. Health Summary

Display quick project health:

```
┌─ FlipTalk Session Start ────────────────────────────────────┐
│                                                             │
│  Features: 9 open, 0 shipped                               │
│  Audit: 8.5/10 (7 days ago)                                │
│  Dirty: 7 features need sync                               │
│                                                             │
│  Suggestions:                                               │
│  • /feature-idea sync    (push dirty features)             │
│  • /audit                (refresh audit score)             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Implementation

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "session_start": {
      "enabled": true,
      "script": "~/.claude/hooks/session-start.sh",
      "timeout": 5000
    }
  }
}
```

## Script

```bash
#!/bin/bash
# ~/.claude/hooks/session-start.sh

PROJECT_JSON=".claude/project.json"
FEATURES_JSON=".claude/features.json"

# Check if this is a managed project
if [ ! -f "$PROJECT_JSON" ]; then
  exit 0
fi

PROJECT_NAME=$(jq -r '.displayName // .name' "$PROJECT_JSON")

echo "┌─ $PROJECT_NAME Session Start ─────────────────────────────┐"
echo "│"

# Count features
if [ -f "$FEATURES_JSON" ]; then
  OPEN=$(jq '[.features[] | select(.status == "idea" or .status == "in-progress")] | length' "$FEATURES_JSON")
  SHIPPED=$(jq '[.features[] | select(.status == "shipped")] | length' "$FEATURES_JSON")
  DIRTY=$(jq '[.features[] | select(.dirty == true)] | length' "$FEATURES_JSON")
  echo "│  Features: $OPEN open, $SHIPPED shipped"
  if [ "$DIRTY" -gt 0 ]; then
    echo "│  ⚠️  $DIRTY features need sync"
  fi
fi

# Check audit age
LAST_AUDIT=$(jq -r '.audit.lastRun // empty' "$PROJECT_JSON")
if [ -n "$LAST_AUDIT" ]; then
  AUDIT_SCORE=$(jq -r '.audit.score.code // "N/A"' "$PROJECT_JSON")
  echo "│  Audit: $AUDIT_SCORE/10"
fi

echo "│"
echo "└──────────────────────────────────────────────────────────┘"
```
