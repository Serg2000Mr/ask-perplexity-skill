# Установка для Cursor

Если у вас ещё нет API-ключа — сначала [получите ключ и пополните баланс API](../README.md#получение-api-ключа-и-пополнение-баланса).

## Установка правила

Скопируйте файл правила в ваш проект:

```bash
mkdir -p .cursor/rules
cp cursor/perplexity.mdc .cursor/rules/perplexity.mdc
```

## Настройка API-ключа

Добавьте в shell profile (`~/.bashrc`, `~/.zshrc` или `~/.bash_profile`):

```bash
export PERPLEXITY_API_KEY="pplx-ваш-ключ-здесь"
```

Перезапустите терминал или выполните `source ~/.bashrc`.

## Безопасность

Если вы храните ключ в `.env` файле проекта — добавьте его в `.gitignore`, чтобы ключ не попал в репозиторий:

```bash
echo ".env" >> .gitignore
```

## Требования

- `python3` и `curl` — обычно предустановлены на macOS/Linux; на Windows используйте Git Bash
