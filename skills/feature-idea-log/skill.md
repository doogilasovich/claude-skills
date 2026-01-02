---
name: feature-idea-log
description: Log new feature idea.
user_invocable: true
---

# /feature-idea log

Create feature with interactive prompts. See `_reference.md` for schemas.

## Args

```
log <title> [--description "X"] [--labels X,Y] [--no-sync]
```

## Behavior

1. Parse title (required)
2. Detect project type from cwd files
3. If no --description: prompt "Description (what problem?):"
4. Suggest labels from keyword matching (see `_reference.md`)
5. Detect related files from conversation context
6. **Capture context** (auto):
   - Code snippets discussed → `conversationContext.codeSnippets`
   - Decisions made → `conversationContext.decisions`
   - Alternatives → `conversationContext.alternatives`
   - URLs → `conversationContext.references`
7. Generate ID: `feat-{NNN}` (next sequential)
8. Create feature object (see schema)
9. Save to `features.json`
10. Unless --no-sync: create GitHub issue with `feature-idea` + `status:idea` labels
11. Update feature with issue number, set dirty=false

## Output

```
✅ Feature logged: feat-002
   Status: 💡 idea
   Labels: ui, video
   GitHub: #323
```
