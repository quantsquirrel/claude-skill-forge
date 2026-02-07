#!/usr/bin/env bash
# recommendation-engine-unit.test.sh - recommendation engine unit tests
#
# Test items:
# RE-1: calculate_priority returns valid priority (1, 2, or 3)
# RE-2: priority_label returns correct label
# RE-3: generate_recommendations returns valid JSON array

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Test isolation: use temp dir for storage
export LOCAL_STORAGE_DIR="/tmp/skill-forge-test-rec-$$"
mkdir -p "$LOCAL_STORAGE_DIR/skills"

# Noop debug_log before sourcing libs
debug_log() { :; }

# Source libraries (recommendation-engine.sh sources storage-local.sh internally)
source "$PROJECT_ROOT/hooks/lib/statistics.sh"
source "$PROJECT_ROOT/hooks/lib/recommendation-engine.sh"

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

cleanup() {
    rm -rf "$LOCAL_STORAGE_DIR"
}

# ------------------------------------------------------------------------------
# RE-1: calculate_priority returns valid priority value
# ------------------------------------------------------------------------------
test_re1_calculate_priority() {
    echo ""
    echo "RE-1: calculate_priority returns valid priority"

    # Seed some usage data first
    storage_record_skill "rec-test-skill" "1000" "false"
    storage_record_skill "rec-test-skill" "1200" "false"

    local priority
    priority=$(calculate_priority "rec-test-skill")

    if [[ "$priority" =~ ^[123]$ ]]; then
        local label
        label=$(priority_label "$priority")
        pass "Priority for 'rec-test-skill': $priority ($label)"
    else
        fail "Invalid priority value: $priority (expected 1, 2, or 3)"
    fi
}

# ------------------------------------------------------------------------------
# RE-2: priority_label returns correct labels
# ------------------------------------------------------------------------------
test_re2_priority_labels() {
    echo ""
    echo "RE-2: priority_label returns correct labels"

    local label_low
    label_low=$(priority_label 1)
    if [[ "$label_low" == "LOW" ]]; then
        pass "priority_label 1 = LOW"
    else
        fail "Expected LOW for priority 1, got '$label_low'"
    fi

    local label_med
    label_med=$(priority_label 2)
    if [[ "$label_med" == "MED" ]]; then
        pass "priority_label 2 = MED"
    else
        fail "Expected MED for priority 2, got '$label_med'"
    fi

    local label_high
    label_high=$(priority_label 3)
    if [[ "$label_high" == "HIGH" ]]; then
        pass "priority_label 3 = HIGH"
    else
        fail "Expected HIGH for priority 3, got '$label_high'"
    fi

    # Default case
    local label_default
    label_default=$(priority_label 99)
    if [[ "$label_default" == "LOW" ]]; then
        pass "priority_label 99 (default) = LOW"
    else
        fail "Expected LOW for default, got '$label_default'"
    fi
}

# ------------------------------------------------------------------------------
# RE-3: generate_recommendations returns valid JSON array
# ------------------------------------------------------------------------------
test_re3_generate_recommendations() {
    echo ""
    echo "RE-3: generate_recommendations returns valid JSON"

    # Add more skills for recommendation diversity
    storage_record_skill "rec-skill-alpha" "2000" "true"
    storage_record_skill "rec-skill-beta" "800" "false"
    storage_record_skill "rec-skill-beta" "900" "false"
    storage_record_skill "rec-skill-beta" "850" "false"

    local recommendations
    recommendations=$(generate_recommendations 2>/dev/null)

    # Validate JSON array
    local is_valid
    is_valid=$(echo "$recommendations" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if isinstance(data, list):
        print('valid_array')
    else:
        print('not_array')
except:
    print('invalid_json')
")

    if [[ "$is_valid" == "valid_array" ]]; then
        pass "generate_recommendations returns valid JSON array"
    else
        fail "Expected valid JSON array, got: $is_valid"
    fi

    # Check that recommendations contain expected fields
    local field_check
    field_check=$(echo "$recommendations" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if len(data) == 0:
    print('empty')
    sys.exit(0)
required = ['skill', 'priority', 'priority_label', 'usage', 'tokens', 'mode']
missing = []
for item in data:
    for f in required:
        if f not in item:
            missing.append(f)
            break
if missing:
    print('MISSING:' + ','.join(set(missing)))
else:
    print('OK:' + str(len(data)))
")

    if [[ "$field_check" == OK:* ]]; then
        local count="${field_check#OK:}"
        pass "Recommendations have all required fields ($count items)"
    elif [[ "$field_check" == "empty" ]]; then
        pass "Recommendations returned empty array (no data yet is acceptable)"
    else
        fail "Recommendations $field_check"
    fi
}

# ------------------------------------------------------------------------------
# RE-4: Python heredocs handle special characters
# ------------------------------------------------------------------------------
test_re4_special_chars_skill_name() {
    echo ""
    echo "RE-4: Special characters in skill name for recommendations"

    storage_record_skill "rec-test-special" "200" "false"

    local priority
    priority=$(calculate_priority "rec-test-special" 2>/dev/null) || true

    if [[ "$priority" =~ ^[1-3]$ ]]; then
        pass "Priority calculated for skill with hyphens: $priority"
    else
        fail "Failed to calculate priority for skill with special chars"
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║        Recommendation Engine Unit Test Suite                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    trap cleanup EXIT

    test_re1_calculate_priority
    test_re2_priority_labels
    test_re3_generate_recommendations
    test_re4_special_chars_skill_name

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
