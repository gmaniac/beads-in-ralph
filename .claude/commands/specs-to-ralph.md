---
description: Convert existing specifications into beads issues and launch ralph to complete the work
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
---

# Specs to Ralph Workflow

Convert an existing specification document into beads issues and launch ralph.

## Usage

```
/project:specs-to-ralph path/to/spec.md
```

Or just provide the spec content directly as $ARGUMENTS.

## Input: $ARGUMENTS

If a file path is provided, read the specification from that file.
If text is provided, parse it as the specification.
If nothing is provided, ask the user for the specification.

## Step 1: Parse the Specification

Analyze the provided specification and extract:

1. **Project/Epic Title** - The main name/title
2. **Description** - What this project/epic is about
3. **Tasks/Components** - Individual work items, with:
   - Title
   - Description
   - Priority (P0-P3)
   - Type (epic, feature, task, bug, chore)
   - Dependencies (what blocks what)
   - Labels (optional)

## Step 2: Initialize Beads

```bash
# Check if beads is initialized
bd info 2>/dev/null || bd init --quiet
```

## Step 3: Create the Issue Hierarchy

### If there's an Epic:

```bash
# Create the epic first
EPIC_RESULT=$(bd create "EPIC_TITLE" -t epic -p 1 -d "EPIC_DESCRIPTION" --json)
EPIC_ID=$(echo "$EPIC_RESULT" | jq -r '.id')
echo "Created epic: $EPIC_ID"
```

### Create all tasks:

For each task extracted from the spec:

```bash
TASK_RESULT=$(bd create "TASK_TITLE" \
  -t task \
  -p PRIORITY \
  -d "TASK_DESCRIPTION" \
  -l "LABELS" \
  --json)
TASK_ID=$(echo "$TASK_RESULT" | jq -r '.id')
echo "Created task: $TASK_ID"
```

### Add dependencies:

```bash
# Add parent-child relationship if there's an epic
bd dep add $TASK_ID $EPIC_ID --type parent-child

# Add blocking dependencies between tasks
bd dep add $DEPENDENT_TASK_ID $BLOCKER_TASK_ID --type blocks
```

## Step 4: Generate Ralph Files

### Create/Update PROMPT.md

```bash
cat > PROMPT.md << 'EOF'
# Project: PROJECT_TITLE

## Overview
PROJECT_DESCRIPTION

## Workflow with Beads

This project uses beads (bd) for task tracking. Follow this workflow:

1. **Find Ready Work**
   ```bash
   bd ready --json
   ```
   Pick the highest priority unblocked task.

2. **Start Working**
   ```bash
   bd update TASK_ID --status in_progress
   ```

3. **Complete Task**
   ```bash
   bd close TASK_ID --reason "Description of what was done"
   ```

4. **Check for New Work**
   Repeat from step 1.

## Exit Conditions

- All beads issues are closed
- Tests pass (if applicable)
- Code compiles/runs successfully

## Notes

- Always update beads status before and after working on a task
- If you discover new work, create a new bead: `bd create "title" -t task -p 2`
- Link discovered work: `bd dep add NEW_ID CURRENT_ID --type discovered-from`
EOF
```

### Create/Update @fix_plan.md

```bash
echo "# Fix Plan" > @fix_plan.md
echo "" >> @fix_plan.md
echo "Generated from beads on $(date)" >> @fix_plan.md
echo "" >> @fix_plan.md
echo "## Tasks by Priority" >> @fix_plan.md
echo "" >> @fix_plan.md

# Add all ready tasks
bd ready --json 2>/dev/null | jq -r '.[] | "- [ ] \(.id): \(.title) (P\(.priority))"' >> @fix_plan.md || echo "No ready tasks yet" >> @fix_plan.md

echo "" >> @fix_plan.md
echo "## All Tasks" >> @fix_plan.md
echo "" >> @fix_plan.md

# Add all tasks
bd list --json 2>/dev/null | jq -r '.[] | "- [\(if .status == "closed" then "x" else " " end)] \(.id): \(.title) (\(.status))"' >> @fix_plan.md || echo "No tasks created yet" >> @fix_plan.md
```

## Step 5: Verify and Report

```bash
echo "=== Beads Summary ==="
bd stats 2>/dev/null || echo "Stats not available"

echo ""
echo "=== Dependency Tree ==="
bd dep tree $EPIC_ID 2>/dev/null || bd ready

echo ""
echo "=== Ready Work ==="
bd ready
```

## Step 6: Launch Ralph

Ask the user before launching:

> "I've created the following issues in beads:
> 
> [Summary of created issues]
> 
> Ready to launch ralph? Options:
> 1. `ralph --monitor` - With tmux monitoring (recommended)
> 2. `ralph` - Simple mode
> 3. Don't launch yet - I'll review first"

If user confirms, launch:

```bash
ralph --monitor
```

## Quick Reference

```bash
# Verify beads
bd list
bd ready
bd dep tree EPIC_ID

# Verify ralph files
cat PROMPT.md
cat @fix_plan.md

# Launch ralph
ralph --monitor
ralph --status
```
