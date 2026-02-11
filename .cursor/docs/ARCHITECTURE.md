# CURSOR RULES ARCHITECTURE v12.2

**Дата обновления:** 2026-02-11
**Версия:** 12.2 (Rules + Skills Hybrid + Claude Code Support)

---

## Общая структура

```
.cursor/
├── docs/                          # Документация (не загружается агентом)
│   ├── ARCHITECTURE.md            # Этот файл
│   ├── HOW-TO-USE.md              # Как работать
│   └── CHANGELOG.md               # История изменений
│
├── rules/                         # Правила для AI агента (16 файлов)
│   ├── core-master.mdc            # ALWAYS — единственный entry point (v5.1)
│   │
│   ├── standard-react-hooks-auto.mdc      # AUTO (*.tsx, *.jsx)
│   ├── standard-radix-select-auto.mdc     # AUTO (*.tsx)
│   ├── standard-error-handling-auto.mdc   # AUTO (*.tsx, *.ts)
│   │
│   ├── standard-*-agent.mdc       # AGENT — constraints (6 шт: +security, +git-workflow)
│   ├── _base-*.mdc                # AGENT — атомарные модули (4 шт)
│   ├── error-learning.mdc         # AGENT — обучение на ошибках
│   └── protocol-freeze-recovery.mdc  # AGENT — восстановление AI
│
├── skills/                        # Skills — процедурные workflows (14 шт)
│   ├── deploy-app/                # Deploy с shell-скриптами
│   │   ├── SKILL.md
│   │   └── scripts/               # deploy-backend.sh, deploy-frontend.sh, etc.
│   ├── api-testing/               # API тестирование с auth скриптами
│   │   ├── SKILL.md
│   │   └── scripts/
│   ├── development/               # Протокол разработки + prepare-prompt
│   │   ├── SKILL.md
│   │   └── references/
│   ├── bugfix/SKILL.md            # Протокол исправления ошибок
│   ├── refactoring/SKILL.md       # Протокол рефакторинга
│   ├── research/SKILL.md          # Протокол анализа данных
│   ├── session-review/SKILL.md    # Обзор сессии
│   ├── code-review/               # QA + CTO Review
│   │   ├── SKILL.md
│   │   └── references/
│   ├── tdd-workflow/SKILL.md      # Test-Driven Development
│   ├── create-rules/              # Создание правил и скиллов
│   │   ├── SKILL.md
│   │   └── assets/
│   ├── techdebt-scan/             # Сканирование техдолга (explicit only)
│   │   ├── SKILL.md
│   │   └── scripts/
│   ├── gap-analysis/              # Поиск пробелов и заглушек
│   │   ├── SKILL.md
│   │   └── scripts/
│   ├── fix-last-task/             # Исправление недоработок (NEW in v12.2)
│   │   ├── SKILL.md
│   │   └── references/
│   └── backlog-to-rules/          # Внедрение улучшений из backlog (NEW in v12.2)
│       ├── SKILL.md
│       └── references/
│
├── config/                        # Project-specific config (НЕ универсальное)
│   ├── project.config.json        # URL, сервисы, пути, auth settings
│   └── project.config.example.json # Пример с реальными значениями
│
├── data/                          # Persistent data (NEW in v12.2)
│   ├── error-log.md               # Error learning records
│   └── improvements-backlog.md    # Improvement proposals
│
├── rules_alone/                   # Одиночные инструкции (@ mention, 3 шт)
│   └── *.mdc
│
└── .secrets/                      # Секреты (заигнорены)
```

---

## Architecture: Rules + Skills Hybrid

### Rules (16 files) — Constraints & Short Guidelines

| Tier | Тип | Когда загружается | Token cost | Файлов |
|------|-----|-------------------|------------|--------|
| **Tier 1: Always** | `alwaysApply: true` | Каждый чат | ~1,200 | 1 |
| **Tier 2: Auto** | `globs: *.tsx` | Когда открыт matching файл | 0 unless triggered | 3 |
| **Tier 3: Agent** | `description: "..."` | Агент решает по описанию | 0 unless triggered | 12 |

### Skills (14 directories) — Procedural Workflows

| Тип | Когда загружается | Особенности |
|-----|-------------------|-------------|
| **Auto-discovered** | Агент решает по описанию | 13 skills |
| **Explicit only** | Только по `/skill-name` | 1 skill (techdebt-scan) |

Skills with scripts: deploy-app (4), api-testing (2), techdebt-scan (2), gap-analysis (1)

### Config (project-specific values)

`.cursor/config/project.config.json` — единственное место для project-specific значений:
- `project_root`, `site_url` — корень проекта и URL сайта
- `services.backend/frontend` — имена сервисов, порты, команды build/restart
- `auth` — пути к секретам, email тестового пользователя
- `verify_pages` — страницы для проверки после деплоя
- `scan_dirs` — директории для сканирования
- `data_dir` — директория для persistent data (error-log, improvements-backlog)

Все shell-скрипты в skills загружают config автоматически через `jq`.

**Universality rule:** Файлы в `rules/`, `rules_alone/`, `skills/` НЕ содержат project-specific значений. Только `config/` и `.secrets/` содержат проектную специфику.

### When to use Rules vs Skills

- **Rules**: Short constraints, non-negotiable invariants, < 100 lines. "Would removing this cause mistakes?" -> Rule.
- **Skills**: Task-specific workflows, multi-step procedures, need scripts. "Is this only relevant sometimes?" -> Skill.

---

## Flow

```
USER REQUEST
     ↓
core-master.mdc (always loaded)
  ├── ШАГ 0: Определить сложность 🟢/🟡/🔴
  ├── ШАГ 1: План → выбрать skill из Routing Table
  ├── ШАГ 2: Выполнение (KISS/YAGNI принципы инлайн)
  ├── ШАГ 3: Проверка (Forbidden + Cross-check + Challenge + Confidence — всё инлайн)
  └── ШАГ 4: DONE блок
     ↓
*.tsx open? → standard-react-hooks-auto.mdc, standard-radix-select-auto.mdc
     ↓
Agent discovers Skills → development, bugfix, refactoring, research, deploy-app, etc.
     ↓
Agent reads Rules → api-pagination, file-size-limits, _base-5wh, etc.
```

---

## Что изменилось в v12.0 (vs v11.0)

### Добавлено — Skills Architecture
- `.cursor/skills/` — 12 skills with SKILL.md format
- 4 skills with executable scripts (deploy-app, api-testing, techdebt-scan, gap-analysis)
- 4 skills with references/assets (development, code-review, create-rules)
- techdebt-scan uses `disable-model-invocation: true` (explicit only)

### Конвертировано — Rules → Skills
- `protocol-development.mdc` + `protocol-prepare-prompt.mdc` → `development` skill
- `protocol-bugfix.mdc` → `bugfix` skill
- `protocol-refactoring.mdc` → `refactoring` skill
- `protocol-research.mdc` → `research` skill
- `protocol-session-review.mdc` → `session-review` skill
- `standard-qa.mdc` + `standard-cto-review.mdc` → `code-review` skill
- `standard-tdd.mdc` → `tdd-workflow` skill
- `core-rules-standard-format-agent.mdc` + `standard-generating-rules-agent.mdc` → `create-rules` skill
- `standard-deploy-verification-agent.mdc` + 3 commands → `deploy-app` skill
- `standard-api-testing-agent.mdc` → `api-testing` skill
- `rules_alone/techdebt-manual.mdc` → `techdebt-scan` skill
- `rules_alone/protocol-gap-analysis-agent.mdc` → `gap-analysis` skill

### Удалено
- 14 rule files (merged into skills)
- 3 command files (merged into deploy-app skill)
- `.cursor/commands/` directory (replaced by skills with scripts)

### Updated
- `core-master.mdc` v4.0 → v5.0 (Routing Table references skills)

### Метрики

| Метрика | v11.0 | v12.0 | Изменение |
|---------|-------|-------|-----------|
| Rules files | 26 | 13 | -50% |
| Skills | 0 | 12 | NEW |
| Commands | 3 | 0 | → skills |
| rules_alone | 7 | 5 | -2 → skills |
| Always-apply tokens | ~2,500 | ~2,500 | unchanged |
| Agent-decided rules | 23 | 10 | -56% |
| Scriptable workflows | 0 | 4 | NEW |

---

## Что изменилось в v12.2 (vs v12.0)

### Добавлено
- `.claude/` — полная поддержка Claude Code Agent (rules, settings, agents)
- `.claude/settings.json` — permissions (allow/deny) + hooks (PreToolUse, PostToolUse)
- `.claude/agents/` — 5 custom subagents (deploy, reviewer, researcher, tester, developer)
- `.cursor/data/` — persistent data directory for error learning and improvements backlog
- `standard-security-agent.mdc` — Zod validation, SQL injection, XSS prevention
- `standard-git-workflow-agent.mdc` — conventional commits, branch naming, PR templates
- `standard-error-handling-auto.mdc` — React state triforce, API error handling
- `project.config.example.json` — example config with realistic values
- `scripts/validate-rules.sh` — cross-reference and integrity validation
- `scripts/migrate-to-claude-code.sh` — automated .cursor/ → .claude/ migration
- `fix-last-task` skill (converted from rules_alone, fixed 5 stale cross-references)

### Исправлено
- 12+ stale cross-references to deleted files (from v11.0/v12.0 migration)
- `.cursor_additional/{projectname}/` broken paths → `.cursor/data/`
- `load-config.sh` jq/python3 inconsistency (BASIC_AUTH extraction)
- All 9 shell scripts: added `set -euo pipefail` + ERR trap
- `scan-large-files.sh`: fixed `find | while read` subshell bug
- Routing Table in `core-master.mdc` — complete with all 13 skills + freeze recovery

### Обновлено
- `core-master.mdc` v5.0 → v5.1 (complete Routing Table)
- `development` skill — TDD section now references `tdd-workflow` skill
- `research` skill — added TypeScript/SQL analysis patterns alongside Python
- `error-learning.mdc` — fixed 3 stale references
- `standard-agent-quality.mdc` — fixed 2 stale references
- `protocol-freeze-recovery.mdc` — fixed 1 stale reference
- `backlog-to-rules.mdc` — fixed 3 stale references

### Метрики

| Метрика | v12.0 | v12.2 | Изменение |
|---------|-------|-------|-----------|
| Rules files | 13 | 16 | +3 (security, git, error-handling) |
| Skills | 12 | 14 | +2 (fix-last-task, backlog-to-rules) |
| rules_alone | 5 | 3 | -2 (→ skills) |
| Stale cross-references | 12+ | 0 | FIXED |
| Shell scripts with error handling | 4/9 | 9/9 | 100% |
| Claude Code support | none | full | NEW |
| Custom subagents | 0 | 5 | NEW |
| Validation scripts | 0 | 2 | NEW |

---

**Версия:** 12.2
**Дата:** 2026-02-11
