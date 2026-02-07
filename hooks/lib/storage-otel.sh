#!/bin/bash
# storage-otel.sh - OpenTelemetry 전송 구현

# 설정 기본값
OTEL_ENDPOINT="${OTEL_EXPORTER_OTLP_ENDPOINT:-http://localhost:4318}"
OTEL_SERVICE="${OTEL_SERVICE_NAME:-skill-evaluator}"

# === ID 생성 ===

generate_trace_id() {
  # 32자리 hex (128bit)
  cat /dev/urandom | LC_ALL=C tr -dc 'a-f0-9' | head -c 32
}

generate_span_id() {
  # 16자리 hex (64bit)
  cat /dev/urandom | LC_ALL=C tr -dc 'a-f0-9' | head -c 16
}

# === OTLP HTTP 전송 ===

send_span() {
  local trace_id="$1"
  local span_id="$2"
  local name="$3"
  local attributes="$4"
  local start_time="$5"
  local end_time="$6"
  local parent_span_id="${7:-}"

  local parent_span_json=""
  if [ -n "$parent_span_id" ]; then
    parent_span_json="\"parentSpanId\": \"$parent_span_id\","
  fi

  # 비동기 전송 (백그라운드)
  curl -s -X POST "${OTEL_ENDPOINT}/v1/traces" \
    -H "Content-Type: application/json" \
    -d "{
      \"resourceSpans\": [{
        \"resource\": {
          \"attributes\": [
            {\"key\": \"service.name\", \"value\": {\"stringValue\": \"${OTEL_SERVICE}\"}}
          ]
        },
        \"scopeSpans\": [{
          \"scope\": {\"name\": \"skill-evaluator\"},
          \"spans\": [{
            \"traceId\": \"${trace_id}\",
            \"spanId\": \"${span_id}\",
            ${parent_span_json}
            \"name\": \"${name}\",
            \"kind\": 1,
            \"startTimeUnixNano\": ${start_time},
            \"endTimeUnixNano\": ${end_time},
            \"attributes\": ${attributes},
            \"status\": {}
          }]
        }]
      }]
    }" > /dev/null 2>&1 &

  debug_log "Span sent: $name (trace: ${trace_id:0:8}...)"
}

send_metric() {
  local name="$1"
  local value="$2"
  local attributes="$3"
  local time_ns
  time_ns=$(get_time_ns)

  curl -s -X POST "${OTEL_ENDPOINT}/v1/metrics" \
    -H "Content-Type: application/json" \
    -d "{
      \"resourceMetrics\": [{
        \"resource\": {
          \"attributes\": [
            {\"key\": \"service.name\", \"value\": {\"stringValue\": \"${OTEL_SERVICE}\"}}
          ]
        },
        \"scopeMetrics\": [{
          \"scope\": {\"name\": \"skill-evaluator\"},
          \"metrics\": [{
            \"name\": \"${name}\",
            \"sum\": {
              \"dataPoints\": [{
                \"asInt\": ${value},
                \"timeUnixNano\": ${time_ns},
                \"attributes\": ${attributes}
              }],
              \"aggregationTemporality\": 2,
              \"isMonotonic\": true
            }
          }]
        }]
      }]
    }" > /dev/null 2>&1 &

  debug_log "Metric sent: $name = $value"
}

# === Storage 인터페이스 구현 ===

storage_init_session() {
  local session_id="$1"
  # shellcheck disable=SC2034
  local cwd="$2"

  local trace_id
  trace_id=$(generate_trace_id)
  local span_id
  span_id=$(generate_span_id)
  local start_time
  start_time=$(get_time_ns)

  # 세션 컨텍스트 저장 (나중에 span에서 사용)
  mkdir -p "$STATE_DIR"
  cat > "$STATE_DIR/$session_id.ctx" << EOF
{"traceId":"$trace_id","spanId":"$span_id","startTime":$start_time}
EOF

  # 세션 시작 span 전송
  send_span "$trace_id" "$span_id" "session" \
    "[{\"key\": \"session.id\", \"value\": {\"stringValue\": \"$session_id\"}}]" \
    "$start_time" "$start_time"

  debug_log "Session started: $session_id (trace: ${trace_id:0:8}...)"
}

storage_record_tool() {
  local session_id="$1"
  local tool_name="$2"
  local success="$3"
  local duration_ms="$4"

  local ctx_file="$STATE_DIR/$session_id.ctx"
  [ ! -f "$ctx_file" ] && return

  # 컨텍스트 로드
  local ctx
  ctx=$(cat "$ctx_file")
  local trace_id
  trace_id=$(echo "$ctx" | extract_json "traceId")
  local parent_span_id
  parent_span_id=$(echo "$ctx" | extract_json "spanId")

  local span_id
  span_id=$(generate_span_id)
  local end_time
  end_time=$(get_time_ns)
  local start_time
  start_time=$((end_time - duration_ms * 1000000))

  # Tool 사용 span 전송
  send_span "$trace_id" "$span_id" "tool.$tool_name" \
    "[
      {\"key\": \"tool.name\", \"value\": {\"stringValue\": \"$tool_name\"}},
      {\"key\": \"tool.success\", \"value\": {\"boolValue\": $success}},
      {\"key\": \"tool.duration_ms\", \"value\": {\"intValue\": $duration_ms}}
    ]" \
    "$start_time" "$end_time" "$parent_span_id"

  # 메트릭 전송
  send_metric "skill_evaluator.tool.usage" 1 \
    "[{\"key\": \"tool.name\", \"value\": {\"stringValue\": \"$tool_name\"}}]"
}

storage_record_correction() {
  local session_id="$1"

  # 메트릭만 전송
  send_metric "skill_evaluator.user.correction" 1 \
    "[{\"key\": \"session.id\", \"value\": {\"stringValue\": \"$session_id\"}}]"

  debug_log "User correction recorded"
}

storage_finalize_session() {
  local session_id="$1"
  local status="$2"

  local ctx_file="$STATE_DIR/$session_id.ctx"
  [ ! -f "$ctx_file" ] && return

  # 컨텍스트 로드
  local ctx
  ctx=$(cat "$ctx_file")
  local trace_id
  trace_id=$(echo "$ctx" | extract_json "traceId")
  local span_id
  span_id=$(echo "$ctx" | extract_json "spanId")
  local start_time
  start_time=$(echo "$ctx" | extract_json_number "startTime")
  local end_time
  end_time=$(get_time_ns)

  # 세션 종료 span 업데이트 (새 span으로 전송)
  local end_span_id
  end_span_id=$(generate_span_id)
  send_span "$trace_id" "$end_span_id" "session.end" \
    "[
      {\"key\": \"session.id\", \"value\": {\"stringValue\": \"$session_id\"}},
      {\"key\": \"session.status\", \"value\": {\"stringValue\": \"$status\"}}
    ]" \
    "$end_time" "$end_time" "$span_id"

  # 세션 duration 메트릭
  local duration_ms
  duration_ms=$(( (end_time - start_time) / 1000000 ))
  send_metric "skill_evaluator.session.duration_ms" "$duration_ms" \
    "[{\"key\": \"session.status\", \"value\": {\"stringValue\": \"$status\"}}]"

  # 정리
  rm -f "$ctx_file"

  debug_log "Session finalized: $status (duration: ${duration_ms}ms)"
}
