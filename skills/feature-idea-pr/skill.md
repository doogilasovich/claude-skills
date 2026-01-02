---
name: feature-idea-pr
description: Create pull request for feature.
user_invocable: true
---

# /feature-idea pr

Create PR linked to issue. See `_reference.md` for schemas.

## Args

```
pr <id>
```

## Prerequisites

- Status: in-progress
- Branch set
- Commits ahead of main

## Behavior

1. Load feature, verify status/branch
2. Check git state:
   - On feature branch
   - Has commits: `git log main..HEAD`
3. Warn if todos incomplete
4. Push: `git push -u origin {branch}`
5. Create PR:
   ```bash
   gh pr create --title "feat-{id}: {title}" --body "Closes #{issue}..." --base main
   ```
6. Update feature: pullRequest={url}, dirty=true
7. Comment on issue: `gh issue comment {n} --body "📬 PR created: {url}"`

## Output

```
✅ PR created: feat-001
   PR: https://github.com/.../pull/45
   Branch: feature/feat-001-... → main
   Issue: #322 (closes on merge)

   Next: merge PR, then /feature-idea ship feat-001
```
