# Changelog

All notable changes to beads-in-ralph will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-02-26

### Fixed

- **Session Pollution from Slash Commands** - The `/project:ideate-and-build` and `/project:specs-to-ralph` commands now launch Ralph with `--reset-session` and `--no-continue` flags. This prevents Ralph from inheriting the context of the slash command conversation, which was causing Ralph to repeat the ideation/beads-creation process instead of working on PROMPT.md tasks.

- **Session Pollution from Manual Claude Usage** - Ralph now uses an isolated session file (`.claude_session_ralph`) instead of the default Claude session file. This prevents manual `claude` usage in the same directory from polluting Ralph's session context and causing self-referential loops where Ralph keeps checking its own status instead of working on tasks.

- **Circuit Breaker False Positives** - The circuit breaker now detects beads progress (closed issues count) in addition to git file changes. Previously, when `.beads/` was in `.gitignore`, Ralph would complete beads tasks but the circuit breaker would see 0 git changes and incorrectly open after 3 loops. Now Ralph tracks beads task completion via `.circuit_breaker_beads_count`.

### Added

- **TDD Workflow as Default** - Ralph now operates in strict Test-Driven Development mode by default. The generated PROMPT.md enforces the Red-Green-Refactor cycle:
  - 🔴 **RED**: Write failing test first (no implementation before test)
  - 🟢 **GREEN**: Write minimal code to pass the test
  - 🔵 **REFACTOR**: Improve code while keeping tests green

- **Session Isolation Warning** - Added prominent documentation warning users not to run `claude` manually in Ralph project directories while Ralph is active. Includes safe alternatives and troubleshooting steps.

- **Beads Progress Detection** - Circuit breaker now shows green checkmark when beads tasks are completed: `✅ Beads progress detected: N task(s) completed`

- **New Troubleshooting Sections**:
  - "Ralph keeps checking its own status / stuck in loop"
  - "Circuit breaker opens but Ralph completed tasks"

### Changed

- **PROMPT.md Template** - Both `specs-to-ralph.md` and `ideate-and-build.md` now generate TDD-focused PROMPT.md files with:
  - Strict TDD workflow instructions
  - Non-negotiable TDD rules
  - Clear Red-Green-Refactor cycle documentation
- **Slash Commands Updated**:
  - `specs-to-ralph.md` now uses `ralph --reset-session` then `ralph --monitor --no-continue`
  - `ideate-and-build.md` now uses `ralph --reset-session` then `ralph --monitor --no-continue`
  - Quick reference sections updated to always recommend `--no-continue` after slash commands
- `CLAUDE_SESSION_FILE` changed from `.claude_session_id` to `.claude_session_ralph` in both `ralph_loop.sh` and `response_analyzer.sh`
- `reset_circuit_breaker()` now also resets the beads count baseline
- `init_circuit_breaker()` now initializes beads count tracking if beads is available

## [1.0.0] - 2026-02-13

### Added

- Initial release
- `/project:ideate-and-build` - Full workflow: iterate on ideas, create beads, launch ralph
- `/project:specs-to-ralph` - Convert existing specs to beads and launch ralph
- `/project:workflow-status` - Check status of beads and ralph
- Integration with beads issue tracking
- Integration with ralph autonomous development loop
- tmux session management for monitoring
