#!/bin/bash
# UserPromptSubmit hook - 사용자 프롬프트 분석

set -euo pipefail

# 공통 라이브러리 로드
source "$(dirname "$0")/lib/common.sh"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 필드 추출
SESSION_ID=$(echo "$INPUT" | extract_json "session_id")
PROMPT=$(echo "$INPUT" | extract_json "prompt")

# 사용자 수정 패턴 감지
# "no", "wrong", "not that", "actually", "try again" 등
if echo "$PROMPT" | grep -qiE '\b(no|wrong|not that|actually|i meant|try again|incorrect|아니|틀렸|다시|잘못)\b'; then
  storage_record_correction "$SESSION_ID"
fi

# 성공 응답
echo '{"continue": true}'
