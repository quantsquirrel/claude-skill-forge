#!/bin/bash
# common.sh - 공통 유틸리티 및 storage 로더
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLAUDE_ROOT="$(cd "$PLUGIN_ROOT/../.." && pwd)"

# 설정 로드
source "$SCRIPT_DIR/config.sh"

# 상태 저장 디렉토리 (임시 파일용)
STATE_DIR="${STATE_DIR:-/tmp/skill-evaluator}"
mkdir -p "$STATE_DIR"

# Storage 모드에 따라 적절한 백엔드 로드
STORAGE_MODE=$(determine_storage_mode)
debug_log "Storage mode: $STORAGE_MODE"

if [ "$STORAGE_MODE" = "otel" ]; then
  source "$SCRIPT_DIR/storage-otel.sh"
else
  source "$SCRIPT_DIR/storage-local.sh"
fi

# === JSON 파싱 헬퍼 (jq 없이) ===

# 단순 문자열 값 추출
extract_json() {
  local key="$1"
  grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | \
    sed "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\"/\1/" | \
    head -1
}

# 숫자 값 추출
extract_json_number() {
  local key="$1"
  grep -o "\"$key\"[[:space:]]*:[[:space:]]*[0-9]*" | \
    sed "s/.*\"$key\"[[:space:]]*:[[:space:]]*\([0-9]*\)/\1/" | \
    head -1
}

# === 시간 유틸리티 ===

# ISO 8601 타임스탬프
get_timestamp() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

# 밀리초 단위 현재 시간
get_time_ms() {
  # macOS와 Linux 호환
  if date +%s%3N 2>/dev/null | grep -q "^[0-9]*$"; then
    date +%s%3N
  else
    echo $(($(date +%s) * 1000))
  fi
}

# 나노초 단위 현재 시간
get_time_ns() {
  if date +%s%N 2>/dev/null | grep -q "^[0-9]*$"; then
    date +%s%N
  else
    echo $(($(date +%s) * 1000000000))
  fi
}
