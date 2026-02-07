#!/bin/bash
# PreToolUse hook - Skill 사용 시작 추적

set -euo pipefail

# 공통 라이브러리 로드
source "$(dirname "$0")/lib/common.sh"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# tool_input 필드 추출
TOOL_INPUT=$(echo "$INPUT" | sed -n 's/.*"tool_input"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' | head -1)

# Skill 이름 추출 (escaped quotes 처리)
SKILL_NAME=$(echo "$TOOL_INPUT" | sed -n 's/.*\\"skill\\"[[:space:]]*:[[:space:]]*\\"\([^\\]*\)\\".*/\1/p')

if [ -n "$SKILL_NAME" ]; then
  # 시작 시간 및 skill 이름 저장
  START_TIME=$(get_time_ms)
  SAFE_SKILL_NAME="${SKILL_NAME//[^a-zA-Z0-9_-]/_}"
  TEMP_FILE="$STATE_DIR/skill_${SAFE_SKILL_NAME}.tmp"
  echo "$START_TIME|$SKILL_NAME" > "$TEMP_FILE"

  debug_log "Skill started: $SKILL_NAME"
fi

# 성공 응답
echo '{"continue": true}'
