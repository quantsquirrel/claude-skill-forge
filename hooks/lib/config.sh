#!/bin/bash
# config.sh - 설정 로더 및 모드 결정

# 플러그인 루트 경로 결정
if [ -z "$PLUGIN_ROOT" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PLUGIN_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

# 설정 파일 로드
load_config() {
  local config_file="$PLUGIN_ROOT/config/settings.env"
  if [ -f "$config_file" ]; then
    # shellcheck source=/dev/null
    source "$config_file"
  fi
}

# 저장 모드 결정
determine_storage_mode() {
  # 1. 환경 변수로 명시적 지정
  if [ -n "$SKILL_EVAL_STORAGE_MODE" ]; then
    echo "$SKILL_EVAL_STORAGE_MODE"
    return
  fi

  # 2. config 파일에서 로드
  load_config
  echo "${STORAGE_MODE:-local}"
}

# 디버그 로그
debug_log() {
  if [ "$SKILL_EVAL_DEBUG" = "true" ]; then
    echo "[skill-eval] $*" >&2
  fi
}

# 설정 로드 실행
load_config
