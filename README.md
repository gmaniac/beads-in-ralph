# beads-in-ralph

> Orchestrate autonomous development with beads issue tracking and ralph execution loops

Custom slash commands for Claude Code that integrate **beads** (issue tracking) and **ralph** (autonomous development loop) into a seamless workflow.

## What's Included

| Command | Description |
|---------|-------------|
| `/project:ideate-and-build` | Full workflow: iterate on ideas, create beads, launch ralph |
| `/project:specs-to-ralph` | Convert existing specs to beads and launch ralph |
| `/project:workflow-status` | Check status of beads and ralph |

## Installation

### Option 1: Project-level (recommended for team use)

Copy the commands to your project's `.claude/commands/` directory:

```bash
# In your project root
mkdir -p .claude/commands

# Copy the command files
cp path/to/ideate-and-build.md .claude/commands/
cp path/to/specs-to-ralph.md .claude/commands/
cp path/to/workflow-status.md .claude/commands/

# Commit to share with your team
git add .claude/commands/
git commit -m "Add beads-in-ralph workflow commands"
```

### Option 2: User-level (available across all projects)

Copy to your personal Claude commands directory:

```bash
mkdir -p ~/.claude/commands

cp path/to/ideate-and-build.md ~/.claude/commands/
cp path/to/specs-to-ralph.md ~/.claude/commands/
cp path/to/workflow-status.md ~/.claude/commands/
```

## Prerequisites

### 1. Install Beads

```bash
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

Verify: `bd --version`

### 2. Install Ralph

```bash
git clone https://github.com/frankbria/ralph-claude-code.git
cd ralph-claude-code
./install.sh
```

Verify: `which ralph`

### 3. Install tmux (for ralph monitoring)

```bash
# macOS
brew install tmux

# Ubuntu/Debian
sudo apt-get install tmux

# CentOS/RHEL
sudo yum install tmux
```

## Usage

### Full Workflow: Ideate → Beads → Ralph

Start with an idea and iterate:

```
/project:ideate-and-build Build a REST API for managing user preferences
```

This will:
1. **Ideation phase**: Claude asks clarifying questions, helps you define scope, components, and acceptance criteria
2. **Beads phase**: Creates issues in beads with proper hierarchy and dependencies
3. **Ralph phase**: Generates PROMPT.md and @fix_plan.md, then launches ralph

### Quick Conversion: Specs → Beads → Ralph

If you already have specifications:

```
/project:specs-to-ralph path/to/your-spec.md
```

Or paste specs directly:

```
/project:specs-to-ralph Build auth system with login, registration, password reset
```

### Check Status

See where things stand:

```
/project:workflow-status
```

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    IDEATE-AND-BUILD WORKFLOW                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐                                          │
│  │   User's Idea    │                                          │
│  └────────┬─────────┘                                          │
│           │                                                     │
│           ▼                                                     │
│  ┌──────────────────────────────────────────┐                  │
│  │         PHASE 1: IDEATION                │                  │
│  │  ┌────────────────────────────────────┐  │                  │
│  │  │ • Understand core vision           │  │                  │
│  │  │ • Define scope & boundaries        │◄─┼──┐ Iterate      │
│  │  │ • Break down into components       │  │  │ until        │
│  │  │ • Identify tech requirements       │──┼──┘ specs are    │
│  │  │ • Define acceptance criteria       │  │    finalized    │
│  │  └────────────────────────────────────┘  │                  │
│  └────────────────────┬─────────────────────┘                  │
│                       │                                         │
│           User says "ready to build"                           │
│                       │                                         │
│                       ▼                                         │
│  ┌──────────────────────────────────────────┐                  │
│  │         PHASE 2: BEADS                   │                  │
│  │  ┌────────────────────────────────────┐  │                  │
│  │  │ • Initialize beads (bd init)       │  │                  │
│  │  │ • Create epic (if applicable)      │  │                  │
│  │  │ • Create tasks with priorities     │  │                  │
│  │  │ • Add dependencies                 │  │                  │
│  │  │ • Verify with bd ready             │  │                  │
│  │  └────────────────────────────────────┘  │                  │
│  └────────────────────┬─────────────────────┘                  │
│                       │                                         │
│           User confirms "launch ralph"                          │
│                       │                                         │
│                       ▼                                         │
│  ┌──────────────────────────────────────────┐                  │
│  │         PHASE 3: RALPH                   │                  │
│  │  ┌────────────────────────────────────┐  │                  │
│  │  │ • Generate PROMPT.md               │  │                  │
│  │  │ • Generate @fix_plan.md            │  │                  │
│  │  │ • Launch: ralph --monitor          │  │                  │
│  │  └────────────────────────────────────┘  │                  │
│  └────────────────────┬─────────────────────┘                  │
│                       │                                         │
│                       ▼                                         │
│  ┌──────────────────────────────────────────┐                  │
│  │       AUTONOMOUS DEVELOPMENT LOOP        │                  │
│  │  ┌────────────────────────────────────┐  │                  │
│  │  │ ralph loop:                        │  │                  │
│  │  │  1. bd ready → get next task       │  │                  │
│  │  │  2. bd update → mark in_progress   │◄─┼──┐               │
│  │  │  3. Execute Claude Code            │  │  │ Repeat       │
│  │  │  4. bd close → mark complete       │──┼──┘ until done   │
│  │  └────────────────────────────────────┘  │                  │
│  └────────────────────┬─────────────────────┘                  │
│                       │                                         │
│                       ▼                                         │
│               ┌──────────────┐                                  │
│               │   Complete!  │                                  │
│               └──────────────┘                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Tips

### During Ideation
- Be specific about tech stack, constraints, and boundaries
- Claude will keep asking clarifying questions until you say "ready"
- Use phrases like "that looks good" or "let's proceed" to move forward

### During Beads Creation
- Claude creates an epic for larger projects with multiple components
- Tasks are created with appropriate priorities (P0-P3)
- Dependencies are automatically linked

### During Ralph Execution
- Ralph runs autonomously in tmux
- Use `Ctrl+B` then `D` to detach (keeps ralph running)
- Use `tmux attach` to reattach
- Check progress with `bd ready` or `ralph --status`

### Discovered Work
When ralph discovers new work during execution, it will:
1. Create a new bead: `bd create "new task" -t task -p 2`
2. Link it: `bd dep add NEW_ID CURRENT_ID --type discovered-from`
3. Continue working

## Troubleshooting

### "bd: command not found"
Beads isn't installed. Run:
```bash
curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash
```

### "ralph: command not found"
Ralph isn't installed. Run:
```bash
git clone https://github.com/frankbria/ralph-claude-code.git
cd ralph-claude-code && ./install.sh
```

### "beads not initialized"
Run `bd init` in your project directory.

### Ralph exits immediately
Check PROMPT.md and @fix_plan.md exist. Use `/project:workflow-status` to diagnose.

## License

MIT - Use however you like!
