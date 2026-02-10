# КАК РАБОТАТЬ С CURSOR RULES + SKILLS

## Краткий ответ

**НЕ нужно** вручную подключать правила или скиллы. Всё работает автоматически.

---

## Как это работает

```
Твой запрос
    ↓
core-master.mdc (автоматически, всегда)
    ├── Определяет сложность 🟢/🟡/🔴
    ├── Выбирает skill из Routing Table
    ├── Проверка: Forbidden + Cross-check + Challenge
    └── DONE блок
    ↓
*.tsx открыт? → react-hooks, radix-select (автоматически)
    ↓
Агент сам подключит нужные skills и rules
```

### Rules vs Skills

| Тип | Что это | Как работает |
|-----|---------|-------------|
| **Rules** | Короткие ограничения, инварианты | Автоматически по globs или описанию |
| **Skills** | Процедурные workflows, скрипты | Автоматически по описанию или `/skill-name` |

---

## Типичные сценарии

| Запрос | Что AI подключит автоматически |
|--------|-------------------------------|
| "Добавь фильтр" | `development` skill |
| "Исправь ошибку" | `bugfix` skill + `_base-5wh.mdc` |
| "Проанализируй данные" | `research` skill |
| "Отрефактори код" | `refactoring` skill |
| Открыт .tsx файл | `standard-react-hooks-auto.mdc` |
| Работа с пагинацией | `standard-api-pagination-agent.mdc` |
| "Задеплой" | `deploy-app` skill (с скриптами!) |
| "Проверь код" | `code-review` skill |
| "Напиши тесты" | `tdd-workflow` skill |

---

## Skills с скриптами

Некоторые skills содержат готовые shell-скрипты:

| Skill | Скрипты |
|-------|---------|
| `deploy-app` | deploy-backend.sh, deploy-frontend.sh, deploy-all.sh, verify-pages.sh |
| `api-testing` | get-session.sh, test-endpoint.sh |
| `techdebt-scan` | scan-large-files.sh, find-todos.sh |
| `gap-analysis` | scan-gaps.sh |

Агент вызывает скрипты автоматически при необходимости.

---

## Явное использование

### Вариант 1: Просто пиши запрос (рекомендуется)
```
Добавь фильтрацию по дате в API /api/deals
```

### Вариант 2: Вызов skill напрямую
```
/development — запустить development workflow
/deploy-app — деплой приложения
/techdebt-scan — сканирование техдолга
```

### Вариант 3: Через @ упоминание
```
@rules_alone/backlog-to-rules Обработай бэклог улучшений
```

---

## Признаки что инструкции работают

- Ответ начинается с определения сложности (`**Сложность: 🟢 SIMPLE**`)
- Для STANDARD/COMPLEX есть план
- Cross-check таблица с файлами
- Challenge 4 вопроса
- DONE блок в конце

---

## Если AI не следует инструкциям

1. Проверь что `core-master.mdc` имеет `alwaysApply: true`
2. Напомни: "Следуй core-master.mdc, выведи DONE блок"
3. Перезапусти Cursor (кэш)

---

## Настройка для нового проекта

1. Скопируйте `.cursor/` в проект
2. Отредактируйте `.cursor/config/project.config.json`:
   - `project_root`, `site_url` — ваш проект
   - `services` — ваши backend/frontend сервисы
   - `auth` — пути к секретам
   - `verify_pages` — ваши ключевые страницы
   - `scan_dirs` — директории для сканирования
3. Создайте `.cursor/.secrets/` с файлами авторизации
4. Готово!

## FAQ

**Q: Как создать своё правило или skill?**
A: Используй `/create-rules` skill или упомяни `@create-rules`

**Q: Где одиночные инструкции?**
A: В `.cursor/rules_alone/`

**Q: Как запустить deploy?**
A: Скажи "задеплой" и агент использует `deploy-app` skill с автоматическими скриптами.

**Q: Как запустить сканирование техдолга?**
A: Используй `/techdebt-scan` (только явный вызов).

**Q: Как перенести в другой проект?**
A: Скопируй `.cursor/`, отредактируй `config/project.config.json`. Все rules/skills универсальны.

---

**Версия:** 9.0
**Дата:** 2026-02-10
