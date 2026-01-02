---
name: app-idea-analyze
description: Market analysis and viability.
user_invocable: true
---

# /app-idea analyze

Market sizing and viability analysis. See `_reference.md` for schema.

## Args

```
analyze <id>
analyze <id> --refresh             # Re-run analysis
```

## Prerequisites

Should complete research first (has competitor data).

## Behavior

### 1. Market Sizing

Estimate TAM/SAM/SOM:

```
TAM (Total Addressable Market):
- Find industry reports, statistics
- "X million people do Y globally"

SAM (Serviceable Addressable Market):
- Geographic focus (US, English-speaking)
- Platform focus (iOS only)

SOM (Serviceable Obtainable Market):
- Realistic capture in year 1
- Based on competitor benchmarks
```

### 2. Monetization Analysis

Based on competitor pricing and category norms:

```
Category benchmarks:
- Lifestyle apps: 2-5% conversion, $2-10/mo
- Utility apps: 5-10% conversion, $1-5 one-time
- Games: 1-3% IAP conversion, whale-dependent

Recommended model:
- Freemium with premium features
- $4.99/mo or $29.99/year
- Expected ARPU: $X
```

### 3. Revenue Projection

Simple model:
```
Year 1:
- Downloads: 10K-50K (realistic for indie)
- Conversion: 3-5%
- Revenue: $X-$Y

Break-even:
- Dev time: X months
- Opportunity cost: $Y
- Need Z paying users
```

### 4. Viability Score

Quick assessment:
- Market size: adequate?
- Competition: beatable?
- Monetization: viable?
- Technical: feasible?

### 5. Update Status

Transition to analysis.

## Output

```
📊 Analysis complete: app-001 "BirdTok"

┌─ Market Size ──────────────────────────────────────────┐
│ TAM: $2.1B  (Global birding market)                   │
│ SAM: $400M  (US mobile apps)                          │
│ SOM: $500K  (Year 1 realistic capture)                │
│ Source: Outdoor Industry Association, App Annie        │
└────────────────────────────────────────────────────────┘

┌─ Monetization ─────────────────────────────────────────┐
│ Recommended: Freemium subscription                     │
│ Pricing: $3.99/mo or $29.99/year                      │
│ Benchmark: Similar apps see 3-5% conversion           │
│ ARPU estimate: $1.20 (blended free/paid)              │
└────────────────────────────────────────────────────────┘

┌─ Revenue Projection (Year 1) ──────────────────────────┐
│ Conservative: 10K users × $1.20 = $12K                │
│ Moderate:     30K users × $1.50 = $45K                │
│ Optimistic:   100K users × $2.00 = $200K              │
└────────────────────────────────────────────────────────┘

┌─ Viability ────────────────────────────────────────────┐
│ ✅ Market: Large enough for indie success             │
│ ✅ Competition: Social angle differentiates           │
│ ⚠️ Monetization: Niche may limit conversion           │
│ ⚠️ Technical: ML accuracy is key risk                 │
└────────────────────────────────────────────────────────┘

   Status: research → 📊 analysis
   Next: /app-idea design app-001
```
