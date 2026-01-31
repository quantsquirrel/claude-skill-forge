**English** | [한국어](README.ko.md)

<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=38BDF8&center=true&vCenter=true&width=500&lines=skill-forge">
  <img alt="skill-forge" src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=0D1117&center=true&vCenter=true&width=500&lines=skill-forge">
</picture>

### ⟨ The TDD Evolution Engine ⟩

[![Version](https://img.shields.io/badge/v0.8-A3E635?style=flat-square&logoColor=0D1117)](https://github.com/quantsquirrel/claude-skill-forge)
[![Tests](https://img.shields.io/badge/tests-passing-38BDF8?style=flat-square)](https://github.com/quantsquirrel/claude-skill-forge)
[![License](https://img.shields.io/badge/MIT-E2E8F0?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=flat-square&color=38BDF8)](https://github.com/quantsquirrel/claude-skill-forge)

**TDD-powered automatic skill evolution for Claude Code**

</div>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💎 The Flow

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8',
  'secondaryColor': '#0D1117',
  'tertiaryColor': '#0D1117'
}}}%%
graph LR
    A["🔴 TEST"] -->|analyze| B["🔍 SCAN"]
    B -->|evolve| C["⚡ EVOLVE"]
    C -->|verify| D["💎 CRYSTAL"]

    style A fill:#0D1117,stroke:#FB7185,stroke-width:2px,color:#FB7185
    style B fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style C fill:#1E293B,stroke:#A3E635,stroke-width:2px,color:#A3E635
    style D fill:#38BDF8,stroke:#38BDF8,color:#0D1117
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ⚡ Quick Start

```bash
# Install
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# Run
/skill-forge:forge --scan
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💎 Features

| 💎 Crystal Clear | ⚡ Auto Evolution |
|:---:|:---:|
| Every change verified by tests | 3x evaluation + 95% CI auto-merge |

| 🔄 Safe Rollback | 📊 Statistics |
|:---:|:---:|
| Original preserved on failure | Real-time score tracking |

### 🔀 Hybrid Upgrade Mode (v0.8)

Skills can now be upgraded through two paths:

| Mode | Condition | Method |
|------|-----------|--------|
| **TDD Mode** | Test files exist | Statistical validation (95% CI) |
| **Heuristic Mode** | No tests | Usage patterns + structure analysis |

```bash
# Check upgrade mode
source hooks/lib/storage-local.sh
get_upgrade_mode "my-skill"  # Returns: TDD_FIT or HEURISTIC
```

### 📊 Skill Monitor (v0.8)

Track skill usage and get upgrade recommendations:

```
/monitor
```

Output:
```
╔══════════════════════════════════════════════════════════════╗
║                    Skill Forge Monitor                        ║
╠══════════════════════════════════════════════════════════════╣
║ Skill                │ Usage │ Trend   │ Mode       │ Pri    ║
╠══════════════════════╪═══════╪═════════╪════════════╪════════╣
║ skill-forge:forge    │    45 │ ▲ +20%  │ TDD_FIT    │ MED    ║
╚══════════════════════════════════════════════════════════════╝
```

### 🎖️ Enhanced Grades (v0.8)

New grade modifiers and SSS tier:

| Modifier | Bonus | Condition |
|----------|-------|-----------|
| Upgraded | +1 | `upgraded: true` |
| Efficient | +0.5 | tokens/usage < 1500 |
| Trending | +0.5 | positive trend |
| Tested | +0.5 | has test files |

**S + Upgraded + Efficient = SSS** ★★★

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔍 TDD-Fit Assessment

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8',
  'secondaryColor': '#0D1117',
  'tertiaryColor': '#0D1117'
}}}%%
flowchart TB
    subgraph CHECK["🔍 TDD-Fit Checklist"]
        direction TB
        Q1["☑️ Has tests?"]
        Q2["☑️ Reproducible?"]
        Q3["☑️ Clear target?"]
        Q4["☑️ Won't break?"]
        Q5["☑️ Small enough?"]
    end

    CHECK --> RESULT{Pass?}
    RESULT -->|"✅"| READY["💎 Ready"]
    RESULT -->|"❌"| SKIP["⏭️ Skip"]

    style Q1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q2 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q4 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q5 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style READY fill:#A3E635,stroke:#A3E635,color:#0D1117
    style SKIP fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ⚡ Trial Branch Strategy

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8',
  'secondaryColor': '#0D1117',
  'tertiaryColor': '#0D1117'
}}}%%
flowchart TB
    subgraph MAIN["main"]
        direction LR
        C1["v0.6<br/>71pts"]
        C2["v0.7<br/>90pts"]
        C1 -.-> C2
    end

    subgraph TRIAL["trial/skill-name"]
        direction LR
        T1["Improve"]
        T2["Evaluate<br/>×3"]
        T3{"CI?"}
        T1 --> T2 --> T3
    end

    C1 -->|branch| T1
    T3 -->|"✅"| C2
    T3 -->|"❌"| D["Discard"]

    style C1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style C2 fill:#A3E635,stroke:#A3E635,color:#0D1117
    style T1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style T2 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style T3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style D fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📊 Statistical Validation

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8',
  'secondaryColor': '#0D1117',
  'tertiaryColor': '#0D1117'
}}}%%
flowchart LR
    subgraph EVAL["📊 Triple Evaluation"]
        direction TB
        E1["Agent 1: 78"]
        E2["Agent 2: 81"]
        E3["Agent 3: 79"]
    end

    subgraph STATS["📈 Statistics"]
        direction TB
        S1["Mean: 79.3"]
        S2["95% CI"]
    end

    subgraph DECISION["⚖️"]
        D1{"CI_new ><br/>CI_old?"}
        D1 -->|YES| MERGE["✅"]
        D1 -->|NO| REJECT["❌"]
    end

    EVAL --> STATS --> DECISION

    style E1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style E2 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style E3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style MERGE fill:#A3E635,stroke:#A3E635,color:#0D1117
    style REJECT fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📊 Results

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#38BDF8', 'secondaryColor': '#A3E635'}}}%%
xychart-beta
    title "Bootstrapping Results"
    x-axis ["Before", "After"]
    y-axis "Score" 0 --> 100
    bar [71, 90.33]
```

**+27% improvement** — skill-forge evolved itself

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🛡️ Safety

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8',
  'secondaryColor': '#0D1117',
  'tertiaryColor': '#0D1117'
}}}%%
flowchart LR
    subgraph SAFETY["🛡️ Safety Pillars"]
        direction LR
        P1["🔄<br/>Rollback"]
        P2["🔒<br/>Preserved"]
        P3["📝<br/>Logged"]
        P4["⏱️<br/>Max 6"]
    end

    style P1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style P2 fill:#1E293B,stroke:#A3E635,stroke-width:2px,color:#A3E635
    style P3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style P4 fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🚀 Commands

| Command | Description |
|---------|-------------|
| `/skill-forge:forge --scan` | 🔍 Scan for upgradeable skills |
| `/skill-forge:forge <skill>` | ⚡ Forge a specific skill |
| `/skill-forge:forge --history` | 📜 View forging history |
| `/skill-forge:forge --watch` | 👁️ Monitor skills |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📈 History

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'git0': '#38BDF8',
  'git1': '#A3E635',
  'git2': '#FB7185',
  'gitBranchLabel0': '#0D1117',
  'gitBranchLabel1': '#0D1117',
  'gitBranchLabel2': '#0D1117',
  'commitLabelColor': '#E2E8F0',
  'commitLabelBackground': '#1E293B',
  'tagLabelColor': '#0D1117',
  'tagLabelBackground': '#A3E635'
}, 'gitGraph': {'showCommitLabel': true}}}%%
gitGraph
    commit id: "v0.5" tag: "Initial"
    commit id: "TDD-Fit"
    commit id: "Trial Branch"
    branch forge-v0.6
    commit id: "+Evaluator"
    commit id: "+CI"
    checkout main
    merge forge-v0.6 id: "v0.6" tag: "71"
    branch forge-v0.7
    commit id: "+CSO"
    commit id: "+Args"
    checkout main
    merge forge-v0.7 id: "v0.7" tag: "90.33"
    commit id: "v0.8+" type: HIGHLIGHT
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📚 Theory

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8'
}}}%%
mindmap
  root((📚))
    Gödel Machines
      Schmidhuber 2007
      Self-referential
    Dynamic Gödel
      Adaptation
      Incremental
    TDD Safety
      Loop prevention
      Boundaries
    Multi-Evaluator
      Consensus
      Bias prevention
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<div align="center">

**Inspired by** [skill-up](https://github.com/BumgeunSong/skill-up)

**Claude Code** · **MIT License**

</div>
