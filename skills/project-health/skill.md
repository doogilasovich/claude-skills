---
name: project-health
description: Show detailed project health metrics including audit breakdown, velocity, and recommendations.
---

# /project health

Shows detailed health metrics for a project. Deeper analysis than `/project view`.

## Usage

```bash
/project health              # Current directory project
/project health CameraTest   # Specific project by name
/project health --json       # JSON output for automation
/project health --refresh    # Re-run audit first
```

## Args

| Arg | Required | Description |
|-----|----------|-------------|
| name | No | Project name (default: detect from cwd) |
| --json | No | Output as JSON |
| --refresh | No | Re-run audit before showing health |

## Resolution

Per `_reference.md#project-resolution-order`.

## Behavior

1. Resolve project
2. If --refresh, run `/audit --scope=all` first
3. Load project.json, audit/state.json, audit/history.json, features.json
4. Calculate:
   - Overall score (weighted: code 50%, UX 30%, issues penalty, velocity bonus)
   - Category breakdowns from audit state
   - Velocity trend (last 4 weeks)
   - Cycle time (idea → shipped)
5. Generate recommendations based on:
   - Critical/high issues (priority 1)
   - Categories < 7/10 (priority 2)
   - Stalled features (in-progress > 7 days)
6. Render health report

## Health Calculation

```
overallScore = (codeScore * 0.5) + (uxScore * 0.3)
             - (highIssues * 0.1) - (criticalIssues * 0.3)
             + (velocityBonus if above target)
```

## Output

Renders health template from `_reference.md#health-project-health`.

Compact example:
```
┌ PROJECT HEALTH: FlipTalk ─────────────────────────┐
│ OVERALL: 78% (7.8/10)                             │
├───────────────────────────────────────────────────┤
│ CODE: 8.5/10          │ UX: 7.2/10                │
│ • Memory: 9    ✓      │ • Friction: 8     ✓      │
│ • Security: 9  ✓      │ • Accessibility: 6 ⚠️    │
│ • Testability: 7 ⚠️   │ • Onboarding: 7   ⚠️     │
├───────────────────────────────────────────────────┤
│ ISSUES: 2 open (0 critical, 2 high)               │
│ VELOCITY: 1.0/wk (trend: ↑)                       │
├───────────────────────────────────────────────────┤
│ RECOMMENDATIONS:                                  │
│ 1. /fix-code-accessibility (+0.8 UX)              │
│ 2. /fix-testability (+0.5 code)                   │
└───────────────────────────────────────────────────┘
```

## JSON Output (--json)

```json
{
  "project": "CameraTest",
  "overall": { "score": 7.8, "trend": "improving" },
  "code": { "score": 8.5, "categories": { "memory": 9, "security": 9 } },
  "ux": { "score": 7.2, "categories": { "friction": 8, "accessibility": 6 } },
  "issues": { "total": 2, "bySeverity": { "high": 2 } },
  "velocity": { "current": 1.0, "trend": [0.5, 1.0, 1.5, 1.0] },
  "recommendations": [{ "action": "/fix-accessibility", "impact": 0.8 }]
}
```

## Errors

E01 - see `_reference.md#error-codes`

Additional:
```
❌ No audit data found
   Run: /audit --scope=all
```
