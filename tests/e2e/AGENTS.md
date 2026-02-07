<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# e2e

## Purpose

End-to-end tests that validate complete forge workflows including trial branch creation, evaluation, and merge/discard decisions.

## Key Files

| File | Description |
|------|-------------|
| `forge-workflow-e2e.test.sh` | Full forge workflow test: create trial → evaluate → merge/discard |
| `trial-branch-e2e.test.sh` | Trial branch lifecycle: create → commit → merge/discard |

## For AI Agents

### Working In This Directory

- E2E tests require git configuration (`user.email`, `user.name`)
- Set `FORGE_EVALUATOR_CMD` to mock evaluator path before running
- Tests create and destroy git branches — run in isolated environment
- Part of CI Tier 2 (runs after unit tests pass)

### Testing Requirements

- Always set mock evaluator: `export FORGE_EVALUATOR_CMD="tests/mocks/mock-evaluator.sh"`
- Configure git identity before running
- Clean up trial branches after test completion

## Dependencies

### Internal

- `../mocks/mock-evaluator.sh` - Mock evaluator for deterministic scores
- `../../hooks/lib/trial-branch.sh` - Trial branch functions under test

<!-- MANUAL: -->
