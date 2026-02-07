#!/usr/bin/env bash
# storage-local-unit.test.sh - storage-local.sh CRUD unit tests
#
# Test items:
# ST-1: Record skill and retrieve
# ST-2: Usage count increments
# ST-3: Token tracking accuracy
# ST-4: get_upgrade_mode returns valid value
# ST-5: find_skill_path with nonexistent skill returns empty
# ST-6: get_skill_type returns "explicit" or "silent"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Test isolation: use temp dir for storage
export LOCAL_STORAGE_DIR="/tmp/skill-forge-test-storage-$$"
mkdir -p "$LOCAL_STORAGE_DIR/skills"

# Noop debug_log before sourcing libs
debug_log() { :; }

# Source libraries
source "$PROJECT_ROOT/hooks/lib/statistics.sh"
source "$PROJECT_ROOT/hooks/lib/storage-local.sh"

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
# ST-1: Record skill and retrieve
# ------------------------------------------------------------------------------
test_st1_record_and_retrieve() {
    echo ""
    echo "ST-1: Record skill and retrieve"

    storage_record_skill "test-crud-skill" "1000" "false"

    local summary
    summary=$(get_all_skills_summary)

    if echo "$summary" | grep -q "test-crud-skill"; then
        pass "Skill 'test-crud-skill' found in summary"
    else
        fail "Skill 'test-crud-skill' not found in summary"
    fi
}

# ------------------------------------------------------------------------------
# ST-2: Usage count increments
# ------------------------------------------------------------------------------
test_st2_usage_count() {
    echo ""
    echo "ST-2: Usage count increments"

    # Record same skill 3 more times (already recorded once in ST-1)
    storage_record_skill "test-crud-skill" "500" "false"
    storage_record_skill "test-crud-skill" "750" "false"
    storage_record_skill "test-crud-skill" "600" "false"

    local usage
    usage=$(get_all_skills_summary | python3 -c "import json,sys; print(json.load(sys.stdin).get('test-crud-skill',{}).get('usageCount',0))")

    if [ "$usage" = "4" ]; then
        pass "Usage count correctly incremented to 4"
    else
        fail "Expected usage count 4, got $usage"
    fi
}

# ------------------------------------------------------------------------------
# ST-3: Token tracking accuracy
# ------------------------------------------------------------------------------
test_st3_token_tracking() {
    echo ""
    echo "ST-3: Token tracking accuracy"

    # Total tokens for test-crud-skill: 1000 + 500 + 750 + 600 = 2850
    local efficiency
    efficiency=$(get_token_efficiency "test-crud-skill")

    # 2850 / 4 = 712.5 → int = 712
    if [[ "$efficiency" =~ ^[0-9]+$ ]]; then
        pass "Token efficiency calculated: $efficiency tokens/usage"
    else
        fail "Invalid efficiency value: $efficiency"
    fi

    # Verify total tokens
    local total_tokens
    total_tokens=$(get_all_skills_summary | python3 -c "import json,sys; print(json.load(sys.stdin).get('test-crud-skill',{}).get('totalTokens',0))")

    if [ "$total_tokens" = "2850" ]; then
        pass "Total tokens correctly tracked: $total_tokens"
    else
        fail "Expected total tokens 2850, got $total_tokens"
    fi
}

# ------------------------------------------------------------------------------
# ST-4: get_upgrade_mode returns valid value
# ------------------------------------------------------------------------------
test_st4_upgrade_mode() {
    echo ""
    echo "ST-4: get_upgrade_mode returns valid value"

    local mode
    mode=$(get_upgrade_mode "test-crud-skill")

    if [[ "$mode" =~ ^(TDD_FIT|HEURISTIC)$ ]]; then
        pass "Upgrade mode: $mode"
    else
        fail "Invalid upgrade mode: $mode"
    fi
}

# ------------------------------------------------------------------------------
# ST-5: find_skill_path with nonexistent skill returns empty
# ------------------------------------------------------------------------------
test_st5_nonexistent_skill_path() {
    echo ""
    echo "ST-5: find_skill_path with nonexistent skill"

    local path
    path=$(find_skill_path "nonexistent-skill-xyz-99999") || true

    if [ -z "$path" ]; then
        pass "Returns empty for nonexistent skill"
    else
        fail "Expected empty, got: $path"
    fi
}

# ------------------------------------------------------------------------------
# ST-6: get_skill_type returns valid type
# ------------------------------------------------------------------------------
test_st6_skill_type() {
    echo ""
    echo "ST-6: get_skill_type returns valid type"

    # Create a temporary skill file to test with
    local tmp_skill_dir="/tmp/skill-forge-test-skill-$$"
    mkdir -p "$tmp_skill_dir"

    # Create an explicit-style skill file (has argument-hint)
    cat > "$tmp_skill_dir/SKILL.md" << 'SKILLEOF'
---
name: test-skill
description: 'Test skill for unit testing'
argument-hint: '<mode>'
---

# Test Skill

## Quick Reference
| Mode | Description |
|------|-------------|
| test | Run tests |
SKILLEOF

    local skill_type
    skill_type=$(get_skill_type "test-skill" "$tmp_skill_dir/SKILL.md")

    if [[ "$skill_type" == "explicit" ]]; then
        pass "Skill with argument-hint detected as 'explicit'"
    else
        fail "Expected 'explicit', got '$skill_type'"
    fi

    # Create a silent-style skill file (has trigger keywords)
    cat > "$tmp_skill_dir/SKILL-silent.md" << 'SKILLEOF'
---
name: auto-formatter
description: 'Triggers on code formatting, style, lint, prettier, eslint, beautify'
---

# Auto Formatter

## When to Use
Automatically triggered on code style discussions.
SKILLEOF

    local silent_type
    silent_type=$(get_skill_type "auto-formatter" "$tmp_skill_dir/SKILL-silent.md")

    if [[ "$silent_type" == "silent" ]]; then
        pass "Skill with trigger keywords detected as 'silent'"
    else
        fail "Expected 'silent', got '$silent_type'"
    fi

    # Cleanup
    rm -rf "$tmp_skill_dir"
}

# ------------------------------------------------------------------------------
# ST-7: storage_init_session exists and is callable
# ------------------------------------------------------------------------------
test_st7_storage_init_session() {
    echo ""
    echo "ST-7: storage_init_session exists and is callable"

    if type storage_init_session &>/dev/null; then
        storage_init_session "test-session-123" "/tmp/test-dir" 2>/dev/null
        if [ $? -eq 0 ]; then
            pass "storage_init_session callable with session_id and cwd"
        else
            fail "storage_init_session returned error"
        fi
    else
        fail "storage_init_session not defined"
    fi
}

# ------------------------------------------------------------------------------
# ST-8: Special characters in skill name
# ------------------------------------------------------------------------------
test_st8_special_chars_in_skill_name() {
    echo ""
    echo "ST-8: Special characters in skill name"

    storage_record_skill "test-skill-special" "100" "false" 2>/dev/null
    local result=$?

    if [ $result -eq 0 ]; then
        pass "Skill name with hyphens handled safely"
    else
        fail "Skill name caused error"
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           Storage Local Unit Test Suite                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    trap cleanup EXIT

    test_st1_record_and_retrieve
    test_st2_usage_count
    test_st3_token_tracking
    test_st4_upgrade_mode
    test_st5_nonexistent_skill_path
    test_st6_skill_type
    test_st7_storage_init_session
    test_st8_special_chars_in_skill_name

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
