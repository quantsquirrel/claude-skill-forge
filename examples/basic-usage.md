# Basic Usage Examples

## 1. Scan for Upgradeable Skills

```bash
/skill-forge:forge --scan
```

Output:
```
Scanning for TDD-fit skills...

Found 3 upgradeable skills:
  ✅ executor    (score: 72, tests: 5)
  ✅ researcher  (score: 68, tests: 3)
  ⏭️ planner    (skipped: no tests)

Run `/skill-forge:forge <skill>` to upgrade.
```

## 2. Upgrade a Specific Skill

```bash
/skill-forge:forge executor
```

Output:
```
[1/6] executor 업그레이드 중...

Trial Branch: trial/executor-20260131-120000
✓ Improvement agent completed
  → Performance: -20% memory
  → Clarity: Added comments

Evaluation (3 rounds):
  Round 1: 78  Round 2: 81  Round 3: 79

Statistics:
  Mean: 79.3 | StdDev: 1.53 | 95% CI: [76.8, 81.8]

Baseline: 72 (CI: [69, 75])

✅ Improvement confirmed: CI_lower(76.8) > CI_upper(75)
→ Merged to main
```

## 3. View Upgrade History

```bash
/skill-forge:forge --history
```

Output:
```
Upgrade History:
  2026-01-29: forge    71 → 90.33 (+27%) ✅
  2026-01-28: executor 68 → 79.3  (+17%) ✅
  2026-01-27: writer   65 → 71    (+9%)  ✅
```
