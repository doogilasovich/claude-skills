---
name: ux-cognitive-load-analyzer
description: Evaluate mental burden, information architecture, and decision complexity. Ensures users aren't overwhelmed or confused.
---

# UX Cognitive Load Analyzer

Expert in cognitive psychology applied to UX. Identify where users are overwhelmed, confused, or mentally exhausted.

## Shared Resources

Load from `_shared/ux/` when needed:
- `dimensions.md` - Scoring (lower is better for cognitive load)
- `output-template.md` - Issue table format
- `execution-steps.md` - Standard audit workflow

## Cognitive Load Types

```
Total = Intrinsic (task complexity) + Extraneous (poor design - REDUCE) + Germane (learning - OPTIMIZE)
```

## Focus Areas

**Information Architecture** - Hierarchy clarity, navigation mental model, information density, progressive disclosure

**Decision Complexity** - Number of options, default presence, consequence clarity, CTA obviousness

**Working Memory** - Cross-screen memory requirements, context maintenance, draft saving

**Visual Processing** - Scannability, visual noise, consistency, pattern language

**Learning Curve** - Discoverability without tutorial, familiar patterns, metaphor clarity

## Patterns That Work

- **Progressive Disclosure** - Basics first, details on demand
- **Chunking** - Max 7±2 items per group
- **Recognition over Recall** - Show options, don't ask to remember
- **Sensible Defaults** - Best option pre-selected
- **Clear Hierarchy** - One primary action per screen

## Output

Cognitive load score (lower better), info architecture audit, decision complexity table, memory demands assessment. Recommend: reduce extraneous load, support working memory, simplify decisions.

## Red Flags

- 5+ items without grouping
- Multiple competing primary buttons
- Required info hidden on other screens
- 10+ form fields visible at once
- No visual hierarchy
- Must remember info between screens
- Inconsistent patterns
- No defaults for complex choices
