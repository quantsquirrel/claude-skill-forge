#!/usr/bin/env bash
# Trial Branch Management
# Purpose: Prevent history pollution from git revert by using disposable trial branches
# Strategy: Create temporary branches for skill improvements, merge on success, discard on failure

set -euo pipefail

TRIAL_PREFIX="skill-forge-trial"

# Create a new trial branch
# Usage: create_trial_branch "skill-name"
# Returns: Branch name (skill-forge-trial-{skill-name}-{timestamp})
create_trial_branch() {
  local skill_name="$1"

  if [[ -z "$skill_name" ]]; then
    echo "Error: Skill name required" >&2
    return 1
  fi

  # Generate timestamped branch name
  local branch_name; branch_name="${TRIAL_PREFIX}-${skill_name}-$(date +%Y%m%d%H%M%S)"

  # Create and checkout new branch
  git checkout -b "$branch_name"

  echo "$branch_name"
}

# Commit changes in trial branch
# Usage: commit_trial "commit message"
commit_trial() {
  local message="$1"

  if [[ -z "$message" ]]; then
    echo "Error: Commit message required" >&2
    return 1
  fi

  # Verify we're on a trial branch
  local current_branch
  current_branch=$(git branch --show-current)

  if [[ ! "$current_branch" =~ ^${TRIAL_PREFIX} ]]; then
    echo "Warning: Not on a trial branch (current: $current_branch)" >&2
  fi

  # Stage and commit all changes
  git add -A
  git commit -m "[TRIAL] $message"
}

# Merge successful trial into original branch
# Usage: merge_trial_success "original-branch" "trial-branch"
merge_trial_success() {
  local original_branch="$1"
  local trial_branch="$2"

  if [[ -z "$original_branch" || -z "$trial_branch" ]]; then
    echo "Error: Both original and trial branch names required" >&2
    return 1
  fi

  # Verify trial branch exists
  if ! git rev-parse --verify "$trial_branch" &>/dev/null; then
    echo "Error: Trial branch '$trial_branch' does not exist" >&2
    return 1
  fi

  # Switch to original branch
  git checkout "$original_branch"

  # Merge with no-fast-forward to preserve trial history
  git merge "$trial_branch" --no-ff -m "Merge successful trial: $trial_branch"

  # Delete trial branch
  git branch -d "$trial_branch"

  echo "Successfully merged and deleted trial branch: $trial_branch"
}

# Discard failed trial branch (no history pollution)
# Usage: discard_trial "original-branch" "trial-branch"
discard_trial() {
  local original_branch="$1"
  local trial_branch="$2"

  if [[ -z "$original_branch" || -z "$trial_branch" ]]; then
    echo "Error: Both original and trial branch names required" >&2
    return 1
  fi

  # Verify trial branch exists
  if ! git rev-parse --verify "$trial_branch" &>/dev/null; then
    echo "Error: Trial branch '$trial_branch' does not exist" >&2
    return 1
  fi

  # Switch to original branch
  git checkout "$original_branch"

  # Force delete trial branch (discards all changes)
  git branch -D "$trial_branch"

  echo "Discarded trial branch: $trial_branch (no history pollution)"
}

# Get current trial branch name (if on one)
# Returns: Trial branch name or empty string
get_current_trial() {
  local current_branch
  current_branch=$(git branch --show-current)

  if [[ "$current_branch" =~ ^${TRIAL_PREFIX} ]]; then
    echo "$current_branch"
  else
    echo ""
  fi
}

# List all trial branches
# Usage: list_trials
list_trials() {
  git branch --list "${TRIAL_PREFIX}*"
}

# Clean up old trial branches (older than 24 hours)
# Usage: cleanup_old_trials
cleanup_old_trials() {
  local cutoff_timestamp
  cutoff_timestamp=$(date -v-24H +%s 2>/dev/null || date -d "24 hours ago" +%s)

  echo "Cleaning up trial branches older than 24 hours..."

  # Iterate through trial branches
  git for-each-ref --format='%(refname:short) %(committerdate:unix)' "refs/heads/${TRIAL_PREFIX}*" | \
  while read -r branch_name commit_timestamp; do
    if [[ "$commit_timestamp" -lt "$cutoff_timestamp" ]]; then
      echo "Deleting old trial branch: $branch_name ($(date -r "$commit_timestamp" '+%Y-%m-%d %H:%M:%S'))"
      git branch -D "$branch_name" 2>/dev/null || echo "  Failed to delete $branch_name"
    fi
  done

  echo "Cleanup complete"
}

# Verify we're in a git repository
_verify_git_repo() {
  if ! git rev-parse --git-dir &>/dev/null; then
    echo "Error: Not in a git repository" >&2
    return 1
  fi
}

# Run verification on script load
_verify_git_repo || true

# Export functions for use in other scripts
export -f create_trial_branch
export -f commit_trial
export -f merge_trial_success
export -f discard_trial
export -f get_current_trial
export -f list_trials
export -f cleanup_old_trials
