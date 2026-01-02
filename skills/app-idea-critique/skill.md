---
name: app-idea-critique
description: Devil's advocate review - challenge assumptions and find weaknesses.
user_invocable: true
---

# /app-idea critique

Challenge an app idea with hard questions, identify risky assumptions, and suggest validation steps. See `_reference.md` for schema.

## Args

```
critique <id>                          # Full critique
critique <id> --focus=virality         # Focus on specific aspect
critique <id> --quick                  # Just hard questions, no details
```

## Focus Areas

| Focus | Challenges |
|-------|------------|
| `problem` | Is this a real problem? Who has it? How painful? |
| `solution` | Does the solution actually solve the problem? Simpler alternatives? |
| `market` | Is the market real? Reachable? Willing to pay? |
| `competition` | Why won't incumbents crush you? What's your moat? |
| `virality` | Will users actually share? What drives word-of-mouth? |
| `retention` | Why come back tomorrow? Next week? Next month? |
| `monetization` | Will users pay? Is pricing sustainable? |
| `technical` | Can you actually build this? What's the hardest part? |
| `content` | Where does content come from? Who creates it? At what cost? |
| `legal` | IP issues? Regulations? Platform policies? |

## Behavior

1. Load idea (must have at least `problem` and `concept`)
2. Analyze each focus area for weaknesses
3. Generate hard questions (things founder might avoid thinking about)
4. Identify assumptions that need validation
5. Suggest specific validation actions
6. Rate overall risk level

## Output Format

```
🔴 Critique: app-001 "Accent Showdown"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HARD QUESTIONS

These are uncomfortable but important:

1. Problem Reality
   → Who wakes up thinking "I wish I could mimic accents better"?
   → Is this a vitamin (nice-to-have) or painkiller (must-have)?
   → How do people solve this today? Why is that insufficient?

2. Virality Assumption
   → Would YOU share a video of yourself doing a bad accent?
   → Only high-scorers share → selection bias limits reach
   → Challenge fatigue: friends respond once, then ignore

3. Content Problem
   → 10 clips = boring. 1000 clips = how?
   → Licensed content = expensive. User content = quality issues
   → Who records the "correct" accent clips? Actors cost money

4. Retention Gap
   → Day 1: fun novelty. Day 7: ???
   → No progression system designed
   → Competitive games need matchmaking - tiny user base = no matches

5. Technical Risk
   → Phoneme matching ≠ "sounds good" (technically right but sounds weird)
   → Users may dispute scores → frustration
   → Background noise, microphone quality vary wildly

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RISKY ASSUMPTIONS

These must be true for the idea to work:

┌─────────────────────────────────────────────────────┬──────────┐
│ Assumption                                          │ Risk     │
├─────────────────────────────────────────────────────┼──────────┤
│ People find accent mimicry fun, not embarrassing    │ HIGH     │
│ Phoneme score feels fair and meaningful to users    │ MEDIUM   │
│ Friends respond to challenges (not ignore)          │ HIGH     │
│ Content library is feasible to build affordably     │ HIGH     │
│ Users share scores publicly (not just privately)    │ MEDIUM   │
│ Novelty sustains beyond first week                  │ MEDIUM   │
└─────────────────────────────────────────────────────┴──────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VALIDATION ACTIONS

Do these BEFORE building:

□ Problem validation
  → Interview 10 actors/voice actors about accent practice pain
  → Post in r/voiceacting asking how they practice accents
  → Search for "accent practice" on YouTube - what exists?

□ Solution validation
  → Build paper prototype: show clip, record, show fake score
  → Test with 5 people: do they laugh or cringe at their recording?
  → Ask: "Would you share this score on Instagram?"

□ Virality validation
  → Create fake challenge post, show to 10 people
  → Ask: "If friend sent this, would you download app to respond?"
  → Measure: enthusiasm vs polite nodding

□ Content validation
  → Source 20 accent clips legally - how hard was it?
  → Calculate: cost to license 100 movie clips
  → Test: can you record "reference" accents yourself?

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RISK SUMMARY

│▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░│ 62% - MODERATE-HIGH RISK

Key concerns:
• Content acquisition is underestimated
• Virality depends on users being comfortable sharing
• Retention mechanics not designed

Recommendation: VALIDATE BEFORE BUILDING
Run the validation actions above. If 3+ assumptions fail,
consider pivoting or parking this idea.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Quick Mode

```
🔴 Quick Critique: app-001 "Accent Showdown"

5 Hard Questions:
1. Would YOU share a video of your bad accent attempt?
2. Where do 1000 accent clips come from affordably?
3. Why come back after day 1 novelty wears off?
4. What if phoneme score feels unfair to users?
5. Why won't ELSA just add a "challenge" feature?

Top 3 Risks: content acquisition, viral embarrassment, retention

Action: Interview 5 voice actors about accent practice pain
```

## Storing Critique

Critique results are stored in the idea:

```json
{
  "critique": {
    "completedAt": "2026-01-01T...",
    "riskScore": 62,
    "riskLevel": "moderate-high",
    "topRisks": ["content acquisition", "viral mechanics", "retention"],
    "assumptions": [
      {"text": "People find accent mimicry fun", "risk": "high", "validated": null},
      {"text": "Phoneme score feels fair", "risk": "medium", "validated": null}
    ],
    "validationActions": [
      {"action": "Interview 10 actors", "completed": false},
      {"action": "Build paper prototype", "completed": false}
    ]
  }
}
```

## Tracking Validation

```
/app-idea critique app-001 --validate

Validation Progress: app-001 "Accent Showdown"

□ → ✓  Interview 10 actors (mark as done? y/n)
       Result: _

Updates the `validated` field and `completed` status.
```

## Integration with Workflow

Critique can be run at any stage but is most valuable:
- After `research` - before investing in deep analysis
- After `analysis` - before design work
- Before `validated` - final check before committing to build

If risk score > 70%, suggest parking or pivoting before advancing.
