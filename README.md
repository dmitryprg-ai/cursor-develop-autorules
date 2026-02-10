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

## Руководство пользователя

### Что работает автоматически (без вашего участия)

Эти инструкции загружаются сами. Вам не нужно ничего писать, вызывать или помнить.

**Всегда активно:**

| Правило | Что обеспечивает |
|---------|-----------------|
| `core-master.mdc` | Определяет сложность задачи, требует план, проверки, DONE-блок. Роутит к нужному skill. Принуждает к KISS/YAGNI. |

**Активируется при открытии файлов определённого типа:**

| Правило | Когда | Что обеспечивает |
|---------|-------|-----------------|
| `standard-react-hooks-auto.mdc` | Открыт `*.tsx` или `*.jsx` | Хуки вызываются в правильном порядке, до early returns |
| `standard-radix-select-auto.mdc` | Открыт `*.tsx` | Запрещает `<SelectItem value="">` (вызывает crash) |

**Агент подключает сам (по ситуации):**

| Правило | Когда агент его подключит |
|---------|--------------------------|
| `standard-api-pagination-agent.mdc` | Пишется код с пагинацией API |
| `standard-file-size-limits-agent.mdc` | Создаётся/изменяется крупный файл |
| `workflows-site-basic-auth-agent.mdc` | Получен 401 при проверке сайта |
| `standard-agent-quality.mdc` | Фаза проверки задачи |
| `protocol-freeze-recovery.mdc` | Агент завис или зациклился |
| `error-learning.mdc` | Произошла ошибка, нужен анализ |
| `_base-5wh.mdc` | Нужен структурированный анализ проблемы |
| `_base-jtbd-thinking.mdc` | Разрабатывается user-facing фича |
| `_base-rat.mdc` | Планирование сложной задачи (проверка рисков) |
| `_base-todo-usage.mdc` | Задача требует декомпозиции на шаги |

**Агент также автоматически подключает skills по контексту вашего запроса:**

| Ваш запрос | Какой skill подключится |
|------------|------------------------|
| "Добавь фильтр по дате" | `development` — полный цикл разработки с JTBD и TDD |
| "Не работает кнопка сохранения" | `bugfix` — анализ через 5 Whys, fix корневой причины |
| "Упрости этот сервис" | `refactoring` — тесты перед изменениями, маленькие шаги |
| "Задеплой изменения" | `deploy-app` — build, restart, verify через shell-скрипты |
| "Проверь этот API" | `api-testing` — авторизация и тест через скрипты |
| "Проанализируй данные из CSV" | `research` — сначала schema, потом гипотеза |
| "Проверь качество кода" | `code-review` — QA чеклист и CTO review |
| "Пиши тесты сначала" | `tdd-workflow` — Red → Green → Refactor |
| "Создай новое правило" | `create-rules` — шаблон, naming, токен-бюджет |
| "Найди незаконченные фичи" | `gap-analysis` — сканирование TODO, пустых handlers |

---

### Что нужно вызывать вручную

**Ручные инструкции** (`rules_alone/`) — вызываются через `@` в сообщении:

| Как вызвать | Когда использовать | Что получите |
|-------------|-------------------|-------------|
| `@ajtbd-evaluation` | Хотите оценить лендинг или интерфейс | Полный JTBD-анализ: Job Stories, выгоды/налоги, оценка конверсии |
| `@backlog-to-rules` | Накопились улучшения, пора внедрять в правила | 7-фазный протокол внедрения из backlog |
| `@core-duplicate-check` | Перед созданием нового файла/класса/функции | Проверка на дублирование с матрицей уверенности |
| `@fix-last-task` | Последняя задача сделана плохо | Анализ + доработка с RCA и session review |
| `@from-the-end` | Задача сложная, хотите начать с результата | Методология "от конца": сначала ожидаемый выход |

**Пример:** напишите в чате `Проанализируй наш лендинг @ajtbd-evaluation` — агент загрузит инструкцию и проведёт полный JTBD-анализ.

**Explicit-only skill:**

| Как вызвать | Что получите |
|-------------|-------------|
| `/techdebt-scan` | Сканирование проекта: oversized файлы, TODO/FIXME, code smells. Запускает shell-скрипты. |

---

### Чем Skills отличаются от Rules

| | Rules (правила) | Skills (скилы) |
|---|---|---|
| **Что это** | Короткие ограничения и стандарты | Пошаговые рабочие процедуры |
| **Формат** | Один файл `.mdc` | Папка: `SKILL.md` + скрипты + справочные материалы |
| **Могут запускать скрипты** | Нет | Да — реальные `.sh` файлы |
| **Размер** | Компактные (< 100 строк) | Подробные (50–106 строк) + доп. файлы |
| **Метафора** | Техника безопасности: "так нельзя" | Инструкция по эксплуатации: "делай так" |
| **Пример правила** | "Хуки только до early return" | — |
| **Пример скила** | — | "Как задеплоить: build → restart → verify → check logs" |

**Когда что используется:**
- **Правило** — если нарушение приводит к багу. "Не делай X" → Rule.
- **Скил** — если нужна пошаговая процедура. "Как сделать Y" → Skill.

---

### Что ещё важно знать

**1. Config — единый источник project-specific значений**

Файл `.cursor/config/project.config.json` содержит URL сайта, имена сервисов, порты, пути к секретам, страницы для проверки. Все скрипты читают значения оттуда. Rules и skills **не содержат** захардкоженных значений — они универсальны для любого проекта.

**2. Secrets — credentials**

`.cursor/.secrets/` содержит файлы с паролями (Basic Auth, тестовый пользователь). Папка заигнорена в `.gitignore`.

**3. Shared loader — общий загрузчик config для скриптов**

Файл `.cursor/skills/_shared/load-config.sh` подключается всеми скриптами через `source`. Предоставляет переменные `PROJECT_ROOT`, `SITE_URL`, `BASIC_AUTH` и функцию `json_get` для чтения config. Работает с `jq` или `python3` как fallback.

**4. Цикл самоулучшения**

```
Ошибка → session-review skill → improvements-backlog.md → @backlog-to-rules → Новое правило/skill
```

Принцип "Rule of Three": кодифицируй правило после 3 повторений одной ошибки.

**5. Документация (`.cursor/docs/`)**

| Файл | Содержание |
|------|-----------|
| `ARCHITECTURE.md` | Техническая архитектура правил и скилов |
| `HOW-TO-USE.md` | Подробное руководство по работе |
| `CHANGELOG.md` | История всех изменений |

---

## Полный состав библиотеки

### Rules — 13 файлов

**Tier 1 — Always (1):** `core-master.mdc` — master protocol с KISS/YAGNI, Forbidden, Cross-check, Challenge, Confidence.

**Tier 2 — Auto (2):**

| Файл | Globs | Что делает |
|------|-------|------------|
| `standard-react-hooks-auto.mdc` | *.tsx, *.jsx | Порядок хуков |
| `standard-radix-select-auto.mdc` | *.tsx | Запрет value="" |

**Tier 3 — Agent (10):** api-pagination, file-size-limits, basic-auth, agent-quality, freeze-recovery, error-learning, 4x _base-* modules

### Skills — 12 директорий

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

### Rules Alone — 5 ручных инструкций

`ajtbd-evaluation`, `backlog-to-rules`, `core-duplicate-check`, `fix-last-task`, `from-the-end`

### .cursorignore

Исключает из контекста AI: `dist/`, `node_modules/`, `.next/`, `.git/`, секреты.

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

**Q: Нужно писать "используй core-master.mdc"?**
A: Нет, `core-master.mdc` применяется автоматически к каждому запросу.

**Q: Как добавить своё правило или skill?**
A: Скажите "создай правило для X" — агент подключит `create-rules` skill с шаблоном и naming-конвенцией.

**Q: Как запустить deploy?**
A: Скажите "задеплой" — агент подключит `deploy-app` skill и запустит нужные скрипты.

**Q: Как вызвать ручную инструкцию?**
A: Напишите `@имя-файла` в сообщении. Например: `@fix-last-task`.

**Q: Как запустить сканирование техдолга?**
A: Используйте `/techdebt-scan` — это explicit-only skill, он не подключается автоматически.

**Q: Как перенести в другой проект?**
A: Скопируйте `.cursor/`, отредактируйте `config/project.config.json`. Все rules/skills универсальны.

**Q: Агент не подключает нужный skill — что делать?**
A: Упомяните его явно: "используй development skill" или опишите задачу точнее.

---

## Лицензия

MIT License

## Ссылки

- [GitHub Repository](https://github.com/dmitryprg-ai/cursor-develop-autorules)
- [Cursor IDE](https://cursor.com/)

---

**Версия:** 12.1 | **Дата:** 2026-02-10
