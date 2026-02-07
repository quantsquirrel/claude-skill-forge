<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# scripts

## Purpose

Automation and utility scripts for project maintenance. Includes PR monitoring and scheduled task configurations.

## Key Files

| File | Description |
|------|-------------|
| `check-pr-status.sh` | Monitors PR status for upstream submissions using `gh` CLI |
| `com.skillforge.prcheck.plist` | macOS LaunchAgent plist for scheduled PR status checks |

## For AI Agents

### Working In This Directory

- `check-pr-status.sh` uses GitHub CLI (`gh`) for API calls
- The plist file configures macOS periodic task execution
- These are development/maintenance scripts, not part of the plugin runtime

### Testing Requirements

- Verify `gh` CLI commands are valid
- Test shell script with ShellCheck

## Dependencies

### External

- `gh` - GitHub CLI for PR status queries
- `jq` - JSON parsing
- `osascript` - macOS notifications (optional)

<!-- MANUAL: -->
