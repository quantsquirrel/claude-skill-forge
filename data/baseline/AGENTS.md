<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-01-31 | Updated: 2026-01-31 -->

# baseline

## Purpose

Stores baseline evaluation scores for skills before and after upgrades. Each JSON file contains statistical data (scores, mean, CI, timestamps) used to determine if improvements are statistically significant.

## Key Files

| File | Description |
|------|-------------|
| `forge.json` | Baseline and improvement data for the forge skill itself (bootstrapping) |

## For AI Agents

### Working In This Directory

- Files track skill upgrade history with statistical validation
- Each file contains: baseline scores, improved scores, CI separation status
- Used by forge skill to verify meaningful improvements

### JSON Schema

```json
{
  "skill_name": "forge:skill-name",
  "version": "vX.Y",
  "bootstrapping": {
    "baseline": { "scores": [], "mean": 0, "stddev": 0, "ci": [] },
    "improved": { "scores": [], "mean": 0, "stddev": 0, "ci": [] },
    "ci_separated": boolean,
    "merged": boolean
  }
}
```

### Testing Requirements

- Validate JSON syntax
- Verify CI calculations match `statistics.sh` output
- Check timestamps are ISO 8601 format

## Dependencies

### Internal

- `../../hooks/lib/statistics.sh` - CI calculation functions
- `../../skills/forge/` - Forge skill reads/writes these files

<!-- MANUAL: -->
