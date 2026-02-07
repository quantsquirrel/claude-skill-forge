#!/bin/bash
# Stop hook - 세션 종료 시 처리

set -euo pipefail

# 공통 라이브러리 로드
source "$(dirname "$0")/lib/common.sh"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 필드 추출
SESSION_ID=$(echo "$INPUT" | extract_json "session_id")
STOP_REASON=$(echo "$INPUT" | extract_json "stop_hook_reason")

# stop_reason이 없으면 대체 필드 시도
if [ -z "$STOP_REASON" ]; then
  STOP_REASON=$(echo "$INPUT" | extract_json "reason")
fi

# 완료 상태 결정
STATUS="unknown"
case "$STOP_REASON" in
  *user*|*cancel*|*interrupt*) STATUS="abandoned" ;;
  *error*|*fail*) STATUS="failure" ;;
  *complete*|*done*|*success*|"") STATUS="success" ;;
esac

# 세션 종료
storage_finalize_session "$SESSION_ID" "$STATUS"

# 성공 응답
echo '{"continue": true}'
