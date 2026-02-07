<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# fixtures

## Purpose

Test data and sample files used by test suites for deterministic, repeatable test execution.

## Key Files

| File | Description |
|------|-------------|
| `eval-scores.json` | Sample evaluation score data for testing statistical functions |

## For AI Agents

### Working In This Directory

- Fixtures provide known-good data for predictable test outcomes
- JSON files should be valid and well-formatted
- Do not modify fixtures without updating dependent tests

## Dependencies

### Internal

- `../unit/` - Unit tests consume fixture data
- `../integration/` - Integration tests may reference fixtures

<!-- MANUAL: -->
