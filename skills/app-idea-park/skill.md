---
name: app-idea-park
description: Pause idea for later.
user_invocable: true
---

# /app-idea park

Park idea (pause for later). See `_reference.md` for schema.

## Args

```
park <id>
park <id> --reason="Waiting for iOS 18"
park <id> --remind="2024-06-01"          # Set reminder
```

## Behavior

1. Update status to parked
2. Record reason and optional reminder
3. Parked ideas excluded from default list view

## Common Reasons

- "Waiting for technology" (new iOS APIs, etc.)
- "Need more expertise first"
- "Market timing not right"
- "Currently building another project"
- "Need funding/resources"

## Output

```
🅿️ Parking: app-002 "ParkingPal"

   Reason: Currently focused on BirdTok, will revisit Q3

   Reminder set: 2024-07-01

   Parked ideas won't appear in default list.
   View with: /app-idea list --parked

   Status: analysis → 🅿️ parked

   To resume: /app-idea status app-002 analysis
```
