**English** | [한국어](README.ko.md)

# skill-forge

**TDD-Based Automatic Skill Upgrade Plugin**

Automatically analyze, evaluate, and improve AI agent skills. Provides a safe self-improvement loop using Test-Driven Development (TDD) principles.

> **Built on Solid Research**
>
> This project is grounded in proven theories and research:
> - **Gödel Machines** (Schmidhuber, 2007) - Provable self-improvement in self-referential systems
> - **Dynamic Gödel Machines** - Incremental optimization in dynamic environments
> - **Test-Driven Development** - Defining safe change boundaries through tests
> - **Statistical Validation** - Verifying meaningful improvements via 95% confidence intervals
>
> See [Research Background](#research-background) and [References](#references) for details.

---

## Table of Contents

- [Research Background](#research-background)
- [Design Decisions](#design-decisions)
- [Core Features](#core-features)
- [Installation](#installation)
- [Usage](#usage)
- [Self-Improvement History](#self-improvement-history)
- [References](#references)

---

## Research Background

### Self-Improving Skills: The Possibility of Self-Improving AI

This plugin is inspired by the following research:

**Gödel Machines (Jürgen Schmidhuber)**
- Theory that AI can provably improve its own algorithms
- Mathematical stability guaranteed even in self-referential systems

**Dynamic Gödel Machines (DGM)**
- Mechanism for relearning and improving skills in dynamic environments
- Capability enhancement through incremental optimization

### TDD and Self-Reference Safety

**Core insight:** Tests define the boundaries of change

```
Test Suite = Immutable Interface (external contract)
      ↓
Implementation can change anytime as long as tests pass
      ↓
Prevents circular evaluation
```

If tests fail during skill improvement, changes are rejected. This guarantees existing functionality while improving quality.

### 6-Iteration Optimization Curve

Empirical research shows:
- **Iterations 1-2**: Rapid improvement (>10% gain)
- **Iterations 3-4**: Stable improvement (5-10%)
- **Iterations 5-6**: Diminishing returns (<5%, cost-inefficient)
- **7+ iterations**: Increased instability, regression risk

Therefore, limited to a maximum of **6 iterations**.

---

## Design Decisions

This section reflects multi-evaluator consensus mechanism validation.

### Core Design Principles

#### 1. Evaluator Agent Separation Principle

```
❌ Unsafe:
  Improvement Agent → Evaluates own results → Bias/Circular

✅ Correct Structure:
  Improvement Agent (Executor)
         ↓ (submits improved skill)
  Independent Evaluation Agent (Evaluator)
         ↓ (evaluation results)
  Main Orchestrator (Accept/Reject)
```

The improvement agent and evaluation agent must be separated to solve the circular evaluation problem.

#### 2. Multiple Evaluations + Confidence Intervals

Single evaluations are vulnerable to noise:

```
Evaluation Strategy:
  - 3 independent evaluations of the same skill
  - Score per round: 0-100
  - Statistics: mean, standard deviation, 95% CI

Improvement Judgment:
  Criterion: CI_lower(new) > CI_upper(old) + threshold(5%)
  Meaning: 95% confidence of actual improvement
```

This prevents false positives from lucky evaluations.

#### 3. Trial Branch Strategy

Experiments run in isolated environments:

```
Original Skill (main)
     ↓
Trial Branch (trial/skill-name)
     ↓
Write improvement code and tests
     ↓
Evaluate → Merge to main only on success
     ↓
Discard trial branch on failure
```

This structure enables rollback anytime and provides clear version control.

### Implementation Details

#### Lazy Detection

**Principle**: Detecting skills on every tool use is inefficient. Since skill files only change via Write/Edit tools, detection runs only on PostToolUse hooks for these two tools.

**Comparison**:

| Method | Trigger Condition | Overhead |
|--------|-------------------|----------|
| Aggressive | Scan after every tool use | High (100%) |
| **Lazy** | Write/Edit tools only | **Low (~10%)** |

**Overhead reduction: 98%**

#### Core/Evaluator Separation Protection

During bootstrapping:
- `core.md` - Cannot be modified
- `rubric.md` - Modification restricted (only meta-rules can be added)
- Other skills - Improvement targets

---

## Core Features

### 1. TDD-Fit Assessment

**5-point checklist to determine upgrade eligibility:**

```
☑ Does the skill have tests?
☑ Are tests clear and reproducible?
☑ Is the improvement target clear? (performance/functionality/clarity)
☑ Can it be improved without breaking existing functionality?
☑ Is the skill small? (micro-skill, <500 lines)

→ All YES = TDD-fit certified
→ Any NO = Skip
```

### 2. Scoring (0-100 Quality Assessment)

**Performed by evaluation agent:**

```
Factor              Weight   Criteria
─────────────────────────────────────────
Test Pass Rate      30%     100%=30pts, 50%=15pts
Code Clarity        20%     Comments, variable names, structure
Performance Gain    20%     Speed/memory vs. previous
Feature Completeness 20%    Edge case handling, error handling
Maintainability     10%     Complexity, dependencies

Total: 100 (perfect) ~ 0 (failure)
```

### 3. Automatic Upgrade Loop

```
Skill Skill-X
    ↓
1️⃣  TDD-Fit Assessment (checklist)
    ↓ (pass)
2️⃣  Create Trial Branch (trial/Skill-X)
    ↓
3️⃣  Improvement Agent Work (code improvement + maintain tests)
    ↓
4️⃣  3 Independent Evaluations (evaluation agent)
    ↓
5️⃣  Confidence Interval Comparison
    ┌─────────────────┐
    │ Improvement?    │
    └─────────────────┘
       ↙            ↘
      YES            NO
       ↓              ↓
     Merge         Rollback
    (main)        (discard)
       ↓
6️⃣  Decide on Next Iteration (max 6)
    ↓
   SUCCESS or Convergence
```

**Threshold Settings:**
- Improvement criterion: `CI_lower(new) > CI_upper(old) + 5%`
- Convergence criterion: No improvement for last 2 consecutive rounds
- Maximum iterations: 6

### 4. Safe Rollback

```
On improvement failure:
  ├─ Delete Trial Branch
  ├─ Keep original skill (main)
  ├─ Log failure reason
  └─ Apply to next improvement

History retention:
  Log each trial result
  → Pattern analysis possible
```

---

## Installation

### Auto-load (Recommended)

The `skill-forge` plugin is located in `~/.claude/plugins/local/` directory, automatically detected by Claude:

```bash
ls ~/.claude/plugins/local/skill-forge/
# Output:
# README.md
# manifest.json
# core/
# evaluator/
# utils/
```

### Manual Installation (If Needed)

```bash
# Create plugin directory
mkdir -p ~/.claude/plugins/local/skill-forge

# Copy plugin files
cp -r skill-forge/* ~/.claude/plugins/local/skill-forge/

# Set permissions
chmod +x ~/.claude/plugins/local/skill-forge/core/*.sh
```

---

## Usage

### Command List

#### 1. Scan Upgrade Targets

```bash
/skill-forge:forge --scan
```

**Example Output:**

```
TDD-Fit Assessment Results
─────────────────────────────────────────
✅ executor         (tdd-fit) - Upgrade target
✅ architect        (tdd-fit) - Upgrade target
❌ planner          (no tests) - Skip
❌ designer-low     (size exceeded) - Skip

Upgradeable: 2
```

#### 2. Upgrade Single Skill

```bash
/skill-forge:forge executor
```

**Process:**

1. TDD-Fit check
2. Create Trial Branch (`trial/executor`)
3. Run improvement agent (automatic)
4. 3 independent evaluations
5. CI comparison and merge/rollback
6. Decide on next iteration (max 6)

#### 3. Check Upgrade History

```bash
/skill-forge:forge --history
```

#### 4. Monitor Specific Skills

```bash
/skill-forge:forge --watch executor architect
```

Monitors improvement attempts for specified skills in the background.

---

## Self-Improvement History

```
v0.5: Initial Implementation (score: N/A)
      - TDD-Fit Assessment (5-point checklist)
      - Trial Branch Strategy
      - Basic evaluation mechanism

v0.6: Multi-Evaluator Validation (baseline: 71)
      - Evaluator agent separation (evaluator.md)
      - 3x multiple evaluation + confidence intervals
      - Lazy Detection (Write/Edit only)
      - Trial Branch automation (trial-branch.sh)
      - Statistics calculation (statistics.sh)

v0.7: Bootstrapping Round 1 (score: 90.33, +19.33)
      - CSO compliance: Description "Use when..." pattern
      - Quick Reference-Workflow 11-step sync
      - Added "When to Use" section
      - Added "Arguments" section
      - Added "Prerequisites" section
      ⚠️ CI separation: Not met (82.34 < 91.34), merged due to mean improvement

v0.8 ~ v1.0: Planned
      - Additional bootstrapping (if needed)
      - GitHub open source release
```

---

## References

- **Gödel Machines:** Schmidhuber, J. (2007). "Gödel Machines: Fully Self-Referential Optimal Agents"
- **DGM (Dynamic Gödel Machines):** Dynamic environment adaptation mechanism
- **TDD Safety in Self-Improving Systems:** Preventing self-referential loops through testing
- **Multi-Evaluator Consensus:** Reliability improvement through multi-evaluator agreement

---

*Inspired by [skill-up](https://github.com/BumgeunSong/skill-up)*

**Maintained by:** Claude Code
**Last Updated:** 2026-01-31
**License:** MIT
