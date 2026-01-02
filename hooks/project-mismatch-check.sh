#!/bin/bash
#
# Project Mismatch Check Hook
# Runs on user-prompt-submit to warn if cwd doesn't match active project
#

ACTIVE_PROJECT_FILE="$HOME/.claude/projects/active.json"
INDEX_FILE="$HOME/.claude/projects/index.json"

# Skip if no active project file
if [ ! -f "$ACTIVE_PROJECT_FILE" ]; then
  exit 0
fi

# Get active project path
ACTIVE_PATH=$(jq -r '.path // empty' "$ACTIVE_PROJECT_FILE" 2>/dev/null)
ACTIVE_NAME=$(jq -r '.name // empty' "$ACTIVE_PROJECT_FILE" 2>/dev/null)

# Skip if no active project set
if [ -z "$ACTIVE_PATH" ]; then
  exit 0
fi

# Get current working directory (resolve symlinks)
CURRENT_DIR=$(pwd -P)
ACTIVE_PATH_RESOLVED=$(cd "$ACTIVE_PATH" 2>/dev/null && pwd -P)

# Compare paths
if [ "$CURRENT_DIR" != "$ACTIVE_PATH_RESOLVED" ]; then
  # Check if current dir is a known project
  CURRENT_PROJECT=""
  if [ -f ".claude/project.json" ]; then
    CURRENT_PROJECT=$(jq -r '.displayName // .name' .claude/project.json 2>/dev/null)
  fi

  # Get active project display name
  ACTIVE_DISPLAY=$(jq -r ".projects[] | select(.name == \"$ACTIVE_NAME\") | .displayName // .name" "$INDEX_FILE" 2>/dev/null)
  [ -z "$ACTIVE_DISPLAY" ] && ACTIVE_DISPLAY="$ACTIVE_NAME"

  echo ""
  echo "┌─ Project Mismatch ─────────────────────────────────────────┐"
  echo "│"
  echo "│  Active project: $ACTIVE_DISPLAY"
  echo "│  Active path:    $ACTIVE_PATH"
  echo "│"
  echo "│  Current dir:    $CURRENT_DIR"
  if [ -n "$CURRENT_PROJECT" ]; then
    echo "│  Current project: $CURRENT_PROJECT"
  else
    echo "│  (not a managed project)"
  fi
  echo "│"
  echo "│  Options:"
  echo "│  • /project switch <name>  - switch to current directory's project"
  echo "│  • cd $ACTIVE_PATH"
  echo "│"
  echo "└────────────────────────────────────────────────────────────┘"
  echo ""
fi
