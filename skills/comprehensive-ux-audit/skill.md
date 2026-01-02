---
name: comprehensive-ux-audit
description: "[DEPRECATED] Use /audit --scope=ux. Full UX pipeline - launches 10 reviewers, collects findings, dispatches fix agents."
user_invocable: true
---

# /comprehensive-ux-audit (Deprecated)

> **This skill is deprecated.** Use `/audit --scope=ux` instead.
> This alias exists for backward compatibility.

## Migration

```bash
# Old                                  # New
/comprehensive-ux-audit                → /audit --scope=ux
/comprehensive-ux-audit --review-only  → /audit --scope=ux --review-only
/comprehensive-ux-audit --category X   → /audit --scope=ux --categories=X
/comprehensive-ux-audit --priority X   → /audit --scope=ux --min-severity=X
```

## Behavior

When invoked, this skill redirects to `/audit --scope=ux` with all provided arguments.

The 10 UX review dimensions and their corresponding dev specialists are unchanged.
See `_shared/categories/ux.md` for the full list.

---

## Legacy Documentation

### Pipeline

1. **Pre-flight**: Verify clean git state, build succeeds
2. **Review**: 10 UX agents in parallel → JSON output
3. **Fix**: Route findings to 10 dev specialists
4. **Verify**: Build + tests per branch before merge
5. **Report**: Score improvements summary

### Integration

```
/audit --scope=ux
  └── 10× ux-{dimension} (parallel)
  └── dev-ux-fix-orchestrator
        └── 10× dev-{dimension}
```

### Related

- `ux-comprehensive-review` - Review phase only
- `dev-ux-fix-orchestrator` - Fix phase only
