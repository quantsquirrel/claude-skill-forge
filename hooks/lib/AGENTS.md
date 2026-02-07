<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-01-31 | Updated: 2026-02-08 -->

# lib

## Purpose

Shared shell library functions for all hooks. Provides configuration loading, storage abstraction, statistics calculation, trial branch management, and skill detection utilities.

## Key Files

| File | Description |
|------|-------------|
| `common.sh` | Main loader - sources config and storage backend, JSON parsing helpers |
| `config.sh` | Configuration loading from `../../config/settings.env` |
| `recommendation-engine.sh` | Quality-based recommendation engine for skill forge prioritization |
| `skill-detector.sh` | Lazy detection - identifies skill file changes on Write/Edit |
| `statistics.sh` | Statistical functions: mean, stddev, 95% CI, CI separation check |
| `storage-local.sh` | Local file storage backend for skill metrics |
| `storage-otel.sh` | OpenTelemetry storage backend (future use) |
| `trial-branch.sh` | Git trial branch management: create, commit, merge, discard |

## For AI Agents

### Working In This Directory

- All scripts use `#!/bin/bash` or `#!/usr/bin/env bash`
- Source `common.sh` to get all utilities
- Use `debug_log` for stderr logging (controlled by `SKILL_EVAL_DEBUG`)

### Key Functions

**statistics.sh:**
- `calc_mean score1 score2 ...` - Calculate average
- `calc_stddev mean score1 score2 ...` - Calculate standard deviation
- `calc_ci mean stddev n` - Calculate 95% confidence interval
- `ci_separated prev_upper curr_lower` - Check if CIs don't overlap

**trial-branch.sh:**
- `create_trial_branch skill-name` - Create isolated experiment branch
- `commit_trial message` - Commit changes on trial branch
- `merge_trial_success original trial` - Merge successful trial
- `discard_trial original trial` - Abandon failed trial

**skill-detector.sh:**
- Runs on Write/Edit PostToolUse
- Detects `.md` files in skill paths
- Logs to `../../data/detections/detection-log.jsonl`

### Testing Requirements

- Test scripts with sample input via stdin
- Verify math calculations with known values
- Test git operations in isolated repo

### Common Patterns

```bash
source "$(dirname "$0")/lib/common.sh"
# Now have: debug_log, extract_json, get_timestamp, storage_* functions
```

## Dependencies

### Internal

- `../../config/settings.env` - Configuration values
- `../../data/` - Storage directories

### External

- `bc` - Arbitrary precision calculator (for statistics)
- `git` - Version control (for trial branches)

<!-- MANUAL: -->
