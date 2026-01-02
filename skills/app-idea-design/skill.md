---
name: app-idea-design
description: Design personas, MVP, and tech stack.
user_invocable: true
---

# /app-idea design

Product design phase. See `_reference.md` for schema.

## Args

```
design <id>
design <id> --personas            # Focus on user personas
design <id> --mvp                 # Focus on MVP features
design <id> --tech                # Focus on tech stack
design <id> --refresh             # Re-run design
```

## Prerequisites

Should complete analysis first.

## Behavior

### 1. User Personas

Define 2-3 personas:

```
Primary Persona:
- Name: "Weekend Birder Bob"
- Demographics: 35-55, suburban, $75K+
- Goals: Identify birds casually, share with friends
- Pain points: Apps too complex, no social aspect
- Tech comfort: Moderate, uses social media

Secondary Persona:
- Name: "Serious Sarah"
- Demographics: 25-45, any location
- Goals: Track life list, contribute to science
- Pain points: Data scattered across apps
```

### 2. MVP Features

Categorize using MoSCoW:

```
Must Have (launch blockers):
- [ ] Core value proposition feature
- [ ] Basic auth/onboarding
- [ ] Minimum viable UX

Should Have (week 2):
- [ ] Social features
- [ ] Notifications
- [ ] Settings

Could Have (v1.1):
- [ ] Gamification
- [ ] Premium features
- [ ] Integrations

Won't Have (out of scope):
- [ ] Web version
- [ ] Android
```

### 3. Tech Stack

Recommend based on requirements:

```
Platform: iOS 17+
Architecture: SwiftUI + MVVM
Dependencies:
- RevenueCat (monetization)
- Firebase (auth, analytics)
- CoreML (on-device ML)

Build vs Buy decisions:
- Bird ID: Use existing API (Merlin?) vs train model
- Video: AVFoundation native
- Social: Build custom vs integrate
```

### 4. Wireframes

ASCII wireframes for key screens:

```
┌─────────────────────┐
│ ◀  Home      ⚙️    │
├─────────────────────┤
│ ┌─────────────────┐ │
│ │                 │ │
│ │   Camera View   │ │
│ │                 │ │
│ └─────────────────┘ │
│                     │
│ [🎤 Record] [📷 ID] │
│                     │
│ Recent Sightings    │
│ ├── Robin (2m ago)  │
│ └── Cardinal (1h)   │
└─────────────────────┘
```

### 5. Update Status

Transition to design.

## Output

```
🎨 Design complete: app-001 "BirdTok"

┌─ Personas ────────────────────────────────────────────┐
│ 👤 Weekend Birder Bob (Primary)                       │
│    35-55, suburban, casual interest                   │
│    Goal: Easy ID + share with friends                 │
│                                                       │
│ 👤 Serious Sarah (Secondary)                          │
│    25-45, dedicated hobbyist                          │
│    Goal: Life list + citizen science                  │
└───────────────────────────────────────────────────────┘

┌─ MVP Features ────────────────────────────────────────┐
│ Must:   Video capture, Bird ID, Feed, Profile        │
│ Should: Comments, Follows, Location tags             │
│ Could:  Challenges, Badges, Expert mode              │
│ Won't:  Android, Web, Offline-first                  │
└───────────────────────────────────────────────────────┘

┌─ Tech Stack ──────────────────────────────────────────┐
│ Platform:  iOS 17+ / SwiftUI                          │
│ Backend:   Firebase (auth, storage, analytics)        │
│ ML:        CoreML + Vision (on-device)               │
│ Payments:  RevenueCat                                │
│ Est. deps: 4 SPM packages                            │
└───────────────────────────────────────────────────────┘

   Status: analysis → 🎨 design
   Next: /app-idea score app-001
```
