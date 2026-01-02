# Claude Code Environment Setup

Complete onboarding guide for new team members.

---

## Overview

The project management system consists of:

| Component | Location | Purpose |
|-----------|----------|---------|
| **Skills** | `~/code/claude-skills/` | Shared commands (app-idea, feature-idea, audit) |
| **Personal Config** | `~/.claude/` | Your preferences, API keys, cross-project data |
| **Project Data** | `{repo}/.claude/` | Per-project features, audit reports |
| **GitHub Actions** | `{repo}/.github/workflows/` | Automation (auto-ship, scheduled audit) |

```
┌─────────────────────────────────────────────────────────────────┐
│                    SYSTEM ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ~/code/claude-skills/          (git repo - shared)             │
│  ├── skills/                    122 custom skills               │
│  ├── hooks/                     Session & PR hooks              │
│  ├── docs/                      Documentation                   │
│  └── templates/                 Project templates               │
│           │                                                     │
│           │ symlinks                                            │
│           ▼                                                     │
│  ~/.claude/                     (private - not versioned)       │
│  ├── skills -> claude-skills/skills                             │
│  ├── hooks -> claude-skills/hooks                               │
│  ├── CLAUDE.md                  Your personal instructions      │
│  ├── app-ideas/ideas.json       Cross-project app ideas         │
│  └── settings.json              API keys                        │
│                                                                 │
│  {project}/.claude/             (git repo - per-project)        │
│  ├── project.json               Project metadata                │
│  ├── features.json              Feature tracking                │
│  └── audit/                     Audit cache & reports           │
│                                                                 │
│  {project}/.github/workflows/   (git repo - per-project)        │
│  ├── feature-auto-ship.yml      Auto-ship on PR merge           │
│  └── scheduled-audit.yml        Weekly audit                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Prerequisites

### 1. Install Claude Code

```bash
# Via npm
npm install -g @anthropic-ai/claude-code

# Or via Homebrew
brew install claude-code
```

### 2. Verify Installation

```bash
claude --version
```

### 3. Required Tools

```bash
# GitHub CLI (for issue sync)
brew install gh
gh auth login

# jq (for JSON manipulation)
brew install jq
```

---

## Step 1: Clone Skills Repository

```bash
git clone https://github.com/doogilasovich/claude-skills.git ~/code/claude-skills
```

### What You Get

```
claude-skills/
├── skills/                 # 122 skills
│   ├── app-idea/          # App idea pipeline (14 commands)
│   ├── feature-idea/      # Feature tracking (18 commands)
│   ├── audit/             # Code & UX auditing (13 presets)
│   ├── project/           # Project management (6 commands)
│   ├── review-*/          # 17 code review categories
│   ├── fix-*/             # 17 code fix categories
│   ├── ux-*/              # 10 UX review categories
│   └── dev-*/             # 10 UX fix categories
├── hooks/
│   ├── session-start.md   # Runs on session start
│   └── pre-pr.md          # Audit gate before PR
├── docs/
│   ├── automations.md     # Automation reference
│   └── ONBOARDING.md      # This file
└── templates/
    ├── project-init.sh    # Initialize new projects
    └── github-workflows/  # GitHub Action templates
```

---

## Step 2: Run Installer

```bash
cd ~/code/claude-skills
chmod +x install.sh
./install.sh
```

### Expected Output

```
Claude Skills Installer
=======================

Source: /Users/you/code/claude-skills
Target: /Users/you/.claude

Creating symlinks...

Installed:
lrwxr-xr-x  docs -> /Users/you/code/claude-skills/docs
lrwxr-xr-x  hooks -> /Users/you/code/claude-skills/hooks
lrwxr-xr-x  skills -> /Users/you/code/claude-skills/skills

Done! Skills are now available in Claude Code.
```

---

## Step 3: Create Personal Configuration

### 3.1 Create CLAUDE.md

```bash
cat > ~/.claude/CLAUDE.md << 'EOF'
# My Claude Code Instructions

## Preferences
- Be concise and direct
- No emojis unless requested
- Focus on technical accuracy

## Context
- Role: [Your role]
- Focus areas: [Your specialties]

## Project Conventions
- [Add team-specific conventions]
EOF
```

### 3.2 Initialize App Ideas Database

```bash
mkdir -p ~/.claude/app-ideas
cat > ~/.claude/app-ideas/ideas.json << 'EOF'
{
  "ideas": [],
  "lastUpdated": null,
  "schemaVersion": "1.0"
}
EOF
```

### 3.3 Initialize Projects Index

```bash
mkdir -p ~/.claude/projects
cat > ~/.claude/projects/index.json << 'EOF'
{
  "projects": [],
  "activeProject": null,
  "lastUpdated": null
}
EOF
```

---

## Step 4: Initialize Your First Project

### Option A: New Project

```bash
cd ~/code/my-project
~/code/claude-skills/templates/project-init.sh . "my-project"
```

### Option B: Existing Project (Already Has .claude/)

If the project already has `.claude/` directory (cloned from team repo):

```bash
cd ~/code/existing-project
# Project data already exists in .claude/
# Just verify:
ls -la .claude/
```

### What Gets Created

```
my-project/
├── .claude/
│   ├── project.json      # Project metadata
│   ├── features.json     # Feature tracking (empty)
│   └── audit/
│       ├── cache/        # Audit stage cache
│       └── reports/      # Archived reports
└── .github/
    └── workflows/
        ├── feature-auto-ship.yml
        └── scheduled-audit.yml
```

---

## Step 5: Sync with GitHub Issues

### 5.1 Initial Feature Sync (Pull from GitHub)

If the project has existing GitHub issues labeled for features:

```bash
cd ~/code/my-project
claude
```

Then:
```
/feature-idea sync --pull
```

This imports GitHub issues into `features.json`.

### 5.2 Push Local Features to GitHub

```
/feature-idea sync --push
```

This creates GitHub issues for local features.

### 5.3 Bidirectional Sync

```
/feature-idea sync
```

Syncs both directions:
- New local features → GitHub issues
- New GitHub issues → local features
- Status changes synced both ways

---

## Step 6: Verify Installation

```bash
cd ~/code/my-project
claude
```

### Test Commands

```
# Project management
/project view                    # Show project dashboard

# App ideas (cross-project)
/app-idea list                   # List all app ideas

# Feature tracking (per-project)
/feature-idea list               # List project features
/feature-idea log "Test feature" # Create test feature

# Audit
/audit --help                    # Show audit options
```

### Expected: Project View

```
┌─ my-project ─────────────────────────────────────────────────┐
│                                                              │
│  Status: active                                              │
│  Features: 0 total (0 ideas, 0 in-progress, 0 shipped)      │
│  Audit: Not run yet                                          │
│                                                              │
│  GitHub: github.com/you/my-project                          │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## Step 7: Enable GitHub Actions

Commit and push the workflow files:

```bash
cd ~/code/my-project
git add .claude/ .github/
git commit -m "chore: initialize Claude project management"
git push
```

### Workflows Enabled

| Workflow | Trigger | Action |
|----------|---------|--------|
| `feature-auto-ship.yml` | PR merged to main | Updates feature status to "shipped" |
| `scheduled-audit.yml` | Weekly (Monday 9am UTC) | Runs audit, creates issues for findings |

---

## Daily Workflow

### Starting a Session

```bash
cd ~/code/my-project
claude
```

Session-start hook automatically:
- Checks for dirty features (need sync)
- Checks audit staleness
- Shows project health

### Working on Features

```bash
# Log new feature
/feature-idea log "Add user authentication"

# Start implementation (creates branch)
/feature-idea implement feat-001

# ... write code ...

# Create PR
/feature-idea pr feat-001

# PR merges → auto-shipped via GitHub Action
```

### Running Audits

```bash
# Quick code audit
/audit

# Full audit with GitHub sync
/audit-sync

# Fix issues from audit
/audit-fix
```

---

## Updating Skills

When skills are updated by the team:

```bash
cd ~/code/claude-skills
git pull
```

Changes apply immediately (symlinked).

---

## Directory Reference

### After Full Setup

```
~/.claude/                              # Personal (private)
├── CLAUDE.md                           # Your instructions
├── settings.json                       # API keys (auto-created)
├── app-ideas/
│   └── ideas.json                      # Cross-project ideas
├── projects/
│   └── index.json                      # Project registry
├── skills -> ~/code/claude-skills/skills
├── hooks -> ~/code/claude-skills/hooks
└── docs -> ~/code/claude-skills/docs

~/code/claude-skills/                   # Shared (git repo)
├── skills/                             # 122 skills
├── hooks/                              # Session hooks
├── docs/                               # Documentation
├── templates/                          # Project templates
├── install.sh                          # Installer
└── README.md

~/code/my-project/                      # Project (git repo)
├── .claude/
│   ├── project.json                    # Project metadata
│   ├── features.json                   # Feature tracking
│   └── audit/                          # Audit data
└── .github/
    └── workflows/
        ├── feature-auto-ship.yml
        └── scheduled-audit.yml
```

---

## Command Quick Reference

### App Ideas (Cross-Project)

| Command | Description |
|---------|-------------|
| `/app-idea log "Title"` | Capture new idea + run pipeline |
| `/app-idea log "Title" --quick` | Just capture, skip pipeline |
| `/app-idea list` | View all ideas |
| `/app-idea view app-001` | Full detail view |
| `/app-idea compare app-001 app-002` | Side-by-side comparison |

### Features (Per-Project)

| Command | Description |
|---------|-------------|
| `/feature-idea list` | List features |
| `/feature-idea log "Title"` | Create feature |
| `/feature-idea implement feat-001` | Start implementation |
| `/feature-idea pr feat-001` | Create pull request |
| `/feature-idea sync` | Sync with GitHub Issues |
| `/feature-idea board` | Kanban board view |

### Audit

| Command | Description |
|---------|-------------|
| `/audit` | Code review + fix |
| `/audit --scope=ux` | UX review + fix |
| `/audit --scope=all` | Both code + UX |
| `/audit-sync` | Review + sync to GitHub |
| `/audit-fix` | Apply fixes from cache |

### Project

| Command | Description |
|---------|-------------|
| `/project view` | Project dashboard |
| `/project list` | All projects |
| `/project create name` | Create new project |
| `/project switch name` | Switch active project |

---

## Troubleshooting

### Skills Not Found

```bash
# Verify symlinks
ls -la ~/.claude/skills

# Re-run installer
cd ~/code/claude-skills && ./install.sh
```

### GitHub Sync Fails

```bash
# Verify GitHub CLI auth
gh auth status

# Re-authenticate
gh auth login
```

### Project Not Recognized

```bash
# Verify .claude/project.json exists
ls -la .claude/

# Re-initialize
~/code/claude-skills/templates/project-init.sh .
```

### Audit Fails

```bash
# Clear audit cache
rm -rf .claude/audit/cache/*

# Run fresh
/audit --fresh
```

---

## Getting Help

```bash
# In Claude Code
/help

# Skill-specific help
/app-idea help
/feature-idea help
/audit --help

# Documentation
cat ~/.claude/docs/automations.md
```
