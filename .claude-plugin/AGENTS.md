<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-01-31 | Updated: 2026-02-08 -->

# .claude-plugin

## Purpose

Plugin metadata directory containing the manifest file that registers skill-forge as a Claude Code plugin. Defines plugin identity, version, and skill location.

## Key Files

| File | Description |
|------|-------------|
| `plugin.json` | Plugin manifest with name, description, version, author, and skills path |

## For AI Agents

### Working In This Directory

- `plugin.json` defines the plugin's identity for Claude Code
- The `skills` field points to `./skills/` directory
- Version follows semver (currently 1.0.0)

### Testing Requirements

- Validate JSON syntax after any edits
- Ensure `skills` path resolves correctly

### Common Patterns

- Keep manifest minimal - only essential metadata
- Version bumps should match changelog in README.md

## Dependencies

### Internal

- `../skills/` - Skills directory referenced by manifest

<!-- MANUAL: -->
