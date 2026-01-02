---
name: audit-fix-after-sync
description: Full pipeline - review, sync to GitHub, fix, verify
user_invocable: true
---
Runs full audit pipeline with GitHub issue tracking:
1. `/audit --review-only --sync` - Review and create issues
2. `/audit --fix-only` - Apply fixes
3. `/audit --stage=verify` - Verify fixes

See `/audit` for full documentation.
