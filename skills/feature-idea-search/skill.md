---
name: feature-idea-search
description: Search features by query.
user_invocable: true
---

# /feature-idea search

Search features with ranking. See `_reference.md` for schemas.

## Args

```
search <query> [filters]
```

| Filter | Description |
|--------|-------------|
| --status=X | Filter by status |
| --label=X | Filter by label |
| --priority=X | Filter by priority |
| --since=DATE | After date |
| --all-projects | Cross-project |
| --format=ids\|json | Output format |
| --save="name" | Save search |
| --saved="name" | Run saved |

## Behavior

1. Parse query (case-insensitive, partial match)
2. Search: title (+3), description (+2), labels (+1), files (+1)
3. Apply filters
4. Sort by score, then updatedAt
5. Output table

## Output

```
🔍 Results for "audio" (3 matches)

ID        Status      Title                    Labels
──────────────────────────────────────────────────────
feat-001  💡 idea     Phoneme scoring          audio, ml
feat-007  🚀 shipped  Audio ducking            audio
```

No results → suggest alternatives.
