---
name: comprehensive-code-audit
description: "[DEPRECATED] Use /audit --scope=code. Runs 17 reviewers in parallel, consolidates, dispatches to 17 fixers."
user_invocable: true
---

# /comprehensive-code-audit (Deprecated)

> **This skill is deprecated.** Use `/audit --scope=code` instead.
> This alias exists for backward compatibility.

## Migration

```bash
# Old                                    # New
/comprehensive-code-audit                → /audit --scope=code
/comprehensive-code-audit --review-only  → /audit --scope=code --review-only
/comprehensive-code-audit --fix-only     → /audit --scope=code --stage=fix
```

## Behavior

When invoked, this skill redirects to `/audit --scope=code` with all provided arguments.

The 17 code review categories and their corresponding fix specialists are unchanged.
See `_shared/categories/code.md` for the full list.

---

## Legacy Documentation

### Options

| Option | Description |
|--------|-------------|
| `--progress` | Human-readable output |
| `--review-only` | No fixes |
| `--fix-only` | Use previous review |
| `--categories=LIST` | Filter categories |
| `--min-severity=X` | low/medium/high/critical |

### Pipeline

1. **Parallel Review**: 17 review skills via Task tool
2. **Consolidation**: Deduplicate, merge, sort by severity
3. **Fix Dispatch**: Invoke `/fix-{category}` with findings
4. **Verification**: Build verification

### Integration

```
/audit --scope=code
  └── 17× /review-{cat} (parallel)
  └── /code-fix-orchestrator
        └── 17× /fix-{cat}
```
