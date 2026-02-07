<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# unit

## Purpose

Unit tests for individual library functions. Each test file targets a single library module with isolated test cases.

## Key Files

| File | Description |
|------|-------------|
| `statistics-unit.test.sh` | Tests for mean, stddev, CI calculation, CI separation |
| `storage-local-unit.test.sh` | Tests for local file storage read/write operations |
| `recommendation-engine-unit.test.sh` | Tests for quality scoring and recommendation logic |

## For AI Agents

### Working In This Directory

- Each test file maps 1:1 to a library file in `hooks/lib/`
- Tests use inline assertion patterns
- Part of CI Tier 1 (run first, fastest feedback)

### Testing Requirements

- Run all: `bash tests/unit/*.test.sh`
- Requires `bc` for statistics tests
- Requires `jq` for storage tests

### Common Patterns

```bash
source "../../hooks/lib/statistics.sh"
# ... test cases with assert_equals ...
```

## Dependencies

### Internal

- `../../hooks/lib/statistics.sh` - Statistics functions
- `../../hooks/lib/storage-local.sh` - Storage functions
- `../../hooks/lib/recommendation-engine.sh` - Recommendation functions

<!-- MANUAL: -->
