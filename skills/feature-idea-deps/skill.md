---
name: feature-idea-deps
description: Manage feature dependencies.
user_invocable: true
---

# /feature-idea deps

Manage dependencies between features. See `_reference.md` for schemas.

## Args

```
deps <id> --needs <id>
deps <id> --relates-to <id>
deps <id> --supersedes <id>
deps <id> --remove <id>
deps <id> [--tree]
deps --graph | --blocked | --ready | --all
```

## Types

| Type | Meaning |
|------|---------|
| `needs` | Must complete first (blocking) |
| `relates-to` | Soft relationship |
| `supersedes` | Replaces older feature |

## Behavior

**Add dependency:**
1. Load both features
2. Check for circular dependency
3. Add to `dependencies[]` with type/timestamp
4. Add reverse ref to target's `dependents[]`
5. Save both

**Circular check:** Traverse graph, reject if cycle detected.

**Views:**
- `deps <id>`: Show needs/relates-to/dependents
- `--tree`: Full dependency tree with blocker warnings
- `--graph`: ASCII graph of all dependencies
- `--blocked`: Features with incomplete deps
- `--ready`: Features with all deps met

## Integration

Status changes warn about deps:
- To in-progress: warn if blockers incomplete
- To shipped: warn if dependents in-progress

## Output

```
🔗 feat-002: Audio ducking
   └── needs: feat-001 (idea) ⚠️ BLOCKER
```
