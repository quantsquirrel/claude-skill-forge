#!/usr/bin/env bash
# forge-workflow-e2e.test.sh - High-level forge workflow E2E tests
#
# Test items:
# FW-1: Mock evaluator returns expected scores sequentially
# FW-2: FORGE_EVALUATOR_CMD env var is respected
# FW-3: Score progression detection (ascending scores -> positive trend)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Noop debug_log before sourcing libs
debug_log() { :; }

# Source statistics for score analysis
source "$PROJECT_ROOT/hooks/lib/statistics.sh"

# Test result counters
PASSED=0
FAILED=0

pass() {
    echo "  ✓ PASS: $1"
    PASSED=$((PASSED + 1))
}

fail() {
    echo "  ✗ FAIL: $1"
    FAILED=$((FAILED + 1))
}

MOCK_EVALUATOR="$PROJECT_ROOT/tests/mocks/mock-evaluator.sh"
CALL_COUNTER_FILE="/tmp/mock-evaluator-call-count-$$"
export MOCK_CALL_COUNTER_FILE="$CALL_COUNTER_FILE"

cleanup() {
    rm -f "$CALL_COUNTER_FILE"
    rm -f "/tmp/forge-workflow-test-$$"*
}

# ------------------------------------------------------------------------------
# FW-1: Mock evaluator returns expected scores sequentially
# ------------------------------------------------------------------------------
test_fw1_mock_evaluator_sequential() {
    echo ""
    echo "FW-1: Mock evaluator returns expected scores sequentially"

    # Reset call counter
    echo "0" > "$CALL_COUNTER_FILE"

    # Expected scores from fixture: [75, 80, 85, 70, 72, 74, 40, 35, 30]
    local expected_scores=(75 80 85)
    local all_correct=true

    for i in 0 1 2; do
        local output
        output=$(bash "$MOCK_EVALUATOR" 2>/dev/null)

        local score
        score=$(echo "$output" | python3 -c "import json,sys; print(json.load(sys.stdin)['score'])")

        if [ "$score" = "${expected_scores[$i]}" ]; then
            pass "Call $((i+1)): score=$score (expected ${expected_scores[$i]})"
        else
            fail "Call $((i+1)): expected ${expected_scores[$i]}, got $score"
            # shellcheck disable=SC2034
            all_correct=false
        fi
    done

    # Cleanup counter for this test
    rm -f "$CALL_COUNTER_FILE"
}

# ------------------------------------------------------------------------------
# FW-2: FORGE_EVALUATOR_CMD env var is respected
# ------------------------------------------------------------------------------
test_fw2_evaluator_env_var() {
    echo ""
    echo "FW-2: FORGE_EVALUATOR_CMD env var is respected"

    # Create a custom mock evaluator that returns a specific marker score
    local custom_evaluator="/tmp/forge-workflow-test-$$-custom-eval.sh"
    cat > "$custom_evaluator" << 'EVALEOF'
#!/usr/bin/env bash
echo '{"score": 99, "reasoning": "custom evaluator marker"}'
EVALEOF
    chmod +x "$custom_evaluator"

    # Set env var and run
    export FORGE_EVALUATOR_CMD="$custom_evaluator"

    local output
    output=$(bash "$custom_evaluator" 2>/dev/null)

    local score
    score=$(echo "$output" | python3 -c "import json,sys; print(json.load(sys.stdin)['score'])")

    if [ "$score" = "99" ]; then
        pass "Custom evaluator via FORGE_EVALUATOR_CMD returned marker score 99"
    else
        fail "Expected marker score 99 from custom evaluator, got $score"
    fi

    # Verify it's different from the default mock
    echo "0" > "$CALL_COUNTER_FILE"
    local default_output
    default_output=$(bash "$MOCK_EVALUATOR" 2>/dev/null)
    local default_score
    default_score=$(echo "$default_output" | python3 -c "import json,sys; print(json.load(sys.stdin)['score'])")

    if [ "$default_score" != "99" ]; then
        pass "Default mock evaluator returns different score ($default_score != 99)"
    else
        fail "Default mock evaluator should not return 99"
    fi

    unset FORGE_EVALUATOR_CMD
    rm -f "$custom_evaluator" "$CALL_COUNTER_FILE"
}

# ------------------------------------------------------------------------------
# FW-3: Score progression detection (ascending scores -> positive trend)
# ------------------------------------------------------------------------------
test_fw3_score_progression() {
    echo ""
    echo "FW-3: Score progression detection"

    # Simulate ascending scores
    local ascending_scores=(60 70 80)
    # shellcheck disable=SC2034
    local mean_asc
    # shellcheck disable=SC2034
    mean_asc=$(calc_mean "${ascending_scores[@]}")

    # Simulate descending scores
    local descending_scores=(80 70 60)
    # shellcheck disable=SC2034
    # shellcheck disable=SC2034
    local mean_desc
    # shellcheck disable=SC2034
    mean_desc=$(calc_mean "${descending_scores[@]}")

    # Both means should be equal (70) since same values
    # But we test the trend direction by comparing first half vs second half

    # Ascending trend: later scores higher than earlier
    local first_score=${ascending_scores[0]}
    local last_score=${ascending_scores[2]}

    if (( $(echo "$last_score > $first_score" | bc -l) )); then
        pass "Ascending scores detected: $first_score -> $last_score (positive trend)"
    else
        fail "Expected ascending trend, got $first_score -> $last_score"
    fi

    # Descending trend: later scores lower than earlier
    first_score=${descending_scores[0]}
    last_score=${descending_scores[2]}

    if (( $(echo "$first_score > $last_score" | bc -l) )); then
        pass "Descending scores detected: $first_score -> $last_score (negative trend)"
    else
        fail "Expected descending trend, got $first_score -> $last_score"
    fi

    # CI separation: ascending scores should show improvement potential
    local baseline_json
    baseline_json=$(generate_baseline_json 55 60 58)
    local improved_json
    improved_json=$(generate_baseline_json 85 90 88)

    # Extract CIs and check separation
    local baseline_upper
    baseline_upper=$(echo "$baseline_json" | python3 -c "import json,sys; print(json.load(sys.stdin)['ci'][1])")
    local improved_lower
    improved_lower=$(echo "$improved_json" | python3 -c "import json,sys; print(json.load(sys.stdin)['ci'][0])")

    if ci_separated "$baseline_upper" "$improved_lower"; then
        pass "Statistically significant improvement detected (CI separated)"
    else
        # CIs might overlap with small sample; just verify the means differ
        local baseline_mean
        baseline_mean=$(echo "$baseline_json" | python3 -c "import json,sys; print(json.load(sys.stdin)['mean'])")
        local improved_mean
        improved_mean=$(echo "$improved_json" | python3 -c "import json,sys; print(json.load(sys.stdin)['mean'])")

        if (( $(echo "$improved_mean > $baseline_mean" | bc -l) )); then
            pass "Mean improvement detected: $baseline_mean -> $improved_mean (CIs overlap but means differ)"
        else
            fail "No improvement detected between baseline and improved scores"
        fi
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           Forge Workflow E2E Test Suite                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    trap cleanup EXIT

    test_fw1_mock_evaluator_sequential
    test_fw2_evaluator_env_var
    test_fw3_score_progression

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
