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

# --ssl-no-revoke works around schannel CRYPT_E_NO_REVOCATION_CHECK on Windows
# Git Bash when the local OCSP/CRL responder is unreachable. Harmless on Linux/macOS
# because those builds use a different TLS backend.
HTTP_CODE="$(curl -s --ssl-no-revoke -w '%{http_code}' -o "$TMPFILE" \
  https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"$MODEL\",\"messages\":[{\"role\":\"user\",\"content\":$ESCAPED}]}")"

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