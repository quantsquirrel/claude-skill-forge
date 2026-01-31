#!/bin/bash
# storage-local.sh - 로컬 파일 저장 구현 (월별 스킬 통계)

STORAGE_DIR="${LOCAL_STORAGE_DIR:-$HOME/.claude/.skill-evaluator}"
SKILLS_DIR="$STORAGE_DIR/skills"

# 월별 스킬 파일 경로
get_month_file() {
  local month=$(date +%Y-%m)
  echo "$SKILLS_DIR/$month.json"
}

# 월별 파일 초기화
storage_init_month() {
  local month_file=$(get_month_file)

  mkdir -p "$SKILLS_DIR"

  if [ ! -f "$month_file" ]; then
    local month=$(date +%Y-%m)
    cat > "$month_file" << EOF
{
  "month": "$month",
  "skills": {}
}
EOF
    debug_log "Month file initialized: $month_file"
  fi
}

# Skill 사용 기록
storage_record_skill() {
  local skill_name="$1"
  local tokens="$2"
  local has_test="$3"

  storage_init_month

  local month_file=$(get_month_file)

  # JSON 파일 읽기
  if [ ! -f "$month_file" ]; then
    return 1
  fi

  # Convert bash boolean to Python boolean
  local py_has_test="False"
  if [ "$has_test" = "true" ]; then
    py_has_test="True"
  fi

  # Python 스크립트를 사용하여 JSON 업데이트 (sed보다 안전)
  python3 << PYTHON_SCRIPT
import json
import sys

try:
    with open("$month_file", "r") as f:
        data = json.load(f)

    if "skills" not in data:
        data["skills"] = {}

    skill_name = "$skill_name"

    if skill_name in data["skills"]:
        # 기존 스킬 업데이트 (증분)
        data["skills"][skill_name]["usageCount"] = data["skills"][skill_name].get("usageCount", 0) + 1
        data["skills"][skill_name]["totalTokens"] = data["skills"][skill_name].get("totalTokens", 0) + $tokens
        data["skills"][skill_name]["hasTestCode"] = $py_has_test
    else:
        # 새로운 스킬 추가
        data["skills"][skill_name] = {
            "usageCount": 1,
            "totalTokens": $tokens,
            "hasTestCode": $py_has_test
        }

    with open("$month_file", "w") as f:
        json.dump(data, f, indent=2)
except Exception as e:
    print(f"Error updating JSON: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT

  debug_log "Skill recorded: $skill_name (tokens: $tokens, test: $has_test)"
}

# Test code 존재 여부 확인
check_skill_has_test() {
  local skill_name="$1"

  # Skill 경로 추정
  local skill_dir="$HOME/.claude/skills/${skill_name}"

  # Plugin 경로도 확인
  if [ -z "$(find "$skill_dir" -name "*test*" -o -name "*spec*" 2>/dev/null | head -1)" ]; then
    skill_dir="$HOME/.claude/plugins/${skill_name}"
  fi

  # Test 파일 검색
  if [ -d "$skill_dir" ]; then
    if find "$skill_dir" -type f \( -name "*test*" -o -name "*spec*" \) 2>/dev/null | grep -q .; then
      echo "true"
      return 0
    fi
  fi

  echo "false"
  return 1
}

# ------------------------------------------------------------------------------
# 트렌드 분석 함수 (신규 추가)
# ------------------------------------------------------------------------------

# 월별 사용량 비교 (30일 트렌드)
# Usage: get_usage_trend "skill-name"
# Output: "positive" | "negative" | "stable"
get_usage_trend() {
    local skill_name="$1"

    local current_month=$(date +%Y-%m)
    local prev_month=$(date -v-1m +%Y-%m 2>/dev/null || date -d "1 month ago" +%Y-%m)

    local current_file="$SKILLS_DIR/$current_month.json"
    local prev_file="$SKILLS_DIR/$prev_month.json"

    python3 << PYTHON_SCRIPT
import json

current_usage = 0
prev_usage = 0

try:
    with open("$current_file", "r") as f:
        data = json.load(f)
        current_usage = data.get("skills", {}).get("$skill_name", {}).get("usageCount", 0)
except:
    pass

try:
    with open("$prev_file", "r") as f:
        data = json.load(f)
        prev_usage = data.get("skills", {}).get("$skill_name", {}).get("usageCount", 0)
except:
    pass

if prev_usage == 0:
    if current_usage > 0:
        print("positive")
    else:
        print("stable")
elif current_usage > prev_usage * 1.2:
    print("positive")
elif current_usage < prev_usage * 0.8:
    print("negative")
else:
    print("stable")
PYTHON_SCRIPT
}

# 토큰 효율 계산
# Usage: get_token_efficiency "skill-name"
# Output: tokens per usage (integer)
get_token_efficiency() {
    local skill_name="$1"
    local month_file=$(get_month_file)

    python3 << PYTHON_SCRIPT
import json
try:
    with open("$month_file", "r") as f:
        data = json.load(f)
    skill = data.get("skills", {}).get("$skill_name", {})
    usage = skill.get("usageCount", 0)
    tokens = skill.get("totalTokens", 0)
    if usage > 0:
        print(int(tokens / usage))
    else:
        print(0)
except:
    print(0)
PYTHON_SCRIPT
}

# 모든 스킬 사용량 요약
# Usage: get_all_skills_summary
# Output: JSON object
get_all_skills_summary() {
    local month_file=$(get_month_file)

    python3 << PYTHON_SCRIPT
import json
try:
    with open("$month_file", "r") as f:
        data = json.load(f)
    print(json.dumps(data.get("skills", {}), indent=2))
except:
    print("{}")
PYTHON_SCRIPT
}

# ------------------------------------------------------------------------------
# TDD-Fit 모드 결정 함수 (신규 추가)
# ------------------------------------------------------------------------------

# TDD-Fit 상태 확인 (확장 버전)
# Usage: get_upgrade_mode "skill-name"
# Output: "TDD_FIT" | "HEURISTIC"
get_upgrade_mode() {
    local skill_name="$1"

    # 기존 함수 재사용
    local has_test=$(check_skill_has_test "$skill_name")

    if [ "$has_test" = "true" ]; then
        echo "TDD_FIT"
    else
        echo "HEURISTIC"
    fi
}

# 스킬 경로 찾기 (여러 위치 검색)
# Usage: find_skill_path "skill-name"
# Output: absolute path or empty
find_skill_path() {
    local skill_name="$1"

    # 검색 순서: skills/ -> commands/ -> ~/.claude/skills/ -> ~/.claude/plugins/
    local search_paths=(
        "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/skill-forge}/skills"
        "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/skill-forge}/commands"
        "$HOME/.claude/skills"
        "$HOME/.claude/plugins"
    )

    for base_path in "${search_paths[@]}"; do
        local skill_dir="$base_path/$skill_name"
        if [ -d "$skill_dir" ]; then
            echo "$skill_dir"
            return 0
        fi

        # SKILL.md 파일 직접 검색
        local skill_file="$base_path/$skill_name/SKILL.md"
        if [ -f "$skill_file" ]; then
            echo "$(dirname "$skill_file")"
            return 0
        fi
    done

    echo ""
    return 1
}
