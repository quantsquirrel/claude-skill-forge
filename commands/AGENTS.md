<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-01-31 | Updated: 2026-01-31 -->

# commands

## Purpose

Slash command documentation files that provide user-facing help text for each skill. These are the entrypoints users see when invoking `/skill-forge:*` commands.

## Key Files

| File | Description |
|------|-------------|
| `forge.md` | Documentation for `/skill-forge:forge` - main upgrade command |
| `visualize.md` | Documentation for `/skill-forge:visualize` - skill stats display |
| `writing-skills.md` | Documentation for `/skill-forge:writing-skills` - TDD skill methodology |

## For AI Agents

### Working In This Directory

- Each `.md` file corresponds to a skill in `../skills/`
- Commands should have clear usage examples
- Keep descriptions concise and action-oriented

### Testing Requirements

- Verify command name matches skill name
- Ensure examples are accurate and runnable

### Common Patterns

- Start with a brief one-liner description
- Include usage syntax and examples
- Reference the corresponding SKILL.md for full details

## Dependencies

### Internal

- `../skills/` - Actual skill implementations

<!-- MANUAL: -->
