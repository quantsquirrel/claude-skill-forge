#!/usr/bin/env bash
# recommendation-engine.sh - 업그레이드 추천 엔진
#
# 목적: 스킬 사용량 패턴 기반 업그레이드 우선순위 계산
# 의존성: storage-local.sh (같은 디렉토리)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/storage-local.sh"

# ------------------------------------------------------------------------------
# 우선순위 계산
# ------------------------------------------------------------------------------
# Usage: calculate_priority "skill-name"
# Output: 1 (LOW) | 2 (MED) | 3 (HIGH)
calculate_priority() {
    local skill_name="$1"

    local trend
    trend=$(get_usage_trend "$skill_name")
    local month_file
    month_file=$(get_month_file)

    # 사용량 가져오기
    local usage_count
    usage_count=$(MONTH_FILE="$month_file" SKILL_NAME="$skill_name" python3 << 'PYTHON_SCRIPT'
import json
import os

month_file = os.environ["MONTH_FILE"]
skill_name = os.environ["SKILL_NAME"]

try:
    with open(month_file, "r") as f:
        data = json.load(f)
    print(data.get("skills", {}).get(skill_name, {}).get("usageCount", 0))
except Exception:
    print(0)
PYTHON_SCRIPT
)

    local upgraded
    upgraded=$(MONTH_FILE="$month_file" SKILL_NAME="$skill_name" python3 << 'PYTHON_SCRIPT'
import json
import os

month_file = os.environ["MONTH_FILE"]
skill_name = os.environ["SKILL_NAME"]

try:
    with open(month_file, "r") as f:
        data = json.load(f)
    print(str(data.get("skills", {}).get(skill_name, {}).get("upgraded", False)).lower())
except Exception:
    print("false")
PYTHON_SCRIPT
)

    # 우선순위 결정
    if [[ "$trend" == "negative" && "$usage_count" -gt 5 ]]; then
        echo "3"  # HIGH
    elif [[ "$usage_count" -ge 30 && "$upgraded" == "false" ]]; then
        echo "2"  # MED
    else
        echo "1"  # LOW
    fi
}

# ------------------------------------------------------------------------------
# 우선순위 라벨 변환
# ------------------------------------------------------------------------------
# Usage: priority_label 3
# Output: "HIGH"
priority_label() {
    local priority=$1
    case $priority in
        3) echo "HIGH" ;;
        2) echo "MED" ;;
        *) echo "LOW" ;;
    esac
}

# ------------------------------------------------------------------------------
# 모든 스킬 추천 생성
# ------------------------------------------------------------------------------
# Usage: generate_recommendations
# Output: JSON array sorted by priority
generate_recommendations() {
    local month_file
    month_file=$(get_month_file)

    MONTH_FILE="$month_file" python3 << 'PYTHON_SCRIPT'
import json
import os

month_file = os.environ["MONTH_FILE"]

try:
    with open(month_file, "r") as f:
        data = json.load(f)
except Exception:
    print("[]")
    exit(0)

recommendations = []
for skill_name, skill_data in data.get("skills", {}).items():
    usage = skill_data.get("usageCount", 0)
    tokens = skill_data.get("totalTokens", 0)
    upgraded = skill_data.get("upgraded", False)
    has_test = skill_data.get("hasTestCode", False)

    # 우선순위 계산 (Python 버전)
    priority = 1  # LOW default

    # trend 계산 (simplified - 단일 월 데이터만)
    # 실제로는 shell에서 get_usage_trend 호출 필요
    if usage > 5:
        priority = 2  # MED (usage exists)
    if usage >= 30 and not upgraded:
        priority = 2  # MED (heavily used but not upgraded)

    efficiency = int(tokens / usage) if usage > 0 else 0
    mode = "TDD_FIT" if has_test else "HEURISTIC"

    recommendations.append({
        "skill": skill_name,
        "priority": priority,
        "priority_label": ["LOW", "LOW", "MED", "HIGH"][priority],
        "usage": usage,
        "tokens": tokens,
        "efficiency": efficiency,
        "upgraded": upgraded,
        "mode": mode
    })

# Sort by priority descending, then by usage descending
recommendations.sort(key=lambda x: (-x["priority"], -x["usage"]))
print(json.dumps(recommendations, indent=2))
PYTHON_SCRIPT
}

# ------------------------------------------------------------------------------
# 대시보드 출력
# ------------------------------------------------------------------------------
# Usage: print_dashboard
print_dashboard() {
    local recommendations
    recommendations=$(generate_recommendations 2>/dev/null)

    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Skill Forge Monitor                        ║"
    echo "╠══════════════════════════════════════════════════════════════╣"

    # Parse and print recommendations
    RECOMMENDATIONS_JSON="$recommendations" python3 << 'PYTHON_SCRIPT'
import json
import os

try:
    data = json.loads(os.environ.get("RECOMMENDATIONS_JSON", "[]"))
except Exception:
    data = []

if not data:
    print("║ No skill usage data found.                                    ║")
else:
    print("║ Skill                    │ Usage │ Tokens │ Mode       │ Pri  ║")
    print("╠══════════════════════════╪═══════╪════════╪════════════╪══════╣")
    for item in data[:10]:  # Top 10
        name = item["skill"][:24].ljust(24)
        usage = str(item["usage"]).rjust(5)
        tokens = f"{item['tokens']//1000}K".rjust(6) if item["tokens"] >= 1000 else str(item["tokens"]).rjust(6)
        mode = item["mode"][:10].ljust(10)
        pri = item["priority_label"].ljust(4)
        print(f"║ {name} │ {usage} │ {tokens} │ {mode} │ {pri} ║")

print("╚══════════════════════════════════════════════════════════════╝")
PYTHON_SCRIPT

    echo ""
    echo "Run '/forge <skill-name>' to upgrade a skill."
}

# ------------------------------------------------------------------------------
# 스크립트 직접 실행 시
# ------------------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    print_dashboard
fi
