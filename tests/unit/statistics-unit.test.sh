#!/usr/bin/env bash
# statistics-unit.test.sh - statistics.sh edge case unit tests
#
# Test items:
# S-1: Empty scores (calc_mean no args)
# S-2: Single score
# S-3: Identical scores (stddev = 0)
# S-4: CI with zero stddev
# S-5: Large n fallback (t_value=2.0)
# S-6: Negative separation
# S-7: Equal boundary
# S-8: Positive separation
# S-9: generate_baseline_json valid JSON

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Noop debug_log before sourcing libs
debug_log() { :; }

# Source library
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

# ------------------------------------------------------------------------------
# S-1: Empty scores → calc_mean with no args → "0", return 1
# ------------------------------------------------------------------------------
test_s1_empty_scores() {
    echo ""
    echo "S-1: Empty scores (calc_mean no args)"

    local result
    local exit_code=0
    result=$(calc_mean) || exit_code=$?

    if [[ "$result" == "0" && "$exit_code" -eq 1 ]]; then
        pass "calc_mean with no args returns '0' with exit code 1"
    else
        fail "Expected '0' with exit 1, got '$result' with exit $exit_code"
    fi
}

# ------------------------------------------------------------------------------
# S-2: Single score → calc_mean 85 → "85" or "85.00"
# ------------------------------------------------------------------------------
test_s2_single_score() {
    echo ""
    echo "S-2: Single score"

    local result
    result=$(calc_mean 85)

    if [[ "$result" == "85" || "$result" == "85.00" || "$result" == "85.0" ]]; then
        pass "calc_mean 85 returns '$result'"
    else
        fail "Expected '85' or '85.00', got '$result'"
    fi
}

# ------------------------------------------------------------------------------
# S-3: Identical scores → calc_stddev with same values → "0"
# ------------------------------------------------------------------------------
test_s3_identical_scores() {
    echo ""
    echo "S-3: Identical scores (stddev = 0)"

    local result
    result=$(calc_stddev 50 50 50 50)

    if [[ "$result" == "0" || "$result" == "0.00" || "$result" == ".00" || "$result" == "0.0" ]]; then
        pass "calc_stddev with identical scores returns '$result'"
    else
        fail "Expected '0' or '0.00', got '$result'"
    fi
}

# ------------------------------------------------------------------------------
# S-4: CI with zero stddev → bounds should be equal
# ------------------------------------------------------------------------------
test_s4_ci_zero_stddev() {
    echo ""
    echo "S-4: CI with zero stddev"

    local ci_output
    ci_output=$(calc_ci 85 0 3)
    mapfile -t ci <<< "$ci_output"

    if [[ "${#ci[@]}" -eq 2 ]]; then
        local lower="${ci[0]}"
        local upper="${ci[1]}"
        # Compare numerically: both bounds should equal the mean
        if (( $(echo "$lower == $upper" | bc -l) )); then
            pass "CI with zero stddev: bounds equal [$lower, $upper]"
        else
            fail "Expected equal bounds, got [$lower, $upper]"
        fi
    else
        fail "calc_ci did not return 2 values (got ${#ci[@]})"
    fi
}

# ------------------------------------------------------------------------------
# S-5: Large n fallback → calc_ci 85 3 100 → uses t_value=2.0
# ------------------------------------------------------------------------------
test_s5_large_n_fallback() {
    echo ""
    echo "S-5: Large n fallback (t_value=2.0)"

    local ci_output
    ci_output=$(calc_ci 85 3 100)
    mapfile -t ci <<< "$ci_output"

    if [[ "${#ci[@]}" -eq 2 ]]; then
        local lower="${ci[0]}"
        local upper="${ci[1]}"
        # With n=100, t=2.0, se=3/sqrt(100)=0.3, margin=0.6
        # CI width should be ~1.2 (very narrow)
        local width
        width=$(echo "$upper - $lower" | bc -l)
        if (( $(echo "$width < 5" | bc -l) )); then
            pass "Large n uses t=2.0, CI width=$width (narrow) [$lower, $upper]"
        else
            fail "Expected narrow CI for n=100, got width=$width [$lower, $upper]"
        fi
    else
        fail "calc_ci did not return 2 values"
    fi
}

# ------------------------------------------------------------------------------
# S-6: Negative separation → ci_separated 90 80 → return 1
# ------------------------------------------------------------------------------
test_s6_negative_separation() {
    echo ""
    echo "S-6: Negative separation (ci_separated 90 80)"

    if ci_separated 90 80; then
        fail "90 < 80 should not be separated"
    else
        pass "ci_separated 90 80 correctly returns 1 (not separated)"
    fi
}

# ------------------------------------------------------------------------------
# S-7: Equal boundary → ci_separated 85 85 → return 1
# ------------------------------------------------------------------------------
test_s7_equal_boundary() {
    echo ""
    echo "S-7: Equal boundary (ci_separated 85 85)"

    if ci_separated 85 85; then
        fail "85 < 85 should not be separated"
    else
        pass "ci_separated 85 85 correctly returns 1 (not separated)"
    fi
}

# ------------------------------------------------------------------------------
# S-8: Positive separation → ci_separated 80 85 → return 0
# ------------------------------------------------------------------------------
test_s8_positive_separation() {
    echo ""
    echo "S-8: Positive separation (ci_separated 80 85)"

    if ci_separated 80 85; then
        pass "ci_separated 80 85 correctly returns 0 (separated)"
    else
        fail "80 < 85 should be separated"
    fi
}

# ------------------------------------------------------------------------------
# S-9: generate_baseline_json returns valid JSON (with 3 scores)
# ------------------------------------------------------------------------------
test_s9_baseline_json() {
    echo ""
    echo "S-9: generate_baseline_json returns valid JSON"

    local json
    json=$(generate_baseline_json 80 85 90)

    # Validate JSON structure with python3
    if echo "$json" | python3 -c "import json,sys; json.load(sys.stdin)" 2>/dev/null; then
        pass "generate_baseline_json produces valid JSON"
    else
        fail "generate_baseline_json produced invalid JSON: $json"
    fi

    # Check required fields
    local fields_check
    fields_check=$(echo "$json" | python3 -c "
import json, sys
d = json.load(sys.stdin)
missing = []
for f in ['scores', 'mean', 'stddev', 'ci', 'sample_size', 'timestamp']:
    if f not in d:
        missing.append(f)
if missing:
    print('MISSING:' + ','.join(missing))
else:
    print('OK')
")
    if [[ "$fields_check" == "OK" ]]; then
        pass "JSON contains all required fields (scores, mean, stddev, ci, sample_size, timestamp)"
    else
        fail "JSON $fields_check"
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           Statistics Unit Test Suite                           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    test_s1_empty_scores
    test_s2_single_score
    test_s3_identical_scores
    test_s4_ci_zero_stddev
    test_s5_large_n_fallback
    test_s6_negative_separation
    test_s7_equal_boundary
    test_s8_positive_separation
    test_s9_baseline_json

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
