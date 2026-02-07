#!/usr/bin/env bash
# skill-up-integration.test.sh - skill-up 통합 기능 E2E 테스트
#
# 테스트 항목:
# 1. Usage Tracking (기존 기능)
# 2. Trend Analysis (신규)
# 3. Upgrade Mode Detection (신규)
# 4. Sample Size Options (신규)
# 5. TDD Regression (기존 함수 무결성)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# 테스트용 환경 설정
export LOCAL_STORAGE_DIR="/tmp/skill-forge-test-$$"
mkdir -p "$LOCAL_STORAGE_DIR/skills"

# 테스트 환경용 debug_log (noop)
debug_log() { :; }

# 라이브러리 로드
source "$PROJECT_ROOT/hooks/lib/storage-local.sh"
source "$PROJECT_ROOT/hooks/lib/statistics.sh"

# 테스트 결과 카운터
PASSED=0
FAILED=0

# 테스트 헬퍼 함수
pass() {
    echo "  ✓ PASS: $1"
    PASSED=$((PASSED + 1))
}

fail() {
    echo "  ✗ FAIL: $1"
    FAILED=$((FAILED + 1))
}

# ------------------------------------------------------------------------------
# Test 1: Usage Tracking (기존 기능 확인)
# ------------------------------------------------------------------------------
test_usage_tracking() {
    echo ""
    echo "Test 1: Usage Tracking"

    # 스킬 기록
    storage_record_skill "test-skill" "1500" "false"
    storage_record_skill "test-skill" "2000" "false"

    # 조회 확인
    local summary
    summary=$(get_all_skills_summary)
    if echo "$summary" | grep -q "test-skill"; then
        pass "Skill recorded in storage"
    else
        fail "Skill not found in storage"
    fi

    # 사용량 확인 (2회 기록)
    local usage
    usage=$(echo "$summary" | python3 -c "import json,sys; print(json.load(sys.stdin).get('test-skill',{}).get('usageCount',0))")
    if [ "$usage" = "2" ]; then
        pass "Usage count incremented correctly (2)"
    else
        fail "Expected usage count 2, got $usage"
    fi
}

# ------------------------------------------------------------------------------
# Test 2: Trend Analysis (신규)
# ------------------------------------------------------------------------------
test_trend_analysis() {
    echo ""
    echo "Test 2: Trend Analysis"

    local trend
    trend=$(get_usage_trend "test-skill")
    if [[ "$trend" =~ ^(positive|negative|stable)$ ]]; then
        pass "Trend returned valid value ($trend)"
    else
        fail "Invalid trend value: $trend"
    fi
}

# ------------------------------------------------------------------------------
# Test 3: Token Efficiency (신규)
# ------------------------------------------------------------------------------
test_token_efficiency() {
    echo ""
    echo "Test 3: Token Efficiency"

    local efficiency
    efficiency=$(get_token_efficiency "test-skill")
    # 3500 tokens / 2 usages = 1750
    if [[ "$efficiency" =~ ^[0-9]+$ ]]; then
        pass "Efficiency calculated: $efficiency tokens/usage"
    else
        fail "Invalid efficiency value: $efficiency"
    fi
}

# ------------------------------------------------------------------------------
# Test 4: Upgrade Mode Detection (신규)
# ------------------------------------------------------------------------------
test_upgrade_mode() {
    echo ""
    echo "Test 4: Upgrade Mode Detection"

    local mode
    mode=$(get_upgrade_mode "test-skill")
    if [[ "$mode" =~ ^(TDD_FIT|HEURISTIC)$ ]]; then
        pass "Mode detected: $mode"
    else
        fail "Invalid mode: $mode"
    fi
}

# ------------------------------------------------------------------------------
# Test 5: Sample Size Options (신규)
# ------------------------------------------------------------------------------
test_sample_size_option() {
    echo ""
    echo "Test 5: Sample Size Options"

    local n_standard
    n_standard=$(get_recommended_sample_size "standard")
    local n_high
    n_high=$(get_recommended_sample_size "high")

    if [ "$n_standard" = "3" ]; then
        pass "Standard sample size: 3"
    else
        fail "Expected standard=3, got $n_standard"
    fi

    if [ "$n_high" = "5" ]; then
        pass "High precision sample size: 5"
    else
        fail "Expected high=5, got $n_high"
    fi
}

# ------------------------------------------------------------------------------
# Test 6: CI Width Estimation (신규)
# ------------------------------------------------------------------------------
test_ci_width_estimation() {
    echo ""
    echo "Test 6: CI Width Estimation"

    local width_n3
    width_n3=$(estimate_ci_width 3.0 3)
    local width_n5
    width_n5=$(estimate_ci_width 3.0 5)

    # n=5일 때 CI가 더 좁아야 함
    if (( $(echo "$width_n3 > $width_n5" | bc -l) )); then
        pass "n=5 has narrower CI than n=3 ($width_n5 < $width_n3)"
    else
        fail "Expected n=5 CI narrower, got n3=$width_n3 n5=$width_n5"
    fi
}

# ------------------------------------------------------------------------------
# Test 7: TDD Regression (기존 함수 무결성)
# ------------------------------------------------------------------------------
test_tdd_regression() {
    echo ""
    echo "Test 7: TDD Regression (existing functions)"

    # calc_mean 테스트
    local mean
    mean=$(calc_mean 82 85 79)
    if [[ "$mean" == "82.00" || "$mean" == "82.0" || "$mean" == "82" ]]; then
        pass "calc_mean works correctly"
    else
        fail "calc_mean returned unexpected value: $mean"
    fi

    # calc_stddev 테스트
    local stddev
    stddev=$(calc_stddev "$mean" 82 85 79)
    if [[ "$stddev" =~ ^[0-9]+\.[0-9]+$ ]]; then
        pass "calc_stddev works correctly: $stddev"
    else
        fail "calc_stddev returned unexpected value: $stddev"
    fi

    # calc_ci 테스트
    local ci; mapfile -t ci < <(calc_ci "$mean" "$stddev" 3)
    if [ "${#ci[@]}" -eq 2 ]; then
        pass "calc_ci returns CI bounds: [${ci[0]}, ${ci[1]}]"
    else
        fail "calc_ci did not return 2 values"
    fi
}

# ------------------------------------------------------------------------------
# Test 8: Find Skill Path (신규)
# ------------------------------------------------------------------------------
test_find_skill_path() {
    echo ""
    echo "Test 8: Find Skill Path"

    # 존재하지 않는 스킬 - 빈 문자열 반환
    local path
    path=$(find_skill_path "nonexistent-skill-12345")
    if [ -z "$path" ]; then
        pass "Returns empty for nonexistent skill"
    else
        fail "Expected empty, got: $path"
    fi
}

# ------------------------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------------------------
cleanup() {
    rm -rf "$LOCAL_STORAGE_DIR"
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           Skill-Up Integration Test Suite                     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    trap cleanup EXIT

    test_usage_tracking
    test_trend_analysis
    test_token_efficiency
    test_upgrade_mode
    test_sample_size_option
    test_ci_width_estimation
    test_tdd_regression
    test_find_skill_path

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
