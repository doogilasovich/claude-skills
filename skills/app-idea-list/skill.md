---
name: app-idea-list
description: View app ideas.
user_invocable: true
---

# /app-idea list

View app ideas with filters. See `_reference.md` for schema.

## Args

```
list                               # All active ideas
list --status=spark                # Filter by status
list --status=validated            # Ready to launch
list --score-min=40                # High-scoring only
list --all                         # Include killed/launched
list --parked                      # Parked ideas only
```

## Behavior

1. Load ideas.json
2. Apply filters (default: exclude killed/launched)
3. Sort by: status order, then score (desc), then date
4. Display table

## Status Order

1. validated (ready to act)
2. design
3. analysis
4. research
5. spark (newest first)
6. parked
7. killed/launched (hidden by default)

## Output

```
💭 App Ideas (5 total)

ID       Status        Score  Title                    Age
────────────────────────────────────────────────────────────
app-003  ✅ validated    48   BirdTok                  5d
app-001  📐 design       38   Gym Timer Pro            2w
app-005  📊 analysis     --   Recipe Scaler            3d
app-002  🔍 research     --   Meditation Timer         1w
app-006  💭 spark        --   Dog Walker Network       1d

Parked: 2 ideas (show with --parked)
Killed: 3 ideas (show with --all)

Next: /app-idea view <id>
```
