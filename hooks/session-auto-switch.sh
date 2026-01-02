#!/bin/bash
#
# Session Auto-Switch Hook
# Runs on session start to sync active project with current working directory
#
# If cwd contains .claude/project.json and doesn't match active project,
# automatically switches to the cwd project.
#

ACTIVE_PROJECT_FILE="$HOME/.claude/projects/active.json"
INDEX_FILE="$HOME/.claude/projects/index.json"
LOCAL_PROJECT_FILE=".claude/project.json"

# Check if current directory is a managed project
if [ ! -f "$LOCAL_PROJECT_FILE" ]; then
    exit 0  # Not a managed project, nothing to do
fi

# Get current directory info
CURRENT_DIR=$(pwd -P)
CURRENT_PROJECT_NAME=$(jq -r '.name // empty' "$LOCAL_PROJECT_FILE" 2>/dev/null)
CURRENT_DISPLAY_NAME=$(jq -r '.displayName // .name' "$LOCAL_PROJECT_FILE" 2>/dev/null)

if [ -z "$CURRENT_PROJECT_NAME" ]; then
    exit 0  # Can't read project name
fi

# Get active project path
ACTIVE_PATH=""
ACTIVE_NAME=""
if [ -f "$ACTIVE_PROJECT_FILE" ]; then
    ACTIVE_PATH=$(jq -r '.path // empty' "$ACTIVE_PROJECT_FILE" 2>/dev/null)
    ACTIVE_NAME=$(jq -r '.name // empty' "$ACTIVE_PROJECT_FILE" 2>/dev/null)
fi

# Resolve active path for comparison
ACTIVE_PATH_RESOLVED=""
if [ -n "$ACTIVE_PATH" ] && [ -d "$ACTIVE_PATH" ]; then
    ACTIVE_PATH_RESOLVED=$(cd "$ACTIVE_PATH" 2>/dev/null && pwd -P)
fi

# Check if already matched
if [ "$CURRENT_DIR" = "$ACTIVE_PATH_RESOLVED" ]; then
    exit 0  # Already matched, nothing to do
fi

# Auto-switch: Update active.json
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat > "$ACTIVE_PROJECT_FILE" << EOF
{
  "name": "$CURRENT_PROJECT_NAME",
  "path": "$CURRENT_DIR",
  "switchedAt": "$TIMESTAMP"
}
EOF

# Update index.json activeProject if jq available
if [ -f "$INDEX_FILE" ] && command -v jq &> /dev/null; then
    jq --arg name "$CURRENT_PROJECT_NAME" '.activeProject = $name' "$INDEX_FILE" > tmp.json && mv tmp.json "$INDEX_FILE"
fi

# Notify user
echo ""
echo "┌─ Auto-Switched Project ──────────────────────────────────────┐"
echo "│"
echo "│  Detected: $CURRENT_DISPLAY_NAME"
echo "│  Path: $CURRENT_DIR"
echo "│"
if [ -n "$ACTIVE_NAME" ] && [ "$ACTIVE_NAME" != "$CURRENT_PROJECT_NAME" ]; then
    echo "│  (was: $ACTIVE_NAME)"
    echo "│"
fi
echo "│  Active project now matches working directory."
echo "│"
echo "└───────────────────────────────────────────────────────────────┘"
echo ""
