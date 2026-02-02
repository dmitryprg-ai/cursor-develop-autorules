# Changelog

Все заметные изменения в библиотеке AI-инструкций документируются здесь.

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.0.0/),
версионирование соответствует [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Типы изменений:**
> - `Added` — новая функциональность
> - `Changed` — изменения в существующей функциональности
> - `Deprecated` — функциональность, которая будет удалена
> - `Removed` — удалённая функциональность
> - `Fixed` — исправления ошибок
> - `Security` — исправления уязвимостей

---

## [10.1.0] - 2026-01-14

### Added — API TESTING STANDARD

**Новое always-правило для тестирования API:**

- **`standard-api-testing-always.mdc`** v1.0 — тестирование с авторизацией:
  - Два уровня авторизации: Basic Auth (nginx) + Session Auth (API)
  - Процесс получения сессии через login endpoint
  - Cleanup session files после тестов
  - Секреты в `.cursor/.secrets/` (заигнорены в git)

### Updated — DOCUMENTATION

- Обновлены `standard-file-size-limits-always.mdc` и `standard-tdd.mdc`
- Синхронизированы все правила между `.cursor/` и `git/.cursor/`

### Statistics v10.1

| Метрика | v10.0 | v10.1 |
|---------|-------|-------|
| Файлов в rules/ | 27 | 30 (+3) |
| alwaysApply: true | 9 | 10 (+1) |

---

## [10.0.0] - 2026-02-02

### Added — KISS/YAGNI/MVP PRINCIPLES

**Новое always-правило для борьбы с over-engineering:**

- **`standard-kiss-yagni-always.mdc`** v1.1 — принципы простоты кода:
  - **KISS** — Simplicity beats complexity, Less code = fewer bugs
  - **YAGNI** — No code "for later", Current requirements ONLY
  - **MVP Mindset** — Start simple, Clear initialization
  - **One Way Principle** — Single way to do X (logging, config, errors)
  - **Complexity Checklist** — 5 обязательных вопросов перед усложнением
  - **Over-Engineering Red Flags** — 8 СТОП-сигналов
  - Ссылка на локальный контекст: `.cursor_additional/{project}/`

### Updated — CLAUDE.md

- Добавлен блок **MAIN PRINCIPLES (ОБЯЗАТЕЛЬНО)** в начало файла
- KISS, YAGNI, MVP Mindset, One Way Principle
- Complexity Checklist и Over-Engineering Red Flags

### Statistics v10.0

| Метрика | v9.0 | v10.0 |
|---------|------|-------|
| Файлов в rules/ | 26 | 27 (+1) |
| alwaysApply: true | 8 | 9 (+1) |
| Покрытие MAIN PRINCIPLES | — | **100%** (36/36 правил) |

---

## [9.0.0] - 2026-02-02

### Added — NEW ALWAYS-APPLY STANDARDS

**Новые правила (alwaysApply: true):**

- **`standard-api-pagination-always.mdc`** v1.0 — правила работы с пагинированными API:
  - НИКОГДА не полагаться только на `response.length < limit`
  - ВСЕГДА использовать `total` из метаданных ответа
  - Safety limits как ДОПОЛНИТЕЛЬНАЯ защита
  - Чеклист и примеры для различных API (Bitrix24, Salesforce, HubSpot)
  - Real-world bug example: бесконечный цикл загрузивший 333000+ записей

- **`standard-react-hooks-always.mdc`** v1.0 — правила использования React хуков:
  - Хуки ВСЕГДА в начале компонента, ДО early returns
  - Хуки НЕ вызываются условно (внутри if/else, циклов, try/catch)
  - Проверки данных — ВНУТРИ callback хука
  - Предотвращает React Error #310, #300

### Added — TECHDEBT COMMAND

**Новая команда для поиска технического долга:**

- **`rules_alone/techdebt-manual.mdc`** v1.0 — команда `/techdebt`:
  - 5 фаз: SCAN → ANALYZE → PRIORITIZE → REPORT → BACKLOG
  - Поиск файлов > 300 строк (согласно file-size-limits)
  - Поиск дублирующегося кода через semantic search и grep
  - Выявление code smells (длинные функции, глубокая вложенность)
  - Приоритизация по Impact/Effort матрице
  - Quick Wins выделяются отдельно
  - Запуск: `@rules_alone/techdebt` или "запусти techdebt scan"

### Updated — DOCUMENTATION

- **`ARCHITECTURE.md`** v8.1 → v9.0 — добавлены новые стандарты
- **`HOW-TO-USE.md`** v5.1 → v6.0 — документация по новым правилам и командам
- **`git/README.md`** v8.1 → v9.0 — актуализирован под v9.0
- **`git/README-EN.md`** v8.1 → v9.0 — актуализирован под v9.0

### Statistics

| Метрика | v8.1 | v9.0 |
|---------|------|------|
| Файлов в rules/ | 24 | 26 (+2) |
| Файлов в rules_alone/ | 5 | 6 (+1) |
| alwaysApply: true | 6 | 8 (+2) |

---

## [8.1.0] - 2026-01-14

### Added — FILE SIZE LIMITS STANDARD

**Задача:** Контроль размера файлов для предотвращения "монолитов"

**Новый файл:**
- **`standard-file-size-limits-always.mdc`** v1.0 — контроль размера файлов:
  - Soft/Hard limits для разных типов файлов (Routes: 200/400, Services: 250/500)
  - Файл > 300 строк = план разбиения ПЕРЕД добавлением кода
  - Разбиение по бизнес-доменам, НЕ по техническим слоям
  - Структуры разбиения для Backend (Express) и Frontend (React)
  - Процесс инкрементального разбиения

### Changed — SERVICE RESTART & FILE SIZE INTEGRATION

**`protocol-development.mdc`** v2.2 → v2.3:
- Добавлена ссылка на `standard-file-size-limits-always.mdc` в Context
- ПРАВИЛО #5: Перезапуск сервисов Backend/Frontend после изменений
- ПРАВИЛО #6: Соблюдать стандарт file-size-limits при проектировании
- PRE-ACTION: добавлен шаг 4 "Control File Size"
- EXECUTE: добавлен шаг 5 "Перезапустить сервисы"
- Critical Points: добавлен "Check Service Restart"

**`protocol-refactoring.mdc`** v1.1 → v1.2:
- Workflow: добавлен шаг "PREPLAN" со ссылкой на file-size-limits
- Golden Rules: добавлено правило "RULES FIRST" — соблюдение file-size-limits

### Updated — DOCUMENTATION

- **`ARCHITECTURE.md`** v8.0 → v8.1 — добавлен standard-file-size-limits-always.mdc
- **`HOW-TO-USE.md`** v5.0 → v5.1 — документация по контролю размера файлов
- **`git/README.md`** v4.0 → v8.0 — актуализирован под v8.1
- **`git/README-EN.md`** v4.0 → v8.0 — актуализирован под v8.1

---

## [8.0.0] - 2026-01-12

### Changed — UNIVERSALITY REQUIREMENT

**Задача:** Сделать все правила универсальными для использования в любых проектах

**Проблема:**
- Правила содержали проектные привязки (Bitrix24, DealsTable, PostgreSQL bigint)
- Примеры были проектно-специфичными (module.types.ts → ...)
- Правила нельзя было переносить в другие проекты без переделки

**Решение:**

1. **Добавлен стандарт универсальности** в `standart-generating-agent.mdc`:
   - Секция "🌍 Universality Requirement (CRITICAL)"
   - Таблица "Где хранить проектную специфику"
   - Invalid examples с проектными привязками

2. **Обновлены правила (7 файлов):**
   - `protocol-development.mdc` — "Project-Specific Rules" → "Common Pitfalls (универсальные)"
   - `standard-qa.mdc` — `DealsTable` → `<ComponentName>`
   - `_base-rat.mdc` — "Bitrix24" → "внешний API"
   - `_base-todo-usage.mdc` — `DealsTable` → `<DataTable>`
   - `protocol-session-review.mdc` — "Tailwind v4" → "CSS-фреймворк"
   - `core-rules-standard-format-always.mdc` — добавлено требование универсальности
   - `workflows-site-basic-auth-always.mdc` — убраны конкретные URL/креды

3. **Проектная специфика вынесена в:**
   - Секреты → `.cursor/.secrets/*`
   - Архитектура проекта → `AGENTS.md`
   - Lessons learned → `.cursor_additional/{project}/improvements-backlog.md`

### Added
- **`workflows-site-basic-auth-always.mdc`** — универсальное правило для Basic Auth
- **`core-rules-standard-format-always.mdc`** — always-правило для генерации rules по стандарту
- **`.cursor/.secrets/`** — папка для секретов проекта (добавлена в .gitignore)

---

## [7.0.0] - 2026-01-12

### Changed — STANDARD FORMAT COMPLIANCE

**Задача:** Привести все правила к стандарту `standart-generating-agent.mdc`

**Изменения:**

1. **Все файлы по новому стандарту:**
   - description в ACTION-TRIGGER-OUTCOME формате
   - Структура: Context → Requirements → Examples → Critical Points
   - XML теги: `<critical>`, `<required>`, `<example>`
   - Tags для категоризации

2. **Обновлённые файлы (22 шт):**
   - `core-master.mdc` v3.1
   - `_base-forbidden.mdc` v2.1
   - `_base-crosscheck.mdc` v2.1
   - `_base-challenge.mdc` v2.1
   - `_base-confidence.mdc` v2.1
   - `_base-todo-usage.mdc` v1.1
   - `_base-5wh.mdc` v1.1
   - `_base-jtbd-thinking.mdc` v1.1
   - `_base-rat.mdc` v1.2
   - `protocol-development.mdc` v2.2
   - `protocol-bugfix.mdc` v1.1
   - `protocol-research.mdc` v1.1
   - `protocol-refactoring.mdc` v1.1
   - `protocol-freeze-recovery.mdc` v1.1
   - `protocol-session-review.mdc` v1.1
   - `protocol-prepare-prompt.mdc` v1.1
   - `standard-agent-quality.mdc` v1.1
   - `standard-rca.mdc` v1.1
   - `standard-qa.mdc` v1.1
   - `standard-tdd.mdc` v1.1
   - `standard-cto-review.mdc` v1.1
   - `error-learning.mdc` v1.1

3. **Обновлённая документация:**
   - `ARCHITECTURE.md` v7.0
   - `HOW-TO-USE.md` v5.0
   - `rules_alone/HOW-TO-USE.md` v1.3

### Сохранено
- Весь контекст и WHY из оригинальных правил
- Архитектура flow (core → protocol → _base)
- Имена файлов (для совместимости)

---

## [3.0.0] - 2026-01-10

### Changed — MAJOR REFACTORING

**Проблема:** Инструкции игнорировались, AI пропускал шаги.

**Решение:**
- core-master.mdc сокращён до ~150 строк
- Критические модули `alwaysApply: true`
- DONE блок обязателен в конце ответа

### Added
- **`rules_alone/fix-last-task.mdc`** — протокол исправления недоработок

---

## [3.1.2] - 2026-01-10

### Changed
- **`README.md`** и **`README-EN.md`** — исправлена структура и актуализированы пути
  - Обновлена диаграмма архитектуры с `.cursor_additional/{projectname}/`
  - Исправлен путь к improvements-backlog.md (был в корне, стал в `.cursor_additional/`)
  - Убрано дублирование секций
  - Добавлен реальный URL репозитория GitHub
  - Обновлены бейджи версий до 3.1

---

## [3.1.1] - 2026-01-10

### Added
- **`README.md`** и **`README-EN.md`** — новая секция "Фиксирование сбоев и проведение самоулучшения"
  - Описание механизма обучения на ошибках
  - Инструкция по созданию improvements-backlog.md
  - Формат записи ошибок в backlog
  - Как запускать `@rules_alone/backlog-to-rules`
  - Реальный пример улучшения

### Changed
- **`README.md`** v3.0 → v3.1
- **`README-EN.md`** v3.0 → v3.1

---

## [3.1.0] - 2026-01-10

### Added
- **`protocol-prepare-prompt.mdc`** v1.2 — секция 1.2 "Explicit Constraints Extraction"
  - Дословное цитирование запроса пользователя
  - Red Flags для обнаружения интерпретации
  - Источник: Improvement #11

- **`_base-rat.mdc`** v1.1 — секция 0 "Понимание запроса"
  - TOP-1 риск: "Я правильно понял запрос"
  - Проверка интерпретации vs буквального следования
  - Источник: Improvement #12

- **`_base-crosscheck.mdc`** v1.1 — секция 6 "Output vs Literal Request"
  - Сравнение результата с буквальным текстом запроса
  - Таблица соответствия требований
  - Источник: Improvement #13

- **`protocol-development.mdc`** v2.1:
  - Секция 1.4 "Find Working Example" — Don't Invent, Copy First
  - Секция 3.1 "Production Deployment Check" — проверка перезапуска сервиса
  - Источники: Improvements #8, #9

- **`AGENTS.md`** v1.1 — секция "Tailwind v4 Specifics"
  - Документация работающих паттернов из /settings/schedule
  - Warning о responsive prefixes
  - Источник: Improvement #10

### Changed
- **`improvements-backlog.md`** — внедрено 6 HIGH priority улучшений (#8-#13)
- **Паттерн "Интерпретация vs Следование"** — теперь предотвращается на 3 уровнях:
  1. RAT: Риск #0 при планировании
  2. Prepare-prompt: Explicit constraints при анализе
  3. Cross-check: Output vs Request при верификации

---

## [3.0.0] - 2026-01-10

### Added
- **`.cursor_additional/`** — новая папка для проект-специфичных файлов
  - `{projectname}/` — CONTEXT.md, improvements-backlog и другие проектные файлы
  - `archive/` — архивные инструкции (бывший rules_arch)
  - `templates/` — шаблоны для создания новых инструкций
- **`git/AGENTS.md`** — универсальный шаблон AGENTS.md для новых проектов

### Changed
- **Реструктуризация** — `.cursor/` теперь полностью универсальная
  - Удалены папки `rules_arch/` и `template/` (перенесены в `.cursor_additional/`)
  - Удалён `CONTEXT.md` из `.cursor/` (перенесён в `.cursor_additional/{projectname}/`)
  - Инструкции ссылаются только на файлы внутри `.cursor/`
- **`ARCHITECTURE.md`** v5.4 → v6.0
  - Обновлена структура под Universal Structure
  - Убраны ссылки на rules_arch и template
- **`HOW-TO-USE.md`** v3.0 → v4.0
  - Убраны ссылки на rules_arch, template, CONTEXT.md
  - Обновлены FAQ
- **`git/`** — содержит только файлы для копирования в корень нового проекта
  - `AGENTS.md` — шаблон для нового проекта
  - `README.md` и `README-EN.md` — документация
  - **НЕ содержит .cursor/** — папка .cursor копируется отдельно

### Removed
- `rules_arch/` из `.cursor/` (перенесён в `.cursor_additional/archive/`)
- `template/` из `.cursor/` (перенесён в `.cursor_additional/templates/`)
- `CONTEXT.md` из `.cursor/` (перенесён в `.cursor_additional/{projectname}/`)
- `RECOMMENDATIONS-rules-improvements.md` из `rules/` (перенесён в `.cursor_additional/{projectname}/`)
- `HOW-TO-USE.md` дубликат из корня `.cursor/`
- `{projectname}-improvements-backlog.md` из корня проекта (перенесён в `.cursor_additional/{projectname}/`)

---

## [2.1.0] - 2026-01-10

### Added
- **`_base-rat.mdc`** — новый базовый модуль Riskiest Assumption Test
  - 3 шага RAT: Выписать → Отранжировать → Проверить
  - Типичные категории рисков для кодинга
  - Quick RAT шаблон для PLAN PHASE
  - Checklist для применения

### Changed
- **`core-master.mdc`** v2.0 → v2.1
  - Добавлена секция 3.6 RAT в BASE MODULES
  - В PLAN PHASE добавлен шаг "🔍 RAT: Выписать и проверить TOP рисков"
  - В MASTER CHECKLIST добавлена проверка RAT
  - Количество BASE MODULES: 7 → 8
- **`protocol-prepare-prompt.mdc`** v1.0 → v1.1
  - Добавлена секция 3.5 RAT — ПРОВЕРКА РИСКОВ В ПРОМТЕ
  - В checklist добавлена проверка RAT для STANDARD/COMPLEX
- **`ARCHITECTURE.md`** v5.3 → v5.4
  - Добавлен `_base-rat.mdc` в список BASE MODULES
  - Обновлено количество файлов: 22 → 23

---

## [2.0.0] - 2026-01-09

### Added
- **`protocol-prepare-prompt.mdc`** — протокол подготовки и улучшения промта
  - 5-компонентная формула: Goal/Context/Constraints/Success/Protocol
  - Quick version для STANDARD задач
  - Интеграция с core-master.mdc
- **`standard-agent-quality.mdc`** — метрики успеха AI агента
  - Target метрики: Linter errors = 0, First-time quality >80%
  - Guardrails и ограничения
  - Feedback loop
- **`_base-jtbd-thinking.mdc`** — JTBD-мышление для user-facing фич
- **`error-learning.mdc`** — протокол обучения на ошибках
- **`rules_alone/backlog-to-rules.mdc`** — внедрение улучшений из backlog

### Changed
- **`core-master.mdc`** полная переработка → v2.0
  - Секция 0: ПОДГОТОВКА ПРОМТА (обязательно для STANDARD/COMPLEX)
  - Адаптивный flow по сложности (SIMPLE/STANDARD/COMPLEX)
  - Inline версии BASE MODULES
  - Обязательный COMPLETION REPORT
  - MASTER CHECKLIST
- **`ARCHITECTURE.md`** v5.0 → v5.3
  - Добавлены все новые модули
  - Обновлены диаграммы потоков
- **`HOW-TO-USE.md`** v2.0 → v3.0
  - Полная переработка с примерами

### Removed
- Дублирующийся контент между инструкциями (вынесен в `_base-*` модули)

---

## [1.5.0] - 2026-01-08

### Added
- **`protocol-session-review.mdc`** — анализ сессии и накопление улучшений
- **`standard-cto-review.mdc`** — CTO/Tech Lead Review стандарт
- **`standard-tdd.mdc`** — Test-Driven Development стандарт
- **`rules_alone/ajtbd-evaluation.mdc`** — полный AJTBD-анализ

### Changed
- **`protocol-development.mdc`** v1.0 → v2.0
  - Добавлен JTBD Analysis
  - Добавлен Duplicate Check
  - Улучшена структура PLAN PHASE

---

## [1.4.0] - 2026-01-07

### Added
- **`_base-crosscheck.mdc`** — cross-check правила
- **`_base-forbidden.mdc`** — запрещённые действия
- **`standard-rca.mdc`** — Root Cause Analysis стандарт (5 Whys + 5W+H)
- **`rules_alone/core-duplicate-check.mdc`** — проверка дубликатов
- **`rules_alone/from-the-end.mdc`** — валидация с конца

### Changed
- **`protocol-bugfix.mdc`** — интеграция с RCA стандартом
- Все протоколы: добавлен cross-check как обязательный шаг

---

## [1.3.0] - 2026-01-06

### Added
- **`_base-5wh.mdc`** — формат 5W+H для структурированного анализа
- **`protocol-research.mdc`** — протокол исследования данных

### Changed
- **`protocol-bugfix.mdc`** — интеграция 5W+H анализа

---

## [1.2.0] - 2026-01-05

### Added
- **`_base-todo-usage.mdc`** — правила использования todo_tool
- **`_base-challenge.mdc`** — протокол Challenge (4 вопроса перед "готово")
- **`protocol-refactoring.mdc`** — протокол безопасного рефакторинга
- **`protocol-freeze-recovery.mdc`** — восстановление после зависания

### Changed
- **`core-master.mdc`** — добавлены ссылки на новые протоколы
- Все протоколы: добавлен Challenge Protocol

---

## [1.1.0] - 2026-01-04

### Added
- **`_base-confidence.mdc`** — калибровка уверенности AI агента
  - Формула вычетов: -50% код не протестирован, -40% артефакты не открыты, и т.д.
  - Порог 80% для готовности
- **`standard-qa.mdc`** — QA стандарты

### Changed
- Все протоколы: добавлен обязательный вывод уверенности

---

## [1.0.0] - 2026-01-03

### Added
- **`core-master.mdc`** v1.0 — Master Router Protocol
  - Единственный файл с `alwaysApply: true`
  - Маршрутизация по типам задач
  - Базовый PLAN → EXECUTE → VERIFY flow
- **`protocol-development.mdc`** v1.0 — разработка новых фич
- **`protocol-bugfix.mdc`** v1.0 — исправление ошибок
- **`ARCHITECTURE.md`** v1.0 — описание архитектуры инструкций
- **`HOW-TO-USE.md`** v1.0 — инструкция по использованию

### Notes
- Начальная версия библиотеки AI-инструкций
- Архитектура: один entry point (core-master) + специализированные протоколы

---

## Версии файлов

| Файл | Текущая версия |
|------|----------------|
| `core-master.mdc` | 3.1 |
| `ARCHITECTURE.md` | 9.0 |
| `HOW-TO-USE.md` | 6.0 |
| `standart-generating-agent.mdc` | 2.0 |
| `protocol-prepare-prompt.mdc` | 1.2 |
| `protocol-development.mdc` | 2.3 |
| `standard-file-size-limits-always.mdc` | 1.0 |
| `standard-api-pagination-always.mdc` | 1.0 |
| `standard-react-hooks-always.mdc` | 1.0 |
| `techdebt-manual.mdc` | 1.0 |
| `protocol-bugfix.mdc` | 1.1 |
| `protocol-refactoring.mdc` | 1.2 |
| `protocol-research.mdc` | 1.1 |
| `protocol-freeze-recovery.mdc` | 1.1 |
| `protocol-session-review.mdc` | 1.2 |
| `standard-agent-quality.mdc` | 1.1 |
| `standard-qa.mdc` | 1.2 |
| `standard-rca.mdc` | 1.1 |
| `standard-tdd.mdc` | 1.1 |
| `standard-cto-review.mdc` | 1.1 |
| `error-learning.mdc` | 1.1 |
| `_base-confidence.mdc` | 2.1 |
| `_base-todo-usage.mdc` | 1.2 |
| `_base-challenge.mdc` | 2.1 |
| `_base-5wh.mdc` | 1.1 |
| `_base-forbidden.mdc` | 2.1 |
| `_base-crosscheck.mdc` | 2.1 |
| `_base-jtbd-thinking.mdc` | 1.1 |
| `_base-rat.mdc` | 1.3 |
| `workflows-site-basic-auth-always.mdc` | 1.0 |
| `core-rules-standard-format-always.mdc` | 1.0 |
| `git/README.md` | 8.0 |
| `git/README-EN.md` | 8.0 |

---

**Последнее обновление:** 2026-02-02

