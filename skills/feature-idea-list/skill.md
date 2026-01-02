---
name: feature-idea-list
description: List features with optional filters.
user_invocable: true
---

# /feature-idea list

Display features table. See `_reference.md` for schemas.

## Args

| Flag | Filter |
|------|--------|
| --status=X | By status (comma-sep) |
| --label=X | By label |
| --all | Include archived |
| --deps | Show dependency tree |
| --format=ids\|json\|md | Output format |

## Behavior

1. Load `features.json` for current project
2. Apply filters
3. Sort: in-progress → ready → designing → exploring → idea → shipped → archived
4. Output table:

```
📋 Features for {project} ({N} total)

ID        Status      Title                    Labels         GitHub
──────────────────────────────────────────────────────────────────────
feat-001  💡 idea     Title here               audio, ml      #322
```

Empty → "No features. Use `log feature idea: <title>` to create."
