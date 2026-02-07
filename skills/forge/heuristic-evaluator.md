---
name: heuristic-evaluator
description: Internal subagent for evaluating skills without tests. Called by forge skill when TDD mode is not applicable.
allowed-tools: Read, Grep, Glob, Bash
user-invocable: false
---

# Heuristic Skill Evaluator (Subagent)

테스트가 없는 스킬을 **유형별 기준**으로 평가하는 내부 서브에이전트입니다.

## Invocation

forge 스킬에서 다음과 같이 호출됩니다:
```
Task(subagent_type="forge:heuristic-evaluator", prompt="Evaluate skill: <skill-name>")
```

## Input

- **skill-name**: 평가할 스킬 이름
- **usage-data**: `~/.claude/.skill-evaluator/skills/{YYYY-MM}.json`에서 로드

## Step 1: Determine Skill Type

스킬 유형에 따라 평가 기준이 **완전히 다릅니다**.

```bash
source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/storage-local.sh"
SKILL_TYPE=$(get_skill_type "$skill_name")
# Output: "explicit" | "silent"
```

| 유형 | 설명 | 예시 |
|------|------|------|
| **explicit** | 사용자가 `/명령어`로 명시적 호출 | forge, monitor, visualize |
| **silent** | 상황에 맞으면 자동 트리거 | git-master, frontend-ui-ux |

## Evaluation Criteria by Type

### Type A: EXPLICIT Skills (명시적 호출 스킬)

> 사용자가 의도적으로 호출 → **사용법 명확성**이 핵심

| 기준 | 점수 | 체크 방법 |
|------|------|-----------|
| **argument-hint 존재** | 25 | frontmatter에 `argument-hint:` 있음 |
| **모드/옵션 설명** | 25 | 본문에 mode/option 테이블 있음 |
| **Quick Reference** | 20 | `## Quick Reference` 섹션 있음 |
| **워크플로우 설명** | 15 | `## Workflow` 섹션 있음 |
| **예시** | 15 | `## Example` 섹션 있음 |

**Explicit 스킬에서 트리거 키워드가 많으면 감점:**
- 트리거 키워드 5개 이상 → -10점 (오탐 위험)

### Type B: SILENT Skills (자동 트리거 스킬)

> 상황 인식으로 자동 호출 → **발견성**이 핵심

| 기준 | 점수 | 체크 방법 |
|------|------|-----------|
| **"Use when..." 시작** | 15 | description이 "Use when"으로 시작 |
| **트리거 키워드 풍부** | 20 | description에 키워드 5개+ |
| **When to Use 섹션** | 20 | `## When to Use` 섹션 있음 |
| **Red Flags 섹션** | 15 | 오탐 방지용 `## Red Flags` 있음 |
| **Quick Reference** | 15 | `## Quick Reference` 섹션 있음 |
| **예시** | 15 | `## Example` 섹션 있음 |

**Silent 스킬에서 트리거 키워드가 적으면 감점:**
- 트리거 키워드 2개 이하 → -15점 (발견 어려움)

## Execution Steps

1. **Determine Skill Type**
   ```bash
   source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/storage-local.sh"
   SKILL_TYPE=$(get_skill_type "$skill_name")
   ```

2. **Get Quality Score** (유형별 자동 적용)
   ```bash
   QUALITY_JSON=$(get_skill_quality_score "$skill_name")
   # Returns JSON with score, breakdown, grade
   ```

3. **Load Usage Data** (참고용 - 품질 점수에 직접 영향 없음)
   ```bash
   USAGE_TREND=$(get_usage_trend "$skill_name")
   TOKEN_EFFICIENCY=$(get_token_efficiency "$skill_name")
   ```

4. **Generate Improvements**
   - Missing sections → suggest adding
   - Type mismatch → suggest restructuring
   - Explicit without argument-hint → HIGH priority fix

5. **Return JSON Result**

## Output Format

```json
{
  "skill_name": "example-skill",
  "skill_type": "explicit | silent",
  "mode": "HEURISTIC",
  "score": 72,
  "breakdown": {
    "argument_hint": 25,
    "mode_options": 15,
    "quick_reference": 20,
    "workflow": 0,
    "examples": 12
  },
  "usage_context": {
    "usage_count": 45,
    "trend": "positive",
    "efficiency": 1500
  },
  "improvements": [
    "[HIGH] Add argument-hint to frontmatter",
    "[MED] Add ## Workflow section",
    "[LOW] Consider adding more examples"
  ],
  "recommendation": "UPGRADE_SUGGESTED"
}
```

## Recommendation Logic

| Score Range | Recommendation |
|-------------|----------------|
| 80-100 | UPGRADE_READY (품질 우수, 미세 조정만) |
| 60-79 | UPGRADE_SUGGESTED (개선점 있음) |
| 40-59 | NEEDS_WORK (구조적 개선 필요) |
| 0-39 | DEFER (재작성 권장) |

## Improvement Priority

개선 제안은 우선순위와 함께 제공:

| Priority | Condition | Example |
|----------|-----------|---------|
| **HIGH** | 유형 핵심 요소 누락 | explicit인데 argument-hint 없음 |
| **MED** | 보조 요소 누락 | Quick Reference 없음 |
| **LOW** | 선택적 개선 | 예시 추가 권장 |

## Type Mismatch Detection

스킬이 잘못된 유형으로 작성된 경우 경고:

| 상황 | 경고 |
|------|------|
| explicit인데 트리거 키워드 많음 | "Consider removing trigger keywords to prevent false positives" |
| silent인데 argument-hint 있음 | "argument-hint is unusual for auto-triggered skills" |
| silent인데 트리거 키워드 적음 | "Add more trigger keywords for better discoverability" |

## Red Flags

- DO NOT attempt to run tests (this skill is for test-less skills)
- DO NOT modify the skill file (only evaluate and suggest)
- DO NOT call external APIs
- DO NOT conflate usage count with quality (they are independent)
