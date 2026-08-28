# Установка для Codex

Если у вас ещё нет API-ключа — сначала [получите ключ и пополните баланс API](../README.md#получение-api-ключа-и-пополнение-баланса).

## Установка навыка

```bash
git clone https://github.com/Serg2000Mr/ask-perplexity-skill.git
cd ask-perplexity-skill
bash install.sh codex
```

Навык будет установлен в `~/.codex/skills/ask-perplexity`.

## Использование

Попросите Codex обратиться к Perplexity. Агент хранит вопрос, манифест и
разрешённые исходные материалы отдельно от исполняемых скриптов. На Windows
перед сетевым запросом можно проверить манифест:

```powershell
& "$HOME\.codex\skills\ask-perplexity\run-perplexity.ps1" `
  -RequestFile 'C:\path\to\request.json' -ValidateOnly
```

## Требования для Windows

- PowerShell;
- Git Bash;
- Python 3 и `curl`, доступные из Git Bash.
