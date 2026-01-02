#!/bin/bash
#
# Project Initialization Script
# Sets up .claude/ directory, CLAUDE.md, and GitHub workflows for a new project
#
# Usage:
#   project-init.sh [path] [name]
#   project-init.sh              # Initialize current directory
#   project-init.sh .            # Initialize current directory
#   project-init.sh /path/to/dir # Initialize specific directory
#   project-init.sh . "MyApp"    # Initialize with custom name
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="${1:-.}"
PROJECT_NAME="${2:-$(basename "$(cd "$PROJECT_DIR" && pwd)")}"

echo "Project Initialization"
echo "======================"
echo ""
echo "Project: $PROJECT_NAME"
echo "Directory: $PROJECT_DIR"
echo ""

# Step 1: Run Claude /init if available and not already initialized
if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
    if command -v claude &> /dev/null; then
        echo "Running Claude Code /init..."
        (cd "$PROJECT_DIR" && claude --dangerously-skip-permissions -p "/init" --max-turns 1 2>/dev/null) || true
        if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
            echo "Created: CLAUDE.md (via /init)"
        else
            # Fallback: create template CLAUDE.md
            cat > "$PROJECT_DIR/CLAUDE.md" << 'EOF'
# Project Instructions

## Overview

Project-specific instructions for Claude Code.

## Code Style

- Follow existing patterns in the codebase
- Keep functions focused and small
- Use descriptive variable names

## Testing

- Run tests before committing
- Add tests for new functionality

## Project Management

This project uses claude-skills for feature tracking and auditing:

```bash
/project view              # Project dashboard
/feature-idea list         # View features
/feature-idea log "Title"  # Create feature
/audit                     # Run code audit
```
EOF
            echo "Created: CLAUDE.md (template)"
        fi
    else
        # No claude CLI, create template
        cat > "$PROJECT_DIR/CLAUDE.md" << 'EOF'
# Project Instructions

## Overview

Project-specific instructions for Claude Code.

## Code Style

- Follow existing patterns in the codebase
- Keep functions focused and small
- Use descriptive variable names

## Testing

- Run tests before committing
- Add tests for new functionality

## Project Management

This project uses claude-skills for feature tracking and auditing:

```bash
/project view              # Project dashboard
/feature-idea list         # View features
/feature-idea log "Title"  # Create feature
/audit                     # Run code audit
```
EOF
        echo "Created: CLAUDE.md (template)"
    fi
else
    echo "Exists: CLAUDE.md"
fi

# Step 2: Create .claude directory structure
mkdir -p "$PROJECT_DIR/.claude/audit/cache"
mkdir -p "$PROJECT_DIR/.claude/audit/reports"

# Step 3: Create project.json (our project management metadata)
if [ ! -f "$PROJECT_DIR/.claude/project.json" ]; then
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > "$PROJECT_DIR/.claude/project.json" << EOF
{
  "name": "$PROJECT_NAME",
  "displayName": "$PROJECT_NAME",
  "description": "",
  "status": "active",
  "origin": {
    "type": "manual",
    "appIdeaId": null
  },
  "repository": {
    "url": null,
    "owner": null,
    "name": null
  },
  "features": {
    "stats": {
      "total": 0,
      "byStatus": {
        "idea": 0,
        "in-progress": 0,
        "shipped": 0,
        "archived": 0
      }
    },
    "lastUpdated": null
  },
  "audit": {
    "lastRun": null,
    "lastScope": null,
    "score": {
      "code": null,
      "ux": null
    }
  },
  "createdAt": "$TIMESTAMP",
  "updatedAt": "$TIMESTAMP"
}
EOF
    echo "Created: .claude/project.json"
else
    echo "Exists: .claude/project.json"
fi

# Step 4: Create features.json
if [ ! -f "$PROJECT_DIR/.claude/features.json" ]; then
    cat > "$PROJECT_DIR/.claude/features.json" << EOF
{
  "features": [],
  "lastUpdated": null,
  "schemaVersion": "1.0"
}
EOF
    echo "Created: .claude/features.json"
else
    echo "Exists: .claude/features.json"
fi

# Step 5: Copy GitHub workflows
mkdir -p "$PROJECT_DIR/.github/workflows"

if [ ! -f "$PROJECT_DIR/.github/workflows/feature-auto-ship.yml" ]; then
    cp "$SCRIPT_DIR/github-workflows/feature-auto-ship.yml" "$PROJECT_DIR/.github/workflows/"
    echo "Created: .github/workflows/feature-auto-ship.yml"
else
    echo "Exists: .github/workflows/feature-auto-ship.yml"
fi

if [ ! -f "$PROJECT_DIR/.github/workflows/scheduled-audit.yml" ]; then
    cp "$SCRIPT_DIR/github-workflows/scheduled-audit.yml" "$PROJECT_DIR/.github/workflows/"
    echo "Created: .github/workflows/scheduled-audit.yml"
else
    echo "Exists: .github/workflows/scheduled-audit.yml"
fi

# Step 6: Update git remote info in project.json if git repo
if [ -d "$PROJECT_DIR/.git" ]; then
    REMOTE_URL=$(cd "$PROJECT_DIR" && git remote get-url origin 2>/dev/null || echo "")
    if [ -n "$REMOTE_URL" ]; then
        # Extract owner/repo from URL
        if [[ $REMOTE_URL =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
            OWNER="${BASH_REMATCH[1]}"
            REPO="${BASH_REMATCH[2]}"

            # Update project.json with jq if available
            if command -v jq &> /dev/null; then
                jq --arg url "$REMOTE_URL" \
                   --arg owner "$OWNER" \
                   --arg repo "$REPO" \
                   '.repository = {"url": $url, "owner": $owner, "name": $repo}' \
                   "$PROJECT_DIR/.claude/project.json" > tmp.json && mv tmp.json "$PROJECT_DIR/.claude/project.json"
                echo "Updated: repository info from git remote"
            fi
        fi
    fi
fi

# Step 7: Add to global project index
INDEX_FILE="$HOME/.claude/projects/index.json"
if [ -f "$INDEX_FILE" ] && command -v jq &> /dev/null; then
    FULL_PATH="$(cd "$PROJECT_DIR" && pwd)"
    # Check if project already in index
    EXISTS=$(jq --arg path "$FULL_PATH" '.projects[] | select(.path == $path) | .name' "$INDEX_FILE" 2>/dev/null || echo "")
    if [ -z "$EXISTS" ]; then
        TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        jq --arg name "$PROJECT_NAME" \
           --arg path "$FULL_PATH" \
           --arg ts "$TIMESTAMP" \
           '.projects += [{"name": $name, "displayName": $name, "path": $path, "status": "active", "lastAccessed": $ts, "quickStats": {"features": {"open": 0, "shipped": 0}, "auditScore": null}}]' \
           "$INDEX_FILE" > tmp.json && mv tmp.json "$INDEX_FILE"
        echo "Added: project to global index"
    else
        echo "Exists: project in global index"
    fi
fi

echo ""
echo "Done! Project initialized."
echo ""
echo "Files created:"
echo "  CLAUDE.md                              # Project instructions"
echo "  .claude/project.json                   # Project metadata"
echo "  .claude/features.json                  # Feature tracking"
echo "  .claude/audit/                         # Audit cache & reports"
echo "  .github/workflows/feature-auto-ship.yml"
echo "  .github/workflows/scheduled-audit.yml"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  claude"
echo "  /project view"
echo "  /feature-idea log \"First feature\""
