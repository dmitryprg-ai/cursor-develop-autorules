# 🏗️ CURSOR RULES ARCHITECTURE v10.0

**Дата обновления:** 2026-02-02
**Версия:** 10.0 (KISS/YAGNI/MVP Principles)

---

## 📊 Общая структура

```
.cursor/
├── CHANGELOG.md               # История изменений
│
├── rules/                     # ⭐ АКТУАЛЬНЫЕ инструкции
│   ├── core-master.mdc        # Entry point (alwaysApply: true)
│   ├── _base-*.mdc            # Базовые модули (8 шт)
│   ├── protocol-*.mdc         # Протоколы (7 шт)
│   ├── standard-*.mdc         # Стандарты (9 шт)
│   ├── error-learning.mdc     # Обучение на ошибках
│   ├── standart-generating-agent.mdc  # Стандарт создания правил
│   ├── ARCHITECTURE.md        # Этот файл
│   └── HOW-TO-USE.md          # Как работать
│
└── rules_alone/               # 🎯 ОДИНОЧНЫЕ инструкции
    ├── *.mdc                  # Для единичных задач
    └── HOW-TO-USE.md          # Документация
```

---

## 🔄 Flow: Как это работает

```
USER REQUEST
     ↓
core-master.mdc (alwaysApply: true)
  ├── ШАГ 0: Определить сложность 🟢/🟡/🔴
  ├── ШАГ 1: План (для STANDARD/COMPLEX)
  ├── ШАГ 2: Выполнение
  ├── ШАГ 3: Проверка (Cross-check + Challenge)
  └── ШАГ 4: DONE блок (ОБЯЗАТЕЛЬНО)
     ↓
protocol-*.mdc (по типу задачи)
     ↓
_base-*.mdc (загружаются автоматически: alwaysApply: true)
     ↓
standard-*.mdc (верификация)
```

---

## 📁 Категории файлов

### Entry Point (alwaysApply: true)

| Файл | Назначение |
|------|------------|
| `core-master.mdc` | Master Router, единственная точка входа |

### Base Modules (alwaysApply: true — критичные)

| Файл | Назначение |
|------|------------|
| `_base-forbidden.mdc` | Критические запреты |
| `_base-crosscheck.mdc` | Независимая проверка |
| `_base-challenge.mdc` | 4 вопроса перед "готово" |
| `_base-confidence.mdc` | Калибровка уверенности |
| `_base-todo-usage.mdc` | Использование todo_tool |
| `_base-5wh.mdc` | Формат 5W+H и 5 Whys |
| `_base-jtbd-thinking.mdc` | Jobs To Be Done |
| `_base-rat.mdc` | Riskiest Assumption Test |

### Protocols (alwaysApply: false — по типу задачи)

| Файл | Ключевые слова |
|------|----------------|
| `protocol-development.mdc` | добавить, создать, фича |
| `protocol-bugfix.mdc` | ошибка, баг, не работает |
| `protocol-refactoring.mdc` | рефакторинг, улучшить |
| `protocol-research.mdc` | данные, анализ, pandas |
| `protocol-freeze-recovery.mdc` | завис, freeze |
| `protocol-session-review.mdc` | review, конец сессии |
| `protocol-prepare-prompt.mdc` | улучшение промта |

### Standards (верификация и архитектура)

| Файл | alwaysApply | Когда применять |
|------|-------------|-----------------|
| `standard-agent-quality.mdc` | false | VERIFY фаза |
| `standard-qa.mdc` | false | Code Review |
| `standard-rca.mdc` | false | Bug Fix, Freeze |
| `standard-tdd.mdc` | false | Development |
| `standard-cto-review.mdc` | false | COMPLEX задачи |
| `standard-file-size-limits-always.mdc` | **true** | Контроль размера файлов |
| `standard-api-pagination-always.mdc` | **true** | Пагинация API (предотвращает infinite loops) |
| `standard-react-hooks-always.mdc` | **true** | React хуки (предотвращает Error #310) |
| `standard-kiss-yagni-always.mdc` | **true** | **KISS/YAGNI/MVP — Anti-Overengineering** |

---

## 📋 Формат правил (standart-generating-agent.mdc)

Все файлы соответствуют стандарту:

```mdc
---
description: "ACTION-TRIGGER-OUTCOME формат"
globs: 
alwaysApply: true/false
tags: [tag1, tag2]
---

# Title

## Context
- Когда применять
- Предусловия

## Requirements
<required>
  - Тестируемые требования
</required>

## Examples
<example>
GOOD: ...
</example>

<example type="invalid">
BAD: ...
</example>

## Critical Points
<critical>
  - ALWAYS do X
  - NEVER do Y
</critical>
```

---

## 🎯 Определение сложности

| Сложность | Признаки | Flow |
|-----------|----------|------|
| 🟢 SIMPLE | 1-2 файла, очевидный результат | EXECUTE → VERIFY(linter) → DONE |
| 🟡 STANDARD | Новая фича, несколько файлов | PLAN → EXECUTE → VERIFY → DONE |
| 🔴 COMPLEX | Архитектура, критичные данные | + CTO Review + Session Review |

---

## 📈 Метрики успеха

| Метрика | Target |
|---------|--------|
| Linter errors = 0 | 100% |
| Задачи без переделок | >80% |
| Повторные ошибки | <10% |
| First-time Quality | >80% |

---

## 🔗 Проектные файлы

| Файл | Расположение |
|------|--------------|
| `AGENTS.md` | корень проекта |
| `improvements-backlog.md` | `.cursor_additional/{projectname}/` |
| `error-log.md` | `.cursor_additional/{projectname}/` |

---

## 🌍 Universality Requirement (NEW in v8.0)

Правила должны работать **в любом проекте**. Один набор rules используется в нескольких проектах.

### НЕ включать в правила:
| ❌ Что | ✅ Куда выносить |
|--------|------------------|
| Домены, URL, креды | `.cursor/.secrets/*` |
| Названия сущностей (`DealsTable`) | Плейсхолдеры `<ComponentName>` |
| Проектная архитектура | `AGENTS.md` |
| Lessons learned | `.cursor_additional/{project}/` |

### Примеры:
```
❌ BAD:  DealsTable.tsx, Bitrix24 UF-поля, module.types.ts
✅ GOOD: <ComponentName>.tsx, External API fields, types → service → routes
```

---

## 📏 File Size Limits (NEW in v8.1)

Новый стандарт `standard-file-size-limits-always.mdc` предотвращает создание "монолитных" файлов.

### Лимиты:

| Тип файла | Soft limit | Hard limit |
|-----------|------------|------------|
| Routes/Controllers | 200 строк | 400 строк |
| Services | 250 строк | 500 строк |
| API client (frontend) | 200 строк | 400 строк |
| React components | 200 строк | 400 строк |

### Правила:
- Файл > 300 строк = **план разбиения ПЕРЕД добавлением кода**
- Разбиение по **бизнес-доменам**, НЕ по техническим слоям
- Использовать **barrel exports** (`index.ts`)

### Интеграция:
- `protocol-development.mdc` — ПРАВИЛО #6 + шаг "Control File Size"
- `protocol-refactoring.mdc` — шаг "PREPLAN" + "RULES FIRST"

---

## 🆕 Что нового в v9.0

1. **`standard-api-pagination-always.mdc`** v1.0 — правила пагинации API (alwaysApply: true)
   - Предотвращает бесконечные циклы при работе с пагинированными API
   - ВСЕГДА использовать `total` из метаданных ответа
   - Safety limits как дополнительная защита

2. **`standard-react-hooks-always.mdc`** v1.0 — правила React хуков (alwaysApply: true)
   - Хуки ВСЕГДА в начале компонента, ДО early returns
   - Предотвращает React Error #310, #300

3. **`rules_alone/techdebt-manual.mdc`** v1.0 — команда `/techdebt`
   - 5 фаз: SCAN → ANALYZE → PRIORITIZE → REPORT → BACKLOG
   - Поиск дублирующегося кода и code smells
   - Quick Wins выделяются отдельно

### Что было в v8.1:
- `standard-file-size-limits-always.mdc` — контроль размера файлов
- `protocol-development.mdc` v2.3 — интеграция file-size-limits
- `protocol-refactoring.mdc` v1.2 — PREPLAN шаг

### Что было в v8.0:
- Universality Requirement — правила работают в любом проекте
- Проектная специфика вынесена — в AGENTS.md и .cursor/.secrets/
- Обновлены примеры — плейсхолдеры вместо проектных названий

### Что было в v7.0:
- Все правила по стандарту — description в ACTION-TRIGGER-OUTCOME формате
- Критичные модули alwaysApply: true — forbidden, crosscheck, challenge, confidence
- XML теги — `<critical>`, `<required>`, `<example>`

---

**Версия:** 9.0
**Дата:** 2026-02-02
