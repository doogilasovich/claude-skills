# Audit Presets

Pre-configured category + severity combinations for common workflows.

## Presets

| Preset | Scope | Categories | Severity | Use Case |
|--------|-------|------------|----------|----------|
| `quick` | code | memory, concurrency, security | critical | Fast pre-commit check |
| `quick-ux` | ux | friction, trust, accessibility | critical | Fast UX sanity check |
| `pr` | all | memory, security, error-handling, friction, accessibility | medium+ | PR review |
| `release` | all | all code, all ux | high+ | Pre-release gate |
| `nightly` | all | all code, all ux | low+ | Full overnight scan |

## Preset Details

### quick
Fast code-only scan for critical issues before committing.

```bash
/audit --preset=quick
# Equivalent to:
/audit --scope=code --categories=memory,concurrency,security --min-severity=critical
```

### quick-ux
Fast UX-only scan for critical issues.

```bash
/audit --preset=quick-ux
# Equivalent to:
/audit --scope=ux --categories=friction,trust,accessibility --min-severity=critical
```

### pr
Balanced check for pull request review. Both code and UX.

```bash
/audit --preset=pr
# Equivalent to:
/audit --scope=all --categories=memory,security,error-handling,friction,accessibility --min-severity=medium --incremental
```

### release
Comprehensive pre-release gate. High+ severity across all categories.

```bash
/audit --preset=release
# Equivalent to:
/audit --scope=all --min-severity=high
```

### nightly
Full scan including low-severity issues. Run overnight.

```bash
/audit --preset=nightly
# Equivalent to:
/audit --scope=all --min-severity=low
```

## Category Shortcuts

For `--categories` flag:

| Shortcut | Expands To |
|----------|------------|
| `code-critical` | memory, concurrency, security |
| `code-perf` | performance, main-thread, battery, network |
| `code-quality` | readability, maintainability, testability |
| `ux-critical` | friction, trust, accessibility |
| `ux-growth` | onboarding, retention, virality, monetization |
| `ux-polish` | delight, cognitive-load, platform-compliance |
