# Output Formats

Default is JSON (machine-readable). Use `--verbose` or `--progress` for human output.

## Default (JSON)

Machine-readable, no decoration:
```json
{"phase":"review","total":48,"critical":2,"categories":{"memory":10,"concurrency":16}}
{"phase":"sync","created":5,"updated":2,"closed":3}
{"phase":"fix","fixed":22,"total":26}
{"phase":"verify","build":"pass","tests":"pass"}
```

## Progress (--progress)

Human-readable phase updates:
```
▸ Phase 1: Review
  memory: 10 | concurrency: 16 | performance: 22
  done (48 issues, 2 critical)

▸ Phase 2: Sync
  created: 5 | updated: 2 | closed: 3
  done

▸ Phase 3: Fix
  memory: 8/10 ✓ | concurrency: 14/16 ✓
  done (22/26 fixed)

▸ Phase 4: Verify
  build: ✓ | tests: ✓
  done

Summary: 48 found → 22 fixed → 26 pending
```

## Quiet (--quiet)

Single line per invocation:
```
Review: 48 (2 critical) | Sync: 5↑ 3↓ | Fixed: 22/26 | Verify: ✓
```

## Verbose (--verbose)

Full progress + file-level detail. Use for debugging.
