<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-01-31 | Updated: 2026-02-08 -->

# forge

## Purpose

Main upgrade skill implementing TDD-based evaluation and improvement workflow. Uses trial branches for isolation, 3x independent evaluations for statistical confidence, and CI separation check for validation. This is the core functionality of skill-forge.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Main skill definition with 11-step workflow |
| `evaluator.md` | Subskill for independent evaluation (used by critic agent) |
| `heuristic-evaluator.md` | Subskill for heuristic-based evaluation (skills without tests) |
| `rubric.md` | Scoring rubric with weighted criteria |

## For AI Agents

### Working In This Directory

- **SKILL.md** is the main entry point - defines complete upgrade workflow
- **evaluator.md** must be invoked via critic agent (separation of concerns)
- **rubric.md** defines scoring: test pass (30%), clarity (20%), performance (20%), completeness (20%), maintainability (10%)

### 11-Step Workflow

1. Trial Branch 생성
2. 스킬 찾기 및 읽기
3. Pressure Scenario 생성
4. 기준선 평가 (3회) - evaluator 사용
5. Discoverability 평가 (CSO 체크)
6. 개선 사항 식별
7. 개선 적용 (GREEN Phase)
8. 개선 후 평가 (3회)
9. 신뢰구간 분리 확인
10. Trial Branch 결과 처리 (병합/폐기)
11. Stats 업데이트 (upgraded: true)

### Testing Requirements

- Run pressure scenarios with 3+ combined pressures
- Verify CI separation calculation
- Test trial branch create/merge/discard flows

### Common Patterns

- Use `Task(subagent_type="oh-my-claudecode:critic")` for evaluation
- Source `statistics.sh` for CI calculations
- Source `trial-branch.sh` for git operations

## Dependencies

### Internal

- `../../hooks/lib/statistics.sh` - Statistical calculations
- `../../hooks/lib/trial-branch.sh` - Git branch management
- `../writing-skills/` - TDD methodology (required background)

<!-- MANUAL: -->
