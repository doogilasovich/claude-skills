---
name: code-audit
description: "[DEPRECATED] Use /audit --scope=code. Code quality pipeline with review, GitHub sync, fixes, and verification."
user_invocable: true
---

# /code-audit (Deprecated)

> **This skill is deprecated.** Use `/audit --scope=code` instead.
> All options remain compatible. This alias exists for backward compatibility.

## Migration

```bash
# Old                          # New
/code-audit                    → /audit --scope=code
/code-audit --preset=quick     → /audit --preset=quick
/code-audit --sync             → /audit --scope=code --sync
```

## Behavior

When invoked, this skill redirects to `/audit --scope=code` with all provided arguments.

---

## Legacy Documentation

See `/audit` for full documentation. The following options are supported:

| Option | Description |
|--------|-------------|
| `--progress` | Human-readable output |
| `--quiet` | One-line output |
| `--stage=X` | review, sync, fix, verify |
| `--resume` | Continue from last stage |
| `--fresh` | Ignore cache |
| `--sync` | GitHub bidirectional sync |
| `--sync=push/pull` | One-way sync |
| `--dry-run` | Preview without changes |
| `--categories=X` | Filter categories |
| `--min-severity=X` | low, medium, high, critical |
| `--preset=X` | quick, release, pr, nightly |
| `--incremental` | Changed files only |
| `--history` | Show trend |
