#!/usr/bin/env bash
# Lazy Detection: Write/Edit 도구 사용 시 스킬 파일 감지
#
# 이 스크립트는 Write/Edit 도구의 PostToolUse 훅으로 실행됩니다.
# 스킬 경로에 있는 .md 파일이 수정되었을 때만 처리합니다.

set -euo pipefail

# 공통 라이브러리 로드
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh" 2>/dev/null || true

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 파일 경로 추출 (Write/Edit 도구의 tool_input에서)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' | head -1)

# 파일 경로가 없으면 종료
if [[ -z "$FILE_PATH" ]]; then
  echo '{"continue": true}'
  exit 0
fi

# 스킬 경로 패턴 정의
SKILL_PATTERNS=(
  "$HOME/.claude/skills/"
  "$HOME/.claude/plugins/"
  ".claude/skills/"
)

# 스킬 파일인지 확인
is_skill_file() {
  local path="$1"

  # .md 파일이 아니면 스킬 아님
  [[ "$path" != *.md ]] && return 1

  # 스킬 경로 패턴 확인
  for pattern in "${SKILL_PATTERNS[@]}"; do
    if [[ "$path" == *"$pattern"* ]]; then
      # SKILL.md 또는 skills/ 디렉토리 내 파일
      if [[ "$path" == *"/SKILL.md" ]] || [[ "$path" == *"/skills/"* ]]; then
        return 0
      fi
    fi
  done

  return 1
}

# 스킬 이름 추출
extract_skill_name() {
  local path="$1"

  # 패턴: .../skills/{skill-name}/SKILL.md
  if [[ "$path" =~ /skills/([^/]+)/SKILL\.md$ ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi

  # 패턴: .../skills/{skill-name}/.../*.md
  if [[ "$path" =~ /skills/([^/]+)/ ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi

  # 패턴: .../{plugin-name}/skills/{skill-name}/...
  if [[ "$path" =~ /([^/]+)/skills/([^/]+)/ ]]; then
    echo "${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
    return
  fi

  echo "unknown"
}

# 새 스킬 감지 처리
handle_skill_detection() {
  local file_path="$1"
  local skill_name="$2"

  # 로그 디렉토리 확인
  LOG_DIR="${CLAUDE_PLUGIN_ROOT}/data/detections"
  mkdir -p "$LOG_DIR"

  # 감지 로그 기록
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local log_entry="{\"timestamp\": \"$timestamp\", \"skill\": \"$skill_name\", \"path\": \"$file_path\", \"action\": \"detected\"}"

  echo "$log_entry" >> "$LOG_DIR/detection-log.jsonl"

  # TODO: tdd-fit 판별 및 기준선 평가는 별도 프로세스로 실행
  # 현재는 감지만 기록

  # 디버그 로그 (선택적)
  if [[ "${DEBUG:-false}" == "true" ]]; then
    echo "[skill-detector] Detected: $skill_name ($file_path)" >&2
  fi
}

# 메인 로직
if is_skill_file "$FILE_PATH"; then
  SKILL_NAME=$(extract_skill_name "$FILE_PATH")
  handle_skill_detection "$FILE_PATH" "$SKILL_NAME"
fi

# 항상 계속 진행
echo '{"continue": true}'
