**English** | [한국어](README.ko.md)

<div align="center">

```
                    ╔═══════════════════════════════════════╗
                    ║                                       ║
        ⚒️          ║     S K I L L   F O R G E            ║          🔥
                    ║                                       ║
                    ╚═══════════════════════════════════════╝
                                    ▲
                               ╱────┴────╲
                              ╱   ANVIL   ╲
                             ▕  ▓▓▓▓▓▓▓▓▓  ▏
                              ╲___________╱
```

### Where AI Skills Are Forged Through Fire

**TDD-Based Automatic Skill Upgrade Plugin for Claude Code**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.7-blue.svg)](https://github.com/quantsquirrel/claude-skill-forge)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet.svg)](https://claude.ai)
[![GitHub stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=social)](https://github.com/quantsquirrel/claude-skill-forge)
[![Last Commit](https://img.shields.io/github/last-commit/quantsquirrel/claude-skill-forge)](https://github.com/quantsquirrel/claude-skill-forge)

<br/>

> *"Like a master blacksmith tempering steel, skill-forge heats, hammers, and quenches*
> *your AI skills until they emerge stronger than before."*

<br/>

[⚡ Quick Start](#-ignite-the-forge) · [🔥 The Process](#-the-forging-process) · [📊 Results](#-proof-of-the-flame)

</div>

---

<table>
<tr>
<td width="50%">

### 🏛️ Built on Proven Theory

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#1e293b', 'primaryTextColor': '#f1f5f9', 'primaryBorderColor': '#475569', 'lineColor': '#ea580c'}}}%%
mindmap
  root((🔩 Foundations))
    Gödel Machines
      Provable self-improvement
      Schmidhuber 2007
    Dynamic Gödel
      Adapt to change
      Incremental optimization
    TDD Safety
      Tests as boundaries
      Prevent regressions
    Statistics
      95% CI validation
      3x evaluations
```

</td>
<td width="50%">

### 📊 Proof of the Flame

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'secondaryColor': '#0d9488'}}}%%
xychart-beta
    title "Bootstrapping Results"
    x-axis ["Before", "After"]
    y-axis "Score" 0 --> 100
    bar [71, 90.33]
```

**+27% improvement** — *skill-forge forged itself*

</td>
</tr>
</table>

---

## ⚡ Ignite the Forge

```bash
# Summon the forge to your workshop
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# Strike the first spark
/skill-forge:forge --scan
```

---

## 🔥 The Forging Process

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8', 'secondaryColor': '#1e293b', 'tertiaryColor': '#334155'}}}%%
flowchart LR
    subgraph INPUT[" "]
        A[("🔩<br/>Raw Skill")]
    end

    subgraph FORGE["⚒️ THE FORGE"]
        direction LR
        B["🔥 HEAT<br/>─────<br/>Analyze<br/>& Plan"]
        C["⚒️ HAMMER<br/>─────<br/>Improve<br/>& Test"]
        D["💧 QUENCH<br/>─────<br/>Verify<br/>& Merge"]
        B --> C --> D
    end

    subgraph OUTPUT[" "]
        E[("⚔️<br/>Forged Skill")]
    end

    A --> B
    D --> E

    style A fill:#475569,stroke:#64748b,color:#f8fafc
    style B fill:#ea580c,stroke:#c2410c,color:#fff
    style C fill:#ea580c,stroke:#c2410c,color:#fff
    style D fill:#0d9488,stroke:#0f766e,color:#fff
    style E fill:#0d9488,stroke:#0f766e,color:#fff
```

---

### 🔥 HEAT: TDD-Fit Assessment

Before any skill enters the forge, it must pass the heat test:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart TB
    subgraph CHECK["🔥 TDD-Fit Checklist"]
        direction TB
        Q1["☑️ Has tests?"]
        Q2["☑️ Tests reproducible?"]
        Q3["☑️ Clear improvement target?"]
        Q4["☑️ Won't break functionality?"]
        Q5["☑️ Small enough? (<500 lines)"]
    end

    CHECK --> RESULT{All Pass?}
    RESULT -->|"✅ YES"| READY["🔨 Ready for Forge"]
    RESULT -->|"❌ NO"| SKIP["⏭️ Skip"]

    style Q1 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q2 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q3 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q4 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q5 fill:#ea580c,stroke:#c2410c,color:#fff
    style READY fill:#0d9488,stroke:#0f766e,color:#fff
    style SKIP fill:#475569,stroke:#64748b,color:#f8fafc
```

---

### ⚒️ HAMMER: Trial Branch Strategy

The skill is hammered on a separate anvil (branch) for safety:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart TB
    subgraph MAIN["🏠 main branch"]
        direction LR
        C1["v0.6<br/>score: 71"]
        C2["v0.7<br/>score: 90"]
        C1 -.->|"time"| C2
    end

    subgraph TRIAL["🔥 trial/skill-name"]
        direction LR
        T1["1️⃣ Improve"]
        T2["2️⃣ Evaluate<br/>(×3 rounds)"]
        T3{"3️⃣ CI check"}
        T1 --> T2 --> T3
    end

    C1 -->|"git checkout -b"| T1
    T3 -->|"✅ CI_lower > CI_upper"| C2
    T3 -->|"❌ Not improved"| D["🗑️ Discard"]

    style C1 fill:#475569,stroke:#64748b,color:#f8fafc
    style C2 fill:#0d9488,stroke:#0f766e,color:#fff
    style T1 fill:#ea580c,stroke:#c2410c,color:#fff
    style T2 fill:#ea580c,stroke:#c2410c,color:#fff
    style T3 fill:#ea580c,stroke:#c2410c,color:#fff
    style D fill:#475569,stroke:#64748b,color:#f8fafc
```

---

### 💧 QUENCH: Statistical Validation

Only statistically significant improvements survive:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart LR
    subgraph EVAL["📊 Triple Evaluation"]
        direction TB
        E1["Agent 1<br/>Score: 78"]
        E2["Agent 2<br/>Score: 81"]
        E3["Agent 3<br/>Score: 79"]
    end

    subgraph STATS["📈 Statistics"]
        direction TB
        S1["Mean: 79.3"]
        S2["StdDev: 1.53"]
        S3["95% CI: [76.8, 81.8]"]
    end

    subgraph DECISION["⚖️ Decision"]
        D1{"CI_lower(new) ><br/>CI_upper(old)?"}
        D1 -->|YES| MERGE["✅ Merge"]
        D1 -->|NO| REJECT["❌ Reject"]
    end

    EVAL --> STATS --> DECISION

    style E1 fill:#475569,stroke:#64748b,color:#f8fafc
    style E2 fill:#475569,stroke:#64748b,color:#f8fafc
    style E3 fill:#475569,stroke:#64748b,color:#f8fafc
    style MERGE fill:#0d9488,stroke:#0f766e,color:#fff
    style REJECT fill:#475569,stroke:#64748b,color:#f8fafc
```

---

## ⚔️ Quality Scoring

Each skill is scored across five dimensions:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#ea580c', 'secondaryColor': '#0d9488', 'tertiaryColor': '#475569', 'primaryTextColor': '#f8fafc'}}}%%
pie showData
    title Quality Score Weights
    "Test Pass Rate" : 30
    "Code Clarity" : 20
    "Performance" : 20
    "Completeness" : 20
    "Maintainability" : 10
```

---

## 🛡️ Safety Mechanisms

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart TB
    subgraph SAFETY["🛡️ Four Pillars of Safety"]
        direction LR
        P1["🔄<br/>Safe Rollback<br/>─────<br/>Trial branch<br/>deleted on failure"]
        P2["🔒<br/>Original Preserved<br/>─────<br/>Source skill<br/>never touched"]
        P3["📝<br/>Failure Logged<br/>─────<br/>Learn from<br/>what didn't work"]
        P4["⏱️<br/>Max 6 Iterations<br/>─────<br/>Prevent over-<br/>optimization"]
    end

    style P1 fill:#475569,stroke:#64748b,color:#f8fafc
    style P2 fill:#0d9488,stroke:#0f766e,color:#fff
    style P3 fill:#ea580c,stroke:#c2410c,color:#fff
    style P4 fill:#475569,stroke:#64748b,color:#f8fafc
```

---

## 📦 Installation

<details>
<summary><b>Option 1: Auto-load (Recommended)</b></summary>

```bash
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge
```

</details>

<details>
<summary><b>Option 2: Manual Installation</b></summary>

```bash
mkdir -p ~/.claude/plugins/local/skill-forge
cp -r skill-forge/* ~/.claude/plugins/local/skill-forge/
chmod +x ~/.claude/plugins/local/skill-forge/hooks/*.sh
```

</details>

---

## 🚀 Commands

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart LR
    subgraph COMMANDS["🚀 Available Commands"]
        direction TB
        C1["/skill-forge:forge --scan<br/>🔍 Scan for upgradeable skills"]
        C2["/skill-forge:forge <skill><br/>⚒️ Forge a specific skill"]
        C3["/skill-forge:forge --history<br/>📜 View forging history"]
        C4["/skill-forge:forge --watch<br/>👁️ Monitor skills"]
    end

    style C1 fill:#475569,stroke:#64748b,color:#f8fafc
    style C2 fill:#ea580c,stroke:#c2410c,color:#fff
    style C3 fill:#475569,stroke:#64748b,color:#f8fafc
    style C4 fill:#0d9488,stroke:#0f766e,color:#fff
```

---

## 📈 Forging History

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'git0': '#475569', 'git1': '#ea580c', 'git2': '#0d9488', 'gitBranchLabel0': '#f8fafc', 'gitBranchLabel1': '#fff', 'gitBranchLabel2': '#fff', 'commitLabelColor': '#f8fafc', 'commitLabelBackground': '#475569', 'tagLabelColor': '#fff', 'tagLabelBackground': '#0d9488'}, 'gitGraph': {'showCommitLabel': true}}}%%
gitGraph
    commit id: "v0.5" tag: "Initial"
    commit id: "TDD-Fit"
    commit id: "Trial Branch"
    branch forge-v0.6
    commit id: "+Evaluator sep"
    commit id: "+CI validation"
    checkout main
    merge forge-v0.6 id: "v0.6 (71pts)" tag: "71"
    branch forge-v0.7
    commit id: "+CSO compliance"
    commit id: "+Arguments"
    commit id: "+Prerequisites"
    checkout main
    merge forge-v0.7 id: "v0.7 (90pts)" tag: "90.33"
    commit id: "v0.8+" type: HIGHLIGHT
```

---

## 📚 The Lore (References)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#1e293b', 'primaryTextColor': '#f1f5f9', 'primaryBorderColor': '#475569', 'lineColor': '#ea580c'}}}%%
mindmap
  root((📚 References))
    Gödel Machines
      Schmidhuber 2007
      Self-referential agents
      arxiv:cs/0309048
    Dynamic Gödel
      Environment adaptation
      Incremental learning
    TDD Safety
      Loop prevention
      Change boundaries
    Multi-Evaluator
      Consensus reliability
      Bias prevention
```

---

<div align="center">

```
        ╱╲
       ╱  ╲
      ╱ 🔥 ╲
     ╱      ╲
    ╱________╲
   ╱ ▓▓▓▓▓▓▓▓ ╲
  ╱____________╲
       ║║
    ═══╬╬═══
```

*"A skill forged in fire is a skill that will never tire."*

---

Inspired by [skill-up](https://github.com/BumgeunSong/skill-up)

**Maintained by:** Claude Code · **License:** MIT

</div>
