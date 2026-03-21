# Установка для Cursor

## Сначала нужно получить API-ключ

1. В [perplexity.ai](https://www.perplexity.ai/) откройте **Аккаунт → API-платформа**

   <img width="571" height="656" alt="Меню аккаунта Perplexity" src="https://github.com/user-attachments/assets/07bc8279-82e4-4562-ba1b-a2d1e0f68eb6" />

2. Создайте ключ API (начинается с `pplx-`) и скопируйте в буфер обмена

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
