---
name: monitor
description: Use when you want to see skill usage trends, identify underused skills, or get upgrade recommendations. Triggers on 스킬 모니터링, 사용량 분석, 추천, /monitor, skill monitor, usage dashboard
argument-hint: [--priority=HIGH|MED|LOW (default: all)] [--type=explicit|silent|all (default: all)]
allowed-tools: Read, Glob, Bash
user-invocable: true
---

# Skill Monitor

스킬 **품질**을 분석하고 업그레이드 우선순위를 추천합니다.

> **핵심 원칙:** 사용량 ≠ 품질. 품질 점수로 추천하고, 사용량은 영향력 지표로만 참고.

## Quick Reference

| Step | Action |
|------|--------|
| 1 | 스킬 목록 스캔 (all scopes) |
| 2 | 각 스킬 유형 판별 (explicit/silent) |
| 3 | 유형별 품질 점수 계산 |
| 4 | 우선순위 기반 추천 생성 |
| 5 | 대시보드 출력 |

## When to Use

- 어떤 스킬을 업그레이드해야 할지 모를 때
- 스킬 품질 현황을 파악하고 싶을 때
- 유형별(explicit/silent) 분석이 필요할 때

## Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `--priority=HIGH\|MED\|LOW` | 특정 우선순위만 표시 | all |
| `--type=explicit\|silent\|all` | 특정 유형만 표시 | all |
| `--format=table\|json` | 출력 형식 | table |

## Data Sources

```bash
source "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/local/skill-forge}/hooks/lib/storage-local.sh"

# 스킬 유형 판별
get_skill_type "$skill_name"

# 품질 점수 계산 (유형별 기준 자동 적용)
get_skill_quality_score "$skill_name"

# 사용량 (참고용)
get_all_skills_summary
get_usage_trend "$skill_name"
```

## Execution Steps

### Step 1: Scan All Skills

스킬 위치 스캔:
```
~/.claude/skills/*/SKILL.md
~/.claude/plugins/**/skills/*/SKILL.md
.claude/skills/*/SKILL.md
```

### Step 2: Analyze Each Skill

For each skill:
```bash
SKILL_TYPE=$(get_skill_type "$skill_name")
QUALITY_JSON=$(get_skill_quality_score "$skill_name")
USAGE_TREND=$(get_usage_trend "$skill_name")
```

### Step 3: Calculate Priority

**품질 기반 우선순위** (사용량과 무관):

| Priority | Condition | Meaning |
|----------|-----------|---------|
| **HIGH** | 품질 점수 < 40 | 구조적 문제, 즉시 개선 필요 |
| **MED** | 품질 점수 40-59 | 개선 여지 있음 |
| **LOW** | 품질 점수 60-79 | 선택적 개선 |
| **READY** | 품질 점수 ≥ 80 | 품질 양호 |

**Impact 보정** (선택적):
- 사용량 ≥ 30 + 품질 낮음 → 영향력 높음 태그 추가
- 사용량 < 5 → 우선순위 영향 없음 (품질만 판단)

### Step 4: Generate Output

## Output Format

```
╔══════════════════════════════════════════════════════════════════════╗
║                      🔥 Skill Forge Monitor                           ║
╠══════════════════════════════════════════════════════════════════════╣
║ Quality Analysis (품질 기반 - 사용량과 무관)                          ║
╠════════════════════════╤══════════╤═══════╤══════════╤═══════════════╣
║ Skill                  │ Type     │ Score │ Grade    │ Priority      ║
╠════════════════════════╪══════════╪═══════╪══════════╪═══════════════╣
║ omc:git-master         │ silent   │   45  │ C        │ [HIGH] ⚡     ║
║ forge:forge      │ explicit │   72  │ B        │ [LOW]         ║
║ omc:analyze            │ explicit │   85  │ A        │ [READY] ✓     ║
╚════════════════════════╧══════════╧═══════╧══════════╧═══════════════╝

╔══════════════════════════════════════════════════════════════════════╗
║                      Upgrade Recommendations                          ║
╠══════════════════════════════════════════════════════════════════════╣
║ 1. [HIGH] omc:git-master (silent, score: 45)                          ║
║    → Missing: Red Flags section, trigger keywords insufficient        ║
║    → Impact: 59 uses/month (high impact if fixed)                     ║
║                                                                       ║
║ 2. [MED] example-skill (explicit, score: 55)                          ║
║    → Missing: Quick Reference table                                   ║
║                                                                       ║
║ 3. [LOW] forge:forge (explicit, score: 72)                      ║
║    → Suggestion: Add more examples                                    ║
╚══════════════════════════════════════════════════════════════════════╝

Run `/forge:forge <skill-name>` to upgrade.
```

## Type-Specific Insights

유형별로 다른 개선 제안 제공:

### For Explicit Skills
```
Missing argument-hint → [HIGH] "Add argument-hint for slash command hints"
Missing mode table → [MED] "Document available modes/options"
```

### For Silent Skills
```
Few trigger keywords → [HIGH] "Add more trigger keywords for discoverability"
Missing Red Flags → [MED] "Add Red Flags section to prevent false positives"
```

## Red Flags

- DO NOT rank by usage count alone (usage ≠ quality)
- DO NOT modify any skill files (read-only monitoring)
- DO NOT run long-running processes
- DO NOT access external APIs

## Example Usage

```
User: "/monitor"
→ Show full dashboard with all skills

User: "/monitor --priority=HIGH"
→ Show only HIGH priority skills needing improvement

User: "/monitor --type=explicit"
→ Show only explicit (slash command) skills

User: "어떤 스킬을 업그레이드해야 해?"
→ Show recommendations sorted by priority
```
