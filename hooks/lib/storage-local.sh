#!/bin/bash
# storage-local.sh - 로컬 파일 저장 구현 (월별 스킬 통계)

STORAGE_DIR="${LOCAL_STORAGE_DIR:-$HOME/.claude/.skill-evaluator}"
SKILLS_DIR="$STORAGE_DIR/skills"

# 월별 스킬 파일 경로
get_month_file() {
  local month
  month=$(date +%Y-%m)
  echo "$SKILLS_DIR/$month.json"
}

# 월별 파일 초기화
storage_init_month() {
  local month_file
  month_file=$(get_month_file)

  mkdir -p "$SKILLS_DIR"

  if [ ! -f "$month_file" ]; then
    local month
    month=$(date +%Y-%m)
    cat > "$month_file" << EOF
{
  "month": "$month",
  "skills": {}
}
EOF
    debug_log "Month file initialized: $month_file"
  fi
}

# Initialize session (no-op for local storage; required by session-start.sh)
storage_init_session() {
    local session_id="${1:-}"
    local cwd="${2:-}"
    debug_log "Session initialized (local): $session_id in $cwd"
}

# Record user correction (required by user-prompt.sh)
storage_record_correction() {
    local session_id="${1:-}"
    debug_log "User correction recorded (local): $session_id"
}

# Finalize session (required by session-stop.sh)
storage_finalize_session() {
    local session_id="${1:-}"
    local status="${2:-unknown}"
    debug_log "Session finalized (local): $session_id with status: $status"
}

# Skill 사용 기록
storage_record_skill() {
  local skill_name="$1"
  local tokens="$2"
  local has_test="$3"

  storage_init_month

  local month_file
  month_file=$(get_month_file)

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
  MONTH_FILE="$month_file" SKILL_NAME="$skill_name" PY_HAS_TEST="$py_has_test" TOKENS="$tokens" python3 << 'PYTHON_SCRIPT'
import json
import sys
import os

month_file = os.environ["MONTH_FILE"]
skill_name = os.environ["SKILL_NAME"]
py_has_test = os.environ["PY_HAS_TEST"] == "True"
tokens = int(os.environ["TOKENS"])

try:
    with open(month_file, "r") as f:
        data = json.load(f)

    if "skills" not in data:
        data["skills"] = {}

    if skill_name in data["skills"]:
        # 기존 스킬 업데이트 (증분)
        data["skills"][skill_name]["usageCount"] = data["skills"][skill_name].get("usageCount", 0) + 1
        data["skills"][skill_name]["totalTokens"] = data["skills"][skill_name].get("totalTokens", 0) + tokens
        data["skills"][skill_name]["hasTestCode"] = py_has_test
    else:
        # 새로운 스킬 추가
        data["skills"][skill_name] = {
            "usageCount": 1,
            "totalTokens": tokens,
            "hasTestCode": py_has_test
        }

    with open(month_file, "w") as f:
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
  local skill_dir="${CLAUDE_ROOT:-$HOME/.claude}/skills/${skill_name}"

  # Plugin 경로도 확인
  if [ -z "$(find "$skill_dir" -name "*test*" -o -name "*spec*" 2>/dev/null | head -1)" ]; then
    skill_dir="${CLAUDE_ROOT:-$HOME/.claude}/plugins/${skill_name}"
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

    local current_month
    current_month=$(date +%Y-%m)
    local prev_month
    prev_month=$(date -v-1m +%Y-%m 2>/dev/null || date -d "1 month ago" +%Y-%m)

    local current_file="$SKILLS_DIR/$current_month.json"
    local prev_file="$SKILLS_DIR/$prev_month.json"

    CURRENT_FILE="$current_file" PREV_FILE="$prev_file" SKILL_NAME="$skill_name" python3 << 'PYTHON_SCRIPT'
import json
import os

current_file = os.environ["CURRENT_FILE"]
prev_file = os.environ["PREV_FILE"]
skill_name = os.environ["SKILL_NAME"]

current_usage = 0
prev_usage = 0

try:
    with open(current_file, "r") as f:
        data = json.load(f)
        current_usage = data.get("skills", {}).get(skill_name, {}).get("usageCount", 0)
except Exception:
    pass

try:
    with open(prev_file, "r") as f:
        data = json.load(f)
        prev_usage = data.get("skills", {}).get(skill_name, {}).get("usageCount", 0)
except Exception:
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
    local month_file
    month_file=$(get_month_file)

    MONTH_FILE="$month_file" SKILL_NAME="$skill_name" python3 << 'PYTHON_SCRIPT'
import json
import os

month_file = os.environ["MONTH_FILE"]
skill_name = os.environ["SKILL_NAME"]

try:
    with open(month_file, "r") as f:
        data = json.load(f)
    skill = data.get("skills", {}).get(skill_name, {})
    usage = skill.get("usageCount", 0)
    tokens = skill.get("totalTokens", 0)
    if usage > 0:
        print(int(tokens / usage))
    else:
        print(0)
except Exception:
    print(0)
PYTHON_SCRIPT
}

# 모든 스킬 사용량 요약
# Usage: get_all_skills_summary
# Output: JSON object
get_all_skills_summary() {
    local month_file
    month_file=$(get_month_file)

    MONTH_FILE="$month_file" python3 << 'PYTHON_SCRIPT'
import json
import os

month_file = os.environ["MONTH_FILE"]

try:
    with open(month_file, "r") as f:
        data = json.load(f)
    print(json.dumps(data.get("skills", {}), indent=2))
except Exception:
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
    local has_test
    has_test=$(check_skill_has_test "$skill_name")

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
        "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/local/skill-forge}/skills"
        "${CLAUDE_PLUGIN_ROOT:-$HOME/.claude/plugins/local/skill-forge}/commands"
        "${CLAUDE_ROOT:-$HOME/.claude}/skills"
        "${CLAUDE_ROOT:-$HOME/.claude}/plugins"
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

# ------------------------------------------------------------------------------
# 스킬 유형 판별 함수 (신규 추가)
# ------------------------------------------------------------------------------

# 스킬 유형 판별
# Usage: get_skill_type "skill-name" "skill_file_path"
# Output: "explicit" | "silent"
#
# explicit: 사용자가 명시적으로 /명령어로 호출 (예: forge, monitor)
# silent: 상황에 맞으면 자동으로 호출 (예: git-master, frontend-ui-ux)
get_skill_type() {
    local skill_name="$1"
    local skill_file="$2"

    # 스킬 파일이 없으면 경로 찾기
    if [ -z "$skill_file" ] || [ ! -f "$skill_file" ]; then
        local skill_dir
        skill_dir=$(find_skill_path "$skill_name")
        if [ -n "$skill_dir" ]; then
            skill_file="$skill_dir/SKILL.md"
        fi
    fi

    if [ ! -f "$skill_file" ]; then
        echo "unknown"
        return 1
    fi

    SKILL_FILE="$skill_file" python3 << 'PYTHON_SCRIPT'
import re
import os

skill_file = os.environ["SKILL_FILE"]

with open(skill_file, "r") as f:
    content = f.read()

# Extract frontmatter
frontmatter_match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL)
if not frontmatter_match:
    print("unknown")
    exit(0)

frontmatter = frontmatter_match.group(1)

# Check for argument-hint (explicit indicator)
has_argument_hint = bool(re.search(r'argument-hint:', frontmatter))

# Check description length and trigger keywords
desc_match = re.search(r"description:\s*['\"]?(.+?)['\"]?\s*$", frontmatter, re.MULTILINE)
description = desc_match.group(1) if desc_match else ""

# Silent skill indicators
has_triggers_on = "Triggers on" in description or "triggers on" in description
desc_length = len(description)
has_many_keywords = description.count(",") >= 3  # Multiple trigger keywords

# Explicit skill indicators
is_short_description = desc_length < 100
has_mode_hint = "mode" in description.lower() or "modes:" in description.lower()

# Decision logic
if has_argument_hint:
    print("explicit")
elif has_triggers_on or has_many_keywords:
    print("silent")
elif is_short_description and not has_triggers_on:
    print("explicit")
else:
    print("silent")
PYTHON_SCRIPT
}

# 스킬 품질 점수 계산 (유형별 기준 적용)
# Usage: get_skill_quality_score "skill-name" "skill_file_path"
# Output: JSON with score and breakdown
get_skill_quality_score() {
    local skill_name="$1"
    local skill_file="$2"

    # 스킬 파일이 없으면 경로 찾기
    if [ -z "$skill_file" ] || [ ! -f "$skill_file" ]; then
        local skill_dir
        skill_dir=$(find_skill_path "$skill_name")
        if [ -n "$skill_dir" ]; then
            skill_file="$skill_dir/SKILL.md"
        fi
    fi

    if [ ! -f "$skill_file" ]; then
        echo '{"score": 0, "type": "unknown", "error": "skill file not found"}'
        return 1
    fi

    local skill_type
    skill_type=$(get_skill_type "$skill_name" "$skill_file")

    SKILL_FILE="$skill_file" SKILL_TYPE="$skill_type" SKILL_NAME="$skill_name" python3 << 'PYTHON_SCRIPT'
import re
import json
import os

skill_file = os.environ["SKILL_FILE"]
skill_type = os.environ["SKILL_TYPE"]
skill_name_env = os.environ["SKILL_NAME"]

with open(skill_file, "r") as f:
    content = f.read()
score = 0
breakdown = {}

# Extract frontmatter
frontmatter_match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL)
frontmatter = frontmatter_match.group(1) if frontmatter_match else ""

# Extract body (after frontmatter)
body = content[frontmatter_match.end():] if frontmatter_match else content

# Common checks
has_quick_reference = bool(re.search(r'##.*Quick Reference', body, re.IGNORECASE))
has_when_to_use = bool(re.search(r'##.*When to Use', body, re.IGNORECASE))
has_workflow = bool(re.search(r'##.*Workflow', body, re.IGNORECASE))
has_examples = bool(re.search(r'##.*Example', body, re.IGNORECASE))
has_red_flags = bool(re.search(r'##.*Red Flag', body, re.IGNORECASE))

if skill_type == "explicit":
    # EXPLICIT SKILL SCORING (명시적 호출 스킬)
    # Focus: 사용법 명확성, 옵션 설명, 모드 안내

    # 1. argument-hint 존재 (25점)
    has_argument_hint = bool(re.search(r'argument-hint:', frontmatter))
    breakdown["argument_hint"] = 25 if has_argument_hint else 0

    # 2. 모드/옵션 설명 (25점)
    has_modes = bool(re.search(r'mode|option|argument', body, re.IGNORECASE))
    has_mode_table = bool(re.search(r'\|.*mode.*\|', body, re.IGNORECASE))
    breakdown["mode_options"] = 25 if (has_modes and has_mode_table) else (15 if has_modes else 0)

    # 3. Quick Reference 테이블 (20점)
    breakdown["quick_reference"] = 20 if has_quick_reference else 0

    # 4. 워크플로우/단계 설명 (15점)
    breakdown["workflow"] = 15 if has_workflow else 0

    # 5. 예시 (15점)
    breakdown["examples"] = 15 if has_examples else 0

else:
    # SILENT SKILL SCORING (자동 트리거 스킬)
    # Focus: 발견성, 트리거 정확도, 오탐 방지

    desc_match = re.search(r"description:\s*['\"]?(.+?)['\"]?\s*$", frontmatter, re.MULTILINE)
    description = desc_match.group(1) if desc_match else ""

    # 1. "Use when" 으로 시작 (15점)
    starts_with_use_when = description.lower().startswith("use when")
    breakdown["use_when_prefix"] = 15 if starts_with_use_when else 0

    # 2. 트리거 키워드 풍부함 (20점)
    keyword_count = description.count(",") + 1
    if keyword_count >= 5:
        breakdown["trigger_keywords"] = 20
    elif keyword_count >= 3:
        breakdown["trigger_keywords"] = 15
    else:
        breakdown["trigger_keywords"] = 5

    # 3. When to Use 섹션 (20점)
    breakdown["when_to_use"] = 20 if has_when_to_use else 0

    # 4. Red Flags 섹션 - 오탐 방지 (15점)
    breakdown["red_flags"] = 15 if has_red_flags else 0

    # 5. Quick Reference (15점)
    breakdown["quick_reference"] = 15 if has_quick_reference else 0

    # 6. 예시 (15점)
    breakdown["examples"] = 15 if has_examples else 0

score = sum(breakdown.values())

result = {
    "skill_name": skill_name_env,
    "skill_type": skill_type,
    "score": score,
    "breakdown": breakdown,
    "max_score": 100,
    "grade": "A" if score >= 80 else "B" if score >= 60 else "C" if score >= 40 else "D"
}

print(json.dumps(result, indent=2))
PYTHON_SCRIPT
}
