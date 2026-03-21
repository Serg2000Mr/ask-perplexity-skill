# ask-perplexity-skill

Скилл для веб-поиска через [Perplexity AI](https://www.perplexity.ai/) прямо из чата с AI-агентом.

Поддерживает **Claude Code** (VSCode extension, CLI) и **Cursor**.

## Что это

Добавляет команду `/ask-perplexity` в ваш AI-агент. Вопрос отправляется в Perplexity API, ответ выводится прямо в чат. Полезно когда нужно:

- Найти актуальную информацию, которой нет в обучающих данных
- Уточнить незнакомый API, библиотеку или формат
- Проверить поведение платформы или edge cases перед принятием решения
- Провести ревью плана или архитектурного решения с внешней точкой зрения

## Получение API-ключа

1. Зарегистрируйтесь на [perplexity.ai](https://www.perplexity.ai/)
2. Перейдите в [Settings → API](https://www.perplexity.ai/settings/api)
3. Создайте API-ключ (начинается с `pplx-`)

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

```bash
mkdir -p .cursor/rules
cp cursor/perplexity.mdc .cursor/rules/perplexity.mdc
```

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

## Использование

В чате с агентом:

```
/ask-perplexity как работает WebSocket handshake?
/ask-perplexity what are the rate limits for GitHub API?
/ask-perplexity формат frontmatter для Cursor .mdc файлов
```

## Требования

- `python3` (для экранирования JSON и парсинга ответа)
- `curl` (для HTTP-запросов)
- Оба обычно предустановлены на macOS/Linux. На Windows используйте Git Bash.

## Модели Perplexity

| Модель | Описание |
|--------|----------|
| `sonar` | Стандартная модель (используется по умолчанию) |
| `sonar-pro` | Расширенная модель (требует Pro API key) |

Чтобы сменить модель, отредактируйте `"model":"sonar"` в SKILL.md / perplexity.mdc.

## Лимиты API

- **Free**: ~200 запросов/день
- **Pro**: 1000+ запросов/день
- При превышении лимита API возвращает HTTP 429 — подождите 60 секунд

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
