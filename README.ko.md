[English](README.md) | **한국어**

<div align="center">

<img src="docs/assets/forge.jpeg" alt="Skill Forge" width="600"/>

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=FFD700&center=true&vCenter=true&width=500&lines=skill-forge">
  <img alt="skill-forge" src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=42&duration=3000&pause=1000&color=FF6B00&center=true&vCenter=true&width=500&lines=skill-forge">
</picture>

### ⚔️ 스킬을 전설의 무기로 단조하세요

[![Version](https://img.shields.io/badge/v1.0-FFB800?style=flat-square&logoColor=1A0A00)](https://github.com/quantsquirrel/claude-skill-forge)
[![Tests](https://img.shields.io/badge/tests-passing-FF6B00?style=flat-square)](https://github.com/quantsquirrel/claude-skill-forge)
[![License](https://img.shields.io/badge/MIT-FFD700?style=flat-square)](LICENSE)
[![Stars](https://img.shields.io/github/stars/quantsquirrel/claude-skill-forge?style=flat-square&color=FF6B00)](https://github.com/quantsquirrel/claude-skill-forge)

**TDD 기반 Claude Code 스킬 자동 진화 엔진**

</div>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔥 단조 과정

모든 전설의 무기는 원석에서 시작합니다. 가열, 타격, 담금질을 거쳐 평범한 금속이 비범한 무기로 탄생합니다.

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
    A["⚙️ 원석<br/>스킬"] -->|"🔥 가열"| B["🔍 분석<br/>구조"]
    B -->|"🔨 타격"| C["⚡ 진화<br/>개선"]
    C -->|"💧 담금질"| D["✅ 검증<br/>테스트"]
    D -->|"⚔️"| E["✨ 전설"]

    style A fill:#2D1810,stroke:#A0A0A0,stroke-width:2px,color:#A0A0A0
    style B fill:#1A0A00,stroke:#FF6B00,stroke-width:3px,color:#FFB800
    style C fill:#1A0A00,stroke:#FFB800,stroke-width:3px,color:#FFD700
    style D fill:#2D1810,stroke:#FF6B00,stroke-width:2px,color:#FFD700
    style E fill:#FFD700,stroke:#FFD700,color:#1A0A00,stroke-width:4px
```

**대장간은 멈추지 않습니다** — 각 스킬은 분석의 불로 가열되고, 개선의 망치로 두들겨지며, 테스트의 담금질을 거쳐 더 강하게 태어납니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ⚡ 빠른 시작

```bash
# 대장간 설치
git clone https://github.com/quantsquirrel/claude-skill-forge.git \
  ~/.claude/plugins/local/skill-forge

# 불꽃 점화
/skill-forge:forge --scan
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💎 기능

| 🔨 불에 단조됨 | ⚡ 자동 진화 | 🛡️ 안전한 시험 | 📊 삼중 타격 |
|:---:|:---:|:---:|:---:|
| 모든 변경 테스트됨 | 3회 평가 합의 | 원본 보존 | 95% CI 검증 |

### 🔀 이중 단조 경로 (v1.0)

재료의 품질에 따라 두 가지 방식으로 스킬을 단조할 수 있습니다:

| 경로 | 조건 | 기법 |
|------|------|------|
| **⚔️ TDD 단조** | 테스트 파일 존재 | 통계적 검증 (95% CI) |
| **🔥 패턴 단조** | 테스트 없음 | 사용 패턴 + 휴리스틱 분석 |

```bash
# 단조 방식 확인
source hooks/lib/storage-local.sh
get_upgrade_mode "my-skill"  # 반환: TDD_FIT 또는 HEURISTIC
```

### 📊 대장간 모니터 (v1.0)

무기들을 추적하고 재단조가 필요한 것을 확인하세요:

```
/monitor
```

출력 예시:
```
╔══════════════════════════════════════════════════════════════╗
║                    🔥 대장간 모니터                           ║
╠══════════════════════════════════════════════════════════════╣
║ 무기                 │ 타격수  │ 열기   │ 방식       │ 등급  ║
╠══════════════════════╪═════════╪════════╪════════════╪═══════╣
║ skill-forge:forge    │    45   │ ▲ +20% │ TDD_FIT    │ MED   ║
╚══════════════════════════════════════════════════════════════╝
```

### 🎖️ 전설 등급 (v1.0)

뛰어난 무기는 특별한 표식을 획득합니다:

| 강화 | 보너스 | 단조 조건 |
|------|--------|----------|
| 재단조됨 | +1 | `upgraded: true` |
| 효율적 | +0.5 | 토큰/사용량 < 1500 |
| 상승세 | +0.5 | 긍정적 트렌드 |
| 검증됨 | +0.5 | 테스트 파일 존재 |

**S + 재단조됨 + 효율적 = ★★★ SSS 전설**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🛡️ 시험 브랜치 — 안전한 모루

숙련된 대장장이는 결코 걸작에 직접 작업하지 않습니다. 먼저 시험 조각으로 테스트합니다.

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
    subgraph MAIN["⚔️ main (마스터 무기)"]
        direction LR
        C1["v0.6<br/>71점"]
        C2["v0.7<br/>90점"]
        C1 -.-> C2
    end

    subgraph TRIAL["🔥 trial/skill-name (시험 모루)"]
        direction LR
        T1["🔨 타격"]
        T2["🔨 타격"]
        T3["🔨 타격"]
        T4{"가치 있나?"}
        T1 --> T2 --> T3 --> T4
    end

    C1 -->|"분기"| T1
    T4 -->|"✅ 더 강함"| C2
    T4 -->|"❌ 취약함"| D["🗑️ 폐기"]

    style C1 fill:#2D1810,stroke:#FFD700,stroke-width:2px,color:#FFD700
    style C2 fill:#FFD700,stroke:#FFD700,color:#1A0A00,stroke-width:3px
    style T1 fill:#1A0A00,stroke:#FF6B00,stroke-width:2px,color:#FFB800
    style T2 fill:#1A0A00,stroke:#FF6B00,stroke-width:2px,color:#FFB800
    style T3 fill:#1A0A00,stroke:#FF6B00,stroke-width:2px,color:#FFB800
    style T4 fill:#2D1810,stroke:#FF6B00,stroke-width:2px,color:#FFD700
    style D fill:#1A0A00,stroke:#A0A0A0,stroke-width:1px,color:#A0A0A0
```

**안전 우선** — 마스터 무기(`main`)는 시험이 가치를 증명할 때까지 절대 건드리지 않습니다. 실패한 실험은 병합되지 않고 폐기됩니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔨 삼중 타격 — 대장장이의 합의

한 번의 망치질은 속일 수 있습니다. 세 번의 타격이 진실을 드러냅니다.

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
    subgraph STRIKE["🔨 삼중 타격 평가"]
        direction TB
        S1["🔨 대장장이 1<br/>점수: 78"]
        S2["🔨 대장장이 2<br/>점수: 81"]
        S3["🔨 대장장이 3<br/>점수: 79"]
    end

    subgraph MEASURE["⚖️ 품질 측정"]
        direction TB
        M1["평균: 79.3"]
        M2["95% 신뢰구간"]
    end

    subgraph VERDICT["⚔️ 최종 판결"]
        V1{"이전보다<br/>강한가?"}
        V1 -->|"YES"| ACCEPT["✅ 재단조"]
        V1 -->|"NO"| REJECT["❌ 폐기"]
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

**통계적 합의** — 세 번의 독립적인 평가. 통계적 신뢰구간. 새 버전이 명백히 우수할 때만 병합합니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📊 단조 결과

**이전:** 71점 — 거칠고 미완성
**이후:** 90.33점 — 담금질된 전설

**+27% 향상** — skill-forge가 스스로를 재단조했습니다

궁극의 시험: 자신의 과정을 통해 스스로를 개선하는 도구.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔒 안전 메커니즘

숙련된 대장장이는 여러 안전장치를 갖춥니다:

| 안전장치 | 보호 |
|---------|------|
| 🔄 **롤백 준비** | 원본 항상 보존 |
| 🔒 **격리된 시험** | 별도 브랜치에서 테스트 |
| 📝 **전체 로그** | 모든 타격 기록됨 |
| ⏱️ **반복 제한** | 최대 6회 시도 |
| ✅ **테스트 검증** | 모든 테스트 통과 필수 |

대장간을 떠나는 무기는 모두 검증됩니다. 마스터 버전은 절대 손상되지 않습니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🚀 명령어

| 명령어 | 동작 |
|--------|------|
| `/skill-forge:forge --scan` | 🔍 재단조 가능한 스킬 탐색 |
| `/skill-forge:forge <skill>` | ⚡ 특정 스킬 재단조 |
| `/skill-forge:forge --history` | 📜 단조 연대기 보기 |
| `/skill-forge:forge --watch` | 👁️ 대장간 모니터링 |

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📚 대장간의 이론

**괴델 머신** (Schmidhuber 2007) — 자신의 코드를 개선할 수 있는 자기 참조 시스템
**동적 적응** — 통계적 검증을 통한 점진적 진화
**TDD 안전 경계** — 테스트가 치명적 자기 수정을 방지
**다중 평가자 합의** — 여러 독립 심사자가 편향을 줄임

[전체 이론 읽기 →](docs/THEORY.md)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<div align="center">

**영감** [skill-up](https://github.com/BumgeunSong/skill-up)

⚒️ **Claude Code로 단조됨** · 🔥 **MIT License** · ⚔️ **v1.0**

</div>
