#!/bin/bash
# PostToolUse hook - Skill 사용 완료 기록

set -euo pipefail

# 공통 라이브러리 로드
source "$(dirname "$0")/lib/common.sh"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# tool_input에서 skill 이름 추출 (escaped quotes 처리)
TOOL_INPUT=$(echo "$INPUT" | sed -n 's/.*"tool_input"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' | head -1)
SKILL_NAME=$(echo "$TOOL_INPUT" | sed -n 's/.*\\"skill\\"[[:space:]]*:[[:space:]]*\\"\([^\\]*\)\\".*/\1/p')

if [ -z "$SKILL_NAME" ]; then
  # Fallback: pre-tool.sh에서 저장한 파일 찾기
  for tmp_file in "$STATE_DIR"/skill_*.tmp; do
    if [ -f "$tmp_file" ]; then
      SKILL_NAME=$(cat "$tmp_file" | cut -d'|' -f2)
      START_TIME=$(cat "$tmp_file" | cut -d'|' -f1)
      rm -f "$tmp_file"
      break
    fi
  done
fi

if [ -n "$SKILL_NAME" ]; then
  # 시작 시간 로드
  SAFE_SKILL_NAME="${SKILL_NAME//[^a-zA-Z0-9_-]/_}"
  TEMP_FILE="$STATE_DIR/skill_${SAFE_SKILL_NAME}.tmp"
  START_TIME=0
  if [ -f "$TEMP_FILE" ]; then
    START_TIME=$(cat "$TEMP_FILE" | cut -d'|' -f1)
    rm -f "$TEMP_FILE"
  fi

  # Duration 계산
  END_TIME=$(get_time_ms)
  DURATION_MS=$((END_TIME - START_TIME))
  if [ "$DURATION_MS" -lt 0 ]; then
    DURATION_MS=0
  fi

  # 토큰 사용량 추출 시도 (tool_output에서)
  TOOL_OUTPUT=$(echo "$INPUT" | sed -n 's/.*"tool_output"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' | head -1)
  TOKENS=$(echo "$TOOL_OUTPUT" | grep -o "[0-9]* tokens" | grep -o "[0-9]*" | head -1)
  TOKENS=${TOKENS:-0}

  # Test code 존재 여부 확인
  HAS_TEST=$(check_skill_has_test "$SKILL_NAME")

  # Skill 사용 기록
  storage_record_skill "$SKILL_NAME" "$TOKENS" "$HAS_TEST"

  debug_log "Skill completed: $SKILL_NAME (${DURATION_MS}ms, ${TOKENS} tokens, test: $HAS_TEST)"
fi

# 성공 응답
echo '{"continue": true}'
