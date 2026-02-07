<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-01-31 | Updated: 2026-02-08 -->

# skills

## Purpose

Skill definitions directory. Each subdirectory contains a complete skill with SKILL.md (main definition), supporting documentation, and test scenarios. These skills implement the TDD-based upgrade workflow.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `forge/` | Main upgrade skill - TDD evaluation and improvement (see `forge/AGENTS.md`) |
| `monitor/` | Forge monitor dashboard showing skill quality scores and priorities (see `monitor/AGENTS.md`) |
| `visualize/` | Skill stats visualization and dashboard (see `visualize/AGENTS.md`) |
| `writing-skills/` | TDD methodology guide for skill creation (see `writing-skills/AGENTS.md`) |

## For AI Agents

### Working In This Directory

- Each skill has a `SKILL.md` as its main entry point
- SKILL.md frontmatter defines: name, description, allowed-tools, user-invocable
- Description must start with "Use when..." for CSO (Claude Search Optimization)

### Testing Requirements

- Each skill should have pressure scenarios
- Run 3 evaluations for statistical confidence
- Verify CSO compliance (description format, keywords)

### Common Patterns

```yaml
---
name: forge:skill-name
description: Use when [trigger condition]. [Brief purpose].
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task
user-invocable: true
---
```

## Dependencies

### Internal

- `../hooks/` - Hooks detect skill file changes
- `../commands/` - User-facing command documentation

<!-- MANUAL: -->
