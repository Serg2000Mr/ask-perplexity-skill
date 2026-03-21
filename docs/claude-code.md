# Установка для Claude Code

Если у вас ещё нет API-ключа — сначала [получите ключ и пополните баланс API](../README.md#получение-api-ключа-и-пополнение-баланса).

## Установка навыка

### Автоматически

```bash
git clone https://github.com/Serg2000Mr/ask-perplexity-skill.git
cd ask-perplexity-skill
bash install.sh
```

### Вручную

```bash
mkdir -p ~/.claude/skills/ask-perplexity
cp claude-code/SKILL.md ~/.claude/skills/ask-perplexity/SKILL.md
cp claude-code/run-perplexity.sh ~/.claude/skills/ask-perplexity/run-perplexity.sh
chmod +x ~/.claude/skills/ask-perplexity/run-perplexity.sh
```

## Настройка API-ключа и разрешений

Добавьте в `~/.claude/settings.json`:

```json
{
  "env": {
    "PERPLEXITY_API_KEY": "pplx-ваш-ключ-здесь"
  },
  "permissions": {
    "allow": [
      "Skill(ask-perplexity)",
      "Bash(bash ~/.claude/skills/ask-perplexity/run-perplexity.sh *)"
    ]
  }
}
```

Навык вызывает один wrapper-скрипт. Разрешение на этот скрипт позволяет Claude Code выполнять запросы без дополнительных подтверждений.

## Требования

- `python3` и `curl` — обычно предустановлены на macOS/Linux; на Windows используйте Git Bash
