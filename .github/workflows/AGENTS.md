<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# workflows

## Purpose

GitHub Actions workflow definitions for CI/CD. Implements a tiered test strategy and automated release process.

## Key Files

| File | Description |
|------|-------------|
| `ci.yml` | Main CI pipeline: Tier 1 (unit) → Tier 2 (integration + e2e) + ShellCheck lint |
| `pr-check.yml` | Pull request validation checks |
| `release.yml` | Automated release workflow |

## For AI Agents

### Working In This Directory

- CI runs on matrix: ubuntu-latest + macos-latest
- Test tiers have dependencies: tier2 `needs: test-tier1`
- E2E tests require git config and mock evaluator setup
- ShellCheck lints all `.sh` files in `hooks/` and `tests/`

### Testing Requirements

- Validate YAML syntax with `yamllint` or equivalent
- Ensure job dependency chains are correct
- Test workflow changes in a PR first

### Common Patterns

- Use `actions/checkout@v4` for repo checkout
- Install `bc` and `jq` on Linux runners
- Set `FORGE_EVALUATOR_CMD` for mock-based E2E tests

## Dependencies

### Internal

- `../../tests/` - All test scripts
- `../../hooks/` - Scripts checked by ShellCheck

<!-- MANUAL: -->
