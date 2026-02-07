# Changelog

All notable changes to skill-forge will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Planned
See [GitHub Issues](https://github.com/quantsquirrel/claude-skill-forge/issues) for planned features and community feedback.

## [1.0.0] - 2026-02-01

### Added
- **Hybrid Upgrade Mode**: Heuristic-based upgrades for skills without tests / 테스트 없는 스킬도 휴리스틱 기반으로 업그레이드 가능
- **Heuristic Evaluator**: Skill evaluation through usage patterns and structural analysis / 사용량 패턴과 구조 분석으로 스킬 평가 (`skill-forge:heuristic-evaluator`)
- **Skill Monitor**: Usage dashboard and upgrade recommendations / 사용량 대시보드 및 업그레이드 추천 (`/monitor`)
- **Enhanced Grade System**: Extended grading up to SSS + Modifier bonuses / SSS까지 확장된 등급 + Modifier 보너스
- **n=5 Precision Mode**: High-precision statistical verification with `--precision=high` or `-n5` / 고정밀 통계 검증
- **Trend Analysis**: Monthly usage trend analysis via `get_usage_trend()` function / 월별 사용량 트렌드 분석 함수
- **Token Efficiency**: Token efficiency calculation via `get_token_efficiency()` function / 토큰 효율 계산 함수
- **Recommendation Engine**: Priority-based upgrade recommendations / 우선순위 기반 업그레이드 추천

### Changed
- `storage-local.sh`: Added trend analysis and mode detection functions / 트렌드 분석 및 모드 감지 함수 추가
- `statistics.sh`: Added sample size helper functions / 샘플 사이즈 헬퍼 함수 추가
- `forge SKILL.md`: Added TDD/Heuristic mode branching logic / TDD/Heuristic 모드 분기 로직 추가
- `visualize`: Added support for Modifier bonuses and SSS grade / Modifier 보너스 및 SSS 등급 지원

### Technical
- Implemented hybrid strategy based on multi-model analysis / Multi-model analysis 기반 하이브리드 전략 구현
- Integrated skill-up advantages (usage tracking, heuristic evaluation) / skill-up 장점 통합 (사용량 추적, 휴리스틱 평가)
- Maintained 100% backward compatibility with existing TDD workflow / 기존 TDD 워크플로우 100% 유지

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

---

[Unreleased]: https://github.com/quantsquirrel/claude-skill-forge/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/quantsquirrel/claude-skill-forge/releases/tag/v1.0.0
[0.7]: https://github.com/quantsquirrel/claude-skill-forge/releases/tag/v0.7
[0.6]: https://github.com/quantsquirrel/claude-skill-forge/releases/tag/v0.6
[0.5]: https://github.com/quantsquirrel/claude-skill-forge/releases/tag/v0.5
