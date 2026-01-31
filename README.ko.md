[English](README.md) | **한국어**

<div align="center">

```
                    ╔═══════════════════════════════════════╗
                    ║                                       ║
        ⚒️          ║     S K I L L   F O R G E            ║          🔥
                    ║                                       ║
                    ╚═══════════════════════════════════════╝
                                    ▲
                               ╱────┴────╲
                              ╱   모루    ╲
                             ▕  ▓▓▓▓▓▓▓▓▓  ▏
                              ╲___________╱
```

### 불꽃 속에서 AI 스킬을 단조하다

**Claude Code를 위한 TDD 기반 스킬 자동 업그레이드 플러그인**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-0.7-blue.svg)](https://github.com/quantsquirrel/claude-skill-forge)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet.svg)](https://claude.ai)
[![GitHub stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=social)](https://github.com/quantsquirrel/claude-skill-forge)
[![Last Commit](https://img.shields.io/github/last-commit/quantsquirrel/claude-skill-forge)](https://github.com/quantsquirrel/claude-skill-forge)

<br/>

> *"마스터 대장장이가 강철을 담금질하듯, skill-forge는 당신의 AI 스킬을*
> *달구고, 두드리고, 식혀서 더 강하게 만듭니다."*

<br/>

[⚡ 빠른 시작](#-대장간에-불을-지피다) · [🔥 단조 과정](#-단조-과정) · [📊 결과](#-불꽃의-증거)

</div>

---

<table>
<tr>
<td width="50%">

### 🏛️ 검증된 이론 기반

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#1e293b', 'primaryTextColor': '#f1f5f9', 'primaryBorderColor': '#475569', 'lineColor': '#ea580c'}}}%%
mindmap
  root((🔩 기반 이론))
    Gödel Machines
      증명 가능한 자기 개선
      Schmidhuber 2007
    Dynamic Gödel
      변화에 적응
      점진적 최적화
    TDD 안전성
      테스트가 경계
      회귀 방지
    통계학
      95% CI 검증
      3회 평가
```

</td>
<td width="50%">

### 📊 불꽃의 증거

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'secondaryColor': '#0d9488'}}}%%
xychart-beta
    title "부트스트래핑 결과"
    x-axis ["이전", "이후"]
    y-axis "점수" 0 --> 100
    bar [71, 90.33]
```

**+27% 향상** — *skill-forge가 스스로를 단조했습니다*

</td>
</tr>
</table>

---

## ⚡ 대장간에 불을 지피다

```bash
# 대장간을 작업실로 소환
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# 첫 번째 불꽃을 일으키다
/skill-forge:forge --scan
```

---

## 🔥 단조 과정

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8', 'secondaryColor': '#1e293b', 'tertiaryColor': '#334155'}}}%%
flowchart LR
    subgraph INPUT[" "]
        A[("🔩<br/>원재료 스킬")]
    end

    subgraph FORGE["⚒️ 대장간"]
        direction LR
        B["🔥 달구기<br/>─────<br/>분석<br/>& 계획"]
        C["⚒️ 두드리기<br/>─────<br/>개선<br/>& 테스트"]
        D["💧 담금질<br/>─────<br/>검증<br/>& 병합"]
        B --> C --> D
    end

    subgraph OUTPUT[" "]
        E[("⚔️<br/>단조된 스킬")]
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

### 🔥 달구기: TDD-Fit 평가

스킬이 대장간에 들어가기 전, 열 테스트를 통과해야 합니다:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart TB
    subgraph CHECK["🔥 TDD-Fit 체크리스트"]
        direction TB
        Q1["☑️ 테스트가 있는가?"]
        Q2["☑️ 테스트가 재현 가능한가?"]
        Q3["☑️ 개선 대상이 명확한가?"]
        Q4["☑️ 기존 기능을 깨뜨리지 않는가?"]
        Q5["☑️ 크기가 작은가? (<500줄)"]
    end

    CHECK --> RESULT{모두 통과?}
    RESULT -->|"✅ YES"| READY["🔨 단조 준비 완료"]
    RESULT -->|"❌ NO"| SKIP["⏭️ 스킵"]

    style Q1 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q2 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q3 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q4 fill:#ea580c,stroke:#c2410c,color:#fff
    style Q5 fill:#ea580c,stroke:#c2410c,color:#fff
    style READY fill:#0d9488,stroke:#0f766e,color:#fff
    style SKIP fill:#475569,stroke:#64748b,color:#f8fafc
```

---

### ⚒️ 두드리기: Trial Branch 전략

스킬은 안전을 위해 별도의 모루(브랜치)에서 단조됩니다:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart TB
    subgraph MAIN["🏠 main 브랜치"]
        direction LR
        C1["v0.6<br/>점수: 71"]
        C2["v0.7<br/>점수: 90"]
        C1 -.->|"시간"| C2
    end

    subgraph TRIAL["🔥 trial/skill-name"]
        direction LR
        T1["1️⃣ 개선"]
        T2["2️⃣ 평가<br/>(×3회)"]
        T3{"3️⃣ CI 검사"}
        T1 --> T2 --> T3
    end

    C1 -->|"git checkout -b"| T1
    T3 -->|"✅ CI_lower > CI_upper"| C2
    T3 -->|"❌ 개선 없음"| D["🗑️ 폐기"]

    style C1 fill:#475569,stroke:#64748b,color:#f8fafc
    style C2 fill:#0d9488,stroke:#0f766e,color:#fff
    style T1 fill:#ea580c,stroke:#c2410c,color:#fff
    style T2 fill:#ea580c,stroke:#c2410c,color:#fff
    style T3 fill:#ea580c,stroke:#c2410c,color:#fff
    style D fill:#475569,stroke:#64748b,color:#f8fafc
```

---

### 💧 담금질: 통계적 검증

통계적으로 유의미한 개선만 살아남습니다:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart LR
    subgraph EVAL["📊 3중 평가"]
        direction TB
        E1["에이전트 1<br/>점수: 78"]
        E2["에이전트 2<br/>점수: 81"]
        E3["에이전트 3<br/>점수: 79"]
    end

    subgraph STATS["📈 통계"]
        direction TB
        S1["평균: 79.3"]
        S2["표준편차: 1.53"]
        S3["95% CI: [76.8, 81.8]"]
    end

    subgraph DECISION["⚖️ 결정"]
        D1{"CI_lower(신규) ><br/>CI_upper(기존)?"}
        D1 -->|YES| MERGE["✅ 병합"]
        D1 -->|NO| REJECT["❌ 거부"]
    end

    EVAL --> STATS --> DECISION

    style E1 fill:#475569,stroke:#64748b,color:#f8fafc
    style E2 fill:#475569,stroke:#64748b,color:#f8fafc
    style E3 fill:#475569,stroke:#64748b,color:#f8fafc
    style MERGE fill:#0d9488,stroke:#0f766e,color:#fff
    style REJECT fill:#475569,stroke:#64748b,color:#f8fafc
```

---

## ⚔️ 품질 점수화

각 스킬은 5가지 차원에서 평가됩니다:

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#ea580c', 'secondaryColor': '#0d9488', 'tertiaryColor': '#475569', 'primaryTextColor': '#f8fafc'}}}%%
pie showData
    title 품질 점수 가중치
    "테스트 통과율" : 30
    "코드 명확성" : 20
    "성능" : 20
    "완전성" : 20
    "유지보수성" : 10
```

---

## 🛡️ 안전 메커니즘

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart TB
    subgraph SAFETY["🛡️ 안전의 4대 기둥"]
        direction LR
        P1["🔄<br/>안전한 롤백<br/>─────<br/>실패 시 Trial<br/>브랜치 삭제"]
        P2["🔒<br/>원본 보존<br/>─────<br/>소스 스킬<br/>절대 건드리지 않음"]
        P3["📝<br/>실패 기록<br/>─────<br/>실패에서<br/>배우기"]
        P4["⏱️<br/>최대 6회 반복<br/>─────<br/>과최적화<br/>방지"]
    end

    style P1 fill:#475569,stroke:#64748b,color:#f8fafc
    style P2 fill:#0d9488,stroke:#0f766e,color:#fff
    style P3 fill:#ea580c,stroke:#c2410c,color:#fff
    style P4 fill:#475569,stroke:#64748b,color:#f8fafc
```

---

## 📦 설치

<details>
<summary><b>방법 1: 자동 로드 (권장)</b></summary>

```bash
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge
```

</details>

<details>
<summary><b>방법 2: 수동 설치</b></summary>

```bash
mkdir -p ~/.claude/plugins/local/skill-forge
cp -r skill-forge/* ~/.claude/plugins/local/skill-forge/
chmod +x ~/.claude/plugins/local/skill-forge/hooks/*.sh
```

</details>

---

## 🚀 명령어

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#475569', 'primaryTextColor': '#f8fafc', 'primaryBorderColor': '#64748b', 'lineColor': '#94a3b8'}}}%%
flowchart LR
    subgraph COMMANDS["🚀 사용 가능한 명령어"]
        direction TB
        C1["/skill-forge:forge --scan<br/>🔍 업그레이드 가능한 스킬 스캔"]
        C2["/skill-forge:forge <skill><br/>⚒️ 특정 스킬 단조"]
        C3["/skill-forge:forge --history<br/>📜 단조 이력 확인"]
        C4["/skill-forge:forge --watch<br/>👁️ 스킬 모니터링"]
    end

    style C1 fill:#475569,stroke:#64748b,color:#f8fafc
    style C2 fill:#ea580c,stroke:#c2410c,color:#fff
    style C3 fill:#475569,stroke:#64748b,color:#f8fafc
    style C4 fill:#0d9488,stroke:#0f766e,color:#fff
```

---

## 📈 단조 이력

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'git0': '#475569', 'git1': '#ea580c', 'git2': '#0d9488', 'gitBranchLabel0': '#f8fafc', 'gitBranchLabel1': '#fff', 'gitBranchLabel2': '#fff', 'commitLabelColor': '#f8fafc', 'commitLabelBackground': '#475569', 'tagLabelColor': '#fff', 'tagLabelBackground': '#0d9488'}, 'gitGraph': {'showCommitLabel': true}}}%%
gitGraph
    commit id: "v0.5" tag: "초기"
    commit id: "TDD-Fit"
    commit id: "Trial Branch"
    branch forge-v0.6
    commit id: "+평가자 분리"
    commit id: "+CI 검증"
    checkout main
    merge forge-v0.6 id: "v0.6 (71점)" tag: "71"
    branch forge-v0.7
    commit id: "+CSO 준수"
    commit id: "+Arguments"
    commit id: "+Prerequisites"
    checkout main
    merge forge-v0.7 id: "v0.7 (90점)" tag: "90.33"
    commit id: "v0.8+" type: HIGHLIGHT
```

---

## 📚 전승 (참고자료)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#1e293b', 'primaryTextColor': '#f1f5f9', 'primaryBorderColor': '#475569', 'lineColor': '#ea580c'}}}%%
mindmap
  root((📚 참고자료))
    Gödel Machines
      Schmidhuber 2007
      자기 참조 에이전트
      arxiv:cs/0309048
    Dynamic Gödel
      환경 적응
      점진적 학습
    TDD 안전성
      루프 방지
      변경 경계
    다중 평가자
      합의 신뢰성
      편향 방지
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

*"불꽃 속에서 단조된 스킬은 결코 지치지 않는다."*

---

[skill-up](https://github.com/BumgeunSong/skill-up)에서 영감을 받음

**Maintained by:** Claude Code · **License:** MIT

</div>
