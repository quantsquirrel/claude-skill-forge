# Contributing to skill-forge

Thank you for your interest in contributing to skill-forge! This guide will help you get started.

## Getting Started

### Prerequisites

| Tool | Version | Check |
|------|---------|-------|
| Bash | 4.0+ | `bash --version` |
| Git | 2.0+ | `git --version` |
| bc | any | `which bc` |
| jq | 1.6+ | `jq --version` |
| Python 3 | 3.8+ | `python3 --version` |
| ShellCheck | 0.9+ | `shellcheck --version` |

### Fork & Clone

```bash
git clone https://github.com/YOUR_USERNAME/claude-skill-forge.git
cd claude-skill-forge
```

### Running Tests Locally

```bash
# Tier 1: Unit tests
bash tests/unit/statistics-unit.test.sh
bash tests/unit/storage-local-unit.test.sh
bash tests/unit/recommendation-engine-unit.test.sh

# Tier 2: Integration + Mock E2E
bash tests/integration/skill-up-integration.test.sh
bash tests/integration/hook-integration.test.sh
export FORGE_EVALUATOR_CMD="tests/mocks/mock-evaluator.sh"
bash tests/e2e/trial-branch-e2e.test.sh
bash tests/e2e/forge-workflow-e2e.test.sh

# Tier 3: Real AI E2E (optional, requires Claude Code)
SKILL_FORGE_AI_TESTS=true bash tests/e2e/forge-workflow-e2e.test.sh
```

## Development Workflow

### Branch Naming

- `feature/short-description` for new features
- `fix/short-description` for bug fixes
- `docs/short-description` for documentation changes
- `test/short-description` for test additions

### Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(scope): add new feature
fix(scope): fix bug description
docs: update documentation
test: add test for X
refactor(scope): restructure without behavior change
chore: maintenance task
```

### Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Ensure all Tier 1 + Tier 2 tests pass
4. Run ShellCheck: `find hooks/ tests/ -name "*.sh" -exec shellcheck {} +`
5. Update CHANGELOG.md with your changes
6. Submit a PR with a clear description

## Code Style

### Shell Scripts

- All `.sh` files must pass ShellCheck with zero errors
- Use `set -euo pipefail` at the top of scripts
- Quote all variables: `"${var}"` not `$var`
- Use `local` for function variables
- Prefer `[[ ]]` over `[ ]` for conditionals

### Markdown (Skills)

- Skills follow the SKILL.md format (see `skills/forge/SKILL.md` for reference)
- Include `argument-hint` for user-invocable skills
- Document trigger keywords for silent skills

## Testing

### Test Tiers

| Tier | Directory | CI Required | Description |
|------|-----------|-------------|-------------|
| 1 | `tests/unit/` | Yes | Pure function tests (statistics, storage, detection) |
| 2 | `tests/integration/`, `tests/e2e/` | Yes | Hook integration + Mock evaluator E2E |
| 3 | `tests/e2e/` | No | Real AI evaluator (manual, `SKILL_FORGE_AI_TESTS=true`) |

### Writing Tests

- Follow the existing test pattern in `tests/integration/skill-up-integration.test.sh`
- Use descriptive test names
- Clean up temporary files/directories in test teardown
- For E2E tests involving the forge workflow, use the mock evaluator

### Mock Evaluator

The mock evaluator (`tests/mocks/mock-evaluator.sh`) returns deterministic scores from fixture files. To use it:

```bash
export FORGE_EVALUATOR_CMD="tests/mocks/mock-evaluator.sh"
export MOCK_SCORES_FILE="tests/fixtures/eval-scores.json"
```

## Architecture Overview

### Core Components

```
hooks/lib/
├── statistics.sh          # Statistical functions (mean, stddev, CI)
├── trial-branch.sh        # Git branch isolation
├── storage-local.sh       # Local JSON storage
├── storage-otel.sh        # OpenTelemetry backend (optional)
├── skill-detector.sh      # Skill file detection
├── recommendation-engine.sh # Quality-based recommendations
├── common.sh              # Shared utilities
└── config.sh              # Configuration loader
```

### Key Principles

1. **Evaluator/Executor Separation**: The agent that improves a skill must be different from the agent that evaluates it
2. **Trial Branch Isolation**: All experiments happen in isolated git branches
3. **Statistical Validation**: Improvements must be statistically significant (95% CI)
4. **Dual Forging Paths**: TDD (with tests) and Heuristic (without tests)

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CLAUDE_PLUGIN_ROOT` | Set by Claude plugin system | Plugin installation path |
| `FORGE_EVALUATOR_CMD` | Built-in evaluator | Custom evaluator script path |
| `SKILL_FORGE_AI_TESTS` | `false` | Enable real AI E2E tests |
| `STORAGE_MODE` | `local` | Storage backend (`local` or `otel`) |

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you agree to uphold this code.

## Questions?

Open a [Discussion](https://github.com/quantsquirrel/claude-skill-forge/discussions) for questions, or an [Issue](https://github.com/quantsquirrel/claude-skill-forge/issues) for bugs and feature requests.
