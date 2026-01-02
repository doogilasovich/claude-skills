# App Idea System Reference

Shared definitions for app-idea skills. Do not duplicate.

## Paths

```
~/.claude/app-ideas/
├── ideas.json                    # All app ideas
├── config.json                   # Settings, inbox config
└── research/
    └── {app-id}/                 # Research cache per idea
        ├── competitors.json
        ├── keywords.json
        └── market.json
```

## Idea Schema

```json
{
  "id": "app-NNN",
  "title": "string",
  "oneLiner": "string",
  "problem": "string",
  "status": "status_enum",
  "statusHistory": [{"from": "X", "to": "Y", "at": "ISO", "reason": "string?"}],
  "source": "manual|inbox|voice|import",
  "rawTranscript": "string|null",
  "score": {
    "problem": 0-10,
    "market": 0-10,
    "competition": 0-10,
    "expertise": 0-10,
    "passion": 0-10,
    "timeToMarket": 0-10,
    "total": 0-60,
    "scoredAt": "ISO|null"
  },
  "research": {
    "competitors": [{"name": "X", "url": "Y", "rating": 4.5, "downloads": "1M+", "notes": "..."}],
    "keywords": [{"term": "X", "volume": "high|med|low", "competition": "high|med|low"}],
    "marketSize": {"tam": "$X", "sam": "$Y", "som": "$Z", "source": "..."},
    "researchedAt": "ISO|null",
    "needsReview": "boolean|null",
    "staleReason": "string|null"
  },
  "design": {
    "personas": [{"name": "X", "description": "...", "painPoints": [...], "goals": [...]}],
    "mvpFeatures": [{"name": "X", "priority": "must|should|could", "effort": "S|M|L|XL"}],
    "techStack": {"ui": "SwiftUI", "backend": "CloudKit", "other": [...]},
    "monetization": "free|freemium|paid|subscription",
    "pricing": {"model": "...", "tiers": [...]},
    "designedAt": "ISO|null"
  },
  "critique": {
    "completedAt": "ISO|null",
    "riskScore": 0-100,
    "riskLevel": "low|moderate|moderate-high|high|critical",
    "topRisks": ["string"],
    "assumptions": [{"text": "string", "risk": "low|medium|high", "validated": "boolean|null"}],
    "validationActions": [{"action": "string", "completed": "boolean", "result": "string|null"}]
  },
  "risks": [{"type": "technical|market|legal|resource", "description": "...", "severity": "high|med|low", "mitigation": "..."}],
  "inspiration": [{"type": "url|screenshot|note", "content": "...", "addedAt": "ISO"}],
  "successCriteria": "string|null",
  "parkUntil": "ISO|null",
  "killedReason": "string|null",
  "launchedAsProject": "string|null",
  "createdAt": "ISO",
  "updatedAt": "ISO"
}
```

## Status

| Key | Emoji | Description | Transitions To |
|-----|-------|-------------|----------------|
| spark | 💭 | Just captured, unprocessed | research, parked, killed |
| research | 🔍 | Competitor/market research | analysis, parked, killed |
| analysis | 📊 | Market sizing, viability | design, parked, killed |
| design | 📐 | MVP scoping, tech decisions | validated, parked, killed |
| validated | ✅ | Scored, ready to build | launched, parked, killed |
| launched | 🚀 | Project created | (terminal) |
| parked | 💤 | On hold, revisit later | spark, research, killed |
| killed | ☠️ | Won't pursue, learnings captured | (terminal) |

## Scoring Rubric

| Dimension | 0-3 | 4-6 | 7-10 |
|-----------|-----|-----|------|
| **Problem** | Nice-to-have | Real pain point | Hair-on-fire problem |
| **Market** | Tiny niche | Growing segment | Large, expanding market |
| **Competition** | Dominated by giants | Crowded but beatable | Blue ocean opportunity |
| **Expertise** | Need to learn everything | Some relevant skills | Deep domain knowledge |
| **Passion** | Meh, just business | Interested | Can't stop thinking about it |
| **Time-to-Market** | 1+ year | 3-6 months | MVP in weeks |

**Total thresholds:**
- 0-20: Kill or park
- 21-35: Needs more validation
- 36-45: Promising, proceed with caution
- 46-60: Strong candidate, prioritize

## Inbox Sources

| Source | Mechanism |
|--------|-----------|
| Reminders | AppleScript reads "App Ideas" list |
| Voice Memos | Whisper transcription via `whisper` CLI |
| Notes | AppleScript reads "App Ideas" folder |
| GitHub | `gh issue list --label "app-idea-inbox"` |

## Research Commands

```bash
# App Store search (via web scraping or API)
curl "https://itunes.apple.com/search?term=X&entity=software&limit=10"

# Web search for competitors
/web-search "X app competitors"

# Keyword research (manual or API)
# Sensor Tower, App Annie require paid API
```

## Edit Staleness Rules

When an idea is modified, later stages may become stale. Prompt user to reset.

### Field → Stale Stages

| Field Modified | Stages Made Stale | Reason |
|----------------|-------------------|--------|
| `title` | - | Cosmetic, no reset needed |
| `problem` | research, analysis, design, score | Core proposition changed |
| `oneLiner` | - | Cosmetic, no reset needed |
| `concept` | research, analysis, design, score | Core mechanics changed |
| `inspirations` | - | Additive, no reset needed |
| `targetAudience` | research, analysis, design | Audience affects market sizing |
| `monetization` | analysis, design | Affects revenue projections |

### Stage Order (for reset options)

```
spark (0) → research (1) → analysis (2) → design (3) → validated (4)
```

### Reset Prompt Logic

```
If current_stage > stale_stage:
  Show: "This edit may invalidate {stale_stages}. Reset to {earliest_stale}?"
  Options:
    [Y] Reset to {earliest_stale} (clears later stage data)
    [N] Keep current status (mark stages as "needs review")
    [S] Skip - I know what I'm doing
```

### Data Clearing on Reset

| Reset To | Clears |
|----------|--------|
| spark | research, analysis, design, score |
| research | analysis, design, score |
| analysis | design, score |
| design | score |

## Project Handoff

When launching, create:
1. Project directory from template
2. Initialize git repo
3. Create feature-idea entries for MVP features
4. Set up RevenueCat if monetized
5. Create GitHub repo + project board

## Output Conventions

**Human-readable only.** Suppress all technical output:

| Show | Hide |
|------|------|
| Formatted skill output | File diffs |
| Status confirmations | JSON snippets |
| Tables, lists, progress | `cat -n` output |
| Error messages | Raw tool responses |

Example - after saving:
```
✓ Saved critique to app-001 "Accent Showdown"
   Risk Score: 58% (moderate-high)
```

NOT:
```
The file has been updated. Here's the result of running `cat -n`:
   156→      "critique": {
   ...
```

Read/write operations happen silently. Only show the formatted result defined in each skill's output section.

## Output Formats

```
# List view
ID       Status    Score  Title
────────────────────────────────────────
app-001  📊 analysis  38  BirdTok
app-002  💭 spark     --  Gym Timer

# Detail view
💭 app-001: BirdTok
   "TikTok for bird watching"

   Problem: Birders can't share sightings with context
   Status: research
   Score: -- (not scored)

   Created: 2 days ago
   Source: voice memo
```
