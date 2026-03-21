# ask-perplexity-skill

Скилл для веб-поиска через [Perplexity AI](https://www.perplexity.ai/) прямо из чата с AI-агентом.

Поддерживает **Claude Code** (VSCode extension, CLI) и **Cursor**.

## Что это

Добавляет команду `/ask-perplexity` в ваш AI-агент. Вопрос отправляется в Perplexity API, ответ выводится прямо в чат. Полезно когда нужно:

- Провести ревью плана или архитектурного решения с внешней точкой зрения
- Выполнить поиск по интернету с анализом источников и развёрнутым ответом
- Уточнить незнакомый API, библиотеку или формат
- Проверить поведение платформы или edge cases перед принятием решения

Причем для вопроса необязательно писать команду /ask-perplexity вопрос.
Скажите агенту "Спроси перплексити", и он сам использует навык.

## Сначала нужно получить API-ключ

1. В [perplexity.ai](https://www.perplexity.ai/) откройте **Аккаунт → API-платформа**

  <img width="571" height="656" alt="image" src="https://github.com/user-attachments/assets/07bc8279-82e4-4562-ba1b-a2d1e0f68eb6" />

2.  Cоздайте ключ API (начинается с `pplx-`) и скопируйте в буфер обмена


## Установка навыка

### Claude Code (автоматически)

```bash
git clone https://github.com/Serg2000Mr/ask-perplexity-skill.git
cd ask-perplexity-skill
bash install.sh
```

Скрипт скопирует `SKILL.md` в `~/.claude/skills/ask-perplexity/`.

### Claude Code (вручную)

```bash
mkdir -p ~/.claude/skills/ask-perplexity
cp claude-code/SKILL.md ~/.claude/skills/ask-perplexity/SKILL.md
```

### Cursor

Скопируйте файл правила в ваш проект:

.cursor/rules/perplexity.mdc

## Настройка API-ключа

### Claude Code

Добавьте ключ в `~/.claude/settings.json`:

```json
{
  "env": {
    "PERPLEXITY_API_KEY": "pplx-ваш-ключ-здесь"
  }
}
```

### Cursor

Добавьте в ваш shell profile (`~/.bashrc`, `~/.zshrc` или `~/.bash_profile`):

```bash
export PERPLEXITY_API_KEY="pplx-ваш-ключ-здесь"
```

Перезапустите терминал или выполните `source ~/.bashrc`.

### Безопасность

Если вы храните ключ в `.env` файле проекта, добавьте его в `.gitignore`:

```bash
echo ".env" >> .gitignore
```

## Использование

В чате с агентом:

```
/ask-perplexity проведи ревью плана
/ask-perplexity у меня не получается <суть проблемы> 
```

## Требования

- `python3` (для экранирования JSON и парсинга ответа)
- `curl` (для HTTP-запросов)
- 

## Модели Perplexity API (март 2026)

| Model ID | Описание |
|----------|----------|
| `sonar` | Быстрый веб-поиск, Q&A, суммаризация (128k контекст). Используется по умолчанию |
| `sonar-pro` | Глубокий поиск с расширенным контекстом (200k) |
| `sonar-reasoning-pro` | Многошаговое рассуждение, chain-of-thought (128k) |
| `sonar-deep-research` | Глубокий синтез из сотен источников (128k) |

Чтобы сменить модель, отредактируйте `"model":"sonar"` в SKILL.md / perplexity.mdc.

Список моделей может измениться. Актуальный перечень: [docs.perplexity.ai](https://docs.perplexity.ai/).

## Стоимость и лимиты API

API платный, оплата по факту потребления (за токены). Для работы нужно пополнить баланс на [API-платформе](https://www.perplexity.ai/settings/api).

- При превышении rate limit API возвращает HTTP 429
- Актуальные тарифы: [docs.perplexity.ai](https://docs.perplexity.ai/)

## Troubleshooting

| Проблема | Решение |
|----------|---------|
| `PERPLEXITY_API_KEY not set` | Настройте ключ (см. раздел "Настройка API-ключа") |
| HTTP 401 | Проверьте что ключ начинается с `pplx-` и не истёк |
| HTTP 429 | Превышен лимит запросов, подождите 60 секунд |
| `python3: command not found` | Установите Python 3 |
| Пустой ответ | Проверьте интернет-соединение |

## Лицензия

MIT
