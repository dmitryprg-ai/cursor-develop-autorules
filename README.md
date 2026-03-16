# AI Rules — Система инструкций для AI-агентов (Cursor IDE + Claude Code)

<p align="center">
  <img src="https://img.shields.io/badge/version-13.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/claude--code-native-purple" alt="Claude Code Native">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **Полноценная dual-IDE система правил и навыков для AI-агентов: Cursor IDE (.cursor/) и Claude Code (.claude/) с подагентами, автоматическими проверками, оценкой качества навыков и циклом самоулучшения**

---

## Что это?

Библиотека инструкций для AI-ассистентов в [Cursor IDE](https://cursor.com/) и [Claude Code](https://docs.anthropic.com/en/docs/claude-code):

- **15 навыков (skills)** для любых задач — от разработки до деплоя и аналитики кеша
- **10 правил (rules)** для Claude Code — контекстные ограничения с объяснением «почему»
- **5 подагентов** (developer, reviewer, researcher, tester, deploy) с привязанными навыками
- **Автоматическая оценка качества** — evals с assertions на каждый навык
- **Цикл самоулучшения** — обучение на ошибках → новые правила
- **Методология skill-creator** — навыки построены по [официальному плагину Anthropic](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)

| Метрика | До (v12) | После (v13) |
|---|---|---|
| Задачи без переделок | ~50% | >80% |
| Повторные ошибки | ~30% | <10% |
| Покрытие навыков оценками | 0% | 100% |
| Соответствие skill-creator | ~20% | 100% |

---

## Архитектура v13.0

```
your-project/
├── .claude/                           # Claude Code — основная среда
│   ├── settings.json                  # Разрешения (allow/deny) + хуки
│   ├── launch.json                    # Dev-серверы для Preview
│   ├── MEMORY.md                      # Накопленные паттерны проекта
│   ├── agents/                        # 5 подагентов (deploy, developer, ...)
│   ├── rules/                         # 10 правил (.md с YAML-frontmatter)
│   └── skills/                        # 15 навыков (SKILL.md + scripts/ + evals/)
│       ├── deploy-app/                #   Деплой: build → restart → verify
│       ├── development/               #   Разработка: JTBD + TDD
│       ├── bugfix/                    #   Баг-фикс: 5 Whys RCA
│       ├── code-review/               #   Ревью: QA + CTO
│       ├── tdd-workflow/              #   TDD: Red → Green → Refactor
│       ├── refactoring/               #   Рефакторинг: тесты → малые шаги
│       ├── research/                  #   Аналитика: SQL/TypeScript/Python
│       ├── api-testing/               #   API-тесты: auth + curl-скрипты
│       ├── session-review/            #   Ретроспектива: конец сессии
│       ├── gap-analysis/              #   Поиск пробелов: TODO, стабы
│       ├── techdebt-scan/             #   Техдолг: файлы, TODO/FIXME
│       ├── create-rules/              #   Создание правил и навыков (skill-creator)
│       ├── fix-last-task/             #   Доработка: RCA + исправление
│       ├── backlog-to-rules/          #   Внедрение улучшений из бэклога
│       ├── cache-analysis/            #   Анализ кеша: стоимость, эффективность
│       └── _shared/                   #   Общие скрипты (load-config.sh)
│
├── .cursor/                           # Cursor IDE — параллельная конфигурация
│   ├── config/                        # project.config.json ← адаптация здесь
│   ├── rules/                         # 16 правил (.mdc: always/auto/agent)
│   ├── skills/                        # 13 навыков (.cursor-формат)
│   ├── rules_alone/                   # 3 ручных инструкции (вызов через @)
│   ├── data/                          # error-log, improvements-backlog
│   └── .secrets/                      # Credentials (gitignored)
│
├── CLAUDE.md                          # Контекст проекта (авто-загрузка)
├── AGENTS.md                          # Дополнительный контекст
└── scripts/                           # validate-rules.sh
```

### Что нового в v13

| Аспект | v12 | v13 |
|---|---|---|
| Claude Code | 4 правила, 0 навыков | 10 правил, 15 навыков, 5 агентов |
| Навыки | Жёсткие инструкции | «Почему» > «Нельзя» (skill-creator) |
| Описания навыков | Общие | Контекстные триггеры (pushy) |
| Оценка качества | Нет | evals с assertions на каждый навык |
| Кеш-аналитика | Нет | cache-analysis (hit rate, стоимость, оценка) |
| Dev Preview | Нет | launch.json (backend + frontend) |
| Память проекта | Нет | MEMORY.md — накопленные паттерны |

---

## Быстрый старт

### Для Claude Code (рекомендуется)

```bash
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git
cp -r cursor-develop-autorules/.claude /path/to/your/project/
cp cursor-develop-autorules/{CLAUDE.md,AGENTS.md} /path/to/your/project/

# Отредактируйте CLAUDE.md и AGENTS.md под свой проект
# Отредактируйте .claude/MEMORY.md — опишите архитектуру и ключевые паттерны
```

### Для Cursor IDE

```bash
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/{CLAUDE.md,AGENTS.md,.cursorignore} /path/to/your/project/

cd /path/to/your/project
cp .cursor/config/project.config.example.json .cursor/config/project.config.json
# Заполните: project_name, site_url, services, auth, verify_pages
```

### Для обоих (dual-IDE)

```bash
cp -r cursor-develop-autorules/{.cursor,.claude,CLAUDE.md,AGENTS.md,.cursorignore,scripts} /path/to/your/project/
```

Или попросите AI: *"Я скопировал `.cursor/` и `.claude/` из cursor-develop-autorules. Адаптируй конфигурацию под этот проект."*

---

## Руководство пользователя

### Как это работает

**Главный протокол** (`core-master`) загружается в каждый диалог и автоматически:
1. Оценивает сложность задачи (SIMPLE / STANDARD / COMPLEX)
2. Выбирает навык из Routing Table
3. Запускает проверки (Cross-check, Challenge)
4. Формирует DONE-блок с уровнем уверенности

**Правила** подключаются по контексту — при работе с определёнными файлами или по решению агента.

### Навыки — по контексту запроса

| Ваш запрос | Навык | Что делает |
|---|---|---|
| "Добавь фильтр по дате" | `development` | JTBD-анализ + TDD + проверка дублей |
| "Не работает кнопка" | `bugfix` | 5 Whys RCA → исправление → верификация |
| "Упрости сервис" | `refactoring` | Тесты → малые шаги → проверка |
| "Задеплой" | `deploy-app` | build → restart → health check (скрипты) |
| "Протестируй API" | `api-testing` | Авторизация + curl-тесты (скрипты) |
| "Проанализируй данные" | `research` | Схема → гипотеза → SQL/TS/Python |
| "Проверь код" | `code-review` | QA + CTO review (только чтение) |
| "Пиши тесты сначала" | `tdd-workflow` | Red → Green → Refactor |
| "Создай правило" | `create-rules` | Шаблон + evals + валидация |
| "Найди незаконченное" | `gap-analysis` | Сканирование TODO, пустых handlers |
| "Доработай задачу" | `fix-last-task` | RCA + исправление + improvement |
| "Внедри улучшения" | `backlog-to-rules` | Группировка → реализация → статусы |
| "Покажи стоимость сессий" | `cache-analysis` | Hit rate, экономия, оценка A–F |

**Через `/` (явный вызов):** `/techdebt-scan` — сканирование oversized файлов, TODO/FIXME.

Если агент не подключает навык — скажите: *"используй development skill"*.

### Подагенты Claude Code

| Агент | Навыки | Модель | Особенность |
|---|---|---|---|
| `developer` | development, tdd-workflow | sonnet | JTBD + проверка дублей |
| `reviewer` | code-review | sonnet | Только чтение (без Write/Edit/Bash) |
| `researcher` | research | sonnet | Data-first анализ |
| `tester` | tdd-workflow | sonnet | Строгий Red-Green-Refactor |
| `deploy` | deploy-app | haiku | Быстрый build + restart |

### Cursor IDE: ручные инструкции

**Через `@` (rules_alone):**

| Вызов | Что получите |
|---|---|
| `@ajtbd-evaluation` | JTBD-анализ лендинга/интерфейса |
| `@core-duplicate-check` | Проверка на дубли перед созданием файла |
| `@from-the-end` | Методология «от конца» для сложных задач |

---

### Config и универсальность

**Все правила и навыки универсальны.** Специфичные значения проекта — только в `project.config.json` (Cursor) или `MEMORY.md` (Claude Code).

Скрипты читают config через `_shared/load-config.sh` (работает с `jq` или `python3`).

**Самоулучшение:** Ошибка → `session-review` → `improvements-backlog.md` → `backlog-to-rules` → Новое правило.

---

### Установка на другой проект

**Что менять:** `CLAUDE.md`, `AGENTS.md`, `.claude/MEMORY.md`, `project.config.json`, `.secrets/`.

**Что НЕ менять:** `rules/`, `skills/`, `agents/` — универсальны.

Или попросите AI: *"Адаптируй конфигурацию под этот проект — заполни CLAUDE.md, MEMORY.md, config."*

---

## Полный состав

| Компонент | Количество | Детали |
|---|---|---|
| **Claude Code правила** | 10 | 2 always + 4 path-scoped + 4 agent-decided |
| **Claude Code навыки** | 15 | С evals, scripts, references |
| **Claude Code агенты** | 5 | deploy, developer, researcher, reviewer, tester |
| **Cursor правила** | 16 | 1 always + 3 auto + 12 agent (.mdc) |
| **Cursor навыки** | 13 | Cursor-формат |
| **Cursor rules_alone** | 3 | ajtbd-evaluation, duplicate-check, from-the-end |
| **Shell-скрипты** | 9+ | deploy (4), testing (2), scanning (3), cache (1) |
| **Evals** | 15 | По 2–3 тест-кейса на каждый навык |

---

## FAQ

**Q: Работает автоматически?** — Да, главный протокол загружается в каждый диалог.

**Q: Как добавить правило/навык?** — *"Создай правило для X"* → `create-rules` навык (по методологии skill-creator).

**Q: Как задеплоить?** — *"Задеплой"* → `deploy-app` навык с shell-скриптами.

**Q: Как проверить эффективность кеша?** — *"Покажи стоимость сессий"* → `cache-analysis` навык.

**Q: Claude Code или Cursor?** — Оба поддерживаются. `.claude/` — нативная поддержка с агентами, хуками и preview. `.cursor/` — полная конфигурация для Cursor IDE.

**Q: Как установить на другой проект?** — Скопируйте `.claude/` и/или `.cursor/`, адаптируйте `CLAUDE.md` и `MEMORY.md`.

**Q: Что такое evals?** — Тест-кейсы для оценки качества навыков. Каждый навык имеет `evals/evals.json` с 2–3 промптами и assertions.

---

## Лицензия

MIT License — [GitHub](https://github.com/dmitryprg-ai/cursor-develop-autorules) | [Cursor IDE](https://cursor.com/) | [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

**Версия:** 13.0 | **Дата:** 2026-03-13
