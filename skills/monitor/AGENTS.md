<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-08 | Updated: 2026-02-08 -->

# monitor

## Purpose

Forge monitor skill that displays a quality dashboard showing skill scores, grades, and forge priorities. Provides actionable recommendations for which skills need reforging.

## Key Files

| File | Description |
|------|-------------|
| `SKILL.md` | Monitor skill definition with quality dashboard workflow |

## For AI Agents

### Working In This Directory

- Monitor reads quality data from `recommendation-engine.sh`
- Displays priority-based table: HIGH → MED → LOW → READY
- Supports filtering by `--priority` and `--type` flags
- Output uses box-drawing characters for terminal display

### Testing Requirements

- Test with empty data (should show placeholder)
- Verify grade calculations match recommendation engine
- Test filter flags work correctly

### Common Patterns

- Invoke via `/forge:monitor`
- Uses `get_skill_quality_score` from storage-local.sh
- Formats output as bordered table

## Dependencies

### Internal

- `../../hooks/lib/recommendation-engine.sh` - Quality scoring logic
- `../../hooks/lib/storage-local.sh` - Skill data access

<!-- MANUAL: -->
