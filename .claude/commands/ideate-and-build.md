---
description: Iterate on an idea to nail down specs, create beads issues, then run ralph to complete the work
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
---

# Ideate and Build Workflow

You are orchestrating a complete development workflow that has three distinct phases:
1. **Ideation Phase** - Collaborate with the user to refine and finalize specifications
2. **Beads Phase** - Convert finalized specs into beads issues with proper dependencies
3. **Ralph Phase** - Launch the ralph autonomous loop to complete the work

## Phase 1: Ideation and Specification Refinement

### Starting the Ideation Process

The user has provided an initial idea: **$ARGUMENTS**

If no arguments were provided, ask the user to describe their idea, project, task, or epic.

### Iterative Refinement Process

Work with the user to refine their idea through the following steps:

1. **Understand the Core Vision**
   - What problem does this solve?
   - Who is the target user/audience?
   - What does success look like?

2. **Define Scope and Boundaries**
   - What is in scope for this project/task/epic?
   - What is explicitly out of scope?
   - What are the constraints (time, tech stack, dependencies)?

3. **Break Down into Components**
   - What are the major features or milestones?
   - What are the technical components?
   - What are the dependencies between components?

4. **Identify Technical Requirements**
   - What technologies/frameworks will be used?
   - What integrations are needed?
   - What are the data models/schemas?

5. **Define Acceptance Criteria**
   - How will we know when each component is complete?
   - What tests need to pass?
   - What documentation is required?

### Specification Document

As you iterate, build up a specification document mentally. After each round of discussion, summarize the current state of the specification and ask:

> "Based on our discussion, here's what I understand so far:
> 
> **Project/Task/Epic**: [Title]
> **Description**: [Summary]
> **Scope**: [What's included]
> **Out of Scope**: [What's excluded]
> **Components**:
> 1. [Component 1]
> 2. [Component 2]
> ...
> 
> **Should we continue refining, or are you ready to move to creating beads?**"

### Completion Signals for Ideation Phase

Watch for signals that the user is ready to proceed:
- "That looks good"
- "Let's do it"
- "Ready to build"
- "Create the beads"
- "Start the work"
- "Looks complete"
- "Let's proceed"
- Explicit confirmation like "yes, let's move on"

When you detect a completion signal, confirm with the user:
> "Great! I'll now create the beads issues for this work. Ready to proceed?"

---

## Phase 2: Creating Beads Issues

### Initialize Beads (if needed)

First, check if beads is initialized in the current project:

```bash
bd info 2>/dev/null || bd init --quiet
```

### Create the Epic (if applicable)

If this is a larger project with multiple components, create an epic first:

```bash
bd create "EPIC_TITLE" -t epic -p 1 -d "EPIC_DESCRIPTION" --json
```

### Create Child Tasks

For each component/task identified during ideation, create a bead:

```bash
# Example task creation pattern
bd create "TASK_TITLE" -t task -p PRIORITY -d "TASK_DESCRIPTION" -l "LABELS" --json
```

### Add Dependencies

Link tasks with proper dependency relationships:

```bash
# If task B depends on task A (A blocks B)
bd dep add TASK_B_ID TASK_A_ID --type blocks

# For related tasks
bd dep add TASK_B_ID TASK_A_ID --type related

# For parent-child relationships
bd dep add CHILD_ID PARENT_ID --type parent-child
```

### Priority Guidelines

- **P0**: Critical/blocking - must be done first
- **P1**: High priority - important for core functionality
- **P2**: Medium priority - should be done (default)
- **P3**: Low priority - nice to have

### Type Guidelines

- **epic**: Large body of work with multiple sub-tasks
- **feature**: New functionality
- **bug**: Something broken that needs fixing
- **task**: General work item
- **chore**: Maintenance, refactoring, infrastructure

### Verify Beads Creation

After creating all beads, show the user what was created:

```bash
bd list --json | jq '.'
bd dep tree EPIC_ID 2>/dev/null || bd ready --json
```

Present a summary:
> "I've created the following beads for your project:
> 
> **Epic**: [EPIC_ID] - [Title]
> **Tasks**:
> - [TASK_ID_1] - [Title] (P[priority])
> - [TASK_ID_2] - [Title] (P[priority])
> ...
> 
> **Ready to start ralph autonomous loop?**"

---

## Phase 3: Launching Ralph

### Pre-flight Checks

Before launching ralph, ensure the project is properly configured:

1. **Check for PROMPT.md** - Ralph's main instruction file
2. **Check for @fix_plan.md** - Ralph's task tracking file
3. **Verify beads are synced**

### Generate Ralph Configuration

If PROMPT.md doesn't exist, create it based on the specifications with **TDD workflow**:

```markdown
# Project: [PROJECT_NAME]

## Overview
[Brief description from ideation phase]

## Technical Stack
[Technologies being used]

## TDD Workflow (Red-Green-Refactor)

You are operating in strict TDD mode. For EVERY task, follow this cycle:

### 1. Get Next Task
```bash
bd ready --json | jq -r '.[0]'
bd update TASK_ID --status in_progress
```

### 2. 🔴 RED - Write Failing Test

**Before writing ANY implementation code:**
1. Analyze the task requirements
2. Write a test that specifies the expected behavior
3. Run the test - it MUST fail

```bash
npm test -- --testPathPattern="feature"  # or pytest, cargo test, etc.
```

**Do NOT proceed until you have a failing test!**

### 3. 🟢 GREEN - Make It Pass

Write the MINIMUM code to make the test pass:
- No extra features
- No premature optimization
- Just enough to turn red to green

Run test again - it MUST pass now.

### 4. 🔵 REFACTOR - Improve the Code

Now that tests are green, improve the code:
- Extract reusable functions/components
- Remove duplication
- Improve naming
- Run tests after EVERY change - must stay green!

### 5. Close Task
```bash
bd close TASK_ID --reason "TDD complete: [description]"
```

### 6. Repeat with next task

## TDD Rules (Non-Negotiable)

1. **Never write implementation before test**
2. **Tests must fail first**
3. **Minimal implementation only**
4. **Refactor only when green**
5. **Small increments**

## Exit Conditions
- All beads issues are closed
- All tests pass
- Code has been refactored
```

### Generate @fix_plan.md

Create or update the fix plan based on beads:

```bash
# Generate fix plan from beads
echo "# Fix Plan" > @fix_plan.md
echo "" >> @fix_plan.md
echo "## Priority Tasks (from beads)" >> @fix_plan.md
echo "" >> @fix_plan.md
bd ready --json | jq -r '.[] | "- [ ] \(.id): \(.title) (P\(.priority))"' >> @fix_plan.md
```

### Launch Ralph

Once everything is configured, **IMPORTANT**: Reset session and launch with `--no-continue` to prevent Ralph from inheriting this conversation's context:

```bash
# First, reset session to prevent context pollution
ralph --reset-session

# Option 1: With tmux monitoring (recommended for visibility)
ralph --monitor --no-continue

# Option 2: Simple mode
ralph --no-continue

# Option 3: With custom settings
ralph --monitor --no-continue --calls 50 --timeout 30
```

> **Why `--no-continue`?** Without this flag, Ralph would inherit the context from this slash command conversation and might repeat the ideation/beads creation process instead of working on PROMPT.md tasks.

### Post-Launch Guidance

Inform the user:

> "Ralph is now running autonomously! Here's what to know:
> 
> **Monitoring**:
> - Use `ralph-monitor` in another terminal to watch progress
> - Press `Ctrl+B` then `D` to detach from tmux (keeps ralph running)
> - Use `tmux attach` to reattach
> 
> **Checking Progress**:
> - `bd ready` - See remaining unblocked tasks
> - `bd list --status in_progress` - See what's being worked on
> - `ralph --status` - Check ralph's current state
> 
> **Stopping**:
> - Ralph will stop automatically when all tasks are done
> - Or press `Ctrl+C` to stop manually
> 
> Good luck! 🚀"

---

## Error Handling

### If beads is not installed
```bash
echo "Beads (bd) is not installed. Please install it first:"
echo "curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash"
```

### If ralph is not installed
```bash
echo "Ralph is not installed. Please install it first:"
echo "git clone https://github.com/frankbria/ralph-claude-code.git"
echo "cd ralph-claude-code && ./install.sh"
```

### If there are issues during beads creation
- Log the error
- Attempt to continue with remaining tasks
- Report issues to the user

---

## Quick Reference Commands

```bash
# Beads commands
bd info                    # Check beads status
bd init --quiet           # Initialize beads
bd create "title" -t type -p priority -d "desc"  # Create issue
bd dep add ID1 ID2 --type blocks  # Add dependency
bd ready                   # Show ready work
bd list                    # List all issues
bd close ID --reason "why" # Close issue

# Ralph commands (always use --no-continue after slash commands!)
ralph --reset-session      # Reset before launching
ralph --monitor --no-continue  # Start fresh with monitoring
ralph --no-continue        # Start fresh simple mode
ralph --status             # Check status
ralph-monitor              # Live dashboard
```
