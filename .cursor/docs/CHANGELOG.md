# Changelog

Все заметные изменения в библиотеке AI-инструкций документируются здесь.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/).

---

## [12.2.0] - 2026-01-14

### Added — New Rules
- `standard-error-handling-auto.mdc` — автоматическая обработка ошибок (try-catch паттерны)
- `standard-git-workflow-agent.mdc` — правила работы с Git (commits, branches)
- `standard-security-agent.mdc` — проверки безопасности (secrets, SQL injection)

### Added — New Skills
- `backlog-to-rules/` — конвертация backlog items в rules
- `fix-last-task/` — исправление последней неудачной задачи

### Added — Scripts
- `scripts/migrate-to-claude-code.sh` — миграция на Claude Code
- `scripts/validate-rules.sh` — валидация правил

### Changed
- Обновлены shell-скрипты во всех skills (улучшена совместимость)
- `project.config.example.json` — пример конфигурации

### Statistics v12.2

| Метрика | v12.1 | v12.2 |
|---------|-------|-------|
| Правил в rules/ | 13 | 16 (+3) |
| Skills | 12 | 14 (+2) |
| Скриптов | 15 | 17 (+2) |

---

## [12.1.0] - 2026-02-10

### Added — Project Config System
- `.cursor/config/project.config.json` — single source for all project-specific values
- All shell scripts in skills now read from config via `jq`

### Changed — Universality
- Removed all hardcoded project-specific values from skills (9 files cleaned)
- `deploy-app` scripts: PROJECT_ROOT, SITE_URL, service names → config
- `api-testing` scripts: PROJECT_ROOT, SITE_URL, test user email → config
- `techdebt-scan` scripts: scan directories → config
- `gap-analysis` scripts: scan directories → config
- SKILL.md docs: replaced URLs and paths with config references

### Universality Rule
- Files in `rules/`, `rules_alone/`, `skills/` contain ZERO project-specific values
- Only `config/` and `.secrets/` contain project specifics
- To use in another project: copy `.cursor/`, edit `config/project.config.json`

---

## [12.0.0] - 2026-02-10

### Changed — MAJOR: Rules + Skills Hybrid Architecture

**Проблема:** 23 agent-decided rules — все процедурные workflows. Нет поддержки скриптов, references или progressive disclosure. Cursor Commands (3 шт) дублировали deploy-verification rule.

**Решение:** Миграция 14 rules → 12 skills. Skills поддерживают executable scripts, references/, assets/. Progressive disclosure — SKILL.md загружается при необходимости, references подгружаются по запросу.

### Added — 12 Skills
- `deploy-app` — deploy с 4 скриптами (merged rule + 3 commands)
- `api-testing` — API тестирование с 2 скриптами
- `development` — разработка фич + references/PREPARE-PROMPT.md
- `bugfix` — исправление ошибок (5 Whys)
- `refactoring` — безопасный рефакторинг (TDD)
- `research` — анализ данных (Data First)
- `session-review` — обзор сессии
- `code-review` — QA + references/CTO-REVIEW.md
- `tdd-workflow` — Test-Driven Development
- `create-rules` — создание правил и скиллов + assets/rule-template.mdc
- `techdebt-scan` — сканирование техдолга с 2 скриптами (explicit only)
- `gap-analysis` — поиск пробелов и заглушек с 1 скриптом

### Removed — Merged into Skills
- `protocol-development.mdc` → `development` skill
- `protocol-prepare-prompt.mdc` → `development` skill (references/)
- `protocol-bugfix.mdc` → `bugfix` skill
- `protocol-refactoring.mdc` → `refactoring` skill
- `protocol-research.mdc` → `research` skill
- `protocol-session-review.mdc` → `session-review` skill
- `standard-qa.mdc` → `code-review` skill
- `standard-cto-review.mdc` → `code-review` skill (references/)
- `standard-tdd.mdc` → `tdd-workflow` skill
- `core-rules-standard-format-agent.mdc` → `create-rules` skill
- `standard-generating-rules-agent.mdc` → `create-rules` skill
- `standard-deploy-verification-agent.mdc` → `deploy-app` skill
- `standard-api-testing-agent.mdc` → `api-testing` skill
- `.cursor/commands/deploy-*.md` (3 files) → `deploy-app` skill
- `rules_alone/techdebt-manual.mdc` → `techdebt-scan` skill
- `rules_alone/protocol-gap-analysis-agent.mdc` → `gap-analysis` skill

### Changed — core-master.mdc v4.0 → v5.0
- Routing Table: references skills instead of protocol-*.mdc
- Additional modules table: includes skills

### Statistics v12.0

| Метрика | v11.0 | v12.0 | Изменение |
|---------|-------|-------|-----------|
| Rules files | 26 | 13 | **-50%** |
| Skills | 0 | 12 | **NEW** |
| Commands | 3 | 0 | → skills |
| rules_alone | 7 | 5 | -2 → skills |
| Always-apply tokens | ~2,500 | ~2,500 | unchanged |
| Agent-decided rules | 23 | 10 | **-56%** |
| Scriptable workflows | 0 | 4 | **NEW** |

---

## [11.0.0] - 2026-02-09

### Changed — MAJOR: 3-Tier Token-Optimized Architecture

**Проблема:** ~21,000 токенов always-apply правил в каждом чате.

**Решение:** 3-Tier System — Always / Auto / Agent-decided.

### Removed — Merged into core-master.mdc v4.0
- `_base-challenge.mdc`, `_base-crosscheck.mdc`, `_base-confidence.mdc`, `_base-forbidden.mdc`
- `standard-kiss-yagni-always.mdc`, `standard-rca.mdc`

### Changed — Converted always → auto/agent
- 8 rules converted from always-apply to auto (globs) or agent (description)

### Added
- `.cursorignore`, `.cursor/commands/deploy-*.md`
- CLAUDE.md slimmed: 267 → 80 строк
- AGENTS.md slimmed: 264 → 65 строк

---

## [10.2.0] - 2026-01-14

### Updated — CORE-MASTER v3.2

---

## [10.1.0] - 2026-01-14

### Added — API TESTING STANDARD

---

## [10.0.0] - 2026-02-02

### Added — KISS/YAGNI/MVP PRINCIPLES

---

## [9.0.0] - 2026-02-02

### Added
- `standard-api-pagination-always.mdc`, `standard-react-hooks-always.mdc`, `techdebt-manual.mdc`

---

## Версии файлов (v12.0)

| Файл | Версия |
|------|--------|
| `core-master.mdc` | 5.0 |
| `ARCHITECTURE.md` | 12.0 |
| `HOW-TO-USE.md` | 9.0 |
| `CHANGELOG.md` | 12.0 |
| 12 skills | 1.0 |
| `CLAUDE.md` | 3.0 |
| `AGENTS.md` | 3.0 |

---

**Последнее обновление:** 2026-02-10
