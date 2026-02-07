<!-- Generated: 2026-01-31 | Updated: 2026-02-08 -->

# claude-forge-smith

## Purpose

TDD 기반 스킬 자동 업그레이드 플러그인. AI 에이전트 스킬을 자동으로 분석, 평가, 개선하며 테스트 주도 개발(TDD) 원칙을 활용한 안전한 자기 개선 루프를 제공합니다. Gödel Machines 이론에 영감을 받아, 통계적 신뢰구간 검증으로 유의미한 향상만 적용합니다.

## Key Files

| File | Description |
|------|-------------|
| `README.md` | Project documentation with research background and usage |
| `.claude-plugin/plugin.json` | Plugin manifest for Claude Code integration |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `.claude-plugin/` | Plugin metadata and configuration (see `.claude-plugin/AGENTS.md`) |
| `.github/` | GitHub workflows, issue templates, PR templates (see `.github/AGENTS.md`) |
| `config/` | Environment configuration settings (see `config/AGENTS.md`) |
| `data/` | Data storage for baselines, detections, golden packets (see `data/AGENTS.md`) |
| `docs/` | Project documentation and theoretical foundations (see `docs/AGENTS.md`) |
| `examples/` | Usage examples and tutorials (see `examples/AGENTS.md`) |
| `hooks/` | Claude Code hooks for tool/session lifecycle (see `hooks/AGENTS.md`) |
| `scripts/` | Automation and utility scripts (see `scripts/AGENTS.md`) |
| `skills/` | Skill definitions with SKILL.md files (see `skills/AGENTS.md`) |
| `tests/` | Test suite with unit, integration, and e2e tests (see `tests/AGENTS.md`) |
| `visualize/` | HTML templates for skill visualization (see `visualize/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- This is a Claude Code plugin for skill self-improvement
- Core workflow: Trial Branch → Evaluate (3x) → Statistical validation → Merge/Discard
- Always use `trial-branch.sh` functions for isolated experiments
- Never modify `evaluator.md` or `rubric.md` during bootstrapping

### Testing Requirements

- Each skill has pressure scenarios in its directory
- Use 3 independent evaluations for statistical confidence
- Verify confidence interval separation before merging improvements

### Common Patterns

- **Lazy Detection**: Only scan skills on Write/Edit operations
- **Evaluator Separation**: Different agent evaluates than improves
- **95% CI**: Use t-distribution for small samples (n=3)

## Dependencies

### External

- Claude Code CLI with hooks support
- Git for Trial Branch management
- Bash shell for hook scripts

<!-- MANUAL: -->
