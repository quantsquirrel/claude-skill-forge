**English** | [한국어](README.ko.md)

<div align="center">

<img src="docs/assets/forge.jpeg" alt="Skill Forge" width="600"/>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=FFD700&center=true&vCenter=true&width=500&lines=skill-forge">
  <img alt="skill-forge" src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=FF6B00&center=true&vCenter=true&width=500&lines=skill-forge">
</picture>

### ⚔️ Forge your skills into legendary weapons

[![Version](https://img.shields.io/badge/v1.0-FFB800?style=flat-square&logoColor=1A0A00)](https://github.com/quantsquirrel/claude-skill-forge)
[![Tests](https://img.shields.io/badge/tests-passing-FF6B00?style=flat-square)](https://github.com/quantsquirrel/claude-skill-forge)
[![License](https://img.shields.io/badge/MIT-FFD700?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=flat-square&color=FF6B00)](https://github.com/quantsquirrel/claude-skill-forge)

**TDD-powered automatic skill evolution for Claude Code**

</div>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔥 The Forging Process

Every legendary weapon starts as raw material. Through heat, strikes, and tempering, ordinary metal becomes extraordinary.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#2D1810',
  'primaryTextColor': '#FFD700',
  'primaryBorderColor': '#FF6B00',
  'lineColor': '#FFB800',
  'secondaryColor': '#1A0A00',
  'tertiaryColor': '#1A0A00'
}}}%%
graph LR
    A["⚙️ RAW<br/>SKILL"] -->|"🔥 HEAT"| B["🔍 ANALYZE<br/>Structure"]
    B -->|"🔨 STRIKE"| C["⚡ EVOLVE<br/>Refine"]
    C -->|"💧 TEMPER"| D["✅ VERIFY<br/>Tests"]
    D -->|"⚔️"| E["✨ LEGENDARY"]

    style A fill:#2D1810,stroke:#A0A0A0,stroke-width:2px,color:#A0A0A0
    style B fill:#1A0A00,stroke:#FF6B00,stroke-width:3px,color:#FFB800
    style C fill:#1A0A00,stroke:#FFB800,stroke-width:3px,color:#FFD700
    style D fill:#2D1810,stroke:#FF6B00,stroke-width:2px,color:#FFD700
    style E fill:#FFD700,stroke:#FFD700,color:#1A0A00,stroke-width:4px
```

**The Forge never rests** — Each skill is heated in analysis, struck with improvements, tempered by tests, and emerges stronger.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ⚡ Quick Start

```bash
# Install the forge
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# Ignite the flames
/skill-forge:forge --scan
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💎 Features

| 🔨 Forged in Fire | ⚡ Auto Evolution | 🛡️ Safe Trials | 📊 Triple Strike |
|:---:|:---:|:---:|:---:|
| Every change tested | 3× evaluation consensus | Original preserved | 95% CI validation |

### 🔀 Dual Forging Paths (v1.0)

Skills can be forged through two methods depending on material quality:

| Path | Condition | Technique |
|------|-----------|-----------|
| **⚔️ TDD Forge** | Test files exist | Statistical validation (95% CI) |
| **🔥 Pattern Forge** | No tests | Usage patterns + heuristic analysis |

```bash
# Check forging method
source hooks/lib/storage-local.sh
get_upgrade_mode "my-skill"  # Returns: TDD_FIT or HEURISTIC
```

### 📊 Forge Monitor (v1.0)

Track your weapons and see which need reforging:

```
/monitor
```

Output:
```
╔══════════════════════════════════════════════════════════════╗
║                    🔥 Forge Monitor                           ║
╠══════════════════════════════════════════════════════════════╣
║ Weapon               │ Strikes │ Heat   │ Method     │ Grade ║
╠══════════════════════╪═════════╪════════╪════════════╪═══════╣
║ skill-forge:forge    │    45   │ ▲ +20% │ TDD_FIT    │ MED   ║
╚══════════════════════════════════════════════════════════════╝
```

### 🎖️ Legendary Grades (v1.0)

Exceptional weapons earn special marks:

| Enhancement | Bonus | Forged When |
|-------------|-------|-------------|
| Reforged | +1 | `upgraded: true` |
| Efficient | +0.5 | tokens/usage < 1500 |
| Hot Streak | +0.5 | positive trend |
| Tested | +0.5 | has test files |

**S + Reforged + Efficient = ★★★ SSS LEGENDARY**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🛡️ Trial Branch — The Safe Anvil

Master smiths never work directly on the masterpiece. They test on trial pieces first.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#2D1810',
  'primaryTextColor': '#FFD700',
  'primaryBorderColor': '#FF6B00',
  'lineColor': '#FFB800',
  'secondaryColor': '#1A0A00',
  'tertiaryColor': '#1A0A00'
}}}%%
flowchart TB
    subgraph MAIN["⚔️ main (Master Weapon)"]
        direction LR
        C1["v0.6<br/>71pts"]
        C2["v0.7<br/>90pts"]
        C1 -.-> C2
    end

    subgraph TRIAL["🔥 trial/skill-name (Testing Anvil)"]
        direction LR
        T1["🔨 Strike"]
        T2["🔨 Strike"]
        T3["🔨 Strike"]
        T4{"Worthy?"}
        T1 --> T2 --> T3 --> T4
    end

    C1 -->|"fork"| T1
    T4 -->|"✅ Stronger"| C2
    T4 -->|"❌ Brittle"| D["🗑️ Discard"]

    style C1 fill:#2D1810,stroke:#FFD700,stroke-width:2px,color:#FFD700
    style C2 fill:#FFD700,stroke:#FFD700,color:#1A0A00,stroke-width:3px
    style T1 fill:#1A0A00,stroke:#FF6B00,stroke-width:2px,color:#FFB800
    style T2 fill:#1A0A00,stroke:#FF6B00,stroke-width:2px,color:#FFB800
    style T3 fill:#1A0A00,stroke:#FF6B00,stroke-width:2px,color:#FFB800
    style T4 fill:#2D1810,stroke:#FF6B00,stroke-width:2px,color:#FFD700
    style D fill:#1A0A00,stroke:#A0A0A0,stroke-width:1px,color:#A0A0A0
```

**Safety First** — The master weapon (`main`) is never touched until the trial proves worthy. Failed experiments are discarded, not merged.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔨 Triple Strike — The Smith's Consensus

A single hammer blow can deceive. Three strikes reveal the truth.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#2D1810',
  'primaryTextColor': '#FFD700',
  'primaryBorderColor': '#FF6B00',
  'lineColor': '#FFB800',
  'secondaryColor': '#1A0A00',
  'tertiaryColor': '#1A0A00'
}}}%%
flowchart LR
    subgraph STRIKE["🔨 Triple Strike Evaluation"]
        direction TB
        S1["🔨 Smith 1<br/>Score: 78"]
        S2["🔨 Smith 2<br/>Score: 81"]
        S3["🔨 Smith 3<br/>Score: 79"]
    end

    subgraph MEASURE["⚖️ Measure Quality"]
        direction TB
        M1["Mean: 79.3"]
        M2["95% Confidence"]
    end

    subgraph VERDICT["⚔️ Final Verdict"]
        V1{"Stronger than<br/>before?"}
        V1 -->|"YES"| ACCEPT["✅ REFORGE"]
        V1 -->|"NO"| REJECT["❌ DISCARD"]
    end

    STRIKE --> MEASURE --> VERDICT

    style S1 fill:#1A0A00,stroke:#FFB800,stroke-width:2px,color:#FFD700
    style S2 fill:#1A0A00,stroke:#FFB800,stroke-width:2px,color:#FFD700
    style S3 fill:#1A0A00,stroke:#FFB800,stroke-width:2px,color:#FFD700
    style M1 fill:#2D1810,stroke:#FF6B00,stroke-width:2px,color:#FFD700
    style M2 fill:#2D1810,stroke:#FF6B00,stroke-width:2px,color:#FFD700
    style ACCEPT fill:#FFD700,stroke:#FFD700,color:#1A0A00,stroke-width:3px
    style REJECT fill:#1A0A00,stroke:#A0A0A0,stroke-width:1px,color:#A0A0A0
```

**Statistical Consensus** — Three independent evaluations. Statistical confidence intervals. Only merge if the new version is provably superior.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📊 Forging Results

**Before:** 71 points — Raw, unrefined
**After:** 90.33 points — Tempered, legendary

**+27% improvement** — skill-forge reforged itself

The ultimate test: A tool that improves itself through its own process.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔒 Safety Mechanisms

Master smiths build in multiple safeguards:

| Safeguard | Protection |
|-----------|------------|
| 🔄 **Rollback Ready** | Original always preserved |
| 🔒 **Isolated Trials** | Test in separate branch |
| 📝 **Full Logs** | Every strike recorded |
| ⏱️ **Iteration Limit** | Maximum 6 attempts |
| ✅ **Test Verification** | All tests must pass |

No weapon leaves the forge untested. No master version is ever corrupted.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🚀 Commands

| Command | Action |
|---------|--------|
| `/skill-forge:forge --scan` | 🔍 Scout for skills ready to reforge |
| `/skill-forge:forge <skill>` | ⚡ Reforge a specific skill |
| `/skill-forge:forge --history` | 📜 View forging chronicles |
| `/skill-forge:forge --watch` | 👁️ Monitor the forge |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📚 The Theory Behind the Forge

**Gödel Machines** (Schmidhuber 2007) — Self-referential systems that can improve their own code
**Dynamic Adaptation** — Incremental evolution with statistical validation
**TDD Safety Boundaries** — Tests prevent catastrophic self-modification
**Multi-Evaluator Consensus** — Multiple independent judges reduce bias

[Read the full theory →](docs/THEORY.md)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<div align="center">

**Inspired by** [skill-up](https://github.com/BumgeunSong/skill-up)

⚒️ **Forged with Claude Code** · 🔥 **MIT License** · ⚔️ **v1.0**

</div>
