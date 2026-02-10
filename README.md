# Cursor AI Rules — Система инструкций для AI-агентов в Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-12.1-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **Гибридная система Rules + Skills для AI-агентов в Cursor IDE с оптимизацией token budget и исполняемыми скриптами**

---

## Что это?

**Cursor AI Rules** — библиотека инструкций для AI-ассистентов в [Cursor IDE](https://cursor.com/):

- **Структурирует работу AI** — skills для разных типов задач
- **Повышает качество** — встроенные проверки и верификация
- **Оптимизирует токены** — 3-уровневая система загрузки правил (~2,500 токенов always)
- **Автоматизирует workflows** — shell-скрипты в skills для deploy, тестирования, сканирования
- **Накапливает опыт** — обучение на ошибках

---

## Эффект

| Метрика | До | После |
|---------|------|-------|
| Задачи без переделок | ~50% | >80% |
| Повторные ошибки | ~30% | <10% |
| Linter errors при сдаче | ~15% | 0% |
| Always-apply токенов | ~21,000 | ~2,500 |

---

## Архитектура v12.0: Rules + Skills Hybrid

```
your-project/
├── .cursor/
│   ├── docs/                         # Документация
│   │   ├── ARCHITECTURE.md
│   │   ├── HOW-TO-USE.md
│   │   └── CHANGELOG.md
│   │
│   ├── rules/                        # Rules — constraints (13 файлов)
│   │   ├── core-master.mdc           # Tier 1: ALWAYS (единственный)
│   │   ├── standard-*-auto.mdc       # Tier 2: AUTO (2 шт, по globs)
│   │   └── *-agent.mdc, _base-*.mdc  # Tier 3: AGENT (10 шт)
│   │
│   ├── skills/                       # Skills — workflows (12 директорий)
│   │   ├── deploy-app/               # С shell-скриптами
│   │   ├── api-testing/              # С shell-скриптами
│   │   ├── development/              # С references/
│   │   ├── bugfix/
│   │   ├── refactoring/
│   │   ├── research/
│   │   ├── session-review/
│   │   ├── code-review/              # С references/
│   │   ├── tdd-workflow/
│   │   ├── create-rules/             # С assets/
│   │   ├── techdebt-scan/            # С скриптами (explicit only)
│   │   └── gap-analysis/             # С скриптами
│   │
│   ├── rules_alone/                  # Одиночные инструкции (5 шт)
│   └── .secrets/                     # Секреты (заигнорены)
│
├── .cursorignore                     # Исключения из контекста
├── CLAUDE.md                         # Lean project context
└── AGENTS.md                         # Supplementary AI context
```

### Rules vs Skills

| Аспект | Rules | Skills |
|--------|-------|--------|
| Что | Constraints, инварианты | Процедурные workflows |
| Формат | Один .mdc файл | Директория с SKILL.md + scripts/ |
| Скрипты | Нет | Да (shell, python, etc.) |
| Загрузка | Always / Auto / Agent | Agent-decided или /skill-name |
| Примеры | "Не используй value='' в Select" | "Протокол разработки фичи" |

### Как работает

```
Ваш запрос
    ↓
core-master.mdc (автоматически)
  ├── Сложность 🟢/🟡/🔴
  ├── План → Skill из Routing Table
  ├── Выполнение (KISS/YAGNI инлайн)
  ├── Проверка (Forbidden + Cross-check + Challenge инлайн)
  └── DONE блок
    ↓
*.tsx открыт? → react-hooks, radix-select (auto)
    ↓
Агент подключает нужные skills и rules по описанию
```

---

## Быстрый старт

### Шаг 1: Скопируйте в проект

```bash
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/AGENTS.md /path/to/your/project/
cp cursor-develop-autorules/.cursorignore /path/to/your/project/
```

### Шаг 2: Настройте config и AGENTS.md под проект

1. Отредактируйте `.cursor/config/project.config.json` — укажите URL, сервисы, пути
2. Отредактируйте `AGENTS.md` — укажите структуру проекта
3. Создайте `.cursor/.secrets/` с credentials (если нужны deploy/testing skills)

### Шаг 3: Готово!

Просто начните работать. Инструкции применяются автоматически.

---

## Состав библиотеки

### Rules (13 файлов)

**Tier 1 — Always (1):** `core-master.mdc` — master protocol с KISS/YAGNI, Forbidden, Cross-check, Challenge, Confidence.

**Tier 2 — Auto (2):**

| Файл | Globs | Что делает |
|------|-------|------------|
| `standard-react-hooks-auto.mdc` | *.tsx, *.jsx | Порядок хуков |
| `standard-radix-select-auto.mdc` | *.tsx | Запрет value="" |

**Tier 3 — Agent (10):** api-pagination, file-size-limits, basic-auth, agent-quality, freeze-recovery, error-learning, 4x _base-* modules

### Skills (12 директорий)

| Skill | Назначение | Скрипты |
|-------|-----------|---------|
| `deploy-app` | Deploy backend/frontend | deploy-backend.sh, deploy-frontend.sh, deploy-all.sh, verify-pages.sh |
| `api-testing` | API тестирование с auth | get-session.sh, test-endpoint.sh |
| `development` | Разработка фич (JTBD, TDD) | — |
| `bugfix` | Исправление ошибок (5 Whys) | — |
| `refactoring` | Безопасный рефакторинг | — |
| `research` | Анализ данных | — |
| `session-review` | Обзор качества сессии | — |
| `code-review` | QA + CTO Review | — |
| `tdd-workflow` | Test-Driven Development | — |
| `create-rules` | Создание правил/скиллов | — |
| `techdebt-scan` | Техдолг (explicit only) | scan-large-files.sh, find-todos.sh |
| `gap-analysis` | Поиск пробелов/заглушек | scan-gaps.sh |

### .cursorignore

Исключает из контекста AI: `dist/`, `node_modules/`, `.next/`, `.git/`, секреты.

---

## Ключевые концепции

### KISS/YAGNI (инлайн в core-master)
- Простейшее решение всегда предпочтительнее
- НЕ писать код "на будущее"
- Перед абстракцией: нужна СЕЙЧАС? Можно ПРОЩЕ?

### Challenge Protocol (инлайн в core-master)
4 вопроса перед "готово": опровержение, файлы, edge cases, Job решён?

### RAT — Riskiest Assumption Test
Проверка TOP-1 риска ПЕРЕД кодингом.

---

## Самоулучшение

```
Ошибка → session-review skill → improvements-backlog.md → @rules_alone/backlog-to-rules → Новое правило/skill
```

Принцип "Rule of Three": кодифицируй правило после 3 повторений ошибки.

---

## Что нового в v12.1

- **Project Config**: `.cursor/config/project.config.json` — единый источник project-specific значений
- **Full Universality**: 0 hardcoded значений в rules/skills — все project-specific в config
- **Skills Architecture**: 12 skills с SKILL.md format, progressive disclosure
- **Executable Scripts**: 4 skills с config-driven shell-скриптами (deploy, testing, scanning)
- **References/Assets**: 4 skills с reference материалами
- **Rules → Skills Migration**: 14 rules конвертированы в 12 skills
- **Easy Setup**: Скопируй `.cursor/`, отредактируй `config/project.config.json` — готово

---

## FAQ

**Q: Нужно писать "используй core-master.mdc"?** Нет, применяется автоматически.

**Q: Как добавить правило или skill?** Используй `/create-rules` skill.

**Q: Как запустить deploy?** Скажи "задеплой" — агент подключит `deploy-app` skill с скриптами.

**Q: Как запустить сканирование техдолга?** Используй `/techdebt-scan` (только явный вызов).

---

## Лицензия

MIT License

## Ссылки

- [GitHub Repository](https://github.com/dmitryprg-ai/cursor-develop-autorules)
- [Cursor IDE](https://cursor.com/)

---

**Версия:** 12.1 | **Дата:** 2026-02-10
