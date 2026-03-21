# Установка для Claude Code

## Сначала нужно получить API-ключ

1. В [perplexity.ai](https://www.perplexity.ai/) откройте **Аккаунт → API-платформа**

   <img width="571" height="656" alt="Меню аккаунта Perplexity" src="https://github.com/user-attachments/assets/07bc8279-82e4-4562-ba1b-a2d1e0f68eb6" />

2. Создайте ключ API (начинается с `pplx-`) и скопируйте в буфер обмена

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
