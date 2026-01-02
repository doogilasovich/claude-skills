# Claude Skills

Custom skills, hooks, and documentation for Claude Code.

## Installation

```bash
git clone git@github.com:dmccoy/claude-skills.git ~/code/claude-skills
cd ~/code/claude-skills
./install.sh
```

This creates symlinks from `~/.claude/` to this repo:
- `~/.claude/skills` → `./skills`
- `~/.claude/hooks` → `./hooks`
- `~/.claude/docs` → `./docs`

## Structure

```
claude-skills/
├── skills/           # 122 custom skills
│   ├── app-idea/     # App idea pipeline
│   ├── feature-idea/ # Feature tracking
│   ├── audit/        # Code & UX auditing
│   └── ...
├── hooks/            # Claude Code hooks
│   ├── session-start.md
│   └── pre-pr.md
├── docs/             # Documentation
│   └── automations.md
└── install.sh        # Installer script
```

## Skills Overview

### App Idea Pipeline
Capture, research, analyze, and critique app ideas.

```bash
/app-idea log "My App Idea"     # Capture + run full pipeline
/app-idea list                  # View all ideas
/app-idea compare app-001 app-002
```

### Feature Tracking
Track features from idea to shipped.

```bash
/feature-idea log "New feature"
/feature-idea pipeline feat-001  # Full lifecycle
/feature-idea board             # Kanban view
```

### Audit Pipeline
Code and UX quality auditing.

```bash
/audit                          # Code review + fix
/audit --scope=ux               # UX review + fix
/audit --scope=all              # Both
```

## Hooks

### session-start.md
Runs when Claude Code starts. Shows project health, dirty features, stale audits.

### pre-pr.md
Runs before PR creation. Blocks if critical audit issues found.

## Updating

```bash
cd ~/code/claude-skills
git pull
```

Skills update immediately (symlinked).

## Private Data

These stay in `~/.claude/` (not versioned):
- `CLAUDE.md` - Personal instructions
- `app-ideas/` - Idea database
- `settings.json` - API keys
- Session data (history, todos, etc.)

## License

MIT
