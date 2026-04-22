# Changelog

Пользовательские изменения скилла. Полная история — в `git log`.

## 2026-04-22

### Дисциплина фактчекинга
- `SKILL.md`, `perplexity.mdc`, `README.md` — добавлен раздел про типы галлюцинаций Perplexity (фейковые CVE, версии, API-флаги, коды выхода) и обязательную дисциплину: любое утверждение — гипотеза, проверять по первоисточникам, не копировать в код/план без независимого подтверждения.

### Windows SSL fix
- `run-perplexity.sh`, `perplexity.mdc` — `curl --ssl-no-revoke`. Обходит schannel-ошибку `CRYPT_E_NO_REVOCATION_CHECK` (exit 35 / HTTP 000) в Windows Git Bash. На Linux/macOS флаг безвреден.
- `README.md` — запись в troubleshooting про `curl: (35)` / `HTTP 000`.

## 2026-03-25

### README
- Смягчённые формулировки про критическое восприятие ответов Perplexity.
- Уточнение: для адаптации под другие IDE запрашивайте у агента.

## 2026-03-21 — Первый релиз

- Команда `/ask-perplexity` для Claude Code (VSCode extension, CLI) и Cursor.
- Автоматический выбор модели агентом: `sonar` / `sonar-pro` / `sonar-reasoning-pro` / `sonar-deep-research`.
- `sonar-deep-research` сохраняет ответ в файл (объём может превышать 30 КБ), агент читает файл и даёт краткое резюме.
- Установочный скрипт `install.sh`, инструкции для Claude Code и Cursor (`docs/claude-code.md`, `docs/cursor.md`).
- Wrapper-скрипт для стабильных permissions.
- README с полным описанием моделей, тарифов, использования и troubleshooting.
