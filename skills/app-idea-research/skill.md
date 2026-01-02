---
name: app-idea-research
description: Research competitors and market.
user_invocable: true
---

# /app-idea research

Research competitors and market. See `_reference.md` for schema.

## Args

```
research <id>                      # Interactive research
research <id> --auto               # Auto-search, summarize
research <id> --competitors-only   # Just competitor analysis
research <id> --keywords-only      # Just keyword research
```

## Behavior

### 1. Auto Mode (--auto)

Uses web search and App Store API:

```bash
# App Store search
curl "https://itunes.apple.com/search?term={keywords}&entity=software&country=us&limit=20"

# Web search for competitors
WebSearch: "{title} app competitors"
WebSearch: "{problem} apps iOS"
```

Parse results:
- Top 5-10 competitors
- Ratings, download estimates
- Key features
- Pricing models

### 2. Interactive Mode

Prompts for research input:
```
🔍 Researching: app-001 "BirdTok"

Found 8 potential competitors. Reviewing...

┌─ Merlin Bird ID ────────────────────────────────────────┐
│ Rating: 4.8★ | Downloads: 5M+ | Price: Free            │
│ Publisher: Cornell Lab                                  │
│                                                         │
│ Key features:                                           │
│ • Photo ID, Sound ID                                    │
│ • Bird packs by region                                  │
│ • Offline support                                       │
│                                                         │
│ Gaps/Opportunities:                                     │
│ • No social features                                    │
│ • No video                                              │
│ • Academic, not casual                                  │
└─────────────────────────────────────────────────────────┘

Add notes about this competitor? (or skip)
> Strong ID tech but no community aspect

[Continue for each competitor...]
```

### 3. Keyword Research

Analyze search terms:
- Search volume (estimate from autocomplete behavior)
- Competition level (# of results)
- Suggested keywords

### 4. Update Status

If status=spark, transition to research.

### 5. Cache Results

Save to `~/.claude/app-ideas/research/{id}/`:
- competitors.json
- keywords.json

## Output

```
🔍 Research complete: app-001

   Competitors: 5 analyzed
   ├── Merlin Bird ID (4.8★, 5M+) - Photo/sound ID
   ├── eBird (4.6★, 1M+) - Citizen science
   ├── BirdNET (4.5★, 500K+) - Sound only
   ├── Audubon (4.4★, 100K+) - Field guide
   └── Chirp! (4.2★, 50K+) - Game-ified

   Keywords:
   ├── "bird identification" - High volume, High competition
   ├── "bird sounds" - High volume, Medium competition
   ├── "birding app" - Medium volume, Low competition
   └── "bird watching social" - Low volume, Low competition

   Opportunity: Social/video angle underserved

   Status: spark → 🔍 research
   Next: /app-idea analyze app-001
```
