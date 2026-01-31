[English](README.md) | **한국어**

<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=38BDF8&center=true&vCenter=true&width=500&lines=skill-forge">
  <img alt="skill-forge" src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=0D1117&center=true&vCenter=true&width=500&lines=skill-forge">
</picture>

### ⟨ TDD 진화 엔진 ⟩

[![Version](https://img.shields.io/badge/v0.8-A3E635?style=flat-square&logoColor=0D1117)](https://github.com/quantsquirrel/claude-skill-forge)
[![Tests](https://img.shields.io/badge/tests-passing-38BDF8?style=flat-square)](https://github.com/quantsquirrel/claude-skill-forge)
[![License](https://img.shields.io/badge/MIT-E2E8F0?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=flat-square&color=38BDF8)](https://github.com/quantsquirrel/claude-skill-forge)

**TDD 기반 Claude Code 스킬 자동 진화 엔진**

</div>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💎 흐름

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
    A["🔴 테스트"] -->|분석| B["🔍 스캔"]
    B -->|진화| C["⚡ 진화"]
    C -->|검증| D["💎 결정"]

    style A fill:#0D1117,stroke:#FB7185,stroke-width:2px,color:#FB7185
    style B fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style C fill:#1E293B,stroke:#A3E635,stroke-width:2px,color:#A3E635
    style D fill:#38BDF8,stroke:#38BDF8,color:#0D1117
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ⚡ 빠른 시작

```bash
# 설치
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# 실행
/skill-forge:forge --scan
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💎 기능

| 💎 투명한 검증 | ⚡ 자동 진화 |
|:---:|:---:|
| 모든 변경은 테스트로 검증 | 3회 평가 + 95% CI 자동 머지 |

| 🔄 안전한 롤백 | 📊 통계 |
|:---:|:---:|
| 실패 시 원본 보존 | 실시간 점수 추적 |

### 🔀 하이브리드 업그레이드 모드 (v0.8)

이제 두 가지 경로로 스킬을 업그레이드할 수 있습니다:

| 모드 | 조건 | 방법 |
|------|------|------|
| **TDD 모드** | 테스트 파일 존재 | 통계적 검증 (95% CI) |
| **휴리스틱 모드** | 테스트 없음 | 사용량 패턴 + 구조 분석 |

```bash
# 업그레이드 모드 확인
source hooks/lib/storage-local.sh
get_upgrade_mode "my-skill"  # 반환: TDD_FIT 또는 HEURISTIC
```

### 📊 스킬 모니터 (v0.8)

스킬 사용량을 추적하고 업그레이드 추천을 받으세요:

```
/monitor
```

출력 예시:
```
╔══════════════════════════════════════════════════════════════╗
║                    Skill Forge Monitor                        ║
╠══════════════════════════════════════════════════════════════╣
║ Skill                │ Usage │ Trend   │ Mode       │ Pri    ║
╠══════════════════════╪═══════╪═════════╪════════════╪════════╣
║ skill-forge:forge    │    45 │ ▲ +20%  │ TDD_FIT    │ MED    ║
╚══════════════════════════════════════════════════════════════╝
```

### 🎖️ 강화된 등급 시스템 (v0.8)

새로운 등급 Modifier와 SSS 티어:

| Modifier | 보너스 | 조건 |
|----------|--------|------|
| 업그레이드됨 | +1 | `upgraded: true` |
| 효율적 | +0.5 | 토큰/사용량 < 1500 |
| 상승 트렌드 | +0.5 | positive 트렌드 |
| 테스트됨 | +0.5 | 테스트 파일 존재 |

**S + Upgraded + Efficient = SSS** ★★★

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔍 TDD 적합성 평가

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
    subgraph CHECK["🔍 TDD 적합성 체크리스트"]
        direction TB
        Q1["☑️ 테스트 있음?"]
        Q2["☑️ 재현 가능?"]
        Q3["☑️ 목표 명확?"]
        Q4["☑️ 깨지지 않음?"]
        Q5["☑️ 충분히 작음?"]
    end

    CHECK --> RESULT{통과?}
    RESULT -->|"✅"| READY["💎 준비됨"]
    RESULT -->|"❌"| SKIP["⏭️ 건너뜀"]

    style Q1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q2 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q4 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style Q5 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style READY fill:#A3E635,stroke:#A3E635,color:#0D1117
    style SKIP fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ⚡ 시험 브랜치 전략

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
        C1["v0.6<br/>71점"]
        C2["v0.7<br/>90점"]
        C1 -.-> C2
    end

    subgraph TRIAL["trial/skill-name"]
        direction LR
        T1["개선"]
        T2["평가<br/>×3"]
        T3{"CI?"}
        T1 --> T2 --> T3
    end

    C1 -->|브랜치| T1
    T3 -->|"✅"| C2
    T3 -->|"❌"| D["폐기"]

    style C1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style C2 fill:#A3E635,stroke:#A3E635,color:#0D1117
    style T1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style T2 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style T3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style D fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📊 통계적 검증

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
    subgraph EVAL["📊 3회 평가"]
        direction TB
        E1["에이전트 1: 78"]
        E2["에이전트 2: 81"]
        E3["에이전트 3: 79"]
    end

    subgraph STATS["📈 통계"]
        direction TB
        S1["평균: 79.3"]
        S2["95% CI"]
    end

    subgraph DECISION["⚖️"]
        D1{"CI_신규 ><br/>CI_기존?"}
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

## 📊 결과

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#38BDF8', 'secondaryColor': '#A3E635'}}}%%
xychart-beta
    title "부트스트래핑 결과"
    x-axis ["이전", "이후"]
    y-axis "점수" 0 --> 100
    bar [71, 90.33]
```

**+27% 향상** — skill-forge가 스스로를 진화시켰습니다

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🛡️ 안전장치

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
    subgraph SAFETY["🛡️ 안전 기둥"]
        direction LR
        P1["🔄<br/>롤백"]
        P2["🔒<br/>보존"]
        P3["📝<br/>기록"]
        P4["⏱️<br/>최대 6회"]
    end

    style P1 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style P2 fill:#1E293B,stroke:#A3E635,stroke-width:2px,color:#A3E635
    style P3 fill:#1E293B,stroke:#38BDF8,stroke-width:2px,color:#E2E8F0
    style P4 fill:#1E293B,stroke:#FB7185,stroke-width:2px,color:#FB7185
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🚀 명령어

| 명령어 | 설명 |
|--------|------|
| `/skill-forge:forge --scan` | 🔍 업그레이드 가능한 스킬 스캔 |
| `/skill-forge:forge <skill>` | ⚡ 특정 스킬 단조 |
| `/skill-forge:forge --history` | 📜 단조 기록 보기 |
| `/skill-forge:forge --watch` | 👁️ 스킬 모니터링 |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📈 히스토리

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

## 📚 이론

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {
  'primaryColor': '#1E293B',
  'primaryTextColor': '#E2E8F0',
  'primaryBorderColor': '#38BDF8',
  'lineColor': '#38BDF8'
}}}%%
mindmap
  root((📚))
    괴델 머신
      Schmidhuber 2007
      자기 참조
    동적 괴델
      환경 적응
      점진적 학습
    TDD 안전
      루프 방지
      변경 경계
    다중 평가자
      합의 신뢰성
      편향 방지
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<div align="center">

**영감** [skill-up](https://github.com/BumgeunSong/skill-up)

**Claude Code** · **MIT License**

</div>
