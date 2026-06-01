#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage:"
  echo "  /ask-perplexity <question> [model]"
  echo "  /ask-perplexity --file <prompt.md> [model]"
  echo "  /ask-perplexity --stdin [model]"
  echo "Models: sonar (default), sonar-pro, sonar-reasoning-pro, sonar-deep-research"
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
  exit 0
fi

INPUT_MODE="arg"
QUESTION="${1:-}"
MODEL="${2:-sonar}"
PROMPTFILE=""
PROMPTFILE_IS_TEMP=0

if [ "${1:-}" = "--file" ] || [ "${1:-}" = "-f" ]; then
  INPUT_MODE="file"
  PROMPTFILE="${2:-}"
  MODEL="${3:-sonar}"
  if [ -z "$PROMPTFILE" ]; then
    echo "ERROR: prompt file is required"
    usage
    exit 1
  fi
  if [ ! -f "$PROMPTFILE" ]; then
    echo "ERROR: prompt file not found: $PROMPTFILE"
    exit 1
  fi
elif [ "${1:-}" = "--stdin" ]; then
  INPUT_MODE="stdin"
  MODEL="${2:-sonar}"
fi

if [ "$INPUT_MODE" = "arg" ] && [ -z "$QUESTION" ]; then
  echo "ERROR: question is required"
  usage
  exit 1
fi

if [ -z "${PERPLEXITY_API_KEY:-}" ]; then
  echo "ERROR: PERPLEXITY_API_KEY is not set."
  echo "Set it in ~/.claude/settings.json:"
  echo '{"env":{"PERPLEXITY_API_KEY":"pplx-..."}}'
  exit 1
fi

TMPROOT="${TMPDIR:-${TEMP:-/tmp}}"
TMPFILE="$(mktemp "$TMPROOT/pplx_response_XXXXXX.json")"
BODYFILE="$(mktemp "$TMPROOT/pplx_body_XXXXXX.json")"

if [ "$INPUT_MODE" = "stdin" ]; then
  PROMPTFILE="$(mktemp "$TMPROOT/pplx_prompt_XXXXXX.md")"
  PROMPTFILE_IS_TEMP=1
  cat > "$PROMPTFILE"
elif [ "$INPUT_MODE" = "arg" ]; then
  PROMPTFILE="$(mktemp "$TMPROOT/pplx_prompt_XXXXXX.md")"
  PROMPTFILE_IS_TEMP=1
  printf '%s' "$QUESTION" > "$PROMPTFILE"
fi

cleanup() {
  rm -f "$TMPFILE" "$BODYFILE"
  if [ "$PROMPTFILE_IS_TEMP" = "1" ]; then
    rm -f "$PROMPTFILE"
  fi
}
trap cleanup EXIT

python3 - "$MODEL" "$PROMPTFILE" "$BODYFILE" <<'PY'
import json
import pathlib
import sys

model, prompt_path, body_path = sys.argv[1:4]
question = pathlib.Path(prompt_path).read_text(encoding="utf-8-sig").strip()
if not question:
    print("ERROR: question is required", file=sys.stderr)
    sys.exit(1)

payload = {
    "model": model,
    "messages": [
        {"role": "user", "content": question}
    ],
}
pathlib.Path(body_path).write_text(
    json.dumps(payload, ensure_ascii=False),
    encoding="utf-8")
PY

# --ssl-no-revoke works around schannel CRYPT_E_NO_REVOCATION_CHECK on Windows
# Git Bash when the local OCSP/CRL responder is unreachable. Harmless on Linux/macOS
# because those builds use a different TLS backend.
if ! HTTP_CODE="$(curl -sS --ssl-no-revoke -w '%{http_code}' -o "$TMPFILE" \
  https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "@$BODYFILE")"; then
  echo "ERROR: Perplexity transport failed"
  exit 1
fi

if [ "$HTTP_CODE" != "200" ]; then
  echo "ERROR: Perplexity API returned HTTP $HTTP_CODE"
  cat "$TMPFILE"
  exit 1
fi

if [ "$MODEL" = "sonar-deep-research" ]; then
  OUTFILE="${TMPDIR:-${TEMP:-/tmp}}/pplx-deep-research-$(date +%Y%m%d-%H%M%S).md"
  python3 -c '
import json, sys
data = json.load(sys.stdin)
content = data["choices"][0]["message"]["content"]
citations = data.get("citations", [])
out = content
if citations:
    out += "\n\n---\n## Sources\n"
    for i, url in enumerate(citations, 1):
        out += f"{i}. {url}\n"
sys.stdout.write(out)
' < "$TMPFILE" > "$OUTFILE"
  echo "sonar-deep-research: результат сохранён в файл (слишком большой для чата):"
  echo "$OUTFILE"
else
  python3 -c '
import json, sys
data = json.load(sys.stdin)
print(data["choices"][0]["message"]["content"])

citations = data.get("citations", [])
if citations:
    print("\n---\nSources:")
    for i, url in enumerate(citations, 1):
        print(f"{i}. {url}")
' < "$TMPFILE"
fi
