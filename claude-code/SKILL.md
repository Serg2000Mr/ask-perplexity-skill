---
name: ask-perplexity
description: Ask Perplexity AI for web search. Use when you need to find information online, clarify an unfamiliar API, platform behavior, or resolve uncertainty before making a decision.
argument-hint: "<question>"
allowed-tools:
  - Bash
---

# /ask-perplexity — Web Search via Perplexity AI

## Usage

```
/ask-perplexity <question in any language>
```

## Algorithm

### 1. Compose the question

If no argument is provided — ask the user.
Perplexity understands most languages; keep the question as-is.

### 2. Check API key

```bash
if [ -z "$PERPLEXITY_API_KEY" ]; then
  echo "ERROR: PERPLEXITY_API_KEY is not set."
  echo "Set it in ~/.claude/settings.json: {\"env\":{\"PERPLEXITY_API_KEY\":\"pplx-...\"}}"
  exit 1
fi
```

If the key is not set — stop and show the message above. Do NOT proceed with curl.

### 3. Send the request

Escape the question for JSON using python3, then call the Perplexity API.
Use `-w '%{http_code}'` to capture the HTTP status separately:

```bash
QUESTION="<question>"

TMPFILE=$(mktemp "${TMPDIR:-${TEMP:-/tmp}}/pplx_XXXXXX.json")
trap "rm -f '$TMPFILE'" EXIT

ESCAPED=$(python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))" <<< "$QUESTION")

HTTP_CODE=$(curl -s -w '%{http_code}' -o "$TMPFILE" \
  https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"sonar\",\"messages\":[{\"role\":\"user\",\"content\":$ESCAPED}]}")
```

### 4. Handle errors

Check HTTP status before parsing:

```bash
if [ "$HTTP_CODE" -ne 200 ]; then
  echo "ERROR: Perplexity API returned HTTP $HTTP_CODE"
  cat "$TMPFILE"
  exit 1
fi
```

- HTTP 401 — invalid or missing API key.
- HTTP 429 — rate limit exceeded, suggest waiting 60 seconds.
- Other errors — show the raw response body.

### 5. Show the response with citations

Parse the response and append citations if present:

```bash
python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data['choices'][0]['message']['content'])
citations = data.get('citations', [])
if citations:
    print('\n---\nSources:')
    for i, url in enumerate(citations, 1):
        print(f'{i}. {url}')
" < "$TMPFILE"
```

Display the full output to the user — both the answer text and the source links.

## When to use

- Unfamiliar APIs, libraries, formats
- Third-party system behavior (platform quirks, drivers)
- Limitations or edge cases before planning
- Up-to-date information not in training data
