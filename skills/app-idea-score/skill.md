---
name: app-idea-score
description: Score idea viability.
user_invocable: true
---

# /app-idea score

Score idea using rubric. See `_reference.md` for schema.

## Args

```
score <id>
score <id> --interactive          # Guided scoring
score <id> --auto                 # Auto-score from research
score <id> --refresh              # Re-score
```

## Scoring Rubric

Each dimension 0-10:

### Problem (0-10)
- 0-2: Nice to have, no real pain
- 3-4: Minor inconvenience
- 5-6: Real frustration, workarounds exist
- 7-8: Significant pain, poor solutions
- 9-10: Hair-on-fire problem

### Market (0-10)
- 0-2: <10K potential users
- 3-4: 10K-100K users
- 5-6: 100K-1M users
- 7-8: 1M-10M users
- 9-10: 10M+ users

### Competition (0-10)
- 0-2: Dominated by well-funded players
- 3-4: Strong competition, hard to differentiate
- 5-6: Competition exists, clear gaps
- 7-8: Weak competition, obvious opportunities
- 9-10: Blue ocean, no direct competitors

### Expertise (0-10)
- 0-2: No relevant skills
- 3-4: Would need significant learning
- 5-6: Some transferable skills
- 7-8: Strong relevant experience
- 9-10: Domain expert

### Passion (0-10)
- 0-2: Purely mercenary
- 3-4: Mild interest
- 5-6: Genuinely curious
- 7-8: Excited to build
- 9-10: Would build even if unprofitable

### Time-to-MVP (0-10)
- 0-2: 6+ months
- 3-4: 4-6 months
- 5-6: 2-4 months
- 7-8: 1-2 months
- 9-10: <1 month

## Score Interpretation

```
0-20:  Skip - Not worth pursuing
21-35: Maybe - Needs stronger case
36-45: Promising - Worth deeper dive
46-55: Strong - Prioritize
56-60: Exceptional - Start now
```

## Behavior

### Interactive Mode

```
🎯 Scoring: app-001 "BirdTok"

Rate each dimension 0-10:

Problem: How painful is this?
(Existing solutions are clunky, photo-only)
> 7

Market: How many potential users?
(45M US birders, 10M use apps)
> 6

[Continue for each dimension...]
```

### Auto Mode

Infers scores from research data:
- Problem score from gap analysis
- Market from TAM/SAM
- Competition from competitor strength
- Prompts for Expertise/Passion (subjective)

## Output

```
🎯 Scored: app-001 "BirdTok"

┌─ Score Breakdown ─────────────────────────────────────┐
│ Problem:      7/10  ████████░░  Real frustration     │
│ Market:       6/10  ███████░░░  1M+ potential users  │
│ Competition:  8/10  █████████░  Weak social options  │
│ Expertise:    5/10  ██████░░░░  Some iOS experience  │
│ Passion:      7/10  ████████░░  Genuinely excited    │
│ Time-to-MVP:  5/10  ██████░░░░  ~3 months estimate   │
│ ─────────────────────────────────────────────────────│
│ Total:       38/60  ████████░░  Promising            │
└───────────────────────────────────────────────────────┘

   Recommendation: Worth pursuing
   Strengths: Underserved niche, clear differentiation
   Risks: ML complexity, content moderation

   Next: /app-idea compare app-001 app-002
```
