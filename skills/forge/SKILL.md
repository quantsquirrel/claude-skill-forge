---
name: skill-forge:forge
description: Use when you want to systematically upgrade a skill's quality through TDD-based evaluation. 복수 평가 + 신뢰구간으로 유의미한 향상 검증.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, Skill
user-invocable: true
---

# Forge Skill

Systematically improve a skill through test-driven evaluation and statistical validation.

**REQUIRED BACKGROUND:** First invoke `skill-forge:writing-skills` skill for TDD methodology applied to skills. See `testing-skills-with-subagents.md` in that skill's directory for pressure scenario templates.

## Quick Reference

| Step | Action |
|------|--------|
| 1 | Trial Branch 생성 |
| 2 | 스킬 찾기 및 읽기 |
| 3 | Pressure Scenario 생성 |
| 4 | 기준선 평가 (3회) - evaluator 사용 |
| 5 | Discoverability 평가 (CSO 체크) |
| 6 | 개선 사항 식별 |
| 7 | 개선 적용 (GREEN Phase) |
| 8 | 개선 후 평가 (3회) |
| 9 | 신뢰구간 분리 확인 |
| 10 | Trial Branch 결과 처리 (병합/폐기) |
| 11 | Stats 업데이트 (upgraded: true) |

## When to Use

Use this skill when:
- A skill has low discoverability or unclear instructions
- You want to improve skill quality with measurable metrics
- You need to upgrade a skill with verified improvements (confidence interval separation)

Do NOT use when:
- The skill doesn't exist yet (create it first)
- Quick one-off fixes are needed (just edit directly)

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `skill-name` | Yes | The skill to upgrade (e.g., `superpowers:tdd`, `skill-forge:visualize`) |
| `--iterations N` | No | Maximum upgrade iterations (default: 6) |
| `--dry-run` | No | Evaluate only, don't apply changes |

Example: `/skill-forge:forge superpowers:tdd --iterations 3`

## Prerequisites

Before using this skill, ensure:

1. **Required files exist**:
   - `~/.claude/plugins/local/skill-forge/hooks/lib/statistics.sh`
   - `~/.claude/plugins/local/skill-forge/hooks/lib/trial-branch.sh`
   - `skill-forge:evaluator` subskill

2. **Git initialized** in target directory (for Trial Branch)

3. **First-time setup**: Invoke `skill-forge:writing-skills` once to understand TDD methodology

## Workflow

### 1. Trial Branch 생성

스킬 변경을 격리된 브랜치에서 진행합니다.

```bash
source ~/.claude/plugins/local/skill-forge/hooks/lib/trial-branch.sh

# 현재 브랜치 저장 후 Trial Branch 생성
ORIGINAL=$(git branch --show-current)
TRIAL=$(create_trial_branch "skill-name")
```

**Trial Branch 목적**:
- 스킬 변경을 실험적으로 격리
- 향상 실패 시 깔끔하게 폐기
- 향상 성공 시 원본 브랜치에 병합

### 2. Locate Skill

```
Skill locations (check in order):
~/.claude/skills/{skill-name}/SKILL.md
~/.claude/plugins/**/skills/{skill-name}/SKILL.md
.claude/skills/{skill-name}/SKILL.md
```

If skill not found, report and exit.

### 3. Create Pressure Scenario Test

Generate 2-3 realistic scenarios that would trigger this skill:

**Good scenario template:**
```markdown
SCENARIO: [Realistic situation where skill should apply]

Context:
- [Specific constraint 1]
- [Specific constraint 2]
- [Time/resource pressure]

Task: [What agent must do]

Success criteria:
- [ ] Agent recognizes skill applies
- [ ] Agent follows skill correctly
- [ ] Agent produces expected outcome
```

**Pressure types to combine (pick 3+):**
- Time pressure
- Sunk cost
- Authority override
- Exhaustion
- Pragmatic shortcuts

### 4. 기준선 평가 (3회)

**evaluator 서브스킬 사용** - critic 에이전트로 평가 실행:

```
Task(subagent_type="oh-my-claudecode:critic",
     model="opus",
     prompt="skill-forge:evaluator 스킬을 사용하여 {skill-name} 평가.
             시나리오: {scenario}
             rubric.md의 기준 참조.")
```

**3회 반복**하여 scores 배열 수집:

```bash
# scores.txt에 한 줄씩 저장
echo "85" >> baseline-scores.txt
echo "88" >> baseline-scores.txt
echo "82" >> baseline-scores.txt
```

**신뢰구간 계산**:

```bash
source ~/.claude/plugins/local/skill-forge/hooks/lib/statistics.sh

# 기준선 평균 및 95% CI
BASELINE_MEAN=$(calc_mean baseline-scores.txt)
read BASELINE_LOWER BASELINE_UPPER < <(calc_ci baseline-scores.txt)

echo "기준선: 평균=$BASELINE_MEAN, CI=[$BASELINE_LOWER, $BASELINE_UPPER]"
```

### 5. Evaluate Discoverability (CSO Check)

Check skill's search optimization:

| Check | Pass/Fail |
|-------|-----------|
| Description starts with "Use when..." | |
| Description has specific triggers | |
| Keywords match search terms | |
| Name is verb-first, descriptive | |
| No workflow summary in description | |

### 6. Identify Improvements

Based on test results:

**If agent didn't find skill:**
- Improve description triggers
- Add error message keywords
- Add symptom keywords

**If agent found but didn't follow:**
- Add explicit counters for rationalizations
- Create red flags section
- Add foundational principle

**If skill is unclear:**
- Simplify structure
- Add concrete examples
- Remove ambiguity

### 7. Apply Improvements (GREEN Phase)

Edit the skill with identified improvements:
- Keep changes minimal and targeted
- Address specific test failures
- Don't add hypothetical content

**Trial Branch에서 커밋**:

```bash
source ~/.claude/plugins/local/skill-forge/hooks/lib/trial-branch.sh

commit_trial "Improve discoverability with CSO keywords"
```

### 8. 개선 후 평가 (3회)

동일한 시나리오로 **개선된 스킬**을 3회 재평가:

```
Task(subagent_type="oh-my-claudecode:critic",
     model="opus",
     prompt="skill-forge:evaluator 스킬을 사용하여 개선된 {skill-name} 평가.
             시나리오: {scenario}
             rubric.md의 기준 참조.")
```

```bash
# improved-scores.txt에 수집
echo "90" >> improved-scores.txt
echo "92" >> improved-scores.txt
echo "89" >> improved-scores.txt

# 신뢰구간 계산
IMPROVED_MEAN=$(calc_mean improved-scores.txt)
read IMPROVED_LOWER IMPROVED_UPPER < <(calc_ci improved-scores.txt)

echo "개선 후: 평균=$IMPROVED_MEAN, CI=[$IMPROVED_LOWER, $IMPROVED_UPPER]"
```

### 9. 향상 판단 (신뢰구간 분리)

**신뢰구간이 분리되면 유의미한 향상**으로 판단:

```bash
source ~/.claude/plugins/local/skill-forge/hooks/lib/statistics.sh

# 기준선 CI 상한 < 개선 CI 하한 확인
if ci_separated "$BASELINE_UPPER" "$IMPROVED_LOWER"; then
  echo "✓ 유의미한 향상 인정 (신뢰구간 분리됨)"
  echo "  기준선 CI 상한: $BASELINE_UPPER"
  echo "  개선 CI 하한: $IMPROVED_LOWER"
  APPROVED=true
else
  echo "✗ 향상 미달 (신뢰구간 중복)"
  echo "  기준선 CI 상한: $BASELINE_UPPER"
  echo "  개선 CI 하한: $IMPROVED_LOWER"
  APPROVED=false
fi
```

### 10. Trial Branch 결과 처리

**성공 (신뢰구간 분리됨)**:

```bash
source ~/.claude/plugins/local/skill-forge/hooks/lib/trial-branch.sh

merge_trial_success "$ORIGINAL" "$TRIAL"
# → Trial Branch를 원본에 병합 후 삭제
```

**실패 (신뢰구간 중복)**:

```bash
discard_trial "$ORIGINAL" "$TRIAL"
# → Trial Branch 폐기, 원본 브랜치로 복귀
```

### 11. Mark as Upgraded

Update the skill stats file to set `upgraded: true`:

```bash
MONTH=$(date +%Y-%m)
SKILL_NAME="skill-forge:forge"  # Replace with actual skill name
STATS_FILE="$HOME/.claude/.skill-evaluator/skills/${MONTH}.json"

python3 -c "
import json
with open('$STATS_FILE', 'r') as f:
    data = json.load(f)
if '$SKILL_NAME' in data.get('skills', {}):
    data['skills']['$SKILL_NAME']['upgraded'] = True
    with open('$STATS_FILE', 'w') as f:
        json.dump(data, f, indent=2)
    print('Marked $SKILL_NAME as upgraded')
else:
    print('Skill not found in stats')
"
```

This enables:
- "강화 완료" badge in `/visualize`
- SSS/SS grade bonuses (see `skills/visualize/reference.md`)

## Output Format

After upgrade, report:

```
## Upgrade Complete: {skill-name}

### 기준선 평가 (3회)
- 점수: [78, 82, 80]
- 평균: 80.0, CI: [73.5, 86.5]

### 개선 후 평가 (3회)
- 점수: [90, 92, 89]
- 평균: 90.3, CI: [85.8, 94.8]

### 판단
- 기준선 CI 상한: 86.5
- 개선 CI 하한: 85.8
- 신뢰구간 분리: NO (중복 있음)
- 결과: Trial Branch 폐기

---OR---

### 판단
- 기준선 CI 상한: 86.5
- 개선 CI 하한: 88.2
- 신뢰구간 분리: YES
- 결과: Trial Branch 병합 성공

### CSO Improvements
- [What was improved for discoverability]

### Verification
- [x] Baseline test showed failure
- [x] Improved skill passes tests
- [x] Confidence intervals separated
- [x] Stats updated with upgraded: true
```

## Example

User: `/forge superpowers:tdd`

1. **Trial Branch 생성**: `forge/superpowers-tdd/20260128-143022`
2. Invoke `skill-forge:writing-skills` to load TDD methodology
3. Read the target skill: `~/.claude/skills/superpowers/tdd/SKILL.md`
4. Create scenario: "You wrote 200 lines, forgot TDD, dinner at 6:30pm..."
5. **기준선 평가 (3회)**: [65, 70, 68] → 평균 67.7, CI: [61.2, 74.2]
6. CSO: Description missing "Use when..." (FAIL)
7. Fix: Add explicit "Delete code, start over" section
8. **개선 후 평가 (3회)**: [85, 88, 86] → 평균 86.3, CI: [81.2, 91.4]
9. **신뢰구간 분리**: 기준선 상한 74.2 < 개선 하한 81.2 → **YES**
10. **병합 성공**: Trial Branch를 main에 병합
11. Update stats: `upgraded: true`

## Common Issues

| Issue | Solution |
|-------|----------|
| Skill not found | Check all locations, suggest creation |
| No clear test scenario | Use skill's "When to Use" section |
| Agent always passes | Add more pressure (3+ combined) |
| Improvements don't help | Meta-test: ask agent what would make it clearer |
| CI 분리 실패 (중복) | 더 큰 개선 필요 또는 샘플 수 증가 (n=5) |
| Trial Branch 충돌 | 수동으로 해결 후 `merge_trial_success` 재실행 |

## Statistical Notes

**신뢰구간 분리**의 의미:
- 기준선 점수의 **최대 예상 범위 상한**보다
- 개선 후 점수의 **최소 예상 범위 하한**이 더 크면
- → **통계적으로 유의미한 향상**

**95% 신뢰구간**:
- 표본의 평균이 진짜 평균의 95% 확률로 포함되는 범위
- 작은 n(=3)에서는 t-분포 사용 (정규분포보다 넓음)

**Trial Branch의 장점**:
- 실패한 실험이 메인 브랜치를 오염시키지 않음
- 여러 개선 방향을 독립적으로 실험 가능
- 성공한 개선만 선택적으로 병합
