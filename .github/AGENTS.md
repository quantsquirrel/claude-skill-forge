<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# .github

## Purpose

GitHub-specific configuration for CI/CD workflows, issue templates, and PR templates. Automates testing, linting, and release processes.

## Key Files

| File | Description |
|------|-------------|
| `PULL_REQUEST_TEMPLATE.md` | Default PR description template |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `workflows/` | GitHub Actions CI/CD workflows (see `workflows/AGENTS.md`) |
| `ISSUE_TEMPLATE/` | Issue templates for bugs and features (see `ISSUE_TEMPLATE/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- Workflow files use YAML format
- CI runs on both ubuntu-latest and macos-latest
- Tests are tiered: unit → integration → e2e

### Testing Requirements

- Validate YAML syntax after editing workflows
- Ensure workflow jobs have correct dependency chains

## Dependencies

### Internal

- `../tests/` - Test scripts executed by CI workflows
- `../hooks/` - Shell scripts linted by ShellCheck workflow

<!-- MANUAL: -->
