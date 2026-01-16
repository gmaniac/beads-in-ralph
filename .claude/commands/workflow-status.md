---
description: Check the status of beads issues and ralph loop
allowed-tools:
  - Bash
  - Read
---

# Workflow Status Check

Check the current status of your beads issues and ralph autonomous loop.

## Beads Status

```bash
echo "=== Beads Installation ==="
which bd && bd --version || echo "❌ Beads (bd) not installed"

echo ""
echo "=== Beads Database ==="
bd info 2>/dev/null || echo "❌ Beads not initialized in this project"

echo ""
echo "=== Issue Statistics ==="
bd stats 2>/dev/null || echo "No stats available"

echo ""
echo "=== Ready Work (unblocked tasks) ==="
bd ready 2>/dev/null || echo "No ready work or beads not initialized"

echo ""
echo "=== In Progress ==="
bd list --status in_progress 2>/dev/null || echo "Nothing in progress"

echo ""
echo "=== Recently Closed ==="
bd list --status closed 2>/dev/null | head -10 || echo "No closed issues"
```

## Ralph Status

```bash
echo ""
echo "=== Ralph Installation ==="
which ralph && echo "✅ Ralph installed" || echo "❌ Ralph not installed"

echo ""
echo "=== Ralph Loop Status ==="
ralph --status 2>/dev/null || echo "Ralph not running or not in a ralph project"

echo ""
echo "=== tmux Sessions ==="
tmux list-sessions 2>/dev/null || echo "No tmux sessions"
```

## Project Files Status

```bash
echo ""
echo "=== PROMPT.md ==="
if [ -f "PROMPT.md" ]; then
  echo "✅ PROMPT.md exists"
  head -20 PROMPT.md
else
  echo "❌ PROMPT.md not found"
fi

echo ""
echo "=== @fix_plan.md ==="
if [ -f "@fix_plan.md" ]; then
  echo "✅ @fix_plan.md exists"
  cat @fix_plan.md
else
  echo "❌ @fix_plan.md not found"
fi
```

## Summary

Present a summary of the current state:

> **Workflow Status Summary**
> 
> **Beads**: [Initialized/Not initialized]
> - Open issues: X
> - In progress: X  
> - Closed: X
> - Ready to work: X
> 
> **Ralph**: [Running/Stopped/Not configured]
> - Loop count: X
> - API calls: X/100
> 
> **Next steps**: [Recommendations based on current state]
