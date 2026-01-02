---
name: app-idea-pipeline
description: Run full app-idea evaluation pipeline (research → analyze → critique).
user_invocable: true
---

# /app-idea pipeline

Runs the complete evaluation pipeline for an app idea in one command.

## Args

```
pipeline <id>                    # Full pipeline with pauses
pipeline <id> --auto             # No pauses, run all phases
pipeline <id> --to=research      # Stop after research
pipeline <id> --to=analysis      # Stop after analysis
pipeline <id> --skip=critique    # Skip specific phase
pipeline <id> --resume           # Resume from last completed phase
```

## Pipeline Stages

```
┌─────────┐    ┌─────────┐    ┌─────────┐
│ research│───▶│ analyze │───▶│ critique│
└─────────┘    └─────────┘    └─────────┘
     │              │              │
     ▼              ▼              ▼
 Competitors    Market Size    Hard Questions
 Keywords       Revenue Est    Risk Score
 Trends         Viability      Assumptions
```

## Behavior

1. **Validate**: Check idea exists and has required fields (title, problem)
2. **Research Phase**:
   - Run web searches for competitors, market, keywords
   - Update ideas.json with research data
   - Status: `spark` → `research`
   - Display summary, pause for review (unless --auto)

3. **Analysis Phase**:
   - Calculate TAM/SAM/SOM from research
   - Build revenue projections
   - Score viability dimensions
   - Status: `research` → `analysis`
   - Display summary, pause for review (unless --auto)

4. **Critique Phase**:
   - Generate hard questions
   - Identify risky assumptions
   - Create validation action list
   - Calculate risk score
   - Status remains `analysis` (critique doesn't advance)
   - Display final summary

5. **Completion**:
   - Show pipeline summary
   - Recommend next steps based on scores

## Output

```
🔄 Pipeline: app-001 "Shazam for birds"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PHASE 1: RESEARCH                                         [Running]

Searching competitors...
Analyzing market...
Identifying keywords...

✅ Research complete
   • 5 competitors analyzed
   • Market: $500M TAM
   • 8 keywords identified

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Continue to Analysis phase? [Y/n] _

PHASE 2: ANALYSIS                                         [Running]

Calculating market size...
Building revenue model...
Scoring viability...

✅ Analysis complete
   • TAM: $500M → SAM: $80M → SOM: $2M
   • Year 1 projection: $25K-$150K
   • Viability: MODERATE-HIGH

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Continue to Critique phase? [Y/n] _

PHASE 3: CRITIQUE                                         [Running]

Generating hard questions...
Identifying assumptions...
Calculating risk score...

✅ Critique complete
   • 5 hard questions generated
   • 6 risky assumptions identified
   • Risk score: 45% (moderate)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PIPELINE COMPLETE

  Status: spark → analysis
  Viability: MODERATE-HIGH
  Risk: 45% (moderate)

  Recommendation: PROCEED WITH CAUTION

  Next Steps:
  • /app-idea design app-001    (define MVP)
  • /app-idea score app-001     (formal scoring)
  • /app-idea launch app-001    (when ready)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Integration

This skill is automatically invoked by `/app-idea log` unless `--quick` flag is used.

```bash
/app-idea log "My Idea"           # Logs + runs pipeline
/app-idea log "My Idea" --quick   # Just logs, no pipeline
```

## Error Handling

- If any phase fails, pipeline pauses with error details
- Use `--resume` to continue from last successful phase
- Pipeline state stored in idea's metadata for resumption
