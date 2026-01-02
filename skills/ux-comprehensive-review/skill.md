---
name: ux-comprehensive-review
description: Comprehensive UX audit that launches specialized agents in parallel to evaluate friction, delight, accessibility, monetization, retention, virality, onboarding, trust, cognitive load, and platform compliance. Returns a unified report with prioritized recommendations.
---

# Comprehensive UX Review

UX Director orchestrating comprehensive app review. Launch 10 specialized agents, synthesize findings into actionable report.

## Shared Resources

Load from `_shared/ux/` when needed:
- `dimensions.md` - 10 review dimensions and scoring
- `agent-prompts.md` - Concise prompts for each agent
- `output-template.md` - Report structure

## Dimensions

1. Friction Analyst - Journey friction, drop-off risks
2. Delight Auditor - Emotional design, micro-interactions
3. Accessibility Checker - WCAG, VoiceOver, Dynamic Type
4. Monetization Strategist - Paywall timing, value perception
5. Retention Specialist - Habit loops, re-engagement
6. Viral Growth Hacker - Share mechanics, viral loops
7. Onboarding Expert - First-run, time-to-value
8. Trust Evaluator - Privacy, permissions, security
9. Cognitive Load Analyzer - Mental burden, decisions
10. Platform Compliance - iOS HIG adherence

## Execution

### Step 1: Gather Context
Read CLAUDE.md, identify key flows, note target audience

### Step 2: Launch Parallel Agents
Launch ALL 10 agents simultaneously using Task tool with subagent_type "Explore"

### Step 3: Synthesize Report
```markdown
# Comprehensive UX Audit: [App Name]

## Executive Summary
- **Overall Score**: X/10
- **Strongest**: [Top 2-3]
- **Critical Issues**: [Top 2-3]
- **Quick Wins**: [2-3 easy fixes]

## Dimension Scores
| Dimension | Score | Status | Priority |
|-----------|-------|--------|----------|
| Friction | X/10 | 🟢/🟡/🔴 | High/Med/Low |
...

## Critical Issues (Must Fix)
### Issue 1: [Title]
- **Dimension**: [Source]
- **Location**: [Screen/Flow]
- **Fix**: [Specific action]

## Quick Wins (< 1 day)
1. [Win]: [Description] → [Impact]

## Prioritized Roadmap
### Phase 1: Critical (This Week)
### Phase 2: Core (This Month)
### Phase 3: Polish (Next Quarter)
```

## Key Principles

1. **Parallel Execution** - Launch all 10 agents simultaneously
2. **Cross-Reference** - Note multi-dimension issues
3. **Prioritize by Impact** - User impact × frequency
4. **Actionable Output** - Every finding has specific fix
