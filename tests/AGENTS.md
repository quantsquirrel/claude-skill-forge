<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# tests

## Purpose

Comprehensive test suite organized in a 3-tier structure: unit tests, integration tests, and end-to-end tests. All tests are written in Bash and use assertion patterns for validation.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `unit/` | Unit tests for individual library functions (see `unit/AGENTS.md`) |
| `integration/` | Integration tests for hook and skill workflows (see `integration/AGENTS.md`) |
| `e2e/` | End-to-end tests for complete forge workflows (see `e2e/AGENTS.md`) |
| `fixtures/` | Test data and sample files (see `fixtures/AGENTS.md`) |
| `mocks/` | Mock implementations for isolated testing (see `mocks/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- All tests use Bash with assertion helper patterns
- Tests are tiered: unit → integration → e2e (CI runs in this order)
- Use `assert_equals`, `assert_contains` patterns
- Tests exit with code 0 on success, non-zero on failure

### Testing Requirements

- Run unit tests first: `bash tests/unit/*.test.sh`
- Then integration: `bash tests/integration/*.test.sh`
- Then e2e (requires git config): `bash tests/e2e/*.test.sh`
- E2E tests need `FORGE_EVALUATOR_CMD` set to mock evaluator

### Common Patterns

```bash
#!/bin/bash
# Test file naming: {module}-{type}.test.sh
PASS=0; FAIL=0
assert_equals() { ... }
# ... test cases ...
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
```

## Dependencies

### Internal

- `../hooks/lib/` - Libraries under test
- `mocks/` - Mock evaluator for E2E tests

### External

- `bc` - Required for statistics tests
- `jq` - Required for JSON processing tests
- `git` - Required for trial branch E2E tests

<!-- MANUAL: -->
