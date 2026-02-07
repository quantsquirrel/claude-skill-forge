---
name: evaluator
description: Evaluate skill quality through structured scoring. Assesses discoverability, clarity, completeness, and testability without making improvement suggestions.
allowed-tools: Read, Grep, Glob
user-invocable: false
---

# Skill Evaluator

독립적인 스킬 품질 평가 전용 서브스킬입니다. **개선 제안 없이 오직 점수화만 수행**합니다.

## 역할 분리 원칙

```
개선 에이전트 (Executor) → 스킬 개선 작업
평가 에이전트 (Evaluator) → 품질 점수화 (이 스킬)
```

**순환 평가(circular evaluation) 방지를 위해 평가자는 개선 제안을 하지 않습니다.**

## 평가 대상

이 평가자는 **스킬 자체의 메타 품질**을 평가합니다:
- 스킬이 얼마나 잘 발견되는가? (Discoverability)
- 스킬이 얼마나 명확한가? (Clarity)
- 스킬이 얼마나 완전한가? (Completeness)
- 스킬이 얼마나 테스트 가능한가? (Testability)

## 점수화 체계 (0-100)

| 영역 | 배점 | 설명 |
|------|------|------|
| **Discoverability** | 30점 | 에이전트가 스킬을 찾고 선택할 수 있는가 |
| **Clarity** | 30점 | 스킬 지시사항이 명확하고 이해하기 쉬운가 |
| **Completeness** | 20점 | 필요한 정보가 모두 포함되어 있는가 |
| **Testability** | 20점 | 스킬의 품질을 검증할 수 있는가 |

---

## 평가 프로토콜

### 1. Discoverability (발견성) - 30점

**체크리스트:**

```
[ ] (10점) Description이 "Use when..." 패턴으로 시작하는가?
[ ] (5점)  Description에 구체적인 트리거 상황이 명시되어 있는가?
[ ] (5점)  키워드가 실제 검색어와 일치하는가?
[ ] (5점)  스킬 이름이 동사 우선(verb-first)이고 설명적인가?
[ ] (5점)  Description에 워크플로우 요약이 없는가? (간결성)
```

**점수 산출:**
- 각 항목 충족 시 명시된 점수 부여
- 부분 충족: 해당 항목 점수의 50%
- 미충족: 0점

**측정 방법:**
- YAML 프론트매터 `description` 필드 분석
- 스킬 본문의 "When to Use" 섹션 확인
- 에이전트 관점에서 검색 가능성 평가

---

### 2. Clarity (명확성) - 30점

**체크리스트:**

```
[ ] (10점) 단계별 지시사항이 명확하고 순차적인가?
[ ] (5점)  예시가 충분히 제공되어 있는가?
[ ] (5점)  모호한 표현이 없는가? (예: "적절히", "필요시")
[ ] (5점)  핵심 원칙이 명시되어 있는가?
[ ] (5점)  Red Flags 섹션이 존재하여 흔한 실수를 방지하는가?
```

**점수 산출:**
- 각 항목 충족 시 명시된 점수 부여
- 부분 충족: 해당 항목 점수의 50%
- 미충족: 0점

**측정 방법:**
- 스킬 본문의 구조적 명확성 평가
- 예시 코드/템플릿의 존재 여부
- 모호한 언어 패턴 검색 (`grep -i "적절|필요시|가능한|약간"`)

---

### 3. Completeness (완성도) - 20점

**체크리스트:**

```
[ ] (5점) 필수 도구가 allowed-tools에 명시되어 있는가?
[ ] (5점) 엣지 케이스 처리 방법이 포함되어 있는가?
[ ] (5점) 오류 상황에 대한 대응이 정의되어 있는가?
[ ] (5점) 출력 형식이 명확하게 정의되어 있는가?
```

**점수 산출:**
- 각 항목 충족 시 명시된 점수 부여
- 부분 충족: 해당 항목 점수의 50%
- 미충족: 0점

**측정 방법:**
- YAML 프론트매터의 `allowed-tools` 존재 확인
- 본문에서 "Error", "Edge Case", "Output Format" 키워드 검색
- 실패 시나리오 처리 섹션 존재 여부

---

### 4. Testability (테스트 가능성) - 20점

**체크리스트:**

```
[ ] (10점) 성공/실패 조건이 명확하게 정의되어 있는가?
[ ] (5점)  검증 가능한 예시 시나리오가 포함되어 있는가?
[ ] (5점)  측정 가능한 성공 기준이 있는가? (예: "모든 TODO 완료")
```

**점수 산출:**
- 각 항목 충족 시 명시된 점수 부여
- 부분 충족: 해당 항목 점수의 50%
- 미충족: 0점

**측정 방법:**
- "Success criteria", "Verification", "Example" 섹션 존재 확인
- 테스트 시나리오나 압력 시나리오 존재 여부
- 성공 기준의 측정 가능성 평가 (체크리스트, 숫자 기준 등)

---

## 출력 형식

**필수: JSON-like structured score**

```json
{
  "skill_name": "forge:example",
  "evaluated_at": "2025-01-28T12:34:56Z",
  "total_score": 78,
  "breakdown": {
    "discoverability": {
      "score": 25,
      "max": 30,
      "details": {
        "use_when_pattern": true,
        "specific_triggers": true,
        "keyword_match": false,
        "verb_first_name": true,
        "no_workflow_summary": true
      }
    },
    "clarity": {
      "score": 22,
      "max": 30,
      "details": {
        "clear_steps": true,
        "sufficient_examples": false,
        "no_ambiguity": true,
        "core_principle": true,
        "red_flags_section": true
      }
    },
    "completeness": {
      "score": 15,
      "max": 20,
      "details": {
        "allowed_tools_specified": true,
        "edge_case_handling": false,
        "error_handling": true,
        "output_format_defined": true
      }
    },
    "testability": {
      "score": 16,
      "max": 20,
      "details": {
        "success_failure_defined": true,
        "verifiable_scenarios": true,
        "measurable_criteria": false
      }
    }
  },
  "grade": "B",
  "notes": [
    "키워드 매칭 개선 필요",
    "예시 추가 권장",
    "측정 가능한 성공 기준 추가 고려"
  ]
}
```

## 등급 체계

| 총점 | 등급 | 의미 |
|------|------|------|
| 90-100 | S | 우수 (Production Ready) |
| 80-89 | A | 양호 (Minor improvements) |
| 70-79 | B | 보통 (Moderate improvements) |
| 60-69 | C | 미흡 (Major improvements) |
| 0-59 | F | 불합격 (Rewrite recommended) |

---

## 사용 예시

**Critic 에이전트 호출:**

```
Task(
  subagent_type="oh-my-claudecode:critic",
  model="opus",
  skills=["forge:evaluator"],
  prompt="""
  다음 스킬을 평가해주세요:

  파일: ~/.claude/skills/example/SKILL.md

  0-100 점수와 JSON 형식으로 결과를 제공해주세요.
  개선 제안은 하지 말고 오직 점수화만 수행하세요.
  """
)
```

**평가자의 응답:**

```json
{
  "skill_name": "example:demo",
  "total_score": 72,
  "breakdown": { ... },
  "grade": "B"
}
```

---

## 중요 원칙

### 1. 개선 제안 금지

평가자는 **어떻게 고칠지 제안하지 않습니다**. 오직 현재 상태를 점수화합니다.

```
❌ 나쁜 평가:
  "Discoverability: 20/30. Description을 'Use when...'으로 시작하도록 수정하세요."

✅ 올바른 평가:
  "Discoverability: 20/30. 'Use when...' 패턴 미사용: false"
```

### 2. 객관성 유지

- 체크리스트에 명시된 항목만 평가
- 주관적 판단 최소화
- 측정 가능한 기준만 사용

### 3. 일관성 보장

동일 스킬을 여러 번 평가해도 점수 변동이 ±5점 이내여야 합니다.

---

## 제한사항

**평가 불가 항목:**

- 스킬의 실제 실행 성능 (벤치마크 필요)
- 스킬의 비즈니스 가치
- 스킬의 창의성
- 사용자 만족도

**이 평가자는 오직 스킬 문서의 메타 품질만 평가합니다.**

---

## 참고

이 평가자는 Multi-evaluator 검증의 "평가 에이전트 분리 원칙"을 구현합니다:

```
개선 에이전트 (Executor)
       ↓ (개선된 스킬 제출)
독립 평가 에이전트 (Evaluator) ← 이 스킬
       ↓ (평가 결과)
메인 오케스트레이터 (Accept/Reject)
```

**순환 평가 방지:** 평가자가 개선을 제안하지 않으므로, 자신의 평가 기준을 조작할 수 없습니다.
