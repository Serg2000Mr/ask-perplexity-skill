# ask-perplexity-skill

Скилл для веб-поиска через [Perplexity AI](https://www.perplexity.ai/) прямо из чата с AI-агентом.

Поддерживает **Claude Code** (VSCode extension, CLI) и **Cursor**.

## Что это

Добавляет команду `/ask-perplexity` в ваш AI-агент. Вопрос отправляется в Perplexity API, ответ выводится прямо в чат. Полезно когда нужно:

- Провести ревью плана или архитектурного решения с внешней точкой зрения
- Выполнить поиск по интернету с анализом источников и развёрнутым ответом
- Уточнить незнакомый API, библиотеку или формат
- Проверить поведение платформы или edge cases перед принятием решения

## Получение API-ключа

1. В [perplexity.ai](https://www.perplexity.ai/) перейдите в личный кабинет

   <img width="237" height="657" alt="image" src="https://github.com/user-attachments/assets/3a87b11c-9b82-441d-bdc9-178332c7eebd" />
   
3. Api-платформа

   <img width="256" height="531" alt="image" src="https://github.com/user-attachments/assets/ee93a9ab-e921-43af-8244-be9817ca7891" />
   
5. Создайте API-ключ (начинается с `pplx-`)

## Установка

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
- Оба обычно предустановлены на macOS/Linux. На Windows используйте Git Bash.

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

API платный, оплата по факту потребления (за токены). Бесплатного тарифа нет.

- Подписка **Pro** ($20/мес) даёт **$5 кредита** на API в месяц (~1250 запросов sonar / ~250 запросов sonar-pro)
- После исчерпания кредита — оплата по счётчику
- При превышении rate limit API возвращает HTTP 429

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
