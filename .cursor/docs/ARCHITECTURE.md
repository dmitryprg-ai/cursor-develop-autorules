# CURSOR RULES ARCHITECTURE v12.1

**Дата обновления:** 2026-02-10
**Версия:** 12.1 (Rules + Skills Hybrid Architecture + Config)

---

## Общая структура

```
.cursor/
├── docs/                          # Документация (не загружается агентом)
│   ├── ARCHITECTURE.md            # Этот файл
│   ├── HOW-TO-USE.md              # Как работать
│   └── CHANGELOG.md               # История изменений
│
├── rules/                         # Правила для AI агента (13 файлов)
│   ├── core-master.mdc            # ALWAYS — единственный entry point (v5.0)
│   │
│   ├── standard-react-hooks-auto.mdc      # AUTO (*.tsx, *.jsx)
│   ├── standard-radix-select-auto.mdc     # AUTO (*.tsx)
│   │
│   ├── standard-*-agent.mdc       # AGENT — constraints (4 шт)
│   ├── _base-*.mdc                # AGENT — атомарные модули (4 шт)
│   ├── error-learning.mdc         # AGENT — обучение на ошибках
│   └── protocol-freeze-recovery.mdc  # AGENT — восстановление AI
│
├── skills/                        # Skills — процедурные workflows (12 шт)
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
│   └── gap-analysis/              # Поиск пробелов и заглушек
│       ├── SKILL.md
│       └── scripts/
│
├── config/                        # Project-specific config (НЕ универсальное)
│   └── project.config.json        # URL, сервисы, пути, auth settings
│
├── rules_alone/                   # Одиночные инструкции (@ mention, 5 шт)
│   └── *.mdc
│
└── .secrets/                      # Секреты (заигнорены)
```

---

## Architecture: Rules + Skills Hybrid

### Rules (13 files) — Constraints & Short Guidelines

| Tier | Тип | Когда загружается | Token cost | Файлов |
|------|-----|-------------------|------------|--------|
| **Tier 1: Always** | `alwaysApply: true` | Каждый чат | ~1,200 | 1 |
| **Tier 2: Auto** | `globs: *.tsx` | Когда открыт matching файл | 0 unless triggered | 2 |
| **Tier 3: Agent** | `description: "..."` | Агент решает по описанию | 0 unless triggered | 10 |

### Skills (12 directories) — Procedural Workflows

| Тип | Когда загружается | Особенности |
|-----|-------------------|-------------|
| **Auto-discovered** | Агент решает по описанию | 11 skills |
| **Explicit only** | Только по `/skill-name` | 1 skill (techdebt-scan) |

Skills with scripts: deploy-app (4), api-testing (2), techdebt-scan (2), gap-analysis (1)

### Config (project-specific values)

`.cursor/config/project.config.json` — единственное место для project-specific значений:
- `project_root`, `site_url` — корень проекта и URL сайта
- `services.backend/frontend` — имена сервисов, порты, команды build/restart
- `auth` — пути к секретам, email тестового пользователя
- `verify_pages` — страницы для проверки после деплоя
- `scan_dirs` — директории для сканирования

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

**Версия:** 12.0
**Дата:** 2026-02-10
