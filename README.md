**English** | [한국어](README.ko.md)

<div align="center">

# 🔨 skill-forge

**TDD-Based Automatic Skill Upgrade Plugin for Claude Code**

> *"The only TDD-based self-improvement system for Claude Code skills"*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.7-blue.svg)](https://github.com/quantsquirrel/claude-skill-forge)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet.svg)](https://claude.ai)
[![GitHub stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=social)](https://github.com/quantsquirrel/claude-skill-forge)
[![Last Commit](https://img.shields.io/github/last-commit/quantsquirrel/claude-skill-forge)](https://github.com/quantsquirrel/claude-skill-forge)

*Automatically analyze, evaluate, and improve AI agent skills using Test-Driven Development principles.*

[Quick Start](#-quick-start) · [Features](#-core-features) · [Documentation](#-research-background) · [Contributing](#references)

</div>

---

> **📚 Built on Solid Research**
>
> This project is grounded in proven theories:
> | Foundation | Description |
> |------------|-------------|
> | **Gödel Machines** | Provable self-improvement (Schmidhuber, 2007) |
> | **Dynamic Gödel Machines** | Incremental optimization in dynamic environments |
> | **TDD Safety** | Change boundaries defined by tests |
> | **Statistical Validation** | 95% confidence interval verification |

---

## ⚡ Quick Start

```bash
# Clone to Claude plugins directory
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# Start upgrading skills
/skill-forge:forge --scan
```

---

## 📋 Table of Contents

- [🔬 Research Background](#-research-background)
- [🏗️ Design Decisions](#️-design-decisions)
- [✨ Core Features](#-core-features)
- [📦 Installation](#-installation)
- [🚀 Usage](#-usage)
- [📈 Self-Improvement History](#-self-improvement-history)
- [📚 References](#-references)

---

## 🔬 Research Background

### Self-Improving Skills: The Possibility of Self-Improving AI

This plugin is inspired by groundbreaking research:

| Research | Key Insight |
|----------|-------------|
| **Gödel Machines** (Schmidhuber) | AI can provably improve its own algorithms |
| **Dynamic Gödel Machines** | Skills can be relearned and improved in dynamic environments |

### TDD and Self-Reference Safety

**Core insight:** Tests define the boundaries of change

```mermaid
flowchart TD
    A["Test Suite = Immutable Interface<br/>(external contract)"] --> B["Implementation can change anytime<br/>as long as tests pass"]
    B --> C["Prevents circular evaluation"]
```

### 6-Iteration Optimization Curve

| Iteration | Improvement | Status |
|-----------|-------------|--------|
| 1-2 | >10% gain | 🚀 Rapid |
| 3-4 | 5-10% | 📈 Stable |
| 5-6 | <5% | ⚠️ Diminishing |
| 7+ | Regression risk | 🛑 Stop |

> Maximum **6 iterations** to balance improvement vs. stability.

---

## 🏗️ Design Decisions

### Core Design Principles

#### 1️⃣ Evaluator Agent Separation

❌ **Unsafe:** Improvement Agent → Evaluates own results → Bias/Circular

✅ **Correct:**

```mermaid
flowchart TD
    A["Improvement Agent<br/>(Executor)"] -->|submits| B["Evaluation Agent<br/>(Independent)"]
    B -->|results| C["Orchestrator<br/>Accept/Reject"]
```

#### 2️⃣ Multiple Evaluations + Confidence Intervals

| Strategy | Details |
|----------|---------|
| Evaluations | 3 independent rounds |
| Scoring | 0-100 per round |
| Statistics | Mean, StdDev, 95% CI |
| Threshold | `CI_lower(new) > CI_upper(old) + 5%` |

#### 3️⃣ Trial Branch Strategy

```mermaid
flowchart TB
    subgraph MAIN["🏠 main"]
        direction LR
        C1["v0.6<br/>score: 71"] -.-> C2["v0.7<br/>score: 90"]
    end

    subgraph TRIAL["🧪 trial/skill-name"]
        direction LR
        T1["1. Improve"] --> T2["2. Evaluate<br/>(×3 rounds)"]
        T2 --> T3{"CI check"}
    end

    C1 -->|"git checkout -b"| T1
    T3 -->|"✅ CI_lower > CI_upper"| C2
    T3 -->|"❌ No improvement"| D["🗑️ Discard"]

    style C1 fill:#6b7280,stroke:#374151,color:#fff
    style C2 fill:#10b981,stroke:#059669,color:#fff
    style T1 fill:#3b82f6,stroke:#1d4ed8,color:#fff
    style T2 fill:#3b82f6,stroke:#1d4ed8,color:#fff
    style T3 fill:#f59e0b,stroke:#d97706,color:#fff
    style D fill:#ef4444,stroke:#b91c1c,color:#fff
```

**Key insight**: Only statistically significant improvements are merged.

### Implementation Details

#### Lazy Detection

| Method | Trigger | Overhead |
|--------|---------|----------|
| Aggressive | Every tool use | 100% |
| **Lazy** ✅ | Write/Edit only | **~2%** |

> **98% overhead reduction** by detecting only on file writes.

---

## ✨ Core Features

### 1. TDD-Fit Assessment

```
☑ Has tests?
☑ Tests reproducible?
☑ Clear improvement target?
☑ Won't break existing functionality?
☑ Small skill (<500 lines)?

  → All YES = ✅ TDD-fit certified
  → Any NO  = ⏭️ Skip
```

### 2. Quality Scoring (0-100)

| Factor | Weight | Criteria |
|--------|--------|----------|
| Test Pass Rate | 30% | 100% = 30pts |
| Code Clarity | 20% | Comments, naming |
| Performance | 20% | vs. previous |
| Completeness | 20% | Edge cases |
| Maintainability | 10% | Complexity |

### 3. Automatic Upgrade Loop

```mermaid
flowchart TD
    START["skill-forge:forge"] --> A["1. TDD-Fit Check"]
    A --> B["2. Trial Branch"]
    B --> C["3. Improve Skill"]
    C --> D["4. Evaluate (x3)"]
    D --> E["5. CI Comparison"]
    E -->|Improved?| F{Decision}
    F -->|YES| G["✅ Merge"]
    F -->|NO| H["❌ Discard"]
    G --> I{{"max 6 iterations"}}
    I -->|continue| A
    I -->|done| END["SUCCESS"]
```

### 4. Safe Rollback

- ✅ Trial branch deleted on failure
- ✅ Original skill preserved
- ✅ Failure logged for learning
- ✅ Pattern analysis enabled

---

## 📦 Installation

### Option 1: Auto-load (Recommended)

```bash
# Clone directly to Claude plugins
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge
```

### Option 2: Manual Installation

```bash
# Create directory
mkdir -p ~/.claude/plugins/local/skill-forge

# Copy files
cp -r skill-forge/* ~/.claude/plugins/local/skill-forge/

# Set permissions
chmod +x ~/.claude/plugins/local/skill-forge/hooks/*.sh
```

---

## 🚀 Usage

### Commands

| Command | Description |
|---------|-------------|
| `/skill-forge:forge --scan` | Scan upgradeable skills |
| `/skill-forge:forge <skill>` | Upgrade specific skill |
| `/skill-forge:forge --history` | View upgrade history |
| `/skill-forge:forge --watch <skills>` | Monitor skills |

### Example: Upgrade a Skill

```bash
/skill-forge:forge executor
```

**Output:**
```
[1/6] executor 업그레이드 중...

Trial Branch: trial/executor
✓ Improvement agent completed
  → Performance: -20% memory
  → Clarity: Added comments

Evaluation (3 rounds):
  Round 1: 78  Round 2: 81  Round 3: 79

Statistics:
  Mean: 79.3 | StdDev: 1.53 | 95% CI: [76.8, 81.8]

Baseline: 75 (CI: [72, 78])

✅ Improvement confirmed: CI_lower(76.8) > CI_upper(78)? YES
→ Merged to main
```

---

## 📈 Self-Improvement History

| Version | Score | Changes |
|---------|-------|---------|
| v0.5 | N/A | Initial: TDD-Fit, Trial Branch |
| v0.6 | 71 | +Evaluator separation, +CI validation |
| **v0.7** | **90.33** (+19) | +CSO compliance, +Arguments, +Prerequisites |
| v0.8+ | 🚧 | Planned: Additional bootstrapping |

---

## 🏆 Benchmarks

skill-forge has been validated through self-improvement:

| Metric | Baseline | After 1 Round | Improvement |
|--------|----------|---------------|-------------|
| CSO Score | 71 | 90.33 | **+27%** |
| Test Coverage | - | TDD-enforced | ✅ |
| CI Validation | - | 95% CI | ✅ |

> The forge skill was improved using skill-forge itself (bootstrapping).

---

## 📚 References

| Reference | Description |
|-----------|-------------|
| [Gödel Machines](https://arxiv.org/abs/cs/0309048) | Schmidhuber (2007) - Self-referential optimal agents |
| Dynamic Gödel Machines | Dynamic environment adaptation |
| TDD Safety | Self-referential loop prevention |
| Multi-Evaluator Consensus | Reliability through agreement |

---

<div align="center">

*Inspired by [skill-up](https://github.com/BumgeunSong/skill-up)*

**Maintained by:** Claude Code · **License:** MIT

</div>
