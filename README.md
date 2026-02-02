# 🤖 Cursor AI Rules — Система инструкций для AI-агентов в Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-9.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **Модульная система правил и протоколов для повышения качества работы AI-агентов в Cursor IDE**

---

## 🎯 Что это?

**Cursor AI Rules** — это готовая библиотека инструкций для AI-ассистентов в [Cursor IDE](https://cursor.com/), которая:

- 📋 **Структурирует работу AI** — чёткие протоколы для разных типов задач
- 🔍 **Повышает качество** — встроенные проверки и верификация результатов
- 📊 **Калибрует уверенность** — AI честно оценивает надёжность своих выводов
- 🔄 **Накапливает опыт** — обучение на ошибках для предотвращения повторений
- ✅ **Гарантирует проверки** — Challenge protocol и Cross-check перед завершением

---

## 📈 Какой эффект вы получите?

| Метрика | До | После | Улучшение |
|---------|------|-------|-----------|
| Задачи без переделок | ~50% | >80% | **+30%** |
| Повторные ошибки | ~30% | <10% | **-20%** |
| Linter errors при сдаче | ~15% | 0% | **-15%** |
| Пропущенные edge cases | частые | редкие | **↓↓↓** |

### Реальные примеры улучшений:

**До:**
```
AI: "Готово! Компонент создан."
Реальность: Файл создан, но не открыт. Есть синтаксические ошибки. Не проверен linter.
```

**После:**
```
AI: "Уверенность: 95% → 45% — код написан, но не запускал"
    → Запускает код
    → Cross-check выполнен
    → Challenge protocol пройден
    "Уверенность: 92% — всё проверено"
    
    ✅ COMPLETION REPORT
    Protocol: protocol-development.mdc
    Standards: standard-tdd.mdc
    Base Modules: _base-confidence, _base-challenge, _base-crosscheck
```

---

## 🏗️ Архитектура

```
your-project/
├── .cursor/                       # ⭐ Универсальные инструкции
│   ├── CHANGELOG.md               # История изменений
│   ├── rules/                     # Основные инструкции (26 файлов)
│   │   ├── core-master.mdc        # Единая точка входа (alwaysApply: true)
│   │   ├── _base-*.mdc            # Базовые модули (8 шт)
│   │   ├── protocol-*.mdc         # Протоколы по типам задач (7 шт)
│   │   ├── standard-*.mdc         # Стандарты качества (8 шт)
│   │   └── error-learning.mdc     # Обучение на ошибках
│   │
│   └── rules_alone/               # Одиночные инструкции (6 файлов)
│       └── *.mdc                  # Вызываются явно через @
│
├── .cursor_additional/            # 📁 Проект-специфичные файлы
│   └── {projectname}/             # Папка для вашего проекта
│       ├── improvements-backlog.md # Накопление улучшений
│       └── error-log.md           # Логи ошибок
│
└── AGENTS.md                      # Quick Start для AI агентов
```

### Как работает:

```
Ваш запрос
    ↓
core-master.mdc (определяет сложность и тип)
    ↓
protocol-*.mdc (выполняет задачу)
    ↓
_base-*.mdc (применяет проверки)
    ↓
standard-*.mdc (верифицирует качество)
    ↓
✅ COMPLETION REPORT
```

---

## 🚀 Быстрый старт

### Шаг 1: Скопируйте файлы в ваш проект

```bash
# Клонируйте репозиторий
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git

# Скопируйте .cursor и AGENTS.md в ваш проект
cp -r cursor-develop-autorules/.cursor /путь/к/вашему/проекту/
cp cursor-develop-autorules/AGENTS.md /путь/к/вашему/проекту/
```

### Шаг 2: Готово!

Просто начните работать в Cursor IDE. Инструкции применяются **автоматически**.

```
Добавь компонент для отображения статистики
```

AI автоматически:
1. Определит сложность задачи (Simple/Standard/Complex)
2. Выберет подходящий протокол
3. Применит проверки и верификации
4. Выведет отчёт о выполнении

---

## 📋 Состав библиотеки

### 🔄 Протоколы (7 штук)

| Протокол | Когда применять |
|----------|-----------------|
| `protocol-prepare-prompt` | Улучшение промта пользователя перед выполнением |
| `protocol-development` | Разработка новых фич |
| `protocol-bugfix` | Исправление ошибок |
| `protocol-refactoring` | Рефакторинг кода |
| `protocol-research` | Анализ данных (parquet, csv, SQL) |
| `protocol-freeze-recovery` | Восстановление после зависания AI |
| `protocol-session-review` | Анализ сессии и накопление улучшений |

### 📦 Базовые модули (8 штук)

| Модуль | Что делает |
|--------|------------|
| `_base-confidence` | Калибровка уверенности AI (формула вычетов) |
| `_base-challenge` | 4 вопроса перед "готово" |
| `_base-crosscheck` | Независимая проверка результатов |
| `_base-forbidden` | Критические запреты |
| `_base-todo-usage` | Правила использования TODO |
| `_base-5wh` | Формат 5W+H для анализа |
| `_base-jtbd-thinking` | JTBD-мышление для user-facing фич |
| `_base-rat` | **NEW:** Riskiest Assumption Test — проверка рисков ДО реализации |

### 📋 Стандарты качества (8 штук)

| Стандарт | Назначение |
|----------|------------|
| `standard-agent-quality` | Метрики успеха и границы агента |
| `standard-qa` | QA критерии приёмки |
| `standard-rca` | Root Cause Analysis (5 Whys) |
| `standard-tdd` | Test-Driven Development |
| `standard-cto-review` | CTO/Lead Review для сложных задач |
| `standard-file-size-limits` | Контроль размера файлов (< 300 строк) |
| `standard-api-pagination` | **NEW:** Правила пагинации API (предотвращает бесконечные циклы) |
| `standard-react-hooks` | **NEW:** Правила React хуков (предотвращает Error #310) |

### 🎯 Одиночные инструкции (6 штук)

Вызываются явно через `@`:

```
@rules_alone/core-duplicate-check Проверь дубликаты перед созданием
@rules_alone/ajtbd-evaluation Оцени лендинг
@rules_alone/backlog-to-rules Внедри улучшения из backlog
@rules_alone/fix-last-task Исправь недоработки последней задачи
@rules_alone/techdebt Запусти поиск технического долга
```

### 🧹 Команда /techdebt (NEW in v9.0)

Запуск в конце сессии для поиска и документирования технического долга:

```
@rules_alone/techdebt Запусти techdebt scan
```

**Что делает:**
- Сканирует файлы > 300 строк
- Ищет дублирующийся код
- Выявляет code smells (длинные функции, глубокая вложенность)
- Приоритизирует по Impact/Effort
- Выделяет Quick Wins
- Записывает P0-P1 проблемы в backlog

---

## 💡 Ключевые концепции

### 0. RAT — Riskiest Assumption Test

Проверка рискованных предположений **ДО** начала реализации:

```
RAT = 3 шага:
1. Выписать ВСЕ предположения
2. Отранжировать по риску (что может "убить" решение)
3. Проверить TOP-1 риск ПЕРЕД кодингом

Если риск опровергнут → пересмотреть план!
```

**Типичные риски в кодинге:**
- 🔧 Подход/библиотека подходит?
- 📊 Данные/API как ожидается?
- 🔗 Не сломает существующий код?

> Источник: [Иван Замесин — RAT](https://zamesin.ru/books/product-howto/riskiest-assumption-test/)

### 1. Калибровка уверенности

AI честно оценивает надёжность своих выводов:

```
Уверенность = 100% минус:
• Код не протестирован: -50%
• Артефакты не открыты: -40%
• Нет cross-check: -30%
• Предположения не проверены: -25%

Порог: <80% = не готово
```

### 2. Challenge Protocol

Перед каждым "готово" AI задаёт себе 4 вопроса:

1. Как опровергнуть мой вывод?
2. Открыл ли я ВСЕ созданные файлы?
3. Какие edge cases пропустил?
4. Решает ли это реальный Job пользователя?

### 3. Cross-check

Проверка результата **другим методом**:

- Файл создан → Открой и прочитай
- API работает → curl + код
- Данные верны → pandas + SQL

### 4. COMPLETION REPORT

В конце каждой задачи AI выводит отчёт:

```markdown
## ✅ COMPLETION REPORT

**Сложность:** 🟡 STANDARD

**Использованные инструкции:**
- Protocol: protocol-development.mdc
- Standards: standard-tdd.mdc
- Base Modules: _base-confidence, _base-challenge, _base-crosscheck

**Финальная уверенность:** 92%
```

---

## 🌍 Универсальность правил (NEW in v4.0)

Правила спроектированы для работы **в любом проекте**. Один набор `.cursor/rules/` можно использовать в нескольких проектах без изменений.

### Принцип: Разделение универсального и проектного

| Универсальное (в `.cursor/rules/`) | Проектное (отдельно) |
|-----------------------------------|---------------------|
| Протоколы и workflow | Структура проекта → `AGENTS.md` |
| Стандарты качества | Секреты (URL, креды) → `.cursor/.secrets/` |
| Базовые проверки | Lessons learned → `.cursor_additional/` |

### Примеры в правилах используют плейсхолдеры:

```
✅ <ComponentName>.tsx     вместо   ❌ DealsTable.tsx
✅ <url>, <user>, <pass>   вместо   ❌ конкретные значения
✅ "external API fields"   вместо   ❌ "Bitrix24 UF-поля"
```

---

## 🔧 Настройка под проект

### Настройте AGENTS.md

После копирования отредактируйте `AGENTS.md` под ваш проект:
- Укажите структуру проекта
- Добавьте команды сборки
- Опишите code style
- **Добавьте проектные нюансы** (интеграции, типы данных, workarounds)

### Создайте папку для секретов (если нужно)

```bash
mkdir -p .cursor/.secrets/
echo ".cursor/.secrets/" >> .gitignore
```

### Добавьте специфичные проверки в AGENTS.md

Проектные проверки добавляйте в `AGENTS.md`, а не в `.cursor/rules/`:

```markdown
## ⚠️ Важные нюансы проекта

### [Название интеграции]
- [Особенность 1]
- [Особенность 2]
- WHY: [Реальный случай ошибки]
```

---

## 🔄 Фиксирование сбоев и проведение самоулучшения

Система включает механизм обучения на ошибках. Когда AI допускает ошибку или пользователь указывает на проблему, это фиксируется и превращается в новые правила.

### Как это работает

```
Ошибка обнаружена
        ↓
Session Review (protocol-session-review.mdc)
        ↓
Запись в improvements-backlog.md
        ↓
Внедрение через @rules_alone/backlog-to-rules
        ↓
Новое правило в инструкциях
        ↓
Ошибка не повторяется ✅
```

### Шаг 1: Создайте файл для накопления улучшений

Создайте папку и файл для вашего проекта:

```bash
mkdir -p .cursor_additional/{projectname}/
```

Создайте файл `.cursor_additional/{projectname}/improvements-backlog.md`:

```markdown
# 📋 IMPROVEMENTS BACKLOG

> **Проект:** {projectname}

## 📊 СТАТИСТИКА
| Метрика | Значение |
|---------|----------|
| Всего улучшений | 0 |
| 🔴 High priority | 0 |
| ✅ Внедрено | 0 |

## 🔴 HIGH PRIORITY
(здесь будут записи)

## ✅ ВНЕДРЕНО
(здесь будут внедрённые улучшения)
```

### Шаг 2: Записывайте ошибки после сбоев

Когда AI допустил ошибку, запишите в backlog:

```markdown
---

### IMPROVEMENT #N: YYYY-MM-DD (Краткое название)

**Источник:** Session Review после [какой задачи]

**Проблема:**
[Что пошло не так]

**Root Cause:**
[Почему это произошло — 5 Whys если нужно]

**Предлагаемое изменение:**
```
[Конкретный текст для добавления в инструкции]
```

**Файл для изменения:** `.cursor/rules/[файл].mdc`

**Приоритет:** 🔴 High / 🟡 Medium / 🟢 Low
**Статус:** 📝 Backlog

---
```

### Шаг 3: Внедряйте улучшения

Когда накопилось 2+ High priority улучшений или прошла неделя:

```
@rules_alone/backlog-to-rules Внедри накопленные улучшения
```

AI автоматически:
1. Прочитает backlog
2. Сгруппирует улучшения по файлам
3. Добавит новые секции в инструкции
4. Обновит статусы в backlog (📝 → ✅)
5. Выведет отчёт

### Пример реального улучшения

**Было:** AI создал `.cursor` внутри `git/`, хотя пользователь сказал "скопирую 2 папки сам"

**Записано в backlog:**
```markdown
### IMPROVEMENT #11: Literal Request Following

**Проблема:** AI интерпретирует запрос вместо буквального следования

**Root Cause:** Нет явного шага "выписать constraints дословно"

**Предлагаемое изменение:** Добавить в protocol-prepare-prompt.mdc секцию Explicit Constraints
```

**После внедрения:** Теперь AI всегда выписывает explicit constraints из запроса дословно.

### Когда запускать внедрение

| Условие | Приоритет |
|---------|-----------|
| Накопилось 5+ улучшений | 🔴 Обязательно |
| Есть 2+ High priority | 🔴 Обязательно |
| Прошла неделя | 🟡 Рекомендуется |
| Одна ошибка повторилась 3+ раз | 🔴 Немедленно |

---

## 📊 Определение сложности задач

| Сложность | Признаки | Flow |
|-----------|----------|------|
| 🟢 SIMPLE | 1-2 файла, очевидный результат | EXECUTE → VERIFY |
| 🟡 STANDARD | Новая функциональность, несколько файлов | Полный 4-фазный протокол |
| 🔴 COMPLEX | Архитектура, критические данные | + CTO Review + Session Review |

---

## ❓ FAQ

### Мне нужно писать "используй core-master.mdc"?
**Нет.** Файлы с `alwaysApply: true` применяются автоматически.

### Можно использовать с другими AI-ассистентами?
Библиотека оптимизирована для **Cursor IDE**, но концепции универсальны.

### Как добавить свои правила?
1. Создайте файл `protocol-your-name.mdc` или `_base-your-name.mdc`
2. Добавьте ссылку в `core-master.mdc`

### Как отключить инструкции?
Измените `alwaysApply: true` на `false` в `core-master.mdc`.

---

## 🤝 Вклад в проект

Приветствуются:
- 🐛 Баг-репорты
- 💡 Предложения по улучшению
- 📝 Новые протоколы и модули

---

## 📄 Лицензия

MIT License — используйте свободно в любых проектах.

---

## 🔗 Ссылки

- [GitHub Repository](https://github.com/dmitryprg-ai/cursor-develop-autorules)
- [Cursor IDE](https://cursor.com/)
- [Cursor Docs — Large Codebases](https://cursor.com/docs/cookbook/large-codebases)

---

**Версия:** 9.0  
**Дата:** 2026-02-02

---

## 🆕 Что нового в v9.0

### API Pagination Standard (alwaysApply: true)

Новый стандарт `standard-api-pagination-always.mdc`:

**Проблема:** Бесконечные циклы при пагинации API (реальный случай: загрузка 333000+ записей вместо 100)

**Правила:**
- НИКОГДА не полагаться только на `response.length < limit`
- ВСЕГДА использовать `total` из метаданных ответа
- Safety limits как ДОПОЛНИТЕЛЬНАЯ защита

### React Hooks Standard (alwaysApply: true)

Новый стандарт `standard-react-hooks-always.mdc`:

**Проблема:** React Error #310 "Rendered fewer hooks than expected"

**Правила:**
- Хуки ВСЕГДА в начале компонента, ДО early returns
- Хуки НЕ вызываются условно (внутри if/else, циклов)
- Проверки данных — ВНУТРИ callback хука

### TechDebt Command

Новая команда `@rules_alone/techdebt`:

```
@rules_alone/techdebt Запусти поиск технического долга
```

**5 фаз:** SCAN → ANALYZE → PRIORITIZE → REPORT → BACKLOG

---

## 🆕 Что было в v8.1

### File Size Limits Standard

Новый стандарт `standard-file-size-limits-always.mdc` (alwaysApply: true):

| Тип файла | Soft/Hard limit |
|-----------|-----------------|
| Routes/Controllers | 200/400 строк |
| Services | 250/500 строк |
| React components | 200/400 строк |

**Правила:**
- Файл > 300 строк = **план разбиения ПЕРЕД добавлением кода**
- Разбиение по **бизнес-доменам**, НЕ по техническим слоям
- Использовать barrel exports (`index.ts`)

### Service Restart & Integration

**`protocol-development.mdc` v2.3:**
- ПРАВИЛО #5: Перезапуск сервисов после изменений
- ПРАВИЛО #6: Соблюдать стандарт file-size-limits
- PRE-ACTION: шаг "Control File Size"

**`protocol-refactoring.mdc` v1.2:**
- Workflow: шаг "PREPLAN" со ссылкой на file-size-limits
- Golden Rules: "RULES FIRST"

---

## 🆕 Что было в v8.0

### Universality Requirement

Все правила **полностью универсальны** и работают в любом проекте:

- ❌ Убраны проектные привязки (Bitrix24, DealsTable, PostgreSQL bigint)
- ✅ Примеры используют плейсхолдеры (`<ComponentName>`, `<url>`)
- ✅ Проектная специфика вынесена в `AGENTS.md` и `.cursor/.secrets/`

---

## 🆕 Что было в v7.0

### STANDARD FORMAT COMPLIANCE

- Все 22 файла приведены к единому стандарту
- description в ACTION-TRIGGER-OUTCOME формате
- Структура: Context → Requirements → Examples → Critical Points
- XML теги: `<critical>`, `<required>`, `<example>`

---

## 🆕 Что было в v4.0

### Универсальность правил

- Правила теперь работают **в любом проекте** без изменений
- Примеры используют плейсхолдеры (`<ComponentName>`, `<url>`)
- Проектная специфика вынесена в `AGENTS.md` и `.cursor/.secrets/`

### Новые файлы

- `workflows-site-basic-auth-always.mdc` — универсальное правило для Basic Auth
- `core-rules-standard-format-always.mdc` — стандарт генерации правил

---

## 🆕 Что было в v3.0

### Проблема: AI игнорировал правила

- core-master.mdc был 475 строк — AI терял фокус
- Мягкие формулировки вместо императивов
- _base-* модули не загружались (alwaysApply=false)
- Нет принудительной структуры ответа

### Решение: Полная переработка

| До | После |
|----|-------|
| 475 строк | 179 строк |
| Рекомендации | Жёсткие императивы |
| alwaysApply=false | alwaysApply=true для критичных |
| Свободный формат | Обязательный DONE блок |

### Теперь каждый ответ содержит:

```
1. Сложность: 🟢/🟡/🔴
2. ПЛАН (для STANDARD/COMPLEX)
3. Cross-check таблица
4. Challenge 4 вопроса
5. ## ✅ DONE блок
```
