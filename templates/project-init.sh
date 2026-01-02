#!/bin/bash
#
# Project Initialization Script
# Sets up .claude/ directory and GitHub workflows for a new project
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

# Create .claude directory
mkdir -p "$PROJECT_DIR/.claude/audit/cache"
mkdir -p "$PROJECT_DIR/.claude/audit/reports"

# Create project.json
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

# Create features.json
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

# Copy GitHub workflows
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

# Update git remote info in project.json if git repo
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

echo ""
echo "Done! Project initialized."
echo ""
echo "Next steps:"
echo "  cd $PROJECT_DIR"
echo "  claude"
echo "  /project view"
echo "  /feature-idea log \"First feature\""
