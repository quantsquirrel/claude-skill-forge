---
name: skill-forge:monitor
description: Use when you want to see skill usage trends, identify underused skills, or get upgrade recommendations. Triggers on 스킬 모니터링, 사용량 분석, 추천, /monitor, skill monitor, usage dashboard
allowed-tools: Read, Glob, Bash
user-invocable: true
---

# Skill Monitor

스킬 사용량을 분석하고 업그레이드 우선순위를 추천합니다.

## Quick Reference

| Step | Action |
|------|--------|
| 1 | storage-local.sh 함수로 사용량 데이터 로드 |
| 2 | 트렌드 분석 (get_usage_trend per skill) |
| 3 | 업그레이드 추천 순위 생성 |
| 4 | 터미널 대시보드 출력 |

## When to Use

- 어떤 스킬을 업그레이드해야 할지 모를 때
- 스킬 사용 패턴을 파악하고 싶을 때
- 토큰 효율이 낮은 스킬을 찾고 싶을 때

## Data Source

사용량 데이터 위치: `~/.claude/.skill-evaluator/skills/{YYYY-MM}.json`

로드 방법:
```bash
source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/storage-local.sh"
get_all_skills_summary
```

## Execution Steps

### Step 1: Load Usage Data
```bash
source "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/skill-forge}/hooks/lib/storage-local.sh"
SUMMARY=$(get_all_skills_summary)
```

### Step 2: Analyze Each Skill
For each skill in summary:
```bash
TREND=$(get_usage_trend "$skill_name")
EFFICIENCY=$(get_token_efficiency "$skill_name")
MODE=$(get_upgrade_mode "$skill_name")
```

### Step 3: Generate Recommendations
Priority calculation:
- HIGH: trend=negative AND usageCount > 5
- MED: usageCount 30+ AND not recently upgraded
- LOW: trend=stable AND usageCount < 30

### Step 4: Output Dashboard

## Output Format

```
╔══════════════════════════════════════════════════════════════╗
║                    Skill Forge Monitor                        ║
╠══════════════════════════════════════════════════════════════╣
║ Usage Trends (Last 30 days)                                   ║
╠══════════════════════╤═══════╤════════╤═════════╤════════════╣
║ Skill                │ Usage │ Tokens │ Trend   │ Mode       ║
╠══════════════════════╪═══════╪════════╪═════════╪════════════╣
║ skill-forge:forge    │    45 │  135K  │ ▲ +20%  │ TDD_FIT    ║
║ skill-forge:visualize│    32 │   64K  │ ─  0%   │ TDD_FIT    ║
║ oh-my-claudecode:tdd │    12 │   48K  │ ▼ -15%  │ HEURISTIC  ║
╚══════════════════════╧═══════╧════════╧═════════╧════════════╝

╔══════════════════════════════════════════════════════════════╗
║                  Upgrade Recommendations                      ║
╠══════════════════════════════════════════════════════════════╣
║ 1. [HIGH] oh-my-claudecode:tdd                                ║
║    → 사용량 감소 추세, 개선 필요                              ║
║ 2. [MED]  skill-forge:forge                                   ║
║    → 사용량 많음, 최적화 가능                                 ║
╚══════════════════════════════════════════════════════════════╝

Run `/forge <skill-name>` to upgrade a skill.
```

## Recommendation Algorithm

| Priority | Condition | Reasoning |
|----------|-----------|-----------|
| HIGH | trend=negative AND usageCount > 5 | 활발히 사용되지만 품질 저하 징후 |
| MED | usageCount ≥ 30 AND upgraded=false | 많이 쓰이지만 최적화 안됨 |
| LOW | trend=stable AND usageCount < 30 | 안정적이지만 사용량 적음 |

## Red Flags

- DO NOT modify any skill files (this is a read-only monitoring tool)
- DO NOT run long-running processes
- DO NOT access external APIs

## Example Usage

User: "스킬 모니터링 해줘"
→ Execute this skill to show dashboard

User: "/monitor"
→ Execute this skill to show dashboard

User: "어떤 스킬을 업그레이드해야 해?"
→ Execute this skill and highlight recommendations
