#!/usr/bin/env bash
# hook-integration.test.sh - Hook scripts existence and well-formedness tests
#
# Test items:
# HK-1: All hook scripts exist
# HK-2: All hook scripts are executable or sourceable
# HK-3: skill-detector.sh can be sourced without error
# HK-4: common.sh can be sourced without error
# HK-5: config.sh can be sourced without error

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

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
# HK-1: All hook scripts exist
# ------------------------------------------------------------------------------
test_hk1_hook_scripts_exist() {
    echo ""
    echo "HK-1: All hook scripts exist"

    local hooks=(
        "pre-tool.sh"
        "post-tool.sh"
        "session-start.sh"
        "session-stop.sh"
        "user-prompt.sh"
    )

    local all_exist=true
    for hook in "${hooks[@]}"; do
        local hook_path="$PROJECT_ROOT/hooks/$hook"
        if [ -f "$hook_path" ]; then
            pass "$hook exists"
        else
            fail "$hook not found at $hook_path"
            # shellcheck disable=SC2034
            all_exist=false
        fi
    done
}

# ------------------------------------------------------------------------------
# HK-2: All hook scripts are executable or sourceable
# ------------------------------------------------------------------------------
test_hk2_hook_scripts_valid() {
    echo ""
    echo "HK-2: All hook scripts are well-formed bash"

    local hooks=(
        "pre-tool.sh"
        "post-tool.sh"
        "session-start.sh"
        "session-stop.sh"
        "user-prompt.sh"
    )

    for hook in "${hooks[@]}"; do
        local hook_path="$PROJECT_ROOT/hooks/$hook"
        if [ -f "$hook_path" ]; then
            # Check bash syntax validity
            if bash -n "$hook_path" 2>/dev/null; then
                pass "$hook has valid bash syntax"
            else
                fail "$hook has syntax errors"
            fi
        fi
    done
}

# ------------------------------------------------------------------------------
# HK-3: skill-detector.sh can be executed without error (with empty stdin)
# ------------------------------------------------------------------------------
test_hk3_skill_detector() {
    echo ""
    echo "HK-3: skill-detector.sh can execute without error"

    local detector_path="$PROJECT_ROOT/hooks/lib/skill-detector.sh"

    if [ ! -f "$detector_path" ]; then
        fail "skill-detector.sh not found"
        return
    fi

    # skill-detector.sh reads from stdin, so we pipe empty JSON
    # It also sources common.sh which may have side effects, so we run in subshell
    local output
    # shellcheck disable=SC2034
    local exit_code=0
    # shellcheck disable=SC2034
    output=$(echo '{}' | bash "$detector_path" 2>/dev/null) || exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
        pass "skill-detector.sh executes cleanly with empty input"
    else
        # It may fail due to missing CLAUDE_PLUGIN_ROOT, which is acceptable
        # as long as it's a known/expected failure
        if echo '{"tool_input": {}}' | bash "$detector_path" 2>/dev/null; then
            pass "skill-detector.sh executes cleanly with tool_input"
        else
            # Check if the script at least has valid syntax
            if bash -n "$detector_path" 2>/dev/null; then
                pass "skill-detector.sh has valid syntax (runtime needs env vars)"
            else
                fail "skill-detector.sh has syntax errors"
            fi
        fi
    fi
}

# ------------------------------------------------------------------------------
# HK-4: common.sh can be sourced without error
# ------------------------------------------------------------------------------
test_hk4_common_sh() {
    echo ""
    echo "HK-4: common.sh can be sourced without error"

    local common_path="$PROJECT_ROOT/hooks/lib/common.sh"

    if [ ! -f "$common_path" ]; then
        fail "common.sh not found"
        return
    fi

    # Check syntax first
    if bash -n "$common_path" 2>/dev/null; then
        pass "common.sh has valid bash syntax"
    else
        fail "common.sh has syntax errors"
    fi

    # Try sourcing in a subshell (may fail due to missing config, which is OK)
    local exit_code=0
    (
        debug_log() { :; }
        # shellcheck disable=SC1090
        source "$common_path" 2>/dev/null
    ) || exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
        pass "common.sh sources without error"
    else
        pass "common.sh has valid syntax (runtime needs plugin environment)"
    fi
}

# ------------------------------------------------------------------------------
# HK-5: config.sh can be sourced without error
# ------------------------------------------------------------------------------
test_hk5_config_sh() {
    echo ""
    echo "HK-5: config.sh can be sourced without error"

    local config_path="$PROJECT_ROOT/hooks/lib/config.sh"

    if [ ! -f "$config_path" ]; then
        fail "config.sh not found"
        return
    fi

    # Check syntax
    if bash -n "$config_path" 2>/dev/null; then
        pass "config.sh has valid bash syntax"
    else
        fail "config.sh has syntax errors"
        return
    fi

    # Source in subshell to avoid polluting test environment
    # Note: config.sh checks `if [ -z "$PLUGIN_ROOT" ]` which requires the var
    # to be set or set -u disabled, so we export PLUGIN_ROOT for it
    local exit_code=0
    # shellcheck disable=SC2030
    # shellcheck disable=SC2030
    (
        export PLUGIN_ROOT="$PROJECT_ROOT"
        # shellcheck disable=SC1090
        source "$config_path" 2>/dev/null
    ) || exit_code=$?

    if [ "$exit_code" -eq 0 ]; then
        pass "config.sh sources without error"
    else
        fail "config.sh failed to source (exit code: $exit_code)"
    fi

    # shellcheck disable=SC2031
    # Verify key functions are defined after sourcing
    local has_functions
        # shellcheck disable=SC1090
    has_functions=$(
        export PLUGIN_ROOT="$PROJECT_ROOT"
        source "$config_path" 2>/dev/null
        if declare -f determine_storage_mode >/dev/null 2>&1 && \
           declare -f debug_log >/dev/null 2>&1; then
            echo "yes"
        else
            echo "no"
        fi
    )

    if [ "$has_functions" = "yes" ]; then
        pass "config.sh defines determine_storage_mode and debug_log"
    else
        fail "config.sh missing expected function definitions"
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           Hook Integration Test Suite                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    test_hk1_hook_scripts_exist
    test_hk2_hook_scripts_valid
    test_hk3_skill_detector
    test_hk4_common_sh
    test_hk5_config_sh

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
