# Claude Skills

Custom skills, hooks, and documentation for Claude Code project management.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/doogilasovich/claude-skills.git ~/code/claude-skills

# 2. Install (creates symlinks to ~/.claude/)
cd ~/code/claude-skills
./install.sh

# 3. Initialize a project
cd ~/code/my-project
~/code/claude-skills/templates/project-init.sh .
```

**Full setup guide:** [docs/ONBOARDING.md](docs/ONBOARDING.md)

## Structure

```
claude-skills/
├── skills/              # 122 custom skills
│   ├── app-idea/        # App idea pipeline (14 commands)
│   ├── feature-idea/    # Feature tracking (18 commands)
│   ├── audit/           # Code & UX auditing (13 presets)
│   ├── project/         # Project management (6 commands)
│   ├── review-*/        # 17 code review categories
│   ├── fix-*/           # 17 code fix categories
│   ├── ux-*/            # 10 UX review categories
│   └── dev-*/           # 10 UX fix categories
├── hooks/               # Claude Code hooks
│   ├── session-start.md # Project health on startup
│   └── pre-pr.md        # Audit gate before PR
├── docs/                # Documentation
│   ├── ONBOARDING.md    # Full setup guide
│   └── automations.md   # Automation reference
├── templates/           # Project templates
│   ├── project-init.sh  # Initialize new projects
│   └── github-workflows/# GitHub Action templates
└── install.sh           # Installer script
```

## What It Does

### App Idea Pipeline
Capture, research, analyze, and critique app ideas across all projects.

```bash
/app-idea log "My App Idea"          # Capture + full evaluation pipeline
/app-idea list                       # View all ideas
/app-idea compare app-001 app-002    # Side-by-side comparison
```

### Feature Tracking
Track features from idea to shipped, synced with GitHub Issues.

```bash
/feature-idea log "New feature"      # Create feature
/feature-idea implement feat-001     # Create branch + plan
/feature-idea pr feat-001            # Create pull request
/feature-idea sync                   # Sync with GitHub Issues
```

### Audit Pipeline
Code (17 categories) and UX (10 categories) quality auditing.

```bash
/audit                               # Code review + fix
/audit --scope=ux                    # UX review + fix
/audit --scope=all                   # Both
/audit-sync                          # Review + sync to GitHub Issues
```

### Project Management
Multi-project dashboard and switching.

```bash
/project view                        # Project dashboard
/project list                        # All projects
/project create my-app               # Create new project
```

## Hooks

| Hook | Trigger | Action |
|------|---------|--------|
| `session-start.md` | Session starts | Shows project health, dirty features, stale audits |
| `pre-pr.md` | Before PR creation | Blocks if critical audit issues found |

## GitHub Actions

Templates in `templates/github-workflows/`:

| Workflow | Trigger | Action |
|----------|---------|--------|
| `feature-auto-ship.yml` | PR merged to main | Auto-updates feature status to "shipped" |
| `scheduled-audit.yml` | Weekly (Monday 9am UTC) | Runs audit, creates issues for findings |

## Installation

### Personal Setup

```bash
# Clone and install
git clone https://github.com/doogilasovich/claude-skills.git ~/code/claude-skills
cd ~/code/claude-skills && ./install.sh

# Create personal config
cat > ~/.claude/CLAUDE.md << 'EOF'
# My Claude Code Instructions
- Be concise
- No emojis unless requested
EOF

# Initialize app ideas database
mkdir -p ~/.claude/app-ideas
echo '{"ideas":[],"lastUpdated":null}' > ~/.claude/app-ideas/ideas.json
```

### Project Setup

```bash
cd ~/code/my-project
~/code/claude-skills/templates/project-init.sh .

# Commit to repo
git add .claude/ .github/
git commit -m "chore: initialize Claude project management"
git push
```

## Updating

```bash
cd ~/code/claude-skills
git pull
```

Skills update immediately (symlinked).

## Private Data

These stay in `~/.claude/` (not versioned):
- `CLAUDE.md` - Personal instructions
- `app-ideas/ideas.json` - Cross-project idea database
- `settings.json` - API keys
- `projects/index.json` - Project registry
- Session data (history, todos, etc.)

## Documentation

- [ONBOARDING.md](docs/ONBOARDING.md) - Full setup guide for new team members
- [automations.md](docs/automations.md) - Pipeline and automation reference

## License

MIT
