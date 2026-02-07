<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# integration

## Purpose

Integration tests that verify multiple components working together, including hook pipelines and skill upgrade workflows.

## Key Files

| File | Description |
|------|-------------|
| `hook-integration.test.sh` | Tests hook pipeline: pre-tool → post-tool → detection flow |
| `skill-up-integration.test.sh` | Tests skill upgrade workflow integration between components |

## For AI Agents

### Working In This Directory

- Integration tests source multiple library files together
- Tests verify inter-component communication
- Part of CI Tier 2

### Testing Requirements

- Run after unit tests pass
- Requires `bc` and `jq` installed

## Dependencies

### Internal

- `../../hooks/` - Hook scripts under test
- `../../hooks/lib/` - Library functions under test

<!-- MANUAL: -->
