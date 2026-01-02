# Feature Idea Manual Commands

Use these phrases to invoke feature-idea skills without slash commands:

## List Features
```
list my feature ideas
```

## Log New Feature
```
log feature idea: <title>
```

## View Feature
```
show feature <id>
```

## Change Status
```
set feature <id> status to <status>
```

## Edit Feature
```
edit feature <id>
```

## Search Features
```
search features for <query>
```

## Sync to GitHub
```
sync my feature ideas
```

## Start Implementation
```
implement feature <id>
start working on <id>
```

## Create PR
```
create pr for <id>
submit <id> for review
```

## Ship Feature
```
ship feature <id>
mark <id> as shipped
```

## Project Board
```
open feature board
show feature board
create feature board
sync features to board
```

## Archive Features
```
archive feature <id>
restore feature <id>
list archived features
purge old features
```

## Bulk Operations
```
bulk update features
update all ideas to exploring
add label to all ready features
sync all dirty features
archive old stale ideas
```

## Dependencies
```
feat-002 needs feat-001
feat-002 is blocked by feat-001
show dependencies for feat-002
show dependency graph
what features are blocked
what features are ready to start
```

## Offline Queue
```
check offline status
show offline queue
retry failed syncs
am I offline
```

---

## Examples

```
list my feature ideas

log feature idea: Dark mode support

show feature feat-001

set feature feat-001 status to exploring

search features for audio

sync my feature ideas

implement feature feat-001

create pr for feat-001

ship feature feat-001

open feature board

create feature board

archive feature feat-001

restore feature feat-001

sync all dirty features

feat-002 needs feat-001

show dependency graph

check offline status
```

---

## Full Workflow

```
1. log feature idea: New awesome feature
2. set feature feat-002 status to ready
3. implement feature feat-002
4. [... do the work ...]
5. create pr for feat-002
6. [... merge PR ...]
7. ship feature feat-002
```
