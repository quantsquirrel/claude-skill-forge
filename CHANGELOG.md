# Changelog

All notable changes to skill-forge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [0.7] - 2026-01-29

### Improved
- **forge skill**: CSO compliance, Arguments handling, Prerequisites
- Score improved from 71 → 90.33 (+19.33 points, +27%)

### Validated
- 95% confidence interval verification passed
- Trial branch strategy: `skill-forge-trial-forge-20260129002729`

## [0.6] - 2026-01-28

### Added
- Evaluator agent separation principle
- Confidence interval (CI) validation
- Statistical verification (3x independent evaluations)

### Score
- Baseline: 71 points

## [0.5] - 2026-01-27

### Initial Release
- TDD-Fit assessment system
- Trial Branch strategy
- Quality scoring (0-100)
- Automatic upgrade loop (max 6 iterations)
- Safe rollback mechanism

---

## Improvement Methodology

Each version improvement follows the skill-forge protocol:

1. **TDD-Fit Check** - Verify skill has tests and is improvable
2. **Trial Branch** - Create isolated experiment branch
3. **Improve** - Apply enhancements
4. **Evaluate (x3)** - Three independent evaluations
5. **CI Comparison** - Verify statistical significance
6. **Merge or Discard** - Accept only proven improvements
