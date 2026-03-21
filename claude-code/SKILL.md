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

### 2. Send the request

Escape the question for JSON using python3, then call the Perplexity API:

```bash
QUESTION="<question>"

TMPFILE=$(mktemp "${TMPDIR:-${TEMP:-/tmp}}/pplx_XXXXXX.json")
trap "rm -f '$TMPFILE'" EXIT

ESCAPED=$(python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))" <<< "$QUESTION")

curl -s https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"sonar\",\"messages\":[{\"role\":\"user\",\"content\":$ESCAPED}]}" \
  -o "$TMPFILE" && \
  python3 -c "import json,sys; print(json.load(sys.stdin)['choices'][0]['message']['content'])" < "$TMPFILE"
```

### 3. Show the response

Display the response text to the user. If the response contains links — preserve them.

### 4. Error handling

- If `$PERPLEXITY_API_KEY` is not set — tell the user to set it (see README for instructions).
- If curl returns an error — read `$TMPFILE` and show the error message.
- HTTP 429 — rate limit exceeded, suggest waiting 60 seconds.
- HTTP 401 — invalid API key.

## When to use

- Unfamiliar APIs, libraries, formats
- Third-party system behavior (platform quirks, drivers)
- Limitations or edge cases before planning
- Up-to-date information not in training data
