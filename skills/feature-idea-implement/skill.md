---
name: feature-idea-implement
description: Start implementation (branch, plan, context).
user_invocable: true
---

# /feature-idea implement

Start implementation workflow. See `_reference.md` for schemas.

## Args

```
implement <id>
```

## Prerequisites

Status must be: idea, exploring, designing, or ready.
Git working directory must be clean.

## Behavior

1. Load feature, validate status
2. Check `git status --porcelain` (must be clean)
3. Create branch: `feature/feat-{id}-{slug}`
   ```bash
   git checkout main && git pull
   git checkout -b feature/feat-{id}-{slug}
   ```
4. Update feature: status=in-progress, branch={name}, dirty=true
5. Sync to GitHub: comment + update labels
6. Generate implementation plan (prompt user for approval)
7. Create todos via TodoWrite
8. Load related files into context

## Resume

If already in-progress → load context, show progress.

## Output

```
🚀 Started: feat-001
   Branch: feature/feat-001-phoneme-scoring
   Status: in-progress
   GitHub: #322 (updated)
   Todos: 12 items

   Ready to code. When done: /feature-idea pr feat-001
```
