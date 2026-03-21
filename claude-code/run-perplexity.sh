#!/usr/bin/env bash
set -euo pipefail

QUESTION="${1:-}"
MODEL="${2:-sonar}"

if [ -z "$QUESTION" ]; then
  echo "ERROR: question is required"
  echo "Usage: /ask-perplexity <question> [model]"
  echo "Models: sonar (default), sonar-pro, sonar-reasoning-pro, sonar-deep-research"
  exit 1
fi

if [ -z "${PERPLEXITY_API_KEY:-}" ]; then
  echo "ERROR: PERPLEXITY_API_KEY is not set."
  echo "Set it in ~/.claude/settings.json:"
  echo '{"env":{"PERPLEXITY_API_KEY":"pplx-..."}}'
  exit 1
fi

TMPFILE="$(mktemp "${TMPDIR:-${TEMP:-/tmp}}/pplx_XXXXXX.json")"
trap 'rm -f "$TMPFILE"' EXIT

ESCAPED="$(python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))' <<< "$QUESTION")"

HTTP_CODE="$(curl -s -w '%{http_code}' -o "$TMPFILE" \
  https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":$ESCAPED}]}")"

if [ "$HTTP_CODE" != "200" ]; then
  echo "ERROR: Perplexity API returned HTTP $HTTP_CODE"
  cat "$TMPFILE"
  exit 1
fi

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