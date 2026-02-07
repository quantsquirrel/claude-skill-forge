<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# mocks

## Purpose

Mock implementations that replace real external dependencies during testing. Enables deterministic E2E test execution without requiring actual AI evaluation.

## Key Files

| File | Description |
|------|-------------|
| `mock-evaluator.sh` | Mock skill evaluator returning deterministic scores for E2E tests |

## For AI Agents

### Working In This Directory

- `mock-evaluator.sh` replaces the real AI evaluator during tests
- Set via `FORGE_EVALUATOR_CMD` environment variable
- Must output valid evaluation JSON format
- Scores should be deterministic for reproducible tests

### Testing Requirements

- Mock output must match real evaluator JSON schema
- Verify mock is executable (`chmod +x`)

## Dependencies

### Internal

- `../e2e/` - E2E tests use mock evaluator
- `../../hooks/lib/storage-local.sh` - Mock must match expected data format

<!-- MANUAL: -->
