#!/usr/bin/env bash
# trial-branch-e2e.test.sh - Trial branch lifecycle E2E tests
#
# Test items:
# TB-1: Create trial branch (verify branch exists)
# TB-2: Create and merge trial branch
# TB-3: Create and discard trial branch (verify original unchanged)
# TB-4: Concurrent trials (2 trial branches at once)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Noop debug_log before sourcing libs
debug_log() { :; }

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

# Create an isolated temp git repo for each test
TEST_REPO_BASE="/tmp/skill-forge-trial-test-$$"

setup_test_repo() {
    local repo_dir="$TEST_REPO_BASE/$1"
    mkdir -p "$repo_dir"
    cd "$repo_dir"
    git init --initial-branch=main >/dev/null 2>&1 || git init >/dev/null 2>&1
    git config user.email "test@skill-forge.test"
    git config user.name "Test Runner"
    echo "initial content" > README.md
    git add README.md
    git commit -m "Initial commit" >/dev/null 2>&1
    echo "$repo_dir"
}

cleanup() {
    rm -rf "$TEST_REPO_BASE"
}

# Source trial-branch.sh (needs to be in a git repo)
source_trial_lib() {
    source "$PROJECT_ROOT/hooks/lib/trial-branch.sh"
}

# ------------------------------------------------------------------------------
# TB-1: Create trial branch (verify branch exists)
# ------------------------------------------------------------------------------
test_tb1_create_trial() {
    echo ""
    echo "TB-1: Create trial branch"

    local repo_dir
    repo_dir=$(setup_test_repo "tb1")
    cd "$repo_dir"

    source_trial_lib

    local branch_name
    branch_name=$(create_trial_branch "test-skill-alpha")

    # Verify branch was created and we're on it
    local current
    current=$(git branch --show-current)

    if [[ "$current" == "$branch_name" ]]; then
        pass "Trial branch created and checked out: $branch_name"
    else
        fail "Expected to be on '$branch_name', but on '$current'"
    fi

    # Verify branch name follows naming convention
    if [[ "$branch_name" =~ ^skill-forge-trial-test-skill-alpha-[0-9]+$ ]]; then
        pass "Branch name follows convention: $branch_name"
    else
        fail "Branch name doesn't match pattern: $branch_name"
    fi
}

# ------------------------------------------------------------------------------
# TB-2: Create and merge trial branch
# ------------------------------------------------------------------------------
test_tb2_create_and_merge() {
    echo ""
    echo "TB-2: Create and merge trial branch"

    local repo_dir
    repo_dir=$(setup_test_repo "tb2")
    cd "$repo_dir"

    source_trial_lib

    # Create trial branch
    local branch_name
    branch_name=$(create_trial_branch "merge-skill")

    # Make changes on trial branch
    echo "trial change" > trial-file.txt
    git add trial-file.txt
    git commit -m "[TRIAL] Add trial file" >/dev/null 2>&1

    # Merge back to main
    merge_trial_success "main" "$branch_name" >/dev/null 2>&1

    # Verify we're back on main
    local current
    current=$(git branch --show-current)
    if [[ "$current" == "main" ]]; then
        pass "Returned to main branch after merge"
    else
        fail "Expected to be on 'main', but on '$current'"
    fi

    # Verify trial changes exist on main
    if [ -f "trial-file.txt" ]; then
        pass "Trial changes merged into main"
    else
        fail "Trial changes not found on main"
    fi

    # Verify trial branch was deleted
    if git branch --list "$branch_name" | grep -q "$branch_name"; then
        fail "Trial branch still exists after merge"
    else
        pass "Trial branch deleted after merge"
    fi
}

# ------------------------------------------------------------------------------
# TB-3: Create and discard trial branch (verify original unchanged)
# ------------------------------------------------------------------------------
test_tb3_create_and_discard() {
    echo ""
    echo "TB-3: Create and discard trial branch"

    local repo_dir
    repo_dir=$(setup_test_repo "tb3")
    cd "$repo_dir"

    source_trial_lib

    # Record original state
    local original_hash
    original_hash=$(git rev-parse HEAD)

    # Create trial branch
    local branch_name
    branch_name=$(create_trial_branch "discard-skill")

    # Make changes on trial branch
    echo "changes to discard" > discard-file.txt
    git add discard-file.txt
    git commit -m "[TRIAL] Changes to discard" >/dev/null 2>&1

    # Discard trial
    discard_trial "main" "$branch_name" >/dev/null 2>&1

    # Verify we're back on main
    local current
    current=$(git branch --show-current)
    if [[ "$current" == "main" ]]; then
        pass "Returned to main branch after discard"
    else
        fail "Expected to be on 'main', but on '$current'"
    fi

    # Verify original state is unchanged
    local current_hash
    current_hash=$(git rev-parse HEAD)
    if [[ "$current_hash" == "$original_hash" ]]; then
        pass "Main branch unchanged after discard (hash matches)"
    else
        fail "Main branch changed! Expected $original_hash, got $current_hash"
    fi

    # Verify discarded file does NOT exist on main
    if [ ! -f "discard-file.txt" ]; then
        pass "Discarded changes not present on main"
    else
        fail "Discarded file still exists on main"
    fi

    # Verify trial branch was force-deleted
    if git branch --list "$branch_name" | grep -q "$branch_name"; then
        fail "Trial branch still exists after discard"
    else
        pass "Trial branch force-deleted after discard"
    fi
}

# ------------------------------------------------------------------------------
# TB-4: Concurrent trials (2 trial branches at once)
# ------------------------------------------------------------------------------
test_tb4_concurrent_trials() {
    echo ""
    echo "TB-4: Concurrent trials"

    local repo_dir
    repo_dir=$(setup_test_repo "tb4")
    cd "$repo_dir"

    source_trial_lib

    # Create first trial branch
    local branch1
    branch1=$(create_trial_branch "skill-one")
    echo "change from skill-one" > file1.txt
    git add file1.txt
    git commit -m "[TRIAL] Skill one change" >/dev/null 2>&1

    # Go back to main to create second trial
    git checkout main >/dev/null 2>&1

    # Create second trial branch
    sleep 1  # Ensure different timestamp
    local branch2
    branch2=$(create_trial_branch "skill-two")
    echo "change from skill-two" > file2.txt
    git add file2.txt
    git commit -m "[TRIAL] Skill two change" >/dev/null 2>&1

    # Verify both branches exist
    local branches
    branches=$(git branch --list "skill-forge-trial*")

    local branch1_exists=false
    local branch2_exists=false

    if echo "$branches" | grep -q "$branch1"; then
        branch1_exists=true
    fi
    if echo "$branches" | grep -q "$branch2"; then
        branch2_exists=true
    fi

    if [[ "$branch1_exists" == true && "$branch2_exists" == true ]]; then
        pass "Both trial branches coexist: $branch1 and $branch2"
    else
        fail "Missing trial branches (b1=$branch1_exists, b2=$branch2_exists)"
    fi

    # Merge first trial
    merge_trial_success "main" "$branch1" >/dev/null 2>&1

    # Verify first trial's changes on main
    if [ -f "file1.txt" ]; then
        pass "First trial merged successfully"
    else
        fail "First trial changes not found on main"
    fi

    # Discard second trial
    discard_trial "main" "$branch2" >/dev/null 2>&1

    # Verify second trial's changes NOT on main
    if [ ! -f "file2.txt" ]; then
        pass "Second trial discarded successfully"
    else
        fail "Second trial changes leaked to main"
    fi
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║           Trial Branch E2E Test Suite                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"

    trap cleanup EXIT

    test_tb1_create_trial
    test_tb2_create_and_merge
    test_tb3_create_and_discard
    test_tb4_concurrent_trials

    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "Results: $PASSED passed, $FAILED failed"
    echo "════════════════════════════════════════════════════════════════"

    if [ "$FAILED" -gt 0 ]; then
        exit 1
    fi
}

main "$@"
