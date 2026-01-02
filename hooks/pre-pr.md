# Pre-PR Hook

Runs automatically before creating a pull request to ensure code quality.

## Trigger

- Event: `pre_pr_create`
- Condition: About to run `gh pr create`

## Actions

### 1. Quick Audit Gate

Run critical-severity audit before PR:

```bash
# Run quick audit (critical only)
/audit --scope=code --min-severity=critical --quiet

# If critical issues found, block PR
if [ $CRITICAL_COUNT -gt 0 ]; then
  echo "🚫 PR blocked: $CRITICAL_COUNT critical issues found"
  echo ""
  echo "Fix with: /audit --fix"
  echo "Or bypass: /feature-idea pr <id> --force"
  exit 1
fi
```

### 2. Feature Link Check

Ensure PR is linked to a feature:

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Check if branch matches feat-XXX pattern
if [[ $BRANCH =~ ^feat/(feat-[0-9]+) ]]; then
  FEATURE_ID="${BASH_REMATCH[1]}"
  echo "✅ Linked to feature: $FEATURE_ID"
else
  echo "⚠️  Branch not linked to feature"
  echo "   Consider: /feature-idea implement <id>"
fi
```

### 3. Uncommitted Changes Check

Ensure all changes are committed:

```bash
if [ -n "$(git status --porcelain)" ]; then
  echo "⚠️  Uncommitted changes detected"
  echo "   Stage and commit before PR"
  exit 1
fi
```

### 4. Tests Check (Optional)

Run tests if configured:

```bash
if [ -f "Package.swift" ]; then
  swift test --filter ".*" 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "⚠️  Tests failing. PR will likely fail CI."
    echo "   Continue anyway? [y/N]"
  fi
fi
```

## Implementation

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "pre_pr_create": {
      "enabled": true,
      "script": "~/.claude/hooks/pre-pr.sh",
      "timeout": 60000,
      "blocking": true
    }
  }
}
```

## Script

```bash
#!/bin/bash
# ~/.claude/hooks/pre-pr.sh

set -e

echo "🔍 Pre-PR checks..."
echo ""

# 1. Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ Uncommitted changes detected"
  git status --short
  exit 1
fi
echo "✅ Working tree clean"

# 2. Check branch naming
BRANCH=$(git branch --show-current)
if [[ $BRANCH =~ ^feat/(feat-[0-9]+) ]]; then
  FEATURE_ID="${BASH_REMATCH[1]}"
  echo "✅ Linked to feature: $FEATURE_ID"
elif [[ $BRANCH =~ ^audit/fix- ]]; then
  echo "✅ Audit fix branch"
else
  echo "⚠️  Branch not linked to feature (continuing anyway)"
fi

# 3. Quick audit for critical issues
echo ""
echo "Running quick audit..."

# Check for obvious critical issues
FORCE_UNWRAPS=$(grep -r "!" --include="*.swift" . 2>/dev/null | grep -v "test" | grep -v "//" | wc -l || echo "0")
if [ "$FORCE_UNWRAPS" -gt 50 ]; then
  echo "⚠️  High number of force unwraps detected: $FORCE_UNWRAPS"
fi

# Check for TODO/FIXME
TODOS=$(grep -r "TODO\|FIXME" --include="*.swift" . 2>/dev/null | wc -l || echo "0")
if [ "$TODOS" -gt 0 ]; then
  echo "ℹ️  $TODOS TODO/FIXME comments found"
fi

echo ""
echo "✅ Pre-PR checks passed"
echo ""
```

## Bypass

To bypass the hook (not recommended):

```bash
/feature-idea pr <id> --force
# or
gh pr create --no-verify  # if using gh directly
```

## Integration with Feature Pipeline

When using `/feature-idea pipeline`, the pre-PR hook runs automatically:

```
PHASE 3: PR                                               [Running]

🔍 Pre-PR checks...

✅ Working tree clean
✅ Linked to feature: feat-004
✅ Pre-PR checks passed

Creating pull request...
```
