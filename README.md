# Cursor AI Rules — Система инструкций для AI-агентов в Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-12.2-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/claude--code-supported-purple" alt="Claude Code">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **Гибридная система Rules + Skills для AI-агентов в Cursor IDE и Claude Code с оптимизацией token budget, исполняемыми скриптами и самоулучшением**

---

## Что это?

Библиотека инструкций для AI-ассистентов в [Cursor IDE](https://cursor.com/) и [Claude Code](https://docs.anthropic.com/en/docs/claude-code):

- **14 skills** для разных типов задач с shell-скриптами
- **16 rules** — встроенные проверки (Cross-check, Challenge, DONE-блок)
- **3-уровневая загрузка** правил (~2,500 токенов always вместо ~21,000)
- **Цикл самоулучшения** — обучение на ошибках
- **Claude Code** — `.claude/` с подагентами, permissions, hooks

| Метрика | До | После |
|---|---|---|
| Задачи без переделок | ~50% | >80% |
| Повторные ошибки | ~30% | <10% |
| Always-apply токенов | ~21,000 | ~2,500 |

---

## Архитектура v12.2

```
your-project/
├── .cursor/
│   ├── config/                        # project.config.json ← адаптация здесь
│   ├── rules/                         # 16 правил (always/auto/agent)
│   ├── skills/                        # 14 skills + _shared/ (скрипты, references)
│   ├── rules_alone/                   # 3 ручных инструкции (вызов через @)
│   ├── data/                          # Шаблоны error-log, improvements-backlog
│   ├── docs/                          # ARCHITECTURE, HOW-TO-USE, CHANGELOG
│   └── .secrets/                      # Credentials (gitignored)
├── .claude/                           # Claude Code (settings, 5 agents, 4 rules)
│
├── scripts/                           # validate-rules.sh, migrate-to-claude-code.sh
├── .cursorignore, .mcp.json
├── CLAUDE.md                          # Контекст проекта (авто-загрузка)
└── AGENTS.md                          # Дополнительный контекст
```

### Rules vs Skills

| | Rules | Skills |
|---|---|---|
| Суть | "Так нельзя" — ограничения | "Делай так" — процедуры |
| Формат | Один `.mdc` файл | Папка: `SKILL.md` + скрипты |
| Скрипты | Нет | Да — `.sh` файлы |
| Размер | < 100 строк | 50–120 строк + доп. файлы |

---

## Быстрый старт

```bash
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/{CLAUDE.md,AGENTS.md,.cursorignore} /path/to/your/project/
# Опционально: cp -r cursor-develop-autorules/{.claude,scripts,.mcp.json} /path/to/your/project/

cd /path/to/your/project
cp .cursor/config/project.config.example.json .cursor/config/project.config.json
# Заполните: project_name, site_url, services, auth, verify_pages
# Отредактируйте CLAUDE.md и AGENTS.md под свой проект
```

Или попросите AI: *"Я скопировал `.cursor/` из cursor-develop-autorules. Адаптируй `project.config.json`, `CLAUDE.md`, `AGENTS.md` под этот проект. Запусти `scripts/validate-rules.sh`."*

---

## Руководство пользователя

### Что работает автоматически

**Всегда (каждый диалог):** `core-master.mdc` — сложность, план, skill из Routing Table, проверки, DONE-блок, KISS/YAGNI.

**При открытии файлов:**

| Правило | Когда | Что делает |
|---|---|---|
| `react-hooks-auto` | `*.tsx`, `*.jsx` | Хуки в правильном порядке |
| `radix-select-auto` | `*.tsx` | Запрет `<SelectItem value="">` |
| `error-handling-auto` | `*.tsx`, `*.ts` | Error boundaries, loading/error states |

**Агент подключает по ситуации:** api-pagination, file-size-limits, security, git-workflow, basic-auth, agent-quality, freeze-recovery, error-learning, _base-5wh, _base-jtbd, _base-rat, _base-todo-usage.

**Skills — по контексту запроса:**

| Ваш запрос | Skill |
|---|---|
| "Добавь фильтр по дате" | `development` — JTBD + TDD |
| "Не работает кнопка" | `bugfix` — 5 Whys RCA |
| "Упрости сервис" | `refactoring` — тесты → маленькие шаги |
| "Задеплой" | `deploy-app` — build → restart → verify (скрипты) |
| "Протестируй API" | `api-testing` — auth + тест (скрипты) |
| "Проанализируй данные" | `research` — schema → hypothesis |
| "Проверь код" | `code-review` — QA + CTO review |
| "Пиши тесты сначала" | `tdd-workflow` — Red → Green → Refactor |
| "Создай правило" | `create-rules` — шаблон + naming |
| "Найди незаконченное" | `gap-analysis` — TODO, пустые handlers |
| "Доработай задачу" | `fix-last-task` — RCA + доработка |
| "Внедри улучшения" | `backlog-to-rules` — 7 фаз |

### Что вызывать вручную

**Через `@` (rules_alone):**

| Вызов | Что получите |
|---|---|
| `@ajtbd-evaluation` | JTBD-анализ лендинга/интерфейса |
| `@core-duplicate-check` | Проверка на дубли перед созданием файла |
| `@from-the-end` | Методология "от конца" для сложных задач |

**Через `/` (explicit-only skill):** `/techdebt-scan` — сканирование oversized файлов, TODO/FIXME.

Если агент не подключает skill — скажите: "используй development skill".

---

### Config и универсальность

**Все rules/skills универсальны.** Project-specific значения — только в `project.config.json`:

```json
{
  "project_name": "myproject",
  "site_url": "https://myproject.example.com",
  "services": { "backend": { "name": "myproject-api", "port": 5003 } }
}
```

Скрипты читают config через `_shared/load-config.sh` (работает с `jq` или `python3`).

**Secrets** — `.cursor/.secrets/` (gitignored). **Data** — `.cursor/data/` (error-log, improvements-backlog).

**Самоулучшение:** Ошибка → `session-review` → `improvements-backlog.md` → `@backlog-to-rules` → Новое правило.

**Валидация:** `bash scripts/validate-rules.sh` — cross-references, frontmatter, placeholders, routing table.

---

### Установка на другой проект

**Что менять:** `project.config.json`, `CLAUDE.md`, `AGENTS.md`, `.secrets/`.

**Что НЕ менять:** `rules/`, `skills/`, `rules_alone/` — универсальны.

```bash
cp -r .cursor CLAUDE.md AGENTS.md .cursorignore /path/to/project/
cd /path/to/project
cp .cursor/config/project.config.example.json .cursor/config/project.config.json
# Заполните config → готово
```

Или попросите AI: *"Адаптируй `.cursor/` под этот проект, заполни config, опиши проект в CLAUDE.md."*

---

## Полный состав

| Компонент | Количество | Детали |
|---|---|---|
| **Rules** | 16 | 1 always + 3 auto + 12 agent |
| **Skills** | 14 | 4 с shell-скриптами, 4 с references |
| **Rules Alone** | 3 | ajtbd-evaluation, duplicate-check, from-the-end |
| **Claude Code agents** | 5 | deploy, developer, researcher, reviewer, tester |
| **Shell scripts** | 9 | deploy (4), testing (2), scanning (3) |
| **Validation** | 2 | validate-rules.sh, migrate-to-claude-code.sh |

---

## FAQ

**Q: Нужно писать "используй core-master.mdc"?** — Нет, автоматически.

**Q: Как добавить правило?** — "Создай правило для X" → `create-rules` skill.

**Q: Как задеплоить?** — "Задеплой" → `deploy-app` с скриптами.

**Q: Как вызвать ручную инструкцию?** — `@имя-файла` в сообщении.

**Q: Как проверить целостность?** — `bash scripts/validate-rules.sh`.

**Q: Claude Code поддерживается?** — Да. `.claude/` + `scripts/migrate-to-claude-code.sh`.

**Q: Как перенести?** — Скопируйте `.cursor/`, заполните config. Всё универсально.

---

## Лицензия

MIT License — [GitHub](https://github.com/dmitryprg-ai/cursor-develop-autorules) | [Cursor IDE](https://cursor.com/) | [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

**Версия:** 12.2 | **Дата:** 2026-02-11
