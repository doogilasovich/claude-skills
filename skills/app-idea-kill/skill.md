---
name: app-idea-kill
description: Mark idea as won't pursue.
user_invocable: true
---

# /app-idea kill

Mark idea as killed (won't pursue). See `_reference.md` for schema.

## Args

```
kill <id>
kill <id> --reason="Too competitive"
```

## Behavior

1. Prompt for reason if not provided
2. Update status to killed
3. Record decision for future reference

## Common Reasons

- "Market too small"
- "Too competitive"
- "Not enough differentiation"
- "Technical complexity too high"
- "Lost interest"
- "Found better opportunity"
- "Validated problem doesn't exist"

## Output

```
💀 Killing: app-003 "RecipeScale"

   Reason: Market too competitive, no clear differentiation

   This idea will be archived but preserved for reference.
   You can resurrect it later with: /app-idea status app-003 spark

   Status: research → 💀 killed

   Active ideas: /app-idea list
```
