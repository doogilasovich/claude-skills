---
name: project-create
description: Create a new project in current directory.
---

# /project create

Creates a new project in the current directory.

## Usage

```bash
/project create <name>
/project create <name> --from=app-NNN
/project create <name> --display-name="My App"
```

## Args

| Arg | Required | Description |
|-----|----------|-------------|
| name | Yes | Project name (directory name, no spaces) |
| --from | No | Link to app-idea ID |
| --display-name | No | User-facing name (defaults to name) |
| --description | No | Project description |

## Resolution

Creates in current directory. No project resolution needed.

## Behavior

1. **Validate**
   - Check no .claude/project.json exists (E03)
   - If --from, verify app-idea exists (E04)

2. **Create Structure**
   ```
   mkdir -p .claude
   → project.json (from schema)
   → features.json (empty or imported)
   ```

3. **If --from app-idea**
   - Load from ~/.claude/app-ideas/ideas.json
   - Set origin = { type: "app-idea", appIdeaId, snapshot }
   - Import MVP features if design.mvpFeatures exists
   - Copy oneLiner to description

4. **Detect Git**
   - Parse remote URL for owner/repo
   - Populate repository section

5. **Update Index**
   - Add to ~/.claude/projects/index.json

## Project.json Creation

Generate from `_reference.md#project-schema` with:

| Field | Value |
|-------|-------|
| name | Argument value |
| displayName | --display-name or name |
| description | --description, or app-idea.oneLiner if --from |
| origin.type | "app-idea" if --from, else "manual" |
| origin.appIdeaId | --from value or null |
| origin.snapshot | Frozen app-idea data if --from |
| status | "active" |
| repository.* | Detected from git remote |
| features.stats | Calculated from imported features |

All other fields use schema defaults (null/empty).

## MVP Feature Import

If --from app-idea has concept or design.mvpFeatures:

```json
{
  "id": "feat-001",
  "title": "{feature name}",
  "description": "{feature description}",
  "status": "idea",
  "labels": ["mvp"],
  "origin": { "type": "app-idea", "ref": "{app-id}", "field": "mvpFeatures" },
  "dependencies": [],
  "createdAt": "{ISO}",
  "updatedAt": "{ISO}"
}
```

Features are linked by dependencies based on concept.coreLoop order.

## Output

```
✅ Created project: {name}

   Location: {path}/.claude/
   Origin:   {app-id} "{title}" (if --from)
   Features: {N} imported from MVP

   Next:
   • /project view
   • /feature-idea list
   • /audit
```

## Errors

E03, E04 - see `_reference.md#error-codes`

Additional:
```
❌ Not a valid project location
   Current directory has no .git and contains existing files
```
