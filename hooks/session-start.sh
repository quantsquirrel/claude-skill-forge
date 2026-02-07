#!/bin/bash
# SessionStart hook - 세션 시작 시 초기화

set -euo pipefail

# 공통 라이브러리 로드
source "$(dirname "$0")/lib/common.sh"

# stdin에서 JSON 입력 읽기
INPUT=$(cat)

# 필드 추출
SESSION_ID=$(echo "$INPUT" | extract_json "session_id")
CWD=$(echo "$INPUT" | extract_json "cwd")

# 세션 초기화
storage_init_session "$SESSION_ID" "$CWD"

# 성공 응답
echo '{"continue": true}'
