# Установка для Cursor

Если у вас ещё нет API-ключа — сначала [получите ключ и пополните баланс API](../README.md#получение-api-ключа-и-пополнение-баланса).

## Установка навыка

```bash
git clone https://github.com/Serg2000Mr/ask-perplexity-skill.git
cd ask-perplexity-skill
bash install.sh cursor
```

Навык будет установлен в `~/.cursor/skills/ask-perplexity`. Файл
`cursor/perplexity.mdc` оставлен как короткое правило для старых проектов; он
ссылается на установленный навык и больше не содержит копию транспортного кода.

## Настройка API-ключа

Задайте `PERPLEXITY_API_KEY` в окружении Cursor. На Windows запускатель также
может прочитать ключ из `~/.claude/settings.json`, не выводя его в консоль.

## Использование

Попросите Cursor обратиться к Perplexity. Агент создаст отдельные
`question.md` и `request.json`, проверит их и вызовет неизменяемый запускатель.

## Требования для Windows

- PowerShell;
- Git Bash;
- Python 3 и `curl`, доступные из Git Bash.
