---
name: app-idea-log
description: Capture new app idea. Auto-triggers evaluation pipeline by default.
user_invocable: true
---

# /app-idea log

Quick capture app idea with automatic evaluation pipeline. See `_reference.md` for schema.

## Args

```
log <title>                              # Log + auto-run pipeline
log <title> --problem="X"                # With problem statement
log <title> --oneliner="Y"               # With one-liner description
log <title> --inspiration="url or note"  # With inspiration source

# Pipeline control
log <title> --quick                      # Just log, skip pipeline
log <title> --inbox                      # Log to inbox for batch processing
log <title> --to=research                # Stop pipeline after research
log <title> --to=analysis                # Stop pipeline after analysis
```

## Behavior

### Default Flow (with pipeline)

1. **Capture**: Generate ID, create idea with status=spark
2. **Interactive**: If only title provided, prompt for problem/oneliner
3. **Save**: Write to ideas.json
4. **Pipeline**: Automatically run `/app-idea pipeline <id>`
   - Research: competitors, market, keywords
   - Analyze: TAM/SAM/SOM, revenue projection, viability
   - Critique: hard questions, assumptions, risk score

### Quick Flow (--quick)

1. **Capture**: Generate ID, create idea with status=spark
2. **Save**: Write to ideas.json
3. **Done**: Show confirmation, suggest next steps

### Inbox Flow (--inbox)

1. **Capture**: Generate ID, create idea with status=inbox
2. **Save**: Write to ideas.json
3. **Done**: Idea queued for batch processing

## Interactive Mode

If only title provided, prompt:
```
💭 New idea: "Shazam for birds"

What problem does this solve?
> Can't identify bird calls while hiking

One-liner description?
> Identify birds by their songs using AI

Any inspiration? (URL, app name, or skip)
> Merlin Bird ID app

Run full evaluation pipeline? [Y/n] _
```

## Output (Default with Pipeline)

```
💭 Logging: app-005 "Shazam for birds"

   Title: Shazam for birds
   Problem: Can't identify bird calls while hiking
   One-liner: Identify birds by their songs using AI

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔄 Starting evaluation pipeline...

[Pipeline output follows - research, analyze, critique]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Pipeline complete!

   Status: spark → analysis
   Viability: MODERATE-HIGH
   Risk: 45%

   Next: /app-idea design app-005
```

## Output (--quick)

```
💭 Logged: app-005

   Title: Shazam for birds
   Problem: Can't identify bird calls while hiking
   One-liner: Identify birds by their songs using AI
   Status: spark

   Next steps:
   • /app-idea pipeline app-005  (full evaluation)
   • /app-idea research app-005  (just research)
   • /app-idea view app-005      (view details)
```

## Output (--inbox)

```
📥 Queued: app-005 "Shazam for birds"

   Added to inbox for batch processing.

   Process inbox: /app-idea inbox process
   View inbox: /app-idea list --status=inbox
```

## Why Auto-Pipeline?

Ideas without research are just wishful thinking. Auto-pipeline ensures:
- Every idea gets proper evaluation
- Research happens while context is fresh
- Consistent process, no skipped steps
- Faster decisions on viability

Use `--quick` when you just want to capture a fleeting thought.
Use `--inbox` when you're capturing many ideas for later batch review.
