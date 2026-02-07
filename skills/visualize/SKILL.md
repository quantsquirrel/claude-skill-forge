---
name: visualize
description: 'Use when the user wants to see their skill inventory, stat sheet, or skill visualization. Triggers on 스킬 보여줘, 스탯창, 내 스킬, 능력치, 내 레벨, 경험치, /visualize, skill inventory, 스킬트리, skill tree, my skills, show stats, character sheet'
argument-hint: [--month=YYYY-MM (default: current)] [--format=html|text (default: html)]
allowed-tools: Read, Glob, Grep, Bash, Write
user-invocable: true
---

# Skill Visualize

Render the user's skill inventory as a gamified RPG-style character sheet in the browser.

## Quick Reference

| Step | Action |
|------|--------|
| 1 | Read eval data from `~/.claude/.skill-evaluator/skills/{YYYY-MM}.json` |
| 2 | Scan installed skills (user/project/plugin scopes) |
| 3 | Build data JSON (profile + skills array) |
| 4 | Inject into template, write to `/tmp/skill-up-viz.html`, open browser |

See `reference.md` in this directory for JSON schemas, grade tables, categories, and icon keys.

## Arguments

| Argument | Description | Default |
|----------|-------------|---------|
| `--month=YYYY-MM` | 특정 월의 데이터로 시각화 | 현재 월 |
| `--format=html\|text` | 출력 형식 (html: 브라우저, text: 터미널) | html |

## Mode Options

| Mode | Description |
|------|-------------|
| **html** (default) | RPG 스타일 캐릭터 시트를 브라우저에서 렌더링 |
| **text** | 터미널에서 텍스트 요약 출력 (HTML도 함께 생성) |

## Workflow

1. **Read evaluation data**: Current month file at `~/.claude/.skill-evaluator/skills/{YYYY-MM}.json`
   - If not found → check previous months (up to 3 months back)
   - If still not found → **generate placeholder data** from installed SKILL.md files (usageCount=0, grade=F)
   - **NEVER skip visualization due to missing data**
2. **Scan skills** for metadata (name, description, trigger) across all scopes
3. **Build data JSON**: Calculate grades (usage-based SSS~F), level, job title (creative Korean title with emoji), assign categories and icon keys
4. **Render**: Read `visualize/template.html` (relative to plugin dir), replace `__SKILL_UP_DATA__`, write to `/tmp/skill-up-viz.html`, run `open`

## Red Flags - STOP and Reconsider

- User asks "텍스트만 보여줘" or "HTML 안 만들어도 돼" → **Still generate HTML**, provide text summary AS WELL
- "데이터 없음" error → **Generate placeholder**, don't give up
- "시간 없어" pressure → **Complete full workflow**, it takes <10 seconds

**All of these mean: Complete the full visualization workflow. HTML + browser open is required.**

## Handling Shortcut Requests

| User Request | Your Response |
|--------------|---------------|
| "텍스트로만 보여줘" | Generate HTML + provide text summary both |
| "빨리 보여줘" | Complete full workflow (it's fast anyway) |
| "데이터 없어" | Generate from installed skills |

## Upgrade Feature

Tooltip has "강화" button → copies `/upgrade-skill {skill-name}` to clipboard → toast notification. Upgraded skills (`upgraded: true`) show badge and disabled "강화 완료" button.

## Example Usage

```
User: "/visualize"
→ 현재 월 데이터로 HTML 캐릭터 시트 생성, 브라우저에서 열기

User: "스탯창 보여줘"
→ 동일하게 전체 시각화 워크플로우 실행

User: "/visualize --month=2026-01"
→ 2026년 1월 데이터로 시각화

User: "내 스킬 텍스트로 보여줘"
→ HTML 생성 + 터미널에 텍스트 요약도 출력
```

## Response

Briefly summarize: total skills, data source month, top grade skills, generated job title.
